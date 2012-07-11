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

package org.slc.sli.portlet;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.counter.service.CounterLocalServiceUtil;
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
import org.slc.sli.util.*;
import java.net.URISyntaxException;
import javax.servlet.http.HttpSession;
import org.slc.sli.api.client.impl.CustomClient;
import javax.imageio.ImageIO;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
 

import org.apache.commons.codec.binary.Base64;
/**
 * @author Tapan
 */
public class CustomPortlet extends MVCPortlet {
public void saveData(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {
	 
		
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String portletName = (String)actionRequest.getAttribute(WebKeys.PORTLET_ID);
		PortletURL redirectURL = PortletURLFactoryUtil.create(PortalUtil.getHttpServletRequest(actionRequest),portletName,themeDisplay.getLayout().getPlid(),
		PortletRequest.RENDER_PHASE);
		String portletId = (String)actionRequest.getAttribute(WebKeys.PORTLET_ID);
		redirectURL.setParameter("jspPage", "/success.jsp");
		//convert image to base64  format
		

	 	File file = null;
		UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(actionRequest);
		 
		 
		
		 
		String sli_edOrgName1= uploadRequest.getParameter("sli_edOrgName");
		 
		/*System.out.println(">>>>>>>>sli_edOrgName BEFORE>>>>>>>>>" + sli_edOrgName1);
		String edOrgNameEditor = ParamUtil.getString(actionRequest, "edOrgNameEditor");
		System.out.println(">>>>>>>>edOrgNameEditor BEFORE>>>>>>>>>" + edOrgNameEditor);
		String licAgree = ParamUtil.getString(actionRequest, "licAgree");
		System.out.println(">>>>>>>>licAgree BEFORE>>>>>>>>>" + licAgree);
		String welcomeMessageEditor = ParamUtil.getString(actionRequest, "welcomeMessageEditor");
		System.out.println(">>>>>>>>welcomeMessageEditor BEFORE>>>>>>>>>" + welcomeMessageEditor);
		String homeWel = ParamUtil.getString(actionRequest, "homeWel");
		System.out.println(">>>>>>>>homeWel BEFORE>>>>>>>>>" + homeWel);
		String adminmessageEditor = ParamUtil.getString(actionRequest, "adminmessageEditor");
		System.out.println(">>>>>>>>adminmessageEditor BEFORE>>>>>>>>>" + adminmessageEditor);
		String adminWel = ParamUtil.getString(actionRequest, "adminWel");
		System.out.println(">>>>>>>>adminWel BEFORE>>>>>>>>>" + adminWel);
		String footermessageEditor = ParamUtil.getString(actionRequest, "footermessageEditor");
		System.out.println(">>>>>>>>footermessageEditor BEFORE>>>>>>>>>" + footermessageEditor);
		String footerWel = ParamUtil.getString(actionRequest, "footerWel");
		System.out.println(">>>>>>>>footerWel BEFORE>>>>>>>>>" + footerWel);
		PortletPreferences preferences =PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletId);
			 
			preferences.setValue("edOrgNameEditor", edOrgNameEditor);
			preferences.setValue("licAgree", licAgree);
			preferences.setValue("welcomeMessageEditor", welcomeMessageEditor);
			preferences.setValue("homeWel", homeWel);
			preferences.setValue("adminmessageEditor", adminmessageEditor);
			preferences.setValue("adminWel", adminWel);
			preferences.setValue("footermessageEditor", footermessageEditor);
			preferences.setValue("footerWel", footerWel);*/
		 
		//actionResponse.sendRedirect(redirectURL.toString()+"&sourceFileName="+sourceFileName+"&sli_edOrgName="+sli_edOrgName+"&edOrgNameEditor="+edOrgNameEditor+"&licAgree="+licAgree+"&welcomeMessageEditor="+welcomeMessageEditor+"&homeWel="+homeWel+"&adminmessageEditor="+adminmessageEditor+"&adminWel="+adminWel+"&footermessageEditor="+footermessageEditor+"&footerWel="+footerWel);
		 actionResponse.sendRedirect(redirectURL.toString());
	}
	 
private static Log _log = LogFactoryUtil.getLog(CustomPortlet.class);
}