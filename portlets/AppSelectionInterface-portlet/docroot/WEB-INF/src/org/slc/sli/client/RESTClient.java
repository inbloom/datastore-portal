package org.slc.sli.client;

import org.slc.sli.util.Constants;
import org.slc.sli.util.URLBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

/**
 * REST client to make requests to API
 * 
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
    public JsonArray sessionCheck(String token) throws NullPointerException{
        logger.info("Session check URL = " + Constants.USER_APPS_PREFIX);
        String jsonText = makeJsonRequestWHeaders(Constants.USER_APPS_PREFIX, token, false);
        logger.info("jsonText = " + jsonText);
        JsonParser parser = new JsonParser();
    
        return parser.parse(jsonText).getAsJsonArray();
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
    public String makeJsonRequestWHeaders(String path, String token, boolean fullEntities) {
        RestTemplate template = new RestTemplate();

        if (token != null) {

            URLBuilder url = null;
            if (!path.startsWith("http")) {
                url = new URLBuilder(getSecurityUrl());

                url.addPath(path);
            } else {
                url = new URLBuilder(path);
                
            }

            if (fullEntities)
                url.addQueryParam("full-entities", "true");

            HttpHeaders headers = new HttpHeaders();

            headers.add("Authorization", "Bearer " + token);
           
            HttpEntity entity = new HttpEntity(headers);
            logger.debug("Accessing API at: " + url);
            HttpEntity<String> response = null;
            try {
                response = template.exchange(url.toString(), HttpMethod.GET, entity, String.class);
            } catch (HttpClientErrorException e) {
                logger.warn("Catch HttpClientException: " + e.getStatusCode().toString(), e);
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
    	logger.info("inside app sel interface portlet..."+securityUrl);
        this.securityUrl = securityUrl;
    }

 }
