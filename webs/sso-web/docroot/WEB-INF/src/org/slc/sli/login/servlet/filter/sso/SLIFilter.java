package org.slc.sli.login.servlet.filter.sso;

import java.io.IOException;
import java.net.MalformedURLException;
import javax.servlet.FilterChain;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;

import org.slc.sli.util.Constants;
import org.slc.sli.util.PropsKeys;
import org.slc.sli.api.client.impl.BasicClient;
import org.slc.sli.login.servlet.filter.BasePortalFilter;

/**
 * SLIFilter.java Purpose: This filter is invoked when the user logs in to
 * liferay portal.
 * 
 * @author
 * @version 1.0
 */

public class SLIFilter extends BasePortalFilter {

	private static final String ENTRY_URL = "ENTRY_URL";

	/**
	 * Checks if the liferay has to use sli login authentication to log in to
	 * liferay
	 * 
	 */
	@Override
	public boolean isFilterEnabled(HttpServletRequest request,
			HttpServletResponse response) {

		// check for slifilter property enabled
		// check if the session check url is not null
		// check if the session check rest api is accesseble - can be removed
		// not needed in prod

		try {
			if (GetterUtil.getBoolean(PropsUtil.get(PropsKeys.SLI_SSO_FILTER))) {
				return true;
			}
		} catch (Exception e) {
			_log.error(e, e);
		}

		return false;
	}

	/**
	 * Invokes the idp url for selection of realm and after logged in with open
	 * am redirects back to liferay
	 * 
	 */
	@Override
	protected void processFilter(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws Exception {

		boolean authenticated = false;
		HttpSession session = request.getSession();

		Object token = session.getAttribute(Constants.OAUTH_TOKEN);

		if (_log.isDebugEnabled()) {
			_log.debug(" isAuth Fetching token from session ..." + token);
		}

		BasicClient client = SLISSOUtil.getBasicClientObject();

		if (client != null && token != null) {
			client.setToken((String) token);
		}

		if (request.getRequestURL().toString().endsWith("/c/portal/logout")) {
			if (_log.isDebugEnabled()) {
				_log.debug("Logout called");
			}
			if (client != null) {
				SLISSOUtil.logout(client, request, response);
			}
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		if (request.getRequestURL().toString()
				.endsWith("/c/portal/expire_session")) {
			if (_log.isDebugEnabled()) {
				_log.debug("Expire session called");
			}
			if (client != null) {
				SLISSOUtil.logout(client, request, response);
			}
			return;
		}

		try {
			authenticated = SLISSOUtil.isAuthenticated(request, response);
		} catch (Exception e) {
			_log.error(e, e);
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}
		if (authenticated) {
			if (_log.isDebugEnabled()) {
				_log.debug(" Already authenticated by passing authentication process");
			}
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		// if not authenticated flow comes here redirects to idp url

		if (client == null) {
			response.sendRedirect(request.getRequestURI());
		} else if (token == null && request.getParameter("code") != null) {
			if (_log.isDebugEnabled()) {
				_log.debug("Extracting token..");
			}
			try {
				String jsonText = handleCallback(request, response);

				JsonParser parser = new JsonParser();
				JsonObject jsonObj = parser.parse(jsonText).getAsJsonObject();
				String accessToken = jsonObj.get("access_token").getAsString();

				boolean isSignedIn = SLISSOUtil.isSignedIn(client);

				Object entryUrl = session.getAttribute(ENTRY_URL);

				if (entryUrl != null) {
					if (isSignedIn) {
						session.setAttribute(Constants.OAUTH_TOKEN, accessToken);
						response.sendRedirect(session.getAttribute(ENTRY_URL)
							.toString());
					} else {
						clearSliCookie(request, response);
						response.sendRedirect(client.getLoginURL().toExternalForm());
					}
				} else {
					if (isSignedIn) {
						session.setAttribute(Constants.OAUTH_TOKEN, accessToken);
						response.sendRedirect(request.getRequestURI());
					} else {
						clearSliCookie(request, response);
						response.sendRedirect(client.getLoginURL().toExternalForm());
					}
				}
			} catch (JsonSyntaxException e) {
				_log.error("Token Extract error.. (JsonSyntaxException)", e);
				response = clearSliCookie(request, response);
				response.sendRedirect(session.getAttribute(ENTRY_URL).toString());
			} catch (Exception e) {
				_log.error("Token Extract error..", e);
				// redirect to realm selection in case of token extractor error.
				response = clearSliCookie(request, response);
				response.sendRedirect(client.getLoginURL().toExternalForm());
			}
		} else if (token == null) {
			if (_log.isDebugEnabled()) {
				_log.debug("Connecting to the idp....");
			}
			session.setAttribute(ENTRY_URL, request.getRequestURL());
			authenticate(request, response);

		} else {
			response.sendRedirect(request.getRequestURI());
		}
	}

	private void authenticate(HttpServletRequest req, HttpServletResponse res) {
		try {
			BasicClient client = SLISSOUtil.getBasicClientObject();
			res.sendRedirect(client.getLoginURL().toExternalForm());
		} catch (MalformedURLException e) {
			throw new RuntimeException(e);
		} catch (IOException e) {
			_log.error("Bad redirect", e);
		}
	}

	private String handleCallback(HttpServletRequest request,
			HttpServletResponse response) {
		BasicClient client = SLISSOUtil.getBasicClientObject();
		String code = ((HttpServletRequest) request).getParameter("code");
		String accessToken = "";
		if (client != null) {
			accessToken = client.connect(code);
		}
		return accessToken;
	}

	private HttpServletResponse clearSliCookie(HttpServletRequest request,
			HttpServletResponse response) {

		Cookie[] cookies = request.getCookies();
		for (Cookie cookie : cookies) {
			Cookie openAmCookie = new Cookie(cookie.getName(), "");
			openAmCookie.setDomain(GetterUtil.getString(PropsUtil
					.get(PropsKeys.SLI_COOKE_DOMAIN)));
			openAmCookie.setMaxAge(0);
			openAmCookie.setValue("");
			openAmCookie.setPath(StringPool.SLASH);
			response.addCookie(openAmCookie);
		}
		return response;
	}

	private static Log _log = LogFactoryUtil.getLog(SLIFilter.class);

}
