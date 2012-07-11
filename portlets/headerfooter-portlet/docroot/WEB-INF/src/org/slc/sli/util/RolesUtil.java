package org.slc.sli.util;

import java.io.IOException;

import org.slc.sli.api.client.impl.CustomClient;
import org.slc.sli.client.RESTClient;
import org.slc.sli.login.json.bean.UserData;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

/**
 * RolesUtil.java
 * 
 * Purpose: Utility class to find roles of the logged in user.
 * 
 * @author
 * @version 1.0
 */

public class RolesUtil {

	private RESTClient restClient;

	public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}

	public RolesUtil() {
		this.instance = this;
	}

	public static UserData getUserData(String token) throws IOException {
		return instance._getUserData(token);
	}

	/**
	 * Convert the json object returned from the session check api to userdata
	 * object
	 * 
	 */
	private UserData _getUserData(String token) {
		JsonObject json = getRestClient().sessionCheck(token);
		UserData userData = new Gson().fromJson(json, UserData.class);
		return userData;
	}

	
	//US1577,1576,2801
	
	public static CustomClient getCustomClientObject() {
		return instance.getCustomClient();
	}
	
	public CustomClient getCustomClient() {
		return customClient;
	}

	public void setCustomClient(CustomClient customClient) {
		this.customClient = customClient;
	}
	private CustomClient customClient;
	
	// end US1577
	private static Log _log = LogFactoryUtil.getLog(RolesUtil.class);

	private static RolesUtil instance;

}