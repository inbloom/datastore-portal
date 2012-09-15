/*
 * Copyright 2012 Shared Learning Collaborative, LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.slc.sli.util;

import java.util.List;
import java.util.ArrayList;

import org.slc.sli.client.RESTClient;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;

/**
 * CheckListHelper class helps to create a list of check list for Developer Home page
 * @author Takashi Osako
 *
 */

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
    private static final String LANDING_ZONE = "landingZone";
    private static final String PATH = "path";
    private static final String EDUCATION_ORGANIZATION = "educationOrganization";
    private static final String ENTITY_COUNT = "entityCount";
    
    private static RESTClient restClient;
    
    /**
     * Create List of check list which includes Task name, task description, and task indicator
     * @param token
     * @param mySession
     * @return
     */
    public List<CheckList> getCheckLists(String token, JsonObject mySession) {
        List<CheckList> checkList = new ArrayList<CheckList>();
        
        JsonArray jsonArrayApps = getApps(token);
        
        // Provision LZ
        checkList
                .add(new CheckList(PROVISION_LZ, "Provision description", hasProvisionedLandingZone(mySession, token)));
        // Upload Data
        checkList.add(new CheckList(UPLOAD_DATA, "upload data description", hasUploadedData(mySession, token)));
        // Add User
        checkList.add(new CheckList(ADD_USER, "add user description", hasAddedUsers(mySession, token)));
        // Register App
        checkList.add(new CheckList(REGISTER_APP, "registar app description", jsonArrayApps.size() > 0));
        // Enable app
        checkList.add(new CheckList(ENABLE_APP, "enable app description", hasEnabledApp(jsonArrayApps)));
        
        return checkList;
    }
    
    /**
     * whether sandbox tenant has data in their mongo Tracking
     * ingestion job doesn't seem like a good solution Possible solution: check
     * mongo for data for that tenant
     * 
     * @param mySession
     * @param token
     * @return
     */
    private boolean hasUploadedData(JsonObject mySession, String token) {
        boolean result = false;
        JsonElement myTenantIdJson = mySession.get(TENANT_ID);
        if (myTenantIdJson != null && !myTenantIdJson.isJsonNull()) {
            String myTenantId = myTenantIdJson.getAsString();
            
            // call API
            // http(s)://xxx.xxx.xxx.xxx/api/rest/v1/tenant_metrics/<tenantId>
            String path = Constants.API_PREFIX + "/" + Constants.API_V1 + "/" + Constants.TENANT_METRIC + "/"
                    + myTenantId;
            String jsonText = restClient.makeJsonRequestWHeaders(path, token, true);
            JsonObject jsonObject = (new JsonParser()).parse(jsonText).getAsJsonObject();
            
            if (jsonObject != null && !jsonObject.isJsonNull()) {
                JsonElement tenantMetricElement = jsonObject.get(myTenantId);
                
                // find element with the same tenant id if there is multiple
                // records
                if (tenantMetricElement != null && !tenantMetricElement.isJsonNull()) {
                    
                    JsonObject tenantMetricObject = tenantMetricElement.getAsJsonObject();
                    if (tenantMetricObject != null && !tenantMetricObject.isJsonNull()) {
                        
                        // get educationOrganization element
                        JsonElement educationOrganizationElement = tenantMetricObject.get(EDUCATION_ORGANIZATION);
                        if (educationOrganizationElement != null && !educationOrganizationElement.isJsonNull()) {
                            JsonObject educatinoOrganizationObject = educationOrganizationElement.getAsJsonObject();
                            if (educatinoOrganizationObject != null && !educatinoOrganizationObject.isJsonNull()) {
                                
                                // get entityCount
                                JsonElement entityCountElement = educatinoOrganizationObject.get(ENTITY_COUNT);
                                if (entityCountElement != null && !entityCountElement.isJsonNull()) {
                                    int entityCount = entityCountElement.getAsInt();
                                    // if there is more than 0, then
                                    // consider as data is ready
                                    if (entityCount > 0) {
                                        result = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
    
    /**
     * check if ProvisionLandingZone has done Check for landingZone exists and
     * that landingZone.path is defined note: the call retrieves the entire
     * tenants collections, so we need to filter to the developer's tenant. The
     * tenant name is the developer's login email.
     * 
     * @param token
     * @return
     */
    private boolean hasProvisionedLandingZone(JsonObject mySession, String token) {
        boolean uploadedData = false;
        JsonElement myTenantIdJson = mySession.get(TENANT_ID);
        if (myTenantIdJson != null && !myTenantIdJson.isJsonNull()) {
            String myTenantId = myTenantIdJson.getAsString();
            String path = Constants.API_PREFIX + "/" + Constants.TENANTS;
            JsonArray tenantJsonArray = getJsonArray(path, token);
            for (JsonElement tenantElement : tenantJsonArray) {
                JsonObject tenantObject = tenantElement.getAsJsonObject();
                if (tenantObject != null && !tenantObject.isJsonNull()) {
                    JsonElement tenantId = tenantObject.get(TENANT_ID);
                    if (tenantId != null && !tenantId.isJsonNull()) {
                        if (myTenantId.equals(tenantId.getAsString())) {
                            // matched with my tenant
                            
                            // find landingZone.path is defined
                            JsonElement landingZoneJsonObject = tenantObject.get(LANDING_ZONE);
                            if (landingZoneJsonObject != null && !landingZoneJsonObject.isJsonNull()) {
                                JsonArray landingZoneArray = landingZoneJsonObject.getAsJsonArray();
                                if (landingZoneArray != null && !landingZoneJsonObject.isJsonNull()) {
                                    for (JsonElement landingZone : landingZoneArray) {
                                        JsonObject landingZoneObject = landingZone.getAsJsonObject();
                                        JsonElement landingZonePath = landingZoneObject.get(PATH);
                                        if (landingZonePath != null && !landingZonePath.isJsonNull()) {
                                            uploadedData = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
            }
        }
        return uploadedData;
    }
    /**
     * To find users have been added or not
     * API Call http(s)://xxx.xxx.xxx.xxx/api/rest/users
     * get external_id from session.
     * then, find himself/herself from rest users call
     * @param mySession
     * @param token
     * @return
     */
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
    
    /**
     * Check authorized_ed_orgs exists and is non-empty
     * API call http(s)://xxx.xxx.xxx.xxx/api/rest/apps
     * 
     * @param jsonArrayApps
     * @return
     */
    private boolean hasEnabledApp(JsonArray jsonArrayApps) {
        // Check authorized_ed_orgs exists and is non-empty
        boolean result = false;
        for (JsonElement jsonElement : jsonArrayApps) {
            JsonElement authorizedEdOrgObject = jsonElement.getAsJsonObject().get(AUTHORIZED_ED_ORGS);
            if (authorizedEdOrgObject != null && !authorizedEdOrgObject.isJsonNull()) {
                JsonArray authorizedEdOrgs = authorizedEdOrgObject.getAsJsonArray();
                if (authorizedEdOrgs != null && !authorizedEdOrgs.isJsonNull() && authorizedEdOrgs.size() > 0) {
                    result = true;
                    break;
                }
            }
        }
        return result;
    }
    
    /**
     * helper method
     * API call http(s)://xxx.xxx.xxx.xxx/api/rest/apps
     * @param token
     * @return
     */
    private JsonArray getApps(String token) {
        String path = Constants.API_PREFIX + "/" + Constants.APPS;
        return getJsonArray(path, token);
    }
    
    /**
     * Call API call by given path and return as JsonArray
     * @param path
     * @param token
     * @return
     */
    private JsonArray getJsonArray(String path, String token) {
        JsonArray jsonArray = null;
        try {
            String jsonText = restClient.makeJsonRequestWHeaders(path, token, true);
            
            JsonParser parser = new JsonParser();
            jsonArray = parser.parse(jsonText).getAsJsonArray();
        } catch (Exception e) {
            // possibly API returns 500 or throws some Exception
            // HttpServerErrorException: 500 Internal Server Error
            // if this is the case, return empty JsonArray
            jsonArray = new JsonArray();
        }
        
        return jsonArray;
    }
    
    public void setRestClient(RESTClient restclient) {
        restClient = restclient;
    }
    
    /**
     * POJO: Check list information holder class
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
