package org.slc.sli.portal.action;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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

import org.slc.sli.util.Constants;

/**
 * @author 
 */
public class UpdateTermsOfUseAction extends BaseStrutsAction  {

	public String execute(
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

			long userId = PortalUtil.getUserId(request);
	
			//User usr = UserServiceUtil.updateAgreedToTermsOfUse(userId, true);
			
			//System.out.println("inside update terms of use action class*****************************"+usr.getAgreedToTermsOfUse());
			
			System.out.println("token value si ....***"+request.getSession().getAttribute("OAUTH_TOKEN"));
			
			BasicClient client = (BasicClient)request.getSession().getAttribute("client");

	        
			try{
				EntityCollection collection = new EntityCollection();
		        try {
		        	 Response response1 = client.read(collection, ResourceNames.STUDENTS, BasicQuery.Builder.create().startIndex(0).maxResults(50)
		                    .build());
		        	 _log.info("*****"+response1.getStatus());
		        } catch (URISyntaxException e) {
		            //LOG.error("Exception occurred", e);
		        }
		        ArrayList<String> toReturn = new ArrayList<String>();
		        for (Entity student : collection) {
		            String firstName = (String) ((Map<String, Object>) student.getData().get("name")).get("firstName");
		            String lastName = (String) ((Map<String, Object>) student.getData().get("name")).get("lastSurname");
		            _log.info("firstName%%%%%%5..."+firstName);
		            _log.info("lastNam%%%%%%%%%%..."+lastName);
		            toReturn.add(lastName + ", " + firstName);
		        }
				}catch(Exception e){e.printStackTrace();}
				
				
	        
				try{
					_log.info("roles is %%%%%%%%%%%%%%%%%%%%%"+getRoles(client));
					}catch(Exception e){e.printStackTrace();}
					
					
        	HttpSession session = request.getSession();
			UserData userData = (UserData)session.getAttribute(Constants.USER_DATA);

	        //check if the eula record already exist for this user
	        EntityCollection collection = new EntityCollection();
	        try {
	        	_log.info("chk1 ....");
	            client.read(collection, "EULA", BasicQuery.Builder.create().startIndex(0).maxResults(50)
	                    .build());
	            _log.info("chk2 ...."+collection.size());
	            
	            for (Entity eula1 : collection) {
		            String user_Id = (String) ((Map<String, Object>) eula1.getData().get("eula")).get("userId");
		            String flag = (String) ((Map<String, Object>) eula1.getData().get("eula")).get("flag");
		            String timeStamp =(String) ((Map<String, Object>) eula1.getData().get("eula")).get("timeStamp");
		            _log.info(user_Id + ", " + flag+", "+timeStamp);
		        }
	            
	        } catch (URISyntaxException e) {
	            e.printStackTrace();
	        	//LOG.error("Exception occurred", e);
	        }
	        

			
	        
	        Map<String, Object> eulaBody = createEULA(userData.getUser_id(),false);
	        Entity eula = new GenericEntity("EULA", eulaBody);

	        
	        if(collection.size()==0){
	        	_log.info("chk3 ....");
		        try{
		        	 Response response1 = client.create(eula);
		        	 _log.info("http status..........."+response1.getStatus());
		        }catch(Exception e){
		        	_log.error("error creating eula...");
		        }
	        }else{
	        	_log.info("chk4 ....");
	        	 try{
	        		 client.update(eula);
			        }catch(Exception e){
			        	_log.error("error creating eula...");
			        }
	        }

	        
	        

			return "/common/referer_js.jsp";
		}
	
		private Map<String,Object> createEULA(String userId,boolean flag){
	        Map<String, Object> body = new HashMap<String, Object>();
	        Map<String, String> eula = new HashMap<String, String>();
	        eula.put("userId", userId);
	        eula.put("flag", String.valueOf(flag));
	        System.out.println("time..."+new Date().toString());
	        eula.put("timeStamp", new Date().toString());
	        body.put("eula", eula);
	        return body;

	        
		}
		
	    public List<String> getRoles(BasicClient client) throws IOException {
	        List<String> roles = new ArrayList<String>();
	        EntityCollection collection = new EntityCollection();
	        try {
	        	 Response response2 = client.read(collection, PathConstants.SECURITY_SESSION_CHECK, BasicQuery.EMPTY_QUERY);
	        	 _log.info("response2-------"+response2.getStatus());
	        } catch (URISyntaxException e) {
	        	e.printStackTrace();
	            //LOG.error("Exception occurred", e);
	        }

	        if (collection != null && collection.size() >= 1) {
	            Map<String, Object> auth = (Map<String, Object>) collection.get(0).getData().get("authentication");
	            Map<String, Object> principal = (Map<String, Object>) auth.get("principal");
	            roles = (List<String>) principal.get("roles");
	        }
	        return roles;
	    }
	    
		private static Log _log = LogFactoryUtil.getLog(UpdateTermsOfUseAction.class);
}