package org.slc.sli.login.servlet.filter.sso;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.CharPool;
import com.liferay.portal.kernel.util.StringPool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;

import org.slc.sli.util.Constants;
import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.util.CookieKeys;

import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.impl.BasicClient;
import org.slc.sli.api.client.impl.BasicQuery;

import org.slc.sli.common.constants.v1.PathConstants;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

/**
 * SLISSOUtil.java
 * 
 * Purpose: contains methods to check user is authenticated, logout.
 * 
 * @author
 * @version 1.0
 */

public class SLISSOUtil {

	public SLISSOUtil() {
		this.instance = this;
	}

	public static BasicClient getBasicClientObject() {
		return instance.getBasicClient();
	}

	public static boolean isAuthenticated(HttpServletRequest request,
			HttpServletResponse response) {
		return instance._isAuthenticated(request, response);
	}

	public static UserData getUserDetails(HttpServletRequest request)
			throws IOException {
		return instance._getUserDetails(request);
	}

	public static String getClientSecret() {
		return instance._getClientSecret();
	}

	public static String getCallbackUrl() {
		return instance._getCallbackUrl();
	}

	public static String getClientId() {
		return instance._getClientId();
	}

	public static String getApiUrl() {
		return instance._getApiUrl();
	}

	public static boolean logout(BasicClient client,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		return instance._logout(client, request, response);
	}

	public static boolean isSignedIn(BasicClient client) throws IOException {
		return instance._isSignedIn(client);
	}

	private boolean _isSignedIn(BasicClient client) throws IOException {
		boolean authenticated = false;
		EntityCollection collection = new EntityCollection();
		try {
			client.read(collection, PathConstants.SECURITY_SESSION_CHECK,
					BasicQuery.EMPTY_QUERY);
			if (collection != null && collection.size() >= 1) {
				authenticated = Boolean.valueOf((Boolean) collection.get(0)
						.getData().get("authenticated"));
			}
		} catch (URISyntaxException e) {
			_log.error("Error occurred while calling session chek api..", e);
		}

		if (_log.isDebugEnabled()) {
			_log.debug("check session check api for authentication "
					+ authenticated);
		}

		return authenticated;
	}

	private boolean _logout(BasicClient client, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		boolean logout = false;
		EntityCollection collection = new EntityCollection();
		try {
			_log.info("_logout called -------");
			client.read(collection, PathConstants.SECURITY_SESSION_LOGOUT,
					BasicQuery.EMPTY_QUERY);
		} catch (URISyntaxException e) {
			_log.error("Error occurred while calling logout rest api..", e);
		}

		if (collection != null && collection.size() >= 1) {
			logout = Boolean.valueOf((Boolean) collection.get(0).getData()
					.get("logout"));
		}

		if (logout) {
			HttpSession session = request.getSession();
			session.setAttribute(Constants.USER_DATA, null);
			session.setAttribute(Constants.OAUTH_TOKEN, null);
			clearLiferayCookies(request, response);
		}

		if (_log.isDebugEnabled()) {
			_log.debug("logged out " + logout);
		}
		return logout;
	}

	/**
	 * Converts the jsonobject returned from the session check api to UserData
	 * bean
	 * 
	 */
	private UserData _getUserDetails(HttpServletRequest request)
			throws IOException {

		boolean authenticated = false;
		String fullName = "";
		String userId = "";
		List<String> roles = new ArrayList<String>();
		EntityCollection collection = new EntityCollection();
		try {
			basicClient.read(collection, PathConstants.SECURITY_SESSION_CHECK,
					BasicQuery.EMPTY_QUERY);
			if (collection != null && collection.size() >= 1) {
				fullName = (String) collection.get(0).getData()
						.get("full_name");
				userId = (String) collection.get(0).getData().get("user_id");
				authenticated = Boolean.valueOf((Boolean) collection.get(0)
						.getData().get("authenticated"));
				roles = (List<String>) collection.get(0).getData()
						.get("granted_authorities");
			}
		} catch (URISyntaxException e) {
			_log.error("Error occurred while calling session chek api..", e);
		}

		UserData userData = new UserData();
		userData.setAuthenticated(authenticated);
		userData.setUser_id(userId);
		userData.setFull_name(fullName);
		userData.setGranted_authorities(roles);
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_DATA, userData);

		if (_log.isDebugEnabled()) {
			_log.debug("Fetching user details from sessioncheck api "
					+ userData);
		}

		return userData;
	}

	/**
	 * Checks whether a user is authenticated
	 * 
	 */
	private boolean _isAuthenticated(HttpServletRequest request,
			HttpServletResponse response) {
		boolean authenticated = false;
		HttpSession session = request.getSession();
		String token = (String) session.getAttribute(Constants.OAUTH_TOKEN);

		if (_log.isDebugEnabled()) {
			_log.debug(" isAuth Fetching token from session ..." + token);
		}

		boolean sessionCheckAuthenticated = true;

		if (Validator.isNotNull(token) && basicClient != null) {
			try {
				sessionCheckAuthenticated = _isSignedIn(basicClient);
			} catch (Exception e) {
				_log.error("Error in Authentication..",e);
			}
		}

		// Check if token exists
		if (token != null && sessionCheckAuthenticated == true) {
			_log.info("inside _isAuthenticated method chk1......" + token);
			authenticated = true;
		} else if (token != null && sessionCheckAuthenticated == false) {
			_log.info("inside _isAuthenticated method chk2......" + token);
			session.setAttribute(Constants.USER_DATA, null);
			session.setAttribute(Constants.OAUTH_TOKEN, null);
			clearLiferayCookies(request, response);
		}
		return authenticated;
	}

	/**
	 * Clear liferay cookies when logged out from liferay
	 */
	private void clearLiferayCookies(HttpServletRequest request,
			HttpServletResponse response) {
		HttpSession session = request.getSession();
		try {

			String domain = CookieKeys.getDomain(request);

			Cookie companyIdCookie = new Cookie(CookieKeys.COMPANY_ID,
					StringPool.BLANK);

			if (Validator.isNotNull(domain)) {
				companyIdCookie.setDomain(domain);
			}

			companyIdCookie.setMaxAge(0);
			companyIdCookie.setPath(StringPool.SLASH);

			Cookie idCookie = new Cookie(CookieKeys.ID, StringPool.BLANK);

			if (Validator.isNotNull(domain)) {
				idCookie.setDomain(domain);
			}

			idCookie.setMaxAge(0);
			idCookie.setPath(StringPool.SLASH);

			Cookie passwordCookie = new Cookie(CookieKeys.PASSWORD,
					StringPool.BLANK);

			if (Validator.isNotNull(domain)) {
				passwordCookie.setDomain(domain);
			}

			passwordCookie.setMaxAge(0);
			passwordCookie.setPath(StringPool.SLASH);

			Cookie rememberMeCookie = new Cookie(CookieKeys.REMEMBER_ME,
					StringPool.BLANK);

			if (Validator.isNotNull(domain)) {
				rememberMeCookie.setDomain(domain);
			}

			rememberMeCookie.setMaxAge(0);
			rememberMeCookie.setPath(StringPool.SLASH);

			CookieKeys.addCookie(request, response, companyIdCookie);
			CookieKeys.addCookie(request, response, idCookie);
			CookieKeys.addCookie(request, response, passwordCookie);
			CookieKeys.addCookie(request, response, rememberMeCookie);

			try {
				session.invalidate();
			} catch (Exception e) {
			}
		} catch (Exception e) {

		}
	}

	/**
	 * Convers the userid retreived from the jsonobject to liferay valid screen
	 * name to create user in liferay
	 * 
	 */
	public static String convertScreenName(String screenName) {
		char screenNameArray[] = screenName.toCharArray();
		for (int i = 0; i < screenNameArray.length; i++) {
			char c = screenNameArray[i];
			if ((!Validator.isChar(c)) && (!Validator.isDigit(c))
					&& (c != CharPool.DASH) && (c != CharPool.PERIOD)
					&& (c != CharPool.UNDERLINE)) {
				screenNameArray[i] = '_';
			}
		}
		return new String(screenNameArray);
	}

	/**
	 * Get token from session to fire rest apis
	 * 
	 */
	protected Object getToken(HttpServletRequest request) {
		return request.getSession().getAttribute(Constants.OAUTH_TOKEN);
	}

	public BasicClient getBasicClient() {
		return basicClient;
	}

	public void setBasicClient(BasicClient basicClient) {
		this.basicClient = basicClient;
	}

	public void setCallbackUrl(String callbackUrl) {
		this.callbackUrl = callbackUrl;
	}

	public String _getCallbackUrl() {
		return callbackUrl;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	public String _getClientId() {
		return clientId;
	}

	public void setClientSecret(String clientSecret) {
		this.clientSecret = clientSecret;
	}

	public String _getClientSecret() {
		return clientSecret;
	}

	public void setApiUrl(String apiUrl) {
		this.apiUrl = apiUrl;
	}

	public String _getApiUrl() {
		return this.apiUrl;
	}

	private BasicClient basicClient;
	private String callbackUrl;
	private String clientId;
	private String clientSecret;
	private String apiUrl;

	private static Log _log = LogFactoryUtil.getLog(SLISSOUtil.class);

	private static SLISSOUtil instance;

}
