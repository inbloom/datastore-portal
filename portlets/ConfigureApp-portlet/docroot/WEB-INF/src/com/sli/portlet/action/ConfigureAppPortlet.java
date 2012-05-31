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
import org.slc.sli.json.bean.UserData;
import org.slc.sli.util.AppsUtil;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.sli.util.PropsKeys;

/**
 * Portlet implementation class ConfigureAppPortlet
 */
public class ConfigureAppPortlet extends MVCPortlet {
	@Override
	public void render(RenderRequest renderRequest,
			RenderResponse renderResponse) throws PortletException, IOException {

		HttpSession session = PortalUtil.getHttpServletRequest(renderRequest)
				.getSession(false);

		String tokenFromReq = (String) session.getAttribute("OAUTH_TOKEN");

		_log.info(tokenFromReq);
		// String token = "e88cb6d1-771d-46ac-a207-2e58d7f12196";

		// check whether user is admin user or not
		UserData userdata = AppsUtil.getUserData(tokenFromReq);
		boolean isAdmin = AppsUtil.isAdmin(userdata);
		_log.info("is admin  " + isAdmin);

		if (isAdmin) {
			try {
				List<AppsData> appsData = AppsUtil.getUserApps(tokenFromReq);

				
				List<AppsData> tempAppsData = new ArrayList<AppsData>(appsData);
				
				//DE505- checked current url and removed from list
				String currUrl = "https://"+renderRequest.getServerName()+"/portal";
					
				_log.info("current url---"+currUrl);
				
				for(AppsData apps : tempAppsData){
					if(apps.getApplication_url().contains(currUrl)){
						appsData.remove(apps);
					}
				}
				renderRequest.setAttribute("appList", appsData);
			} catch (Exception e) {
				_log.info("json response is null");
			}
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

	@ProcessAction(name = "openwsrppageofconfapp")
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
	@ProcessAction(name = "openiframepageofconfapp")
	public void processIframeAction(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		String url = actionRequest.getParameter("url");
		URL appUrl = new URL(url);
		HttpURLConnection connection = (HttpURLConnection) appUrl
				.openConnection();
		connection.setRequestMethod("GET");
		connection.connect();

		int code = connection.getResponseCode();

		// Hide default success message
		PortletConfig portletConfig = (PortletConfig) actionRequest
				.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		SessionMessages.add(actionRequest, portletConfig.getPortletName()
				+ SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

		if (code == 200) {

			actionResponse.setEvent(new QName("http:sli.com/events",
					"iframeurl"), url);

			String iframePage = GetterUtil.getString(PropsUtil
					.get(PropsKeys.IFRAME_PAGE));

			actionResponse.sendRedirect(iframePage + "#" + url);
		} else {

			actionResponse.sendRedirect("/portal/web/guest/error");
		}
	}

	private static Log _log = LogFactoryUtil.getLog(ConfigureAppPortlet.class);

}
