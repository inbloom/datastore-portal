/**
 * 
 */
package org.slc.sli.home;

import java.io.IOException;
import org.slc.sli.client.CheckListHelper;
import java.util.List;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletMode;
import javax.portlet.PortletModeException;
import javax.portlet.PortletPreferences;
import javax.portlet.ReadOnlyException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.PortletException;
import javax.portlet.ValidatorException;
import javax.portlet.WindowState;
import javax.portlet.WindowStateException;
import javax.servlet.http.HttpSession;

import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * @author dip
 * 
 */
public class HomePage extends MVCPortlet {
    
    public static final String DO_NOT_SHOW_CHECK_LIST = "doNotShowCheckList";
    private static final String OAUTH_TOKEN = "OAUTH_TOKEN";
    private static final String USER_VIEW = "/user-view.jsp";
    private static final String DEVELOPER_VIEW = "/developer-view.jsp";
    public static final String CHECK_LIST = "checkList";
    
    /**
     * whether a user has a Developer role
     * 
     * @return true if he/she has a Developer role
     */
    private boolean isDeveloper() {
    	// Do a session check to see if sliRoles is "Application Developer"
        return true;
    }
    
    /**
     * Determine a user does not want to see a check list.
     * 
     * @return true if a user does not want to see a check list
     */
    private boolean isDoShowCheckList(RenderRequest renderRequest) {
        
        PortletPreferences preferences = renderRequest.getPreferences();
        
        String doNotShowCheckList = preferences.getValue(DO_NOT_SHOW_CHECK_LIST, Boolean.FALSE.toString());
        
        return doNotShowCheckList.equals(Boolean.TRUE.toString());
    }
    
    /**
     * build check list
     * 
     * @return
     */
    private List<Map.Entry<String, Boolean>> getCheckList(String token) {
    	CheckListHelper checkListHelper = new CheckListHelper(token);
        return checkListHelper.getCheckList();
    }
    
    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        
        String url = USER_VIEW;
        
        // If a user has a developer role and wants to see a check list,
        // set URL to developer-view.jsp and create a list of a check list.
        if (isDeveloper()) {
            url = DEVELOPER_VIEW;
            List<Map.Entry<String, Boolean>> checkList = null;
            if (!isDoShowCheckList(renderRequest)) {
            	HttpSession session = PortalUtil.getHttpServletRequest(renderRequest).getSession(false);

         		String token = (String) session.getAttribute(OAUTH_TOKEN);
                checkList = getCheckList(token);
            }
            renderRequest.setAttribute(CHECK_LIST, checkList);
        }
        
        getPortletContext().getRequestDispatcher(url).include(renderRequest, renderResponse);
    }
    
    /**
     * When a User hits "Apply", this method will be executed.
     */
    @Override
    public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) {
        // read doNotShowList value and store in PortalPreferences
        String doNotShowList = ParamUtil.getString(actionRequest, DO_NOT_SHOW_CHECK_LIST);
        if (doNotShowList != null && doNotShowList.equals(Boolean.TRUE.toString())) {
            PortletPreferences preferences = actionRequest.getPreferences();
            try {
                preferences.setValue(DO_NOT_SHOW_CHECK_LIST, Boolean.TRUE.toString());
                preferences.store();
            } catch (ReadOnlyException e) {
            } catch (ValidatorException e) {
            } catch (IOException e) {
            }
        }
        try {
            actionResponse.setPortletMode(PortletMode.VIEW);
            actionResponse.setWindowState(WindowState.NORMAL);
        } catch (PortletModeException e) {
            
        } catch (WindowStateException e) {
            e.printStackTrace();
        }
    }
    
}
