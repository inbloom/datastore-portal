/**
 * 
 */
package org.slc.sli.home;

import java.io.IOException;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * @author dip
 *
 */
public class HomeImpl extends MVCPortlet {
	@Override
    public void processAction(
            ActionRequest actionRequest, ActionResponse actionResponse)
        throws IOException, PortletException {
		
		//sample of reading preferences
        PortletPreferences prefs = actionRequest.getPreferences();
        String greeting = actionRequest.getParameter("greeting");

        if (greeting != null) {
            prefs.setValue("greeting", greeting);
            prefs.store();
        }

        super.processAction(actionRequest, actionResponse);
    }
	
	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse) 
			throws IOException, PortletException{
		
		String[] checkList = new String[] { "Provision Landing Zone", "Upload Data", "Add Users", "Create App", "Enable App" };
		renderRequest.setAttribute("checkList", checkList);
		super.doView(renderRequest, renderResponse);
	}
	  
}
