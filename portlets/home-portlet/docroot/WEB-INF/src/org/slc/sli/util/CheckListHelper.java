package org.slc.sli.util;

import java.util.List;
import java.util.ArrayList;

import org.slc.sli.client.RESTClient;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

public class CheckListHelper {
    
    private static final String PROVISION_LZ = "Provision a Landing Zone";
    private static final String UPLOAD_DATA = "Upload Data";
    private static final String ADD_USER = "Add Users";
    private static final String REGISTER_APP = "Register your Application";
    private static final String ENABLE_APP = "Enable an Application";
    private static final String TENANT_ID = "tenantId";
    private static final String UID = "uid";
    private static final String EXTERNAL_ID = "external_id";
    private static final String AUTHORIZED_ED_ORGS = "authorized_ed_orgs";
    
    private static RESTClient restClient;
    
    public List<CheckList> getCheckLists(String token) {
        List<CheckList> checkList = new ArrayList<CheckList>();
        
        JsonArray jsonArrayApps = getApps(token);
        JsonObject mySession = restClient.sessionCheck(token);
        
        // Provision LZ
        checkList
                .add(new CheckList(PROVISION_LZ, "Provision description", hasProvisionedLandingZone(mySession, token)));
        // Upload Data
        checkList.add(new CheckList(UPLOAD_DATA, "upload data description", true));
        // Add User
        checkList.add(new CheckList(ADD_USER, "add user description", hasAddedUsers(mySession, token)));
        // Register App
        checkList.add(new CheckList(REGISTER_APP, "registar app description", jsonArrayApps.size() > 0));
        // Enable app
        checkList.add(new CheckList(ENABLE_APP, "enable app description", hasEnabledApp(jsonArrayApps)));
        
        return checkList;
    }
    
    /**
     * check if ProvisionLandingZone has done
     * 
     * @param token
     * @return
     */
    private boolean hasProvisionedLandingZone(JsonObject mySession, String token) {
        boolean result = false;
        
        String path = Constants.API_PREFIX + "/" + Constants.TENANTS;
        JsonArray jsonArray = getJsonArray(path, token);
        
        // if a list of tenantIds in API call "tenants" contains my tennantId from sessionCheck,
        // then consider as done
        for (JsonElement jsonElement : jsonArray) {
            JsonElement tenantId = jsonElement.getAsJsonObject().get(TENANT_ID);
            if (tenantId != null && !tenantId.isJsonNull()) {
                // API sessionCheck call
                JsonElement myTenantId = mySession.get(TENANT_ID);
                if (myTenantId != null && !myTenantId.isJsonNull()
                        && myTenantId.getAsString().equals(tenantId.getAsString())) {
                    result = true;
                    break;
                }
            }
        }
        
        return result;
    }
    
    private boolean hasUploadedData() {
        return false;
    }
    
    private boolean hasAddedUsers(JsonObject mySession, String token) {
        boolean result = false;
        String path = Constants.API_PREFIX + "/" + Constants.USERS;
        JsonArray jsonArray = getJsonArray(path, token);
        // check if there is an entry not equal to himself in uid field
        if (jsonArray.size() > 1) {
            // get own uid (external_id)
            JsonElement myTenantId = mySession.get(EXTERNAL_ID);
            if (myTenantId != null && myTenantId.isJsonPrimitive()) {
                for (JsonElement jsonElement : jsonArray) {
                    JsonObject jsonObject = jsonElement.getAsJsonObject();
                    if (jsonObject != null && !jsonObject.isJsonNull()) {
                        JsonElement uid = jsonObject.get(UID);
                        if (uid != null && uid.isJsonPrimitive()) {
                            if (uid.getAsString().equals(myTenantId.getAsString())) {
                                result = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        return result;
    }
    
    private boolean hasEnabledApp(JsonArray jsonArrayApps) {
        // Check authorized_ed_orgs exists and is non-empty
        boolean result = jsonArrayApps.size() > 0;
        for (JsonElement jsonElement : jsonArrayApps) {
            JsonElement authorizedEdOrg = jsonElement.getAsJsonObject().get(AUTHORIZED_ED_ORGS);
            if (authorizedEdOrg.isJsonNull() || authorizedEdOrg.getAsString().isEmpty()) {
                result = false;
                break;
            }
        }
        return result;
    }
    
    private JsonArray getApps(String token) {
        String path = Constants.API_PREFIX + "/" + Constants.APPS;
        return getJsonArray(path, token);
    }
    
    private JsonArray getJsonArray(String path, String token) {
        String jsonText = restClient.makeJsonRequestWHeaders(path, token, true);
        
        JsonParser parser = new JsonParser();
        JsonArray jsonArray = parser.parse(jsonText).getAsJsonArray();
        
        return jsonArray;
    }
    
    public void setRestClient(RESTClient restclient) {
        restClient = restclient;
    }
    
    /**
     * Check list information holder class
     */
    public class CheckList {
        /**
         * name of Task
         */
        private String taskName;
        
        /**
         * task indicator
         */
        private boolean taskFinished;
        
        /**
         * description of task
         */
        private String taskDescription;
        
        public CheckList(String taskName, String taskDescription, boolean taskFinished) {
            this.taskName = taskName;
            this.taskDescription = taskDescription;
            this.taskFinished = taskFinished;
        }
        
        public String getTaskName() {
            return taskName;
        }
        
        public boolean isTaskFinished() {
            return taskFinished;
        }
        
        public String getTaskDescription() {
            return taskDescription;
        }
    }
}
