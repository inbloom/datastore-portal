package com.sli.portlet.action;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.servlet.http.HttpSession;
import javax.xml.namespace.QName;

import org.slc.sli.json.bean.AppsData;
import org.slc.sli.util.AppsUtil;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.sli.util.PropsKeys;
import com.liferay.portal.kernel.util.HttpUtil;
import javax.servlet.http.HttpServletRequest;

/**
 * Portlet implementation class AppSelectionInterfacePortlet
 */
public class AppSelectionInterfacePortlet extends MVCPortlet {

	private List<AppsData> appList = null;

	@Override
	public void render(RenderRequest renderRequest,
			RenderResponse renderResponse) throws PortletException, IOException {

		HttpSession session = PortalUtil.getHttpServletRequest(renderRequest)
				.getSession(false);

		String tokenFromReq = (String) session.getAttribute("OAUTH_TOKEN");

			//DE 766 removed token log statement
		try {
			List<AppsData> appsData = AppsUtil.getUserApps(tokenFromReq);

			List<AppsData> tempAppsData = new ArrayList<AppsData>(appsData);

			// DE505- checked current url and removed from list
			String currUrl = "https://" + renderRequest.getServerName()
					+ "/portal";

			_log.info("current url---" + currUrl);

			for (AppsData apps : tempAppsData) {
				if (apps.getApplication_url().contains(currUrl)) {
					appsData.remove(apps);
				}
			}

			appList = appsData;
			renderRequest.setAttribute("appList", appsData);
		} catch (NullPointerException e) {
			_log.info("json response is null");
		}
		super.render(renderRequest, renderResponse);
	}

	/**
	 * <b> This method process wsrl action and opens wsrp page with appropriate
	 * wsrp portlet</b>
	 * 
	 * @param actionRequest
	 * @param actionResponse
	 * @throws IOException
	 * @throws PortletException
	 */

	@ProcessAction(name = "openwsrppage")
	public void processWsrpAction(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		String url = actionRequest.getParameter("url");
		actionResponse.setEvent(new QName("http:sli.com/events", "wsrpurl"),
				url);

		String wsrpPage = GetterUtil.getString(PropsUtil
				.get(PropsKeys.WSRP_PAGE));

		// Hide default success Message
		PortletConfig portletConfig = (PortletConfig) actionRequest
				.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(actionRequest, portletConfig.getPortletName()
				+ SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

		actionResponse.sendRedirect(wsrpPage);
	}

	/**
	 * <b> This method process Iframe action and opens Iframe page with proper
	 * url</b>
	 * 
	 * @param actionRequest
	 * @param actionResponse
	 * @throws IOException
	 * @throws PortletException
	 */
	@ProcessAction(name = "openiframepage")
	public void processIframeAction(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		String url = actionRequest.getParameter("url");

		// Hide default success message
		PortletConfig portletConfig = (PortletConfig) actionRequest
				.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(actionRequest, portletConfig.getPortletName()
				+ SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

                if (checkUrl(url)) {
			String encodedUrl = "";

			// DE 660 - Encoded url in iframe page.
			encodedUrl = HttpUtil.encodeURL(url);
			_log.info("encoded url===== " + encodedUrl);

			String iframePage = GetterUtil.getString(PropsUtil
					.get(PropsKeys.IFRAME_PAGE));

			HttpServletRequest request = PortalUtil
					.getHttpServletRequest(actionRequest);
			HttpSession session = request.getSession(false);
			session.setAttribute("iframeSrc", url);

			actionResponse.sendRedirect(iframePage + "#" + encodedUrl);
		} else {
			actionResponse.sendRedirect("/portal/web/guest/error");
		}
	}

	boolean checkUrl(String url) {
		boolean validUrl = false;
		for (AppsData app : appList) {
			String appUrl = app.getApplication_url();
			if (appUrl.equals(url)) {
				validUrl = true;
				break;
			}
		}
		return validUrl;
	}

	private static Log _log = LogFactoryUtil
			.getLog(AppSelectionInterfacePortlet.class);
}
