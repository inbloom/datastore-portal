package org.slc.sli.login.servlet.filter.sso;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.GeneralSecurityException;
import javax.servlet.FilterChain;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

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

		if (request.getRequestURL().toString().endsWith("/c/portal/logout")) {
			BasicClient client = (BasicClient) request.getSession()
					.getAttribute("client");
			SLISSOUtil.logout(client);
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		if (request.getRequestURL().toString()
				.endsWith("/c/portal/expire_session")) {
			BasicClient client = (BasicClient) request.getSession()
					.getAttribute("client");
			SLISSOUtil.logout(client);
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
			processFilter(SLIFilter.class, request, response, filterChain);
			return;
		}

		// if not authenticated flow comes here redirects to idp url

		HttpSession session = request.getSession();

		Object token = session.getAttribute(Constants.OAUTH_TOKEN);

		if (token == null && request.getParameter("code") != null) {
			try {
				String jsonText = handleCallback(request, response);

				JsonParser parser = new JsonParser();
				JsonObject jsonObj = parser.parse(jsonText).getAsJsonObject();
				String accessToken = jsonObj.get("access_token").getAsString();
				session.setAttribute(Constants.OAUTH_TOKEN, accessToken);
				_log.info("token is ......" + accessToken);
				Object entryUrl = session.getAttribute(ENTRY_URL);
				if (entryUrl != null) {
					response.sendRedirect(session.getAttribute(ENTRY_URL)
							.toString());
				} else {
					response.sendRedirect(request.getRequestURI());
				}
			} catch (Exception e) {
				e.printStackTrace();
				// redirect to realm selection in case of token extractor error.
				response = clearSliCookie(request, response);
				BasicClient client = (BasicClient) ((HttpServletRequest) request)
						.getSession().getAttribute("client");
				response.sendRedirect(client.getLoginURL().toExternalForm());
			}
		} else if (token == null) {
			session.setAttribute(ENTRY_URL, request.getRequestURL());
			authenticate(request, response);

		} else {
			// LOG.debug("Using access token " + token);
			// addAuthentication((String) token);
			response.sendRedirect(request.getRequestURI());
		}
	}

	private void authenticate(HttpServletRequest req, HttpServletResponse res) {

		try {
			URL apiURL = new URL(SLISSOUtil.getApiUrl());
			URL callBackURL = new URL(SLISSOUtil.getCallbackUrl());

			/*
			 * BasicClient client = new BasicClient(apiURL, SLISSOUtil
			 * .getAesDecrypt().decrypt(SLISSOUtil.getClientId()),
			 * SLISSOUtil.getAesDecrypt().decrypt(
			 * SLISSOUtil.getClientSecret()), callBackURL);
			 */

			BasicClient client = new BasicClient(apiURL,
					SLISSOUtil.getClientId(), SLISSOUtil.getClientSecret(),
					callBackURL);

			res.sendRedirect(client.getLoginURL().toExternalForm());
			req.getSession().setAttribute("client", client);
		} catch (MalformedURLException e) {
			throw new RuntimeException(e);
		} catch (IOException e) {
			_log.error("Bad redirect", e);
		} /*catch (GeneralSecurityException gse) {

		}*/

	}

	private String handleCallback(HttpServletRequest request,
			HttpServletResponse response) {
		BasicClient client = (BasicClient) ((HttpServletRequest) request)
				.getSession().getAttribute("client");
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