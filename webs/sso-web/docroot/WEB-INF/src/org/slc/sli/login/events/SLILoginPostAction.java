package org.slc.sli.login.events;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.login.servlet.filter.sso.SLISSOUtil;
import org.slc.sli.util.SLIUtil;
import org.slc.sli.util.Constants;
import org.slc.sli.util.PropsKeys;
import org.slc.sli.api.client.impl.BasicClient;
import org.slc.sli.api.client.impl.BasicQuery;
import org.slc.sli.api.client.impl.GenericEntity;
import org.slc.sli.common.constants.ResourceNames;
import org.slc.sli.common.constants.v1.PathConstants;

import org.slc.sli.api.client.Entity;
import org.slc.sli.api.client.EntityCollection;
import javax.ws.rs.core.Response;

import java.net.URISyntaxException;
import java.util.ArrayList;


/**
 * SLILoginPostAction.java
 * 
 * Purpose: This class is called automatically every time when a user logged in
 * to liferay. Responsible for mapping the SLI roles with Liferay roles
 * 
 * @author
 * @version 1.0
 */

public class SLILoginPostAction extends Action {
	   /*private static final String EDORGS_URL = "v1/educationOrganizations/";
	    private static final String CUSTOM_DATA = "/custom";*/

	@Override
	public void run(HttpServletRequest request, HttpServletResponse response) {

		try {
			HttpSession session = request.getSession();

			User user = (User) session.getAttribute(WebKeys.USER);

			UserData userData = (UserData) session
					.getAttribute(Constants.USER_DATA);

			boolean isAdmin = SLIUtil.isAdmin(userData);

			boolean isLiferayAdmin = SLIUtil.isLiferayAdmin(userData);

			long companyId = PortalUtil.getCompanyId(request);

			Role sliEducatorRole = RoleLocalServiceUtil
					.getRole(companyId, GetterUtil.getString(PropsUtil
							.get(PropsKeys.ROLE_EDUCATOR)));

			Role adminRole = RoleLocalServiceUtil.getRole(companyId,
					RoleConstants.ADMINISTRATOR);
			
			System.out.println("inside login post action...."+isLiferayAdmin);
			if (isLiferayAdmin) {
				if (!RoleLocalServiceUtil.hasUserRole(user.getUserId(),
						adminRole.getRoleId())) {

					long[] adminRoleIds = { adminRole.getRoleId() };

					RoleLocalServiceUtil.addUserRoles(user.getUserId(),
							adminRoleIds);
					if (_log.isDebugEnabled()) {
						_log.debug("Adding Liferay Admin role ");
					}
				}
			} else {
				if (!RoleLocalServiceUtil.hasUserRole(user.getUserId(),
						sliEducatorRole.getRoleId())) {

					long[] educatorRoleIds = { sliEducatorRole.getRoleId() };
					RoleLocalServiceUtil.addUserRoles(user.getUserId(),
							educatorRoleIds);
					if (_log.isDebugEnabled()) {
						_log.debug("Adding Educator role ");
					}
				}
			}
			
			/////////////////
			/*long userId = PortalUtil.getUserId(request);
			

			System.out.println("token value si ....***"+request.getSession().getAttribute("OAUTH_TOKEN"));
			
			BasicClient client = (BasicClient)request.getSession().getAttribute("client");

	      	HttpSession session1 = request.getSession();
			UserData userData1 = (UserData)session1.getAttribute(Constants.USER_DATA);

			try{
				EntityCollection collection = new EntityCollection();
		        try {
		        	 Response response1 = client.read(collection, ResourceNames.EDUCATION_ORGANIZATIONS, BasicQuery.Builder.create().startIndex(0).maxResults(50)
		                    .build());
		        	 _log.info("!!!!!!!!!!!@@@@@@@@@@@@@@############*****"+response1.getStatus());
		        } catch (URISyntaxException e) {
		            //LOG.error("Exception occurred", e);
		        }
		        ArrayList<String> toReturn = new ArrayList<String>();
		        
		        org.slc.sli.client.RESTClient rc= SLISSOUtil.getRestClientRC();
		        
		        String token = "token";
		        String id = "id";
	

		        
		        _log.info("inside update terms create eula chk 1"+rc);
		        String url = rc.getSecurityUrl()+"api/rest/" + EDORGS_URL + id + CUSTOM_DATA;
		        _log.info("inside update terms create eula chk 2"+url);
		        org.slc.sli.client.GenericEntity ge=new org.slc.sli.client.GenericEntity();
		        ge.put("eulaid", "12334");
		        
		       
		        
		        rc.putEntityToAPI(url,(String)request.getSession().getAttribute("OAUTH_TOKEN"),ge);
		        org.slc.sli.client.GenericEntity ge1=new org.slc.sli.client.GenericEntity();
		        ge1= rc.createEntityFromAPI(url,(String)request.getSession().getAttribute("OAUTH_TOKEN") );
		        
		        _log.info("reading eula custom entity chk 3");

				}catch(Exception e){e.printStackTrace();}*/
				
			
			////////////

		} catch (Exception e) {
			_log.error(e, e);
		}

	}

	private static Log _log = LogFactoryUtil.getLog(SLILoginPostAction.class);

}