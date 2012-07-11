package com.sli.portlet.action;




import java.io.IOException;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.servlet.http.HttpSession;

import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.impl.CustomClient;
import org.slc.sli.constant.StaticText;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.sli.util.TextUtil;

/**
 * Portlet implementation class HomeTextPortlet
 */
public class AdminContentPortlet extends MVCPortlet {
 
	@Override
	public void render(RenderRequest request, RenderResponse response)
			throws PortletException, IOException {
		
		HttpSession session = PortalUtil.getHttpServletRequest(request).getSession(false);
		
		String token = (String)session.getAttribute("OAUTH_TOKEN");
		
		String adminText;
		
		CustomClient  customClient= TextUtil.getCustomClientObject();
		
		_log.info("inside admin content portlet ************* customClient --- "+customClient);
		
		customClient.setToken(token);
		_log.info(token);
		

		EntityCollection collection = new EntityCollection();
		try {
				customClient.read(collection, StaticText.jsonContent);
				
				System.out.println("inside hometext portlet chk1************* --- "+collection);
				
			if (collection != null && collection.size() >= 1) {
				adminText = String.valueOf((String)collection.get(0).getData().get("adminText"));
	
				_log.info("Admin Welcome Text----"+adminText);
				
				request.setAttribute("admin",adminText);
				}
		} catch (Exception e) {
			
		_log.info("Error Occured......");	
		}
		
		super.render(request, response);
	}
	
	
	
		
	private static Log _log = LogFactoryUtil.getLog(AdminContentPortlet.class);
	
	
}
