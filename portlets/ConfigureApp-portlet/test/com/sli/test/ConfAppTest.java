package com.sli.test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.slc.sli.json.bean.AppsData;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.test.TestCase;

public class ConfAppTest extends TestCase{

	//private String token = "e88cb6d1-771d-46ac-a207-2e58d7f12196";
	private String userAppsArray ="[{\"behavior\":\"Iframe App\",\"version\":\"0.0\",\"is_admin\":false,\"image_url\":\"http://placekitten.com/150/150\",\"description\":\"SDK Sample App CI server\",\"name\":\"SDK Sample App (CI)\",\"application_url\":\"https://devlycans.slidev.org/sample/students\",\"administration_url\":\"https://devlycans.slidev.org/sample/\",\"developer_info\":{\"organization\":\"SLC\"}},{\"behavior\":\"Full Window App\",\"version\":\"0.0\",\"is_admin\":false,\"image_url\":\"http://placekitten.com/150/150\",\"description\":\"Portal on devlycans.slidev.org\",\"name\":\"Portal Devlycans\",\"application_url\":\"https://devlycans.slidev.org/portal\",\"administration_url\":\"https://devlycans.slidev.org/portal\",\"developer_info\":{\"organization\":\"SLC\"}},{\"behavior\":\"Full Window App\",\"version\":\"1.0\",\"is_admin\":false,\"image_url\":\"https://devlycans.slidev.org/dashboard/assets/icon.png\",\"description\":\"SLI dashboard application\",\"name\":\"Dashboard\",\"application_url\":\"https://devlycans.slidev.org/dashboard\",\"administration_url\":\"https://devlycans.slidev.org/dashboard\",\"developer_info\":{\"organization\":\"SLI\"}},{\"behavior\":\"Full Window App\",\"version\":\"0.0\",\"is_admin\":false,\"image_url\":\"http://placekitten.com/150/150\",\"description\":\"Portal Devlr1\",\"name\":\"Portal Devlr1\",\"application_url\":\"https://devlr1.slidev.org/c/portal/login\",\"administration_url\":\"https://devlr1.slidev.org/c/portal/login\",\"developer_info\":{\"organization\":\"SLC\"}}]";
	
	
	/*
	 * Test to check user apps are retrieved or not
	 */
	@Test
	public void testGetUserApps() throws IOException{
		
		assertNotNull(_getUserApps(userAppsArray));
	}
	
	
	/*
	 * Test to check whether all non admin apps are retrieved or not
	 */
	@Test
	public void testIs_Admin(){
		
		JsonParser parser = new JsonParser();
		JsonArray jsonArray = parser.parse(userAppsArray).getAsJsonArray();
		
		for (JsonElement jsonEle : jsonArray) {
			boolean is_admin = jsonEle.getAsJsonObject().get("is_admin").getAsBoolean();
			
			assertEquals(false, is_admin);
		}
	}

	
	
	private List<AppsData> _getUserApps(String userAppsArray) throws IOException{
		
		List<AppsData> listApps = new ArrayList<AppsData>();

		JsonParser parser = new JsonParser();
		JsonArray jsonArray = parser.parse(userAppsArray).getAsJsonArray();

		for (JsonElement jsonEle : jsonArray) {
			AppsData apps = new AppsData();

			String name = jsonEle.getAsJsonObject().get("name").toString();
			String description = jsonEle.getAsJsonObject().get("description").toString();
			String behaviour = jsonEle.getAsJsonObject().get("behavior").toString();
			String imageUrl = jsonEle.getAsJsonObject().get("image_url").toString();
			String adminUrl = jsonEle.getAsJsonObject().get("administration_url").toString();

			_log.info("name---" + name);
			_log.info("description---"+description);
			_log.info("behaviour---"+behaviour);
			_log.info("image url---"+imageUrl);
			_log.info("admin url---"+adminUrl);

			apps.setName(name);
			apps.setDescription(description);
			apps.setBehaviour(behaviour);
			apps.setImage_url(imageUrl);
			apps.setAdmin_url(adminUrl);
			
			listApps.add(apps);
		}

		return listApps;

	}
	private static Log _log = LogFactoryUtil.getLog(ConfAppTest.class);
	
}
