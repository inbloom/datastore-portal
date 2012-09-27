package org.slc.sli.client;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import com.google.gson.Gson;
import org.slc.sli.util.Constants;
import org.slc.sli.util.URLBuilder;

/**
 * RESTClient.java
 * Purpose: Used to fire the rest api calls
 * 
 * @author
 * @version 1.0 
 */
@Component("RESTClient")
public class RESTClient {

    private String securityUrl;

    private static Logger logger = LoggerFactory.getLogger(RESTClient.class);

    /**
     * Call the session/check API
     * 
     * @param token
     *            the sessionId or null
     * @return JsonOject as described by API documentation
     * @throws NoSessionException
     */
    public JsonObject sessionCheck(String token) {
        System.out.println("Session check URL = " + Constants.SESSION_CHECK_PREFIX);
        // String jsonText = makeJsonRequest(Constants.SESSION_CHECK_PREFIX, token);
        String jsonText = makeJsonRequestWHeaders(Constants.SESSION_CHECK_PREFIX, token, true);
        System.out.println("jsonText = " + jsonText);
        JsonParser parser = new JsonParser();
        return parser.parse(jsonText).getAsJsonObject();
    }

    /**
     * Call the session/check API
     * 
     * @param token
     *            the sessionId or null
     * @return JsonOject as described by API documentation
     * @throws NoSessionException
     */
    public JsonObject logout(String token) {
        System.out.println("logout URL = " + Constants.LOGOUT_PREFIX);
        // String jsonText = makeJsonRequest(Constants.SESSION_CHECK_PREFIX, token);
        String jsonText = makeJsonRequestWHeaders(Constants.LOGOUT_PREFIX, token, true);
        System.out.println("jsonText = " + jsonText);
        JsonParser parser = new JsonParser();
        return parser.parse(jsonText).getAsJsonObject();
    }
    
    /**
     * Make a request to a REST service and convert the result to JSON
     * 
     * @param path
     *            the unique portion of the requested REST service URL
     * @param token
     *            not used yet
     * @return a {@link JsonElement} if the request is successful and returns valid JSON, otherwise
     *         null.
     * @throws NoSessionException
     */
    public String makeJsonRequest(String path, String token) {
        RestTemplate template = new RestTemplate();
        URLBuilder url = new URLBuilder(getSecurityUrl());
        url.addPath(path);
        HttpEntity entity = null;
        if (token != null) {
            // url.addQueryParam(API_SESSION_KEY, token);
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "Bearer " + token);
            entity = new HttpEntity(headers);
        }
        logger.info("Accessing API at: " + url.toString());

        HttpEntity<String> response = template.exchange(url.toString(), HttpMethod.GET, entity, String.class);
        logger.info("JSON response for roles: " + response.getBody());
        // String jsonText = template.getForObject(url.toString(), String.class);
        // logger.info("JSON response for roles: " + jsonText);
        return response.getBody();

    }

    public String makeJsonRequestWHeaders(String path, String token, boolean fullEntities) {
        RestTemplate template = new RestTemplate();

        if (token != null) {
            // url.addQueryParam(API_SESSION_KEY, token);
            URLBuilder url = null;
            if (!path.startsWith("http")) {
                url = new URLBuilder(getSecurityUrl());
                url.addPath(path);
            } else {
                url = new URLBuilder(path);
            }
            //TODO probably should use media types
            if (fullEntities)
                url.addQueryParam("full-entities", "true");

            HttpHeaders headers = new HttpHeaders();
            // headers.add(API_SESSION_KEY, token);
            headers.add("Authorization", "Bearer " + token);
            HttpEntity entity = new HttpEntity(headers);
            logger.debug("Accessing API at: " + url);
            HttpEntity<String> response = null;
            try {
                response = template.exchange(url.toString(), HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                logger.debug("Catch HttpClientException: " + e.getStatusCode().toString());
            }
            if (response == null) {
                return null;
            }
            return response.getBody();
        }
        logger.debug("Token is null in call to RESTClient for path" + path);

        return null;
    }

    public String getSecurityUrl() {
        return securityUrl;
    }

    public void setSecurityUrl(String securityUrl) {
    	logger.info("inside rest client.."+securityUrl);
        this.securityUrl = securityUrl;
    }
    
    
    /**
     * Make a PUT request to a REST service
     * 
     * @param path
     *            the unique portion of the requested REST service URL
     * @param token
     *            not used yet
     * 
     * @param entity
     *            entity used for update
     * 
     * @throws NoSessionException
     */
    public void putJsonRequestWHeaders(String path, String token, Object entity) {
    	RestTemplate template = new RestTemplate();
        if (token != null) {
            URLBuilder url = null;
            if (!path.startsWith("http")) {
                url = new URLBuilder(getSecurityUrl());
                url.addPath(path);
            } else {
                url = new URLBuilder(path);
            }
            System.out.println("inside put json request with headers 1..."+path);
            System.out.println("inside put json request with headers 2..."+token);
            System.out.println("inside put json request with headers 3..."+entity);
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "Bearer " + token);
            headers.add("Content-Type", "application/json");
            HttpEntity requestEntity = new HttpEntity(entity, headers);
            System.out.println("inside put json request with headers 4..."+requestEntity);
            logger.info("Updating API at: {}", url);
            try {
                template.put(url.toString(), requestEntity);
                
            } catch (HttpClientErrorException e) {
            	e.printStackTrace();
            	System.out.println("inside put json request with headers 5...");
                logger.info("Catch HttpClientException: {}", e.getStatusCode());
            }
        }
    }
    
    public HttpEntity<String> exchange(String url, HttpMethod method, HttpEntity entity, Class cl) {
    	RestTemplate template = new RestTemplate();
        return template.exchange(url, method, entity, cl);
    }
    
    
    /**
     * Make a request to a REST service and convert the result to JSON
     * 
     * @param path
     *            the unique portion of the requested REST service URL
     * @param token
     *            not used yet
     *
     * @param fullEntities 
     *             flag for returning expanded entities from the API
     *            
     * @return a {@link JsonElement} if the request is successful and returns valid JSON, otherwise
     *         null.
     * @throws NoSessionException
     */
     public String makeJsonRequestWHeaders(String path, String token) {

        if (token != null) {

            URLBuilder url = null;
            if (!path.startsWith("http")) {
                url = new URLBuilder(getSecurityUrl());
                url.addPath(path);
            } else {
                url = new URLBuilder(path);
            }

            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "Bearer " + token);
            HttpEntity entity = new HttpEntity(headers);
            logger.debug("Accessing API at: {}", url);
            HttpEntity<String> response = null;
            try {
                response = exchange(url.toString(), HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                logger.debug("Catch HttpClientException: {}",  e.getStatusCode());
            }
            if (response == null) {
                return null;
            }
            return response.getBody();
        }
        logger.debug("Token is null in call to RESTClient for path {}", path);

        return null;
    }

    /**
     * Creates a generic entity from an API call
     *
     * @param url
     * @param token
     * @param entityClass
     * @return the entity
     */
    public Object createEntityFromAPI(String url, String token, Class entityClass) {
//        DE260 - Logging of possibly sensitive data
//        LOGGER.info("Querying API: {}", url);
        String response = makeJsonRequestWHeaders(url, token);
        if (response == null) {
            return null;
        }
        Gson gson=new Gson();
        Object e = gson.fromJson(response, entityClass);
        return e;
    }

    public GenericEntity createEntityFromAPI(String url, String token) {
//      DE260 - Logging of possibly sensitive data
//      LOGGER.info("Querying API: {}", url);
      String response = makeJsonRequestWHeaders(url, token);
      if (response == null) {
          return null;
      }
      Gson gson=new Gson();
      GenericEntity e = gson.fromJson(response, GenericEntity.class);
      return e;
  }
    
    public <T> void putEntityToAPI(String url, String token, T entity) {
    	 Gson gson=new Gson();
        putJsonRequestWHeaders(url, token, gson.toJson(entity));
    }
}
