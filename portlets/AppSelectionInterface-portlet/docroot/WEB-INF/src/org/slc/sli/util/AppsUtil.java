package org.slc.sli.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.slc.sli.client.RESTClient;
import org.slc.sli.json.bean.AppsData;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.HttpUtil;
import com.liferay.portal.kernel.util.StringPool;

/**
 * <b>This Class is utility class to retrieve list of user accessible applications.</b>
 * @author Manoj Mali
 * 
 * 
 */

public class AppsUtil {

	private RESTClient restClient;

	public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}

	public AppsUtil() {
		this.instance = this;
	}

	/**
	 * <b>This Method returns List of App accessible to user.</b>
	 * 
	 * @author Manoj Mali
	 * @param token - OAuth token retrieved from liferay session
	 * @return List of AppsData
	 * @throws IOException 
	 */
	
	public static List<AppsData> getUserApps(String token) throws IOException,NullPointerException {

				return instance._getUserApps(token);
	}
	
	/**
	 *<b> This method maps list of Apps to UserData Bean.</b>
	 * 
	 * @author Manoj Mali
	 * @param token - OAuth Token retrieved from liferay session
	 * @return List of AppsData
	 * @throws IOException
	 */
	private List<AppsData> _getUserApps(String token) throws IOException,NullPointerException{
		
		List<AppsData> listApps = new ArrayList<AppsData>();
		
		_log.info("calling restclient");
		
		if(getRestClient().sessionCheck(token) == null){
			return null;
		}
			
		//call rest client and retrieve json array
		JsonArray jsonArray = getRestClient().sessionCheck(token);

		for (JsonElement jsonEle : jsonArray) {
			
			AppsData apps = new AppsData();
			
            String name = "";
            String description = "";
            String imageUrl = "";
            String behaviour = "";
            String applicationUrl = "";
			
            if (jsonEle.getAsJsonObject().has("name")) {
                name = jsonEle.getAsJsonObject().get("name").toString().replaceAll(StringPool.QUOTE,StringPool.BLANK);
            }
            
            if (jsonEle.getAsJsonObject().has("description")) {
                description = jsonEle.getAsJsonObject().get("description").toString().replaceAll(StringPool.QUOTE,StringPool.BLANK);
            }
            
            if (jsonEle.getAsJsonObject().has("behavior")) {
                behaviour = jsonEle.getAsJsonObject().get("behavior").toString().replaceAll(StringPool.QUOTE,StringPool.BLANK);
            }
            
			if (jsonEle.getAsJsonObject().has("image_url")) {
                imageUrl = jsonEle.getAsJsonObject().get("image_url").toString().replaceAll(StringPool.QUOTE,StringPool.BLANK);
            }
			
            if (jsonEle.getAsJsonObject().has("application_url")) {
                applicationUrl = jsonEle.getAsJsonObject().get("application_url").toString();
            }

			

			// Map Name,Description,Image url and app Url to bean
			if(!applicationUrl.equalsIgnoreCase(StringPool.DOUBLE_QUOTE)){
				applicationUrl = applicationUrl.replaceAll(StringPool.QUOTE,StringPool.BLANK);
				
				_log.info("name---" + name);
				_log.info("description---"+description);
				_log.info("behaviour---"+behaviour);
				_log.info("image url---"+imageUrl);
				_log.info("app url---"+applicationUrl);
			
			//DE 763 - http encoded image url	
			String encodedImage = HttpUtil.encodeURL(imageUrl);
			
			apps.setName(name);
			apps.setDescription(description);
			apps.setBehaviour(behaviour);
			apps.setImage_url(encodedImage);
			apps.setApplication_url(applicationUrl);
			
			// add apps data bean to list
			listApps.add(apps);
			}
		}

		return listApps;

	}

	private static Log _log = LogFactoryUtil.getLog(AppsUtil.class);

	private static AppsUtil instance;
}