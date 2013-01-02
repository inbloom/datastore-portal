package org.slc.sli.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.slc.sli.client.RESTClient;
import org.slc.sli.json.bean.AppsData;
import org.slc.sli.json.bean.AppsData.InnerApps;
import org.slc.sli.json.bean.UserData;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;

/**
 * <b>This Class is utility class to retrieve list of user accessible
 * applications.</b>
 * 
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

	public static boolean isAdmin(UserData userdata) {
		return userdata.isAdminUser();
	}

	public static UserData getUserData(String token) throws IOException {
		return instance._getUserData(token);
	}

	private UserData _getUserData(String token) {
		JsonObject json = getRestClient().sessionCheck(token);
		UserData userData = new Gson().fromJson(json, UserData.class);
		return userData;
	}

	/**
	 * <b>This Method returns List of App accessible to user.</b>
	 * 
	 * @author Manoj Mali
	 * @param token
	 *            - OAuth token retrieved from liferay session
	 * @return List of AppsData
	 * @throws IOException
	 */

	public static List<AppsData> getUserApps(String token) throws IOException,
			NullPointerException {

		return instance._getUserApps(token);
	}

	/**
	 * <b> This method maps list of Apps to UserData Bean.</b>
	 * 
	 * @author Manoj Mali
	 * @param token
	 *            - OAuth Token retrieved from liferay session
	 * @return List of AppsData
	 * @throws IOException
	 */
	private List<AppsData> _getUserApps(String token) throws IOException,
			NullPointerException {

		List<AppsData> listApps = new ArrayList<AppsData>();

		_log.info("calling restclient");

		// call rest client and retrieve json array
		JsonArray jsonArray = getRestClient().callUserApps(token);

		for (JsonElement jsonEle : jsonArray) {

			AppsData apps = new AppsData();

            String name = "";
            String description = "";
            String imageUrl = "";
            String behaviour = "";
            String applicationUrl = "";
	            
			if (jsonEle.getAsJsonObject().has("name")) {
    			name = jsonEle.getAsJsonObject().get("name").toString().replaceAll(StringPool.QUOTE, StringPool.BLANK);
			}
			
			if (jsonEle.getAsJsonObject().has("description")) {
    			description = jsonEle.getAsJsonObject().get("description").toString().replaceAll(StringPool.QUOTE, StringPool.BLANK);
			}
			
            if (jsonEle.getAsJsonObject().has("behavior")) {
                behaviour = jsonEle.getAsJsonObject().get("behavior").toString().replaceAll(StringPool.QUOTE, StringPool.BLANK);
            }
	        
			if (jsonEle.getAsJsonObject().has("image_url")) {
	             imageUrl = jsonEle.getAsJsonObject().get("image_url").toString().replaceAll(StringPool.QUOTE, StringPool.BLANK);
	        }
			
            if (jsonEle.getAsJsonObject().has("application_url")) {
                applicationUrl = jsonEle.getAsJsonObject().get("application_url").toString();
            }

			// end point size is set to check if thr is any empty endpoint.
			int endPointSize = 1;
			// Map Name,Description,Image url and app Url to bean
			if (!applicationUrl.equalsIgnoreCase(StringPool.DOUBLE_QUOTE)) {
				applicationUrl = applicationUrl.replaceAll(StringPool.QUOTE,
						StringPool.BLANK);

				JsonArray endPoints = null;
				if (Validator.isNotNull(jsonEle.getAsJsonObject().get(
						"endpoints"))) {

					endPoints = jsonEle.getAsJsonObject().get("endpoints")
							.getAsJsonArray();

					_log.info("end points--" + endPoints);
					_log.info("is json empty---" + endPoints.size());

					if (endPoints.size() == 0) {
						endPointSize = 0;
					}

					ArrayList<InnerApps> innerAppsList = new ArrayList<InnerApps>();
					for (JsonElement innerJsonEle : endPoints) {

						InnerApps inApps = new InnerApps();

						String innerAppName = innerJsonEle.getAsJsonObject()
								.get("name").toString()
								.replaceAll(StringPool.QUOTE, StringPool.BLANK);
						String innerAppDescription = innerJsonEle
								.getAsJsonObject().get("description")
								.toString()
								.replaceAll(StringPool.QUOTE, StringPool.BLANK);
						String innerAppUrl = innerJsonEle.getAsJsonObject()
								.get("url").toString()
								.replaceAll(StringPool.QUOTE, StringPool.BLANK);

						_log.info("inner app name---" + innerAppName);
						_log.info("inner app description---"
								+ innerAppDescription);
						_log.info("inner app url---" + innerAppUrl);

						inApps.setName(innerAppName);
						inApps.setDescription(innerAppDescription);
						inApps.setUrl(innerAppUrl);

						innerAppsList.add(inApps);

					}

					apps.setEndpoints(innerAppsList);
				} else {
					apps.setEndpoints(null);
				}

				_log.info("name---" + name);
				_log.info("description---" + description);
				_log.info("behaviour---" + behaviour);
				_log.info("image url---" + imageUrl);
				_log.info("app url---" + applicationUrl);

				if (endPointSize == 1) {
					apps.setName(name);
					apps.setDescription(description);
					apps.setBehaviour(behaviour);
					apps.setImage_url(imageUrl);
					apps.setApplication_url(applicationUrl);
					listApps.add(apps);
				}
			}
		}

		return listApps;

	}

	private static Log _log = LogFactoryUtil.getLog(AppsUtil.class);

	private static AppsUtil instance;
}
