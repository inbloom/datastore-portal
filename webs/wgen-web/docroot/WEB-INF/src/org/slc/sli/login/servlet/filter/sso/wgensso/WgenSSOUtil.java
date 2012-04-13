/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package org.slc.sli.login.servlet.filters.sso.wgensso;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.CharPool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;

import org.springframework.web.util.WebUtils;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.Gson;

import org.slc.sli.client.RESTClient;
import org.slc.sli.util.URLBuilder;
import org.slc.sli.util.URLHelper;
import org.slc.sli.login.util.WgenConstants;
import org.slc.sli.json.bean.UserData;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 *
 * @author 
 */

@Component
public class WgenSSOUtil {

	private RESTClient restClient;

	public RESTClient getRestClient() {
		return restClient;
	}

	public void setRestClient(RESTClient restClient) {
		this.restClient = restClient;
	}

	public WgenSSOUtil() {
		this.instance = this;
	}

	public static boolean isAuthenticated(
			HttpServletRequest request)	{
		return instance._isAuthenticated(request);
	}

	public static UserData getUserDetails(
			HttpServletRequest request){
		return instance._getUserDetails(request);
	}

    public static String getClientSecret() {
        return instance._getClientSecret();
    }
    
    public static String getCallbackUrl() {
        return instance._getCallbackUrl();
    }
    
    public static String getClientId() {
        return instance._getClientId();
    }
    
    public static String getApiUrl() {
        return instance._getApiUrl();
    }
    
	private UserData _getUserDetails(HttpServletRequest request){
		
		String token = getToken(request).toString();
		JsonObject json  = this.restClient.sessionCheck(token);
		//store UserData object in session for futrhur ref
		UserData userData = new Gson().fromJson(json, UserData.class);
		HttpSession session = request.getSession();
		session.setAttribute(WgenConstants.USER_DATA,userData);
		return userData;
	}

	private boolean _isAuthenticated(
			HttpServletRequest request){	
		boolean authenticated =false;
		HttpSession session = request.getSession();
		Object token = session.getAttribute(OAUTH_TOKEN);
		// Check if token exists
		 if (token != null) {
					authenticated =true;
		 }
		return authenticated;
	}

	/*replace the screen name with underscorrs for all special characters*/
	public static String convertScreenName(String screenName){
			char screenNameArray[] =screenName.toCharArray();
			for (int i=0;i<screenNameArray.length ;i++) {
				char c = screenNameArray[i];
				if ((!Validator.isChar(c)) && (!Validator.isDigit(c)) &&
					(c != CharPool.DASH) && (c != CharPool.PERIOD) &&
					(c != CharPool.UNDERLINE)) {
					screenNameArray[i]='_';
				}
			}
			return new String(screenNameArray);
	}

	protected Object getToken(HttpServletRequest request){
		return request.getSession().getAttribute(OAUTH_TOKEN);
	}
	
    public String _getClientSecret() {
        return clientSecret;
    }
    
    public String _getCallbackUrl() {
        return callbackUrl;
    }
    
    public void setClientId(String clientId) {
        this.clientId = clientId;
    }
    
    
    public String _getClientId() {
        return clientId;
    }
    
    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }
    
    public void setCallbackUrl(String callbackUrl) {
        this.callbackUrl = callbackUrl;
    }
    
    public void setApiUrl(String apiUrl) {
        this.apiUrl = apiUrl;
    }
    
    public String _getApiUrl() {
        return this.apiUrl;
    }
    
    private String callbackUrl;
    private String clientId;
    private String clientSecret;
    private String apiUrl;
    
	private static Log _log = LogFactoryUtil.getLog(WgenSSOUtil.class);

	private static WgenSSOUtil instance;
	
	private static final String OAUTH_TOKEN = "OAUTH_TOKEN";
}