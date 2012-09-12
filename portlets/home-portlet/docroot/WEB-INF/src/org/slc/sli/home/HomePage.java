/**
 * 
 */
package org.slc.sli.home;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.ValidatorException;

import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * @author dip
 * 
 */
public class HomePage extends MVCPortlet {
    
    private static final String DO_NOT_SHOW_CHECK_LIST = "doNotShowCheckList";
    private static final String USER_VIEW = "/user-view.jsp";
    private static final String DEVELOPER_VIEW = "/developer-view.jsp";
    public static final String CHECK_LIST = "checkList";
    
    /**
     * whether a user has a Developer role
     * 
     * @return true if he/she has a Developer role
     */
    private boolean isDeveloper() {
        return true;
    }
    
    /**
     * Determine a user does not want to see a check list.
     * 
     * @return true if a user does not want to see a check list
     */
    private boolean isDoShowCheckList(RenderRequest renderRequest) {
        
        PortletPreferences preferences = renderRequest.getPreferences();
        
        String doNotShowCheckList = preferences.getValue(DO_NOT_SHOW_CHECK_LIST, "false");
        
        return doNotShowCheckList.equals("true");
    }
    
    /**
     * build check list
     * 
     * @return
     */
    private List<Map.Entry<String, Boolean>> getCheckList() {
        return null;
    }
    
    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        
        String url = USER_VIEW;
        
        // If a user has a developer role and wants to see a check list,
        // set URL to developer-view.jsp and create a list of a check list.
        if (isDeveloper() && !isDoShowCheckList(renderRequest)) {
            url = DEVELOPER_VIEW;
            renderRequest.setAttribute(CHECK_LIST, getCheckList());
        }
        
        getPortletContext().getRequestDispatcher(url).include(renderRequest, renderResponse);
    }
    
    /**
     * serveResource method is for AJAX handling
     */
    @Override
    public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
        // read doNotShowList value and store in PortalPreferences
        String doNotShowList = ParamUtil.getString(resourceRequest, DO_NOT_SHOW_CHECK_LIST);
        if (doNotShowList != null && doNotShowList.equals("true")) {
            PortletPreferences preferences = resourceRequest.getPreferences();
            try {
                preferences.setValue(DO_NOT_SHOW_CHECK_LIST, "true");
                preferences.store();
            } catch (ReadOnlyException e) {
            } catch (ValidatorException e) {
            } catch (IOException e) {
            }
        }
    }
    
}
