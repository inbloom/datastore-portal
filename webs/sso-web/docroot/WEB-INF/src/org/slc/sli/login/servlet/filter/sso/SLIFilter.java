package org.slc.sli.login.servlet.filter.sso;

import javax.servlet.FilterChain;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.stream.MalformedJsonException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;

import org.scribe.builder.ServiceBuilder;
import org.scribe.model.Token;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;

import org.slc.sli.security.SliApi;
import org.slc.sli.util.Constants;
import org.slc.sli.util.PropsKeys;
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

		try {
			authenticated = SLISSOUtil.isAuthenticated(request, response);
		} catch (Exception e) {
			_log.error(e, e);
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		if (authenticated) {
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		// if not authenticated flow comes here redirects to idp url

		HttpSession session = request.getSession();
		SliApi.setBaseUrl(SLISSOUtil.getApiUrl());

		OAuthService service = new ServiceBuilder()
				.provider(SliApi.class)
				.apiKey(SLISSOUtil.getAesDecrypt().decrypt(
						SLISSOUtil.getClientId()))
				.apiSecret(
						SLISSOUtil.getAesDecrypt().decrypt(
								SLISSOUtil.getClientSecret()))
				.callback(SLISSOUtil.getCallbackUrl()).build();

		Object token = session.getAttribute(Constants.OAUTH_TOKEN);

		if (token == null && request.getParameter("code") != null) {
			try{
				Verifier verifier = new Verifier(request.getParameter("code"));
				Token accessToken = service.getAccessToken(null, verifier);
				_log.info("token is ......" + accessToken);
				session.setAttribute(Constants.OAUTH_TOKEN, accessToken.getToken());
				Object entryUrl = session.getAttribute(ENTRY_URL);
				if (entryUrl != null) {
					response.sendRedirect(session.getAttribute(ENTRY_URL)
							.toString());
				} else {
					response.sendRedirect(request.getRequestURI());
				}
			}catch(Exception e){
				//redirect to realm selection in case of token extractor error.
				response = clearSliCookie(request,response);
				String authUrl = service.getAuthorizationUrl(null);
				response.sendRedirect(authUrl);
			}

		} else if (token == null) {
			session.setAttribute(ENTRY_URL, request.getRequestURL());
			// The request token doesn't matter for OAuth 2.0 which is why it's
			// null
			String authUrl = service.getAuthorizationUrl(null);
			response.sendRedirect(authUrl);
		} else {
			// LOG.debug("Using access token " + token);
			// addAuthentication((String) token);
			response.sendRedirect(request.getRequestURI());
		}
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