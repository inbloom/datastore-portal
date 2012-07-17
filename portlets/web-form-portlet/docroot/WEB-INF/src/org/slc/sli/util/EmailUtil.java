package org.slc.sli.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slc.sli.client.RESTClient;

import com.google.gson.JsonObject;

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

	public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}

	public static String getEmailAddress(String token) {
		System.out.println(">>>>>>>"+token);
		JsonObject json = new JsonObject();
		System.out.println(">>>>>>>"+json);
		json = restClient.getEmailAddress(token);
		System.out.println(">>>>>>>"+json);
		String emailAddress = json.get("email").getAsString();
		System.out.println(">>>>>>>"+emailAddress);
		return emailAddress;
	}
	public static String getLoginEmail(String token) throws Exception {
		String loginEmail="";
		try{
			System.out.println(">>>>>>>"+token);
			JsonObject json = new JsonObject();
			System.out.println(">>>>>>>"+json);
			json = restClient.getLoginEmail(token);
			System.out.println(">>>>>>>"+json);
			loginEmail= json.get("email").getAsString();
			System.out.println(">>>>>>>"+loginEmail);
			
		}catch(Exception e){
		   	e.getMessage();
		}
		return loginEmail;
	}

	private static final String OAUTH_TOKEN = "OAUTH_TOKEN";

}