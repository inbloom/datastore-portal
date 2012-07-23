
package org.slc.sli.portal.action;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.struts.BaseStrutsAction;
import com.liferay.portal.kernel.util.StringUtil;

import com.liferay.portal.model.User;
import com.liferay.portal.service.UserServiceUtil;

import com.liferay.portal.util.PortalUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.core.Response;

import org.slc.sli.api.client.Entity;
import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.impl.BasicClient;
import org.slc.sli.api.client.impl.BasicQuery;
import org.slc.sli.api.client.impl.GenericEntity;
import org.slc.sli.common.constants.ResourceNames;
import org.slc.sli.common.constants.v1.PathConstants;
import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.login.servlet.filter.sso.SLISSOUtil;

import org.slc.sli.util.Constants;

/**
 * @author 
 */
public class UpdateTermsOfUseAction extends BaseStrutsAction  {
    private static final String EDORGS_URL = "v1/educationOrganizations/";
    private static final String CUSTOM_DATA = "/custom";

	public String execute(
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

			long userId = PortalUtil.getUserId(request);
				
			BasicClient client = SLISSOUtil.getBasicClientObject();
	      	
	      	UserData userData = SLISSOUtil.getUserDetails(request);

			try{
				EntityCollection collection = new EntityCollection();
		        try {
		        	 Response response1 = client.read(collection, ResourceNames.EDUCATION_ORGANIZATIONS, BasicQuery.Builder.create().startIndex(0).maxResults(50)
		                    .build());
		        } catch (URISyntaxException e) {
		            //LOG.error("Exception occurred", e);
		        }
		        ArrayList<String> toReturn = new ArrayList<String>();
				}catch(Exception e){e.printStackTrace();}
				
			return "/common/referer_js.jsp";
		}
	
		private Map<String,Object> createEULA(String userId,boolean flag){
	        Map<String, Object> body = new HashMap<String, Object>();
	        Map<String, String> eula = new HashMap<String, String>();
	        eula.put("userId", userId);
	        eula.put("flag", String.valueOf(flag));
	        eula.put("timeStamp", new Date().toString());
	        body.put("eula", eula);
	        return body;

		}
		private static Log _log = LogFactoryUtil.getLog(UpdateTermsOfUseAction.class);
}