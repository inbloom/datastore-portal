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

package com.sli.portlet;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.mail.service.MailServiceUtil;
import com.liferay.portal.kernel.captcha.CaptchaTextException;
import com.liferay.portal.kernel.captcha.CaptchaUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.mail.MailMessage;
import com.liferay.portal.kernel.portlet.PortletResponseUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ContentTypes;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.LocalizationUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PropsKeys;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portlet.expando.model.ExpandoRow;
import com.liferay.portlet.expando.service.ExpandoRowLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoTableLocalServiceUtil;
import com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil;
import javax.portlet.PortletURL;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portal.util.PortalUtil;
import javax.portlet.PortletRequest;

import javax.mail.internet.InternetAddress;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpSession;

import javax.portlet.PortletContext;
import java.util.*;
import java.io.*;
import com.liferay.portal.kernel.upload.*;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;

import java.net.URISyntaxException;
import javax.servlet.http.HttpSession;

import javax.imageio.ImageIO;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.sli.util.CustomPortletUtil;
import org.slc.sli.api.client.impl.BasicClient;

import org.apache.commons.codec.binary.Base64;
/**
 * @author Tapan
 */
public class CustomPortlet extends MVCPortlet {
public void saveData(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {
	 
		boolean valid = true;
		
		
		HttpSession session = PortalUtil.getHttpServletRequest(actionRequest).getSession(false);
		
		String token = (String)session.getAttribute("OAUTH_TOKEN");
	
		BasicClient  basicClient= CustomPortletUtil.getBasicClientObject();
		
		basicClient.setToken(token);
		
		//ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		//String portletName = (String)actionRequest.getAttribute(WebKeys.PORTLET_ID);
		//PortletURL redirectURL = PortletURLFactoryUtil.create(PortalUtil.getHttpServletRequest(actionRequest),portletName,themeDisplay.getLayout().getPlid(),
		//PortletRequest.RENDER_PHASE);
		//String portletId = (String)actionRequest.getAttribute(WebKeys.PORTLET_ID);
		//redirectURL.setParameter("jspPage", "/success.jsp");
		//convert image to base64  format
		

	 	File file = null;
		UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(actionRequest);
		 
		try{
			
			// Validation For Educational Organization Name
			String sli_edOrgName= uploadRequest.getParameter("sli_edOrgName");
			if(sli_edOrgName.equals(""))
			{ 
				SessionErrors.add(actionRequest, "sli_edOrgName");
				valid = false;
			}else if(sli_edOrgName.length()>12 || sli_edOrgName.length()<3){
				SessionErrors.add(actionRequest, "sli_edOrgNameLenght");
				valid = false;
			}
			
			// Validation For License Agreement
			String edOrgNameEditor= uploadRequest.getParameter("edOrgNameEditor");
			String licAgree= uploadRequest.getParameter("licAgree");
			String licData="";
			if(edOrgNameEditor.equals("") && edOrgNameEditor.length()== 0){
				licData=licAgree;
			}else{
				licData=edOrgNameEditor;
			}
			if(licData.length()>1000 || licData.length()<20){
				SessionErrors.add(actionRequest, "edOrgNameEditorLength");
				valid = false;
			}
			// Validation For Home Welcome Text
			String welcomeMessageEditor= uploadRequest.getParameter("welcomeMessageEditor");
			String homeWel= uploadRequest.getParameter("homeWel");
			String homeData="";
			if(welcomeMessageEditor.equals("") && welcomeMessageEditor.length()== 0){
				homeData=homeWel;
			}else{
				homeData=welcomeMessageEditor;
			}
			if(homeData.length()>1000 || homeData.length()<20){
				SessionErrors.add(actionRequest, "welcomeMessageEditorLength");
				valid = false;
			}
			// Validation For Admin Welcome Text
			String adminmessageEditor= uploadRequest.getParameter("adminmessageEditor");
			String adminWel= uploadRequest.getParameter("adminWel");
			String adminData="";
			if(adminmessageEditor.equals("") && adminmessageEditor.length()== 0){
				adminData=adminWel;
			}else{
				adminData=adminmessageEditor;
			}
			if(adminData.length()>1000 || adminData.length()<20){
				SessionErrors.add(actionRequest, "adminmessageEditorLength");
				valid = false;
			}
			actionResponse.setRenderParameter("adminData",adminData);
			// Validation For Footer Text
			String footermessageEditor= uploadRequest.getParameter("footermessageEditor");
			String footerWel= uploadRequest.getParameter("footerWel");
			String footerData="";
			if(footermessageEditor.equals("") && footermessageEditor.length()== 0){
				footerData=footerWel;
			}else{
				footerData=footermessageEditor;
			}
			 if(footerData.length()>50 || footerData.length()<10){
				SessionErrors.add(actionRequest, "footermessageEditorLength");
				valid = false;
			}
			 actionResponse.setRenderParameter("footerData",footerData);
			//convert image to base64  format
			 
			 file = uploadRequest.getFile("Image_Name");
			 String sourceFileName = uploadRequest.getFileName("Image_Name");		 
			 InputStream inputStream = uploadRequest.getFileAsStream("Image_Name");		 
			 BufferedImage img = ImageIO.read(inputStream);
			 ByteArrayOutputStream baos = new ByteArrayOutputStream();
			 ImageIO.write(img, "png", baos);
			 baos.flush();
			 String encodedImage = Base64.encodeBase64String(baos.toByteArray());
			 if(file.length()/1024>20){
				SessionErrors.add(actionRequest, "sli_Image");
				valid = false;
			 }
			 actionResponse.setRenderParameter("encode",encodedImage);
		}catch(Exception e){
		   	e.getMessage();
		}

	if(valid){
		actionResponse.setRenderParameter("jspPage","/success.jsp");
	}
	}
	 
private static Log _log = LogFactoryUtil.getLog(CustomPortlet.class);
}