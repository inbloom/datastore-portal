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

import com.google.gson.JsonObject;
import com.google.gson.Gson;

import org.slc.sli.client.RESTClient;
import org.slc.sli.util.Constants;
import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.util.CookieKeys;
import org.slc.sli.encrypt.EncryptUtils;

import org.slc.sli.api.client.Entity;
import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.impl.BasicClient;
import org.slc.sli.api.client.impl.BasicQuery;
import org.slc.sli.api.client.impl.GenericEntity;
import org.slc.sli.common.constants.ResourceNames;
import org.slc.sli.common.constants.v1.PathConstants;

import javax.ws.rs.core.Response;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SLISSOUtil.java
 * 
 * Purpose: contains methods to check user is authenticated, logout.
 * 
 * @author
 * @version 1.0
 */

public class SLISSOUtil {

	//private EncryptUtils aesDecrypt;

	//private RESTClient restClient;

	/*public void setAesDecrypt(EncryptUtils aesDecrypt) {
		this.aesDecrypt = aesDecrypt;
	}

	public EncryptUtils _getAesDecrypt() {
		return aesDecrypt;
	}

	public static EncryptUtils getAesDecrypt() {
		return instance._getAesDecrypt();
	}*/

	/*public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}*/

	public SLISSOUtil() {
		this.instance = this;
	}

	/*public static RESTClient getRestClientRC() {
		return instance.getRestClient();
	}*/
	
	public static boolean isAuthenticated(HttpServletRequest request,
			HttpServletResponse response) {
		return instance._isAuthenticated(request, response);
	}

	public static UserData getUserDetails(HttpServletRequest request)throws IOException {
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

	public static boolean logout(BasicClient client)throws IOException {
		return instance._logout(client);
	}

 private List<String> getRoles(BasicClient client) throws IOException {
        List<String> roles = new ArrayList<String>();
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
        	 _log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	roles= (List<String>)collection.get(0).getData().get("granted_authorities");
        }
        return roles;
    }
    
    private boolean isAuthenticated(BasicClient client) throws IOException {
        boolean authenticated = false;
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
        	 _log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	authenticated= Boolean.valueOf((Boolean)collection.get(0).getData().get("authenticated"));
        }
        return authenticated;
    }
    
    private String getUserId(BasicClient client) throws IOException {
        String userId = "";
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
        	 _log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	userId= (String)collection.get(0).getData().get("user_id");
        }
        return userId;
    }
    
    private static String getFullName(BasicClient client) throws IOException {
        String fullName = "";
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
        	 //_log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	fullName= (String)collection.get(0).getData().get("full_name");
        }
        return fullName;
    }

    private boolean _logout(BasicClient client) throws IOException {
        boolean logout = false;
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_LOGOUT, BasicQuery.EMPTY_QUERY);
        	 System.out.println("logout called...."+response2.getStatus());
        	 //_log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	logout= Boolean.valueOf((Boolean)collection.get(0).getData().get("logout"));
        	System.out.println("value of logout is ***###"+logout);
        }
        return logout;
    }

	/**
	 * Converts the jsonobject returned from the session check api to UserData
	 * bean
	 * 
	 */
	private UserData _getUserDetails(HttpServletRequest request)throws IOException {

		/*String token = getToken(request).toString();
		JsonObject json = this.restClient.sessionCheck(token);
		// store UserData object in session for futrhur ref
		UserData userData = new Gson().fromJson(json, UserData.class);
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_DATA, userData);*/
		BasicClient client = (BasicClient)request.getSession().getAttribute("client");
		boolean authenticated = false;
        String fullName = "";
        String userId = "";
        List<String> roles = new ArrayList<String>();
        EntityCollection collection = new EntityCollection();
        try {
        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
        	 //_log.info("response2-------"+response2.getStatus());
        } catch (URISyntaxException e) {
        	e.printStackTrace();
            //LOG.error("Exception occurred", e);
        }

        if (collection != null && collection.size() >= 1) {
        	fullName= (String)collection.get(0).getData().get("full_name");
        	userId= (String)collection.get(0).getData().get("user_id");
        	authenticated= Boolean.valueOf((Boolean)collection.get(0).getData().get("authenticated"));
        	roles= (List<String>)collection.get(0).getData().get("granted_authorities");
        }
        
		UserData userData = new UserData();
		userData.setAuthenticated(authenticated);
		userData.setUser_id(userId);
		userData.setFull_name(fullName);
		userData.setGranted_authorities(roles);
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_DATA, userData);
		return userData;
	}

	/**
	 * Logout from sli domain and clears the userdataobject and token from the
	 * httpse
	 * 
	 */
	/*private boolean _logout(HttpServletRequest request) {

		String token = getToken(request).toString();
		JsonObject json = this.restClient.logout(token);
		boolean logout = json.get("logout").getAsBoolean();
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_DATA, null);
		session.setAttribute(Constants.OAUTH_TOKEN, null);
		return logout;
	}*/

	/**
	 * Checks whether a user is authenticated
	 * 
	 */
		private boolean _isAuthenticated(HttpServletRequest request,
			HttpServletResponse response) {
		boolean authenticated = false;
		HttpSession session = request.getSession();
		String token = (String) session.getAttribute(Constants.OAUTH_TOKEN);
		
		BasicClient client = (BasicClient)request.getSession().getAttribute("client");
//DE 766 removed log info
		boolean sessionCheckAuthenticated = true;

		if (Validator.isNotNull(token) && client!=null) {
			/*JsonObject json = this.restClient.sessionCheck(token);

			sessionCheckAuthenticated = json.get("authenticated")
					.getAsBoolean();*/
			try{
				sessionCheckAuthenticated = isAuthenticated(client);
			}catch(Exception e){
				
			}
		}

		// Check if token exists
		if (token != null && sessionCheckAuthenticated == true) {
			authenticated = true;
		} else if (token != null && sessionCheckAuthenticated == false) {
			session.setAttribute(Constants.USER_DATA, null);
			session.setAttribute(Constants.OAUTH_TOKEN, null);

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
		return authenticated;
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

	public String _getClientSecret() {
		return clientSecret;
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

	public void setCallbackUrl(String callbackUrl) {
		this.callbackUrl = callbackUrl;
	}

	public void setApiUrl(String apiUrl) {
		this.apiUrl = apiUrl;
	}

	public String _getApiUrl() {
		return this.apiUrl;
	}

	private String callbackUrl;
	private String clientId;
	private String clientSecret;
	private String apiUrl;

	private static Log _log = LogFactoryUtil.getLog(SLISSOUtil.class);

	private static SLISSOUtil instance;

}