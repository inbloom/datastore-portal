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

package org.slc.sli.headerfooter.service.impl;

import java.io.IOException;
import java.util.List;

import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.impl.CustomClient;
import org.slc.sli.constant.StaticText;
import org.slc.sli.headerfooter.model.HeaderFooter;
import org.slc.sli.headerfooter.model.impl.HeaderFooterImpl;
import org.slc.sli.headerfooter.service.base.HeaderFooterLocalServiceBaseImpl;
import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.util.Constants;
import org.slc.sli.util.PropsKeys;
import org.slc.sli.util.RolesUtil;
import org.slc.sli.util.ServerUtil;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.Validator;


/**
 * The implementation of the header footer local service.
 * 
 * <p>
 * All custom service methods should be put in this class. Whenever methods are
 * added, rerun ServiceBuilder to copy their definitions into the
 * {@link org.slc.sli.headerfooter.service.HeaderFooterLocalService} interface.
 * 
 * <p>
 * This is a local service. Methods of this service will not have security
 * checks based on the propagated JAAS credentials because this service can only
 * be accessed from within the same VM.
 * </p>
 * 
 * @author manoj
 * @see org.slc.sli.headerfooter.service.base.HeaderFooterLocalServiceBaseImpl
 * @see org.slc.sli.headerfooter.service.HeaderFooterLocalServiceUtil
 */
public class HeaderFooterLocalServiceImpl extends
		HeaderFooterLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 * 
	 * Never reference this interface directly. Always use {@link
	 * org.slc.sli.headerfooter.service.HeaderFooterLocalServiceUtil} to access
	 * the header footer local service.
	 */

	protected boolean isAdmin(UserData userdata) {
		boolean isAdmin = false;
		String[] SLI_ROLE_ADMINISTRATOR = PropsUtil
				.getArray(PropsKeys.SLI_ROLE_ADMINISTRATOR);

		if (Validator.isNotNull(userdata)) {
			String[] granted_authorities = userdata.getGranted_authorities();
			for (String role : granted_authorities) {
				for (String admin : SLI_ROLE_ADMINISTRATOR) {
					if(role.equalsIgnoreCase(admin)){
						isAdmin = true;
						break;
					}
				}
			}
		}
		return isAdmin;
	}

	protected String getFullName(UserData userdata) {
		return userdata.getFull_name();
	}

	public HeaderFooter addHeader(String headerData) throws SystemException,
			PortalException {

		HeaderFooter header = headerFooterPersistence
				.create(counterLocalService.increment());

		header.setType("header");
		header.setData(headerData);

		return headerFooterPersistence.update(header, false);
	}

	public HeaderFooter editHeader(long id, String headerData)
			throws SystemException, PortalException {

		HeaderFooter header = new HeaderFooterImpl();

		header.setId(id);
		header.setType("header");
		header.setData(headerData);

		return headerFooterPersistence.update(header, true);

	}

	public HeaderFooter getCurrentHeader() throws SystemException {

		List<HeaderFooter> headerList = headerFooterPersistence
				.findByType("header");

		if (!headerList.isEmpty()) {
			return headerList.get(0);
		}
		return null;
	}

	public String getHeader(String token, String currUrl)
			throws SystemException {
		
		String headerData = "";
		HeaderFooter header = getCurrentHeader();
		
		if (Validator.isNotNull(header)) {
			headerData = header.getData();

			try {
				UserData userdata = RolesUtil.getUserData(token);
				String fullName = getFullName(userdata);
				boolean isAdmin = isAdmin(userdata);

				headerData = headerData.replace("[$PORTAL_URL$]", "");

				/*headerData = headerData
						.replace(
								"[$SLI_LOGO$]",
								"<img alt=\"\" class=\"company-logo\" height=\"17\" src=\"/sli-new-theme/images/custom/sli_logo_icn.png\" width=\"21\" />");
				*/
				//US2801- retrieve organization name from API
				headerData = headerData.replace("[$ORG_NAME$]",getCustomText(token, "orgName"));
				headerData = headerData.replace("[$SLI_LOGO$]",getCustomLogo(token,"logo"));
				
				if (isAdmin) {
					headerData = headerData
							.replace(
									"[$ADMIN_PAGE$]",
									"<li class=\"last_item\"><a href=\"/portal/web/guest/admin\">Admin</a></li></li>");
					headerData = headerData
							.replace(
									"[$ADMIN_PAGES$]",
									"<li class=\"last_item\"><a href=\"/portal/web/guest/admin\" class=\"menulink\">Admin</a></li>");
				} else {
					headerData = headerData.replace("[$ADMIN_PAGE$]", "");
					headerData = headerData.replace("[$ADMIN_PAGES$]", "");

				}

				if (Validator.isNotNull(fullName)) {
					headerData = headerData.replace("[$USER_NAME$]", fullName);
				} else {
					headerData = headerData.replace("[$USER_NAME$]", "");
				}

			} catch (IOException ioe) {
				headerData = headerData.replace("[$ADMIN_PAGE$]", "");
				headerData = headerData.replace("[$ADMIN_PAGES$]", "");
				headerData = headerData.replace("[$USER_NAME$]", "");
				headerData = headerData.replace("[$PORTAL_URL$]", "");
			}

			// header.setData(headerData);
		}
		return headerData;
	}
	
	public String getHeader(boolean isAdmin) throws SystemException {

		HeaderFooter header = getCurrentHeader();
		String headerData = "";
		if (Validator.isNotNull(header)) {
			headerData = header.getData();

			try {
				// UserData userdata = RolesUtil.getUserData(token);
				// String fullName = getFullName(userdata);				
				
				headerData = headerData.replace("[$IS_ADMIN_PAGE$]", "");

				String serverUrl = Constants.HTTP_PREFIX
						+ ServerUtil.getServerURL();

				headerData = headerData.replace("[$PORTAL_URL$]", serverUrl);

				if (isAdmin) {
					headerData = headerData
							.replace(
									"[$ADMIN_PAGE$]",
									"<li class=\"last_item\"><a href=\""
											+ serverUrl
											+ "/portal/web/guest/admin\">Admin</a></li></li>");
					headerData = headerData
							.replace(
									"[$ADMIN_PAGES$]",
									"<li class=\"last_item\"><a href=\""
											+ serverUrl
											+ "/portal/web/guest/admin\" class=\"menulink\">Admin</a></li>");
				} else {
					headerData = headerData.replace("[$ADMIN_PAGE$]", "");
					headerData = headerData.replace("[$ADMIN_PAGES$]", "");

				}

			} catch (Exception e) {
				headerData = headerData.replace("[$ADMIN_PAGE$]", "");
				headerData = headerData.replace("[$ADMIN_PAGES$]", "");
				headerData = headerData.replace("[$USER_NAME$]", "");
				headerData = headerData.replace("[$PORTAL_URL$]", "");
			}

			// header.setData(headerData);
		}
		return headerData;
	}

	// footer methods
	public HeaderFooter addFooter(String footerData) throws SystemException,
			PortalException {

		HeaderFooter header = headerFooterPersistence
				.create(counterLocalService.increment());

		header.setType("footer");
		header.setData(footerData);

		return headerFooterPersistence.update(header, false);
	}

	public HeaderFooter editFooter(long id, String footerData)
			throws SystemException, PortalException {

		HeaderFooter footer = new HeaderFooterImpl();

		footer.setId(id);
		footer.setType("footer");
		footer.setData(footerData);

		return headerFooterPersistence.update(footer, true);

	}

	public HeaderFooter getCurrentFooter() throws SystemException {

		List<HeaderFooter> footerList = headerFooterPersistence
				.findByType("footer");

		if (!footerList.isEmpty()) {
			return footerList.get(0);
		}
		return null;
	}

	public String getFooter(boolean isAdmin) throws SystemException {
		HeaderFooter footer = getCurrentFooter();

		String footerData = "";

		if (Validator.isNotNull(footer)) {
			footerData = footer.getData();
			try {
				// UserData userdata = RolesUtil.getUserData(token);
				// String fullName = getFullName(userdata);
				// boolean isAdmin=isAdmin(userdata);

				String serverUrl = Constants.HTTP_PREFIX
						+ ServerUtil.getServerURL();

				footerData = footerData.replace("[$PORTAL_URL$]", serverUrl);

				if (isAdmin) {
					footerData = footerData
							.replace(
									"[$ADMIN_PAGE$]",
									"<li><a href=\""
											+ serverUrl
											+ "/portal/web/guest/admin\">Admin</a></li></li>");
				} else {
					footerData = footerData.replace("[$ADMIN_PAGE$]", "");
				}
			} catch (Exception e) {
				footerData = footerData.replace("[$ADMIN_PAGE$]", "");
				footerData = footerData.replace("[$USER_NAME$]", "");
				footerData = footerData.replace("[$PORTAL_URL$]", "");
			}
			// footer.setData(footerData);
		}
		return footerData;
	}
	
/*	public String getFooter(boolean isAdmin) throws SystemException {
		HttpServletRequest request = ServerUtil.getRequestObject();
		HttpSession session = request.getSession();
		String token =(String) session.getAttribute("OAUTH_TOKEN");
		String footerText = getCustomText(token,"footerText");
		
		return footerText;
	}*/
	

	/*public String getFooter(String token) throws SystemException {
		HeaderFooter footer = getCurrentFooter();

		String footerData = "";

		if (Validator.isNotNull(footer)) {
			footerData = footer.getData();

			try {
				UserData userdata = RolesUtil.getUserData(token);
				String fullName = getFullName(userdata);
				boolean isAdmin = isAdmin(userdata);

				footerData = footerData.replace("[$PORTAL_URL$]", "");

				if (isAdmin) {
					footerData = footerData
							.replace("[$ADMIN_PAGE$]",
									"<li><a href=\"/portal/web/guest/admin\">Admin</a></li></li>");
				} else {
					footerData = footerData.replace("[$ADMIN_PAGE$]", "");
				}

				if (Validator.isNotNull(fullName)) {
					footerData = footerData.replace("[$USER_NAME$]", fullName);
				} else {
					footerData = footerData.replace("[$USER_NAME$]", "");
				}
			} catch (IOException ioe) {
				footerData = footerData.replace("[$ADMIN_PAGE$]", "");
				footerData = footerData.replace("[$USER_NAME$]", "");
				footerData = footerData.replace("[$PORTAL_URL$]", "");
			}
			// footer.setData(footerData);
		}
		return footerData;
	}*/

	/**
	 * US1577 - get footer from API.
	 *This method returns footer text from API
	 * @author Manoj Mali
	 * @return String
	 * @param String
	 * 
	 */
	public String getFooter(String token) throws SystemException {
		String footerText= "";
		
				footerText = getCustomText(token,"footerText");
				
				HeaderFooter footer = getCurrentFooter();
				try {
				if (Validator.isNull(footer)) {
					
						addFooter(footerText);
					
					_log.info("Footer Created...");
				} else if (Validator.isNotNull(footer)
						&& !(footer.getData().equals(footerText))) {
					
						editFooter(footer.getId(),footerText);
					
					_log.info("Updated Footer...");
				}
				} catch (PortalException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
		return footerText;
	}
	
	/**This method retrieves custom text from API
	 * @param token,name
	 * @return String
	 * @author Manoj Mali
	 */
	public String getCustomText(String token, String name){
		String customText = "";
		CustomClient  customClient= RolesUtil.getCustomClientObject();
		customClient.setToken(token);
		
		EntityCollection collection = new EntityCollection();
		try {
				customClient.read(collection, StaticText.jsonContent);
				
				System.out.println("inside chk1************* --- "+collection);
				
			if (collection != null && collection.size() >= 1) {
				
				customText = String.valueOf((String)collection.get(0).getData().get(name));
				_log.info("Custom Text---- "+customText);
			}
		}catch (Exception e) {
			_log.info("Error occured while retrieving custom text from API");
		}
			
		return customText;
	}
	
	/**This method retrieves custom logo from API
	 * @param token,name
	 * @return String
	 * @author Manoj Mali
	 */
	public String getCustomLogo(String token, String name){
		String customText = "";
		CustomClient  customClient= RolesUtil.getCustomClientObject();
		customClient.setToken(token);
		
		EntityCollection collection = new EntityCollection();
		try {
				customClient.read(collection, StaticText.logoContent);
				
				System.out.println("inside chk1************* --- "+collection);
				
			if (collection != null && collection.size() >= 1) {
				
				customText = String.valueOf((String)collection.get(0).getData().get(name));
				_log.info("Custom Text---- "+customText);
			}
		}catch (Exception e) {
			_log.info("Error occured while retrieving custom text from API");
		}
			
		return"<img alt=\"sli_logo\" src=\"data:image/png;base64,"+customText+"\"/>";
	}
	
	
	private static Log _log = LogFactoryUtil
			.getLog(HeaderFooterLocalServiceImpl.class);

}