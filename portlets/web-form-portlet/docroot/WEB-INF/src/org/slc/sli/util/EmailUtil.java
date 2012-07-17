package org.slc.sli.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slc.sli.client.RESTClient;

import com.google.gson.JsonObject;
import com.liferay.webform.util.EncryptUtils;

/**
 * EmailUtil.java
 * 
 * Purpose: Utility class to fetch email address from the rest api
 * 
 * @author
 * @version 1.0
 */

public class EmailUtil {

	private static RESTClient restClient;
	
    private EncryptUtils aesDecrypt;
    
    private static EmailUtil instance;

    public EmailUtil() {
        this.instance = this;
    }
 
    public void setAesDecrypt(EncryptUtils aesDecrypt) {
        this.aesDecrypt = aesDecrypt;
    }

    public EncryptUtils _getAesDecrypt() {
        return aesDecrypt;
    }

    public static EncryptUtils getAesDecrypt() {
        return instance._getAesDecrypt();
    }
   
	public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}

	public static String getEmailAddress(String token) {
	    JsonObject json = restClient.getEmailAddress(token);
        String emailAddress = json.get("email").getAsString();
        return emailAddress;
	}

	private static final String OAUTH_TOKEN = "OAUTH_TOKEN";

}