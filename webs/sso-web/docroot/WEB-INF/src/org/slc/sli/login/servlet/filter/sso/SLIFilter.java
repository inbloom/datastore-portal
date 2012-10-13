package org.slc.sli.login.servlet.filter.sso;

import java.io.IOException;
import java.net.MalformedURLException;
import javax.servlet.FilterChain;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slc.sli.util.CookieKeys;
import com.liferay.portal.kernel.util.Validator;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.ParamUtil;
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
	//DE1060
	private boolean autoLogout=false;

	/**
	 * Checks if the liferay has to use sli login authentication to log in to
	 * liferay
	 * 
	 */
	@Override
	public boolean isFilterEnabled(HttpServletRequest request,
			HttpServletResponse response) {

		// check for slifilter property enabled
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
	    //US 2131- Realm selection redirect
	    String realmName = ParamUtil.getString(request,"Realm","No Realm");
		
		boolean authenticated = false;
		HttpSession session = request.getSession();

		Object token = session.getAttribute(Constants.OAUTH_TOKEN);

		BasicClient client = SLISSOUtil.getBasicClientObject();

		if (client != null && token != null) {
			client.setToken((String) token);
		}

		// handling logout requests
		if (request.getRequestURL().toString().endsWith("/c/portal/logout")) {
			if (_log.isDebugEnabled()) {
				_log.debug("Logout called");
			}
			if (client != null && token != null) {
				_log.info("client not null");
				SLISSOUtil.logout(client, request, response);
			}else{
				//DE1060 set autologout when directly logout from dashboard
				autoLogout=true;			
			}

			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}
	
		if (client != null && token!=null && autoLogout) {
			if (_log.isDebugEnabled()) {
				_log.debug("Auto Logout");
			}
			autoLogout=false;
			SLISSOUtil.logout(client, request, response);
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}
		
		// handling session timeout
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

		// check if user is authenticated
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

		// if not authenticated, redirect the user to IDP
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

				if (isSignedIn) {
					session.setAttribute(Constants.OAUTH_TOKEN, accessToken);
				} else {
					clearSliCookie(request, response);
					response.sendRedirect(client.getLoginURL().toExternalForm());
				}

				Object entryUrl = session.getAttribute(ENTRY_URL);

				if (entryUrl != null) {
					response.sendRedirect(session.getAttribute(ENTRY_URL)
							.toString());
				} else {
					response.sendRedirect(request.getRequestURI());
				}
			} catch (JsonSyntaxException e) {
				_log.error("Token Extract error.. (JsonSyntaxException)", e);
				response = clearSliCookie(request, response);
				response.sendRedirect("/sli-new-theme/static/tokenerror.html");
			} catch (Exception e) {
				_log.error("Token Extract error..", e);
				// redirect to realm selection in case of token extractor error.
				response = clearSliCookie(request, response);
				response.sendRedirect("/sli-new-theme/static/tokenerror.html");
			}
		} else if (token == null) {
			if (_log.isDebugEnabled()) {
				_log.debug("Connecting to the idp....");
			}
			session.setAttribute(ENTRY_URL, request.getRequestURL());
			//US 2131 - realm selection redirect
			authenticate(request, response,realmName);

		} else {
			response.sendRedirect(request.getRequestURI());
		}
	}

	private void authenticate(HttpServletRequest req, HttpServletResponse res, String realmName) {
		try {
			BasicClient client = SLISSOUtil.getBasicClientObject();
			//US 2131 - realm selection redirect
			res.sendRedirect(client.getLoginURL().toExternalForm()+"&Realm="+realmName);
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
			_log.info("cookie name----"+cookie.getName());
			Cookie openAmCookie = new Cookie(cookie.getName(), "");
			openAmCookie.setDomain(GetterUtil.getString(PropsUtil.get(PropsKeys.SLI_COOKE_DOMAIN)));
			openAmCookie.setMaxAge(0);
			openAmCookie.setValue("");
			openAmCookie.setPath(StringPool.SLASH);
			response.addCookie(openAmCookie);
		}
		return response;
	}

	private static Log _log = LogFactoryUtil.getLog(SLIFilter.class);

}
