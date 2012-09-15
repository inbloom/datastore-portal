/**
 * 
 */
package org.slc.sli.home;

import java.io.IOException;

import org.slc.sli.client.RESTClient;
import org.slc.sli.util.CheckListHelper;

import java.util.List;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletMode;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.PortletException;
import javax.portlet.WindowState;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PropsUtil;
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
    private static final String SLI_ROLES = "sliRoles";
    private static final String DEVELOPER = "Application Developer";
    private static final String IS_SANDBOX = "is_sandbox";
    private static final String DEVELOPER_HOME = "Developer Home";
    private static final String HOME = "Home";
    
    private static RESTClient restClient;
    
    /**
     * whether a user has a Developer role
     * 
     * @return true if he/she has a Developer role
     */
    private boolean isDeveloperAndSandbox(JsonObject mySession) {
        
        boolean developer = false;
        
        boolean is_sandbox = GetterUtil.getBoolean(PropsUtil.get(IS_SANDBOX));
        // check if portal is running sandbox mode.
        if (is_sandbox) {
            // Do a session check to see if sliRoles is "Application Developer"
            JsonElement sli_role_element = mySession.get(SLI_ROLES);
            if (sli_role_element != null && !sli_role_element.isJsonNull()) {
                JsonArray sli_roles = sli_role_element.getAsJsonArray();
                for (JsonElement sli_role : sli_roles) {
                    if (sli_role != null && !sli_role.isJsonNull()) {
                        if (sli_role.getAsString().equals(DEVELOPER)) {
                            developer = true;
                            break;
                        }
                    }
                }
            }
        }
        return developer;
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
    private List<CheckListHelper.CheckList> getCheckList(String token, JsonObject mySession) {
        CheckListHelper checkListHelper = new CheckListHelper();
        return checkListHelper.getCheckLists(token, mySession);
    }
    
    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
        
        String url = USER_VIEW;
        HttpSession session = PortalUtil.getHttpServletRequest(renderRequest).getSession(false);
        String token = (String) session.getAttribute(OAUTH_TOKEN);
        JsonObject mySession = restClient.sessionCheck(token);
        // If a user has a developer role and wants to see a check list,
        // set URL to developer-view.jsp and create a list of a check list.
        if (isDeveloperAndSandbox(mySession)) {
            url = DEVELOPER_VIEW;
            List<CheckListHelper.CheckList> checkList = null;
            if (!isDoShowCheckList(renderRequest)) {
                
                checkList = getCheckList(token, mySession);
            }
            renderRequest.setAttribute(CHECK_LIST, checkList);
            renderResponse.setTitle(DEVELOPER_HOME);
        } else {
            renderResponse.setTitle(HOME);
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
        if (doNotShowList != null && !doNotShowList.equals(Boolean.TRUE.toString())) {
            PortletPreferences preferences = actionRequest.getPreferences();
            try {
                preferences.setValue(DO_NOT_SHOW_CHECK_LIST, Boolean.TRUE.toString());
                preferences.store();
            } catch (Exception e) {
            }
        }
        try {
            actionResponse.setPortletMode(PortletMode.VIEW);
            actionResponse.setWindowState(WindowState.NORMAL);
        } catch (Exception e) {
        }
    }
    
    public void setRestClient(RESTClient restClient) {
        HomePage.restClient = restClient;
    }
}
