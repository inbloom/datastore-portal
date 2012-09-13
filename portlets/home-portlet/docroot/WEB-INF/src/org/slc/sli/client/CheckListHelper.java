package org.slc.sli.client;

import java.util.AbstractMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import org.slc.sli.util.Constants;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

public class CheckListHelper {
	
	private static final String PROVISIONED_LZ = "Provisioned_LZ";
	private static final String UPLOADED_DATA = "Uploaded_Data";
	private static final String ADDED_USER = "Added_User";
	private static final String REGISTERED_APP = "Registered_App";
	private static final String ENABLED_APP = "Enabled_App";
	
	private RESTClient restClient;
	private String token;
	
	public CheckListHelper(String token){
		this.restClient = new RESTClient();
		this.token = token;
	}
	
	public List<Map.Entry<String, Boolean>> getCheckList()
	{
		List<Map.Entry<String, Boolean>> checkList = new ArrayList<Map.Entry<String,Boolean>>();
		
		Map.Entry<String, Boolean> test = new AbstractMap.SimpleEntry<String, Boolean>(PROVISIONED_LZ, this.hasProvisionedLandingZone());
		checkList.add(test);

		return checkList;
	}
	
	private boolean hasProvisionedLandingZone(){
		//TODO
		// use session check and get my tenantid
		
		String path = Constants.API_PREFIX + "/" + Constants.TENANTS;
	    JsonArray jsonArray = getJsonArray(path);

	    for (JsonElement jsonElement : jsonArray) {
	    	if (jsonElement.getAsJsonObject().has("tenantId")) {
	    		// find myself's id
			}
	    }
	    
		return false;
	}
	
	private boolean hasUploadedData()
	{
		return false;
	}
	
	private boolean hasAddedUsers(){
		/*String path = Constants.API_PREFIX + "/" + Constants.USERS;
		JsonArray jsonArray = getJsonArray(path);
		
		for (JsonElement jsonElement : jsonArray ){
			// check if there is an entry not equal to himself in uid field
		}
		*/
		return false;
	}
	
	private boolean hasRegisteredApp(){
	    /*JsonArray jsonArray = getApps();
	    return jsonArray.size() > 0;   
	    */
		return false;
	}
	
	private boolean hasEnabledApp(){
		return false;
	}
	
	private JsonArray getApps()
	{
		String path = Constants.API_PREFIX + "/" + Constants.APPS;
	    return getJsonArray(path);
	}

	private JsonArray getJsonArray(String path) {
		String jsonText = restClient.makeJsonRequestWHeaders(path, token, true);
	    
	    JsonParser parser = new JsonParser();
	    JsonArray jsonArray = parser.parse(jsonText).getAsJsonArray();
	    
	    return jsonArray;
	}
}
