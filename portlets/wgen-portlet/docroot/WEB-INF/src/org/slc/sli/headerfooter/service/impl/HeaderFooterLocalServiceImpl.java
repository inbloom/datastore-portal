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

import org.slc.sli.headerfooter.model.HeaderFooter;
import org.slc.sli.headerfooter.model.impl.HeaderFooterImpl;
import org.slc.sli.headerfooter.service.base.HeaderFooterLocalServiceBaseImpl;
import org.slc.sli.json.bean.UserData;
import org.slc.sli.util.RolesUtil;
import org.slc.sli.util.WgenPropsKeys;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.Validator;


/**
 * The implementation of the header footer local service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the {@link org.slc.sli.headerfooter.service.HeaderFooterLocalService} interface.
 *
 * <p>
 * This is a local service. Methods of this service will not have security checks based on the propagated JAAS credentials because this service can only be accessed from within the same VM.
 * </p>
 *
 * @author manoj
 * @see org.slc.sli.headerfooter.service.base.HeaderFooterLocalServiceBaseImpl
 * @see org.slc.sli.headerfooter.service.HeaderFooterLocalServiceUtil
 */
public class HeaderFooterLocalServiceImpl
	extends HeaderFooterLocalServiceBaseImpl {
	/*
	 * NOTE FOR DEVELOPERS:
	 *
	 * Never reference this interface directly. Always use {@link org.slc.sli.headerfooter.service.HeaderFooterLocalServiceUtil} to access the header footer local service.
	 */
	
	/*protected boolean isAdmin(UserData userdata){
		boolean isAdmin=false;

			if(Validator.isNotNull(userdata)){
				List<UserData.Role> roles = userdata.getAll_roles();
				for(UserData.Role role : roles){
					if(role.getName().equalsIgnoreCase(GetterUtil.getString(PropsUtil.get(WgenPropsKeys.ROLE_IT_ADMINISTRATOR))) || 
							role.getName().equalsIgnoreCase( GetterUtil.getString(PropsUtil.get(WgenPropsKeys.ROLE_SLI_ADMINISTRATOR))))
					{
						isAdmin=true;
						break;
					}
				}
			}
		return isAdmin;
	}*/

	protected boolean isAdmin(UserData userdata){
		boolean isAdmin=false;
		if(Validator.isNotNull(userdata)){
			String[] granted_authorities = userdata.getGranted_authorities();
			for(String role : granted_authorities){
				if(role.equalsIgnoreCase(GetterUtil.getString(PropsUtil.get(WgenPropsKeys.ROLE_IT_ADMINISTRATOR))) || 
						role.equalsIgnoreCase( GetterUtil.getString(PropsUtil.get(WgenPropsKeys.ROLE_SLI_ADMINISTRATOR))))
				{
					isAdmin=true;
					break;
				}
			}
		}
		return isAdmin;
	}
	
	protected String getFullName(UserData userdata){
		return userdata.getFull_name();
	}

	public HeaderFooter addHeader(String headerData) throws SystemException,
			PortalException {

		HeaderFooter header = headerFooterPersistence.create(counterLocalService
				.increment());

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

	public String getHeader(String token) throws SystemException {

		HeaderFooter header = getCurrentHeader();
		String headerData = header.getData();
		
		try{
			UserData userdata = RolesUtil.getUserData(token);
			String fullName = getFullName(userdata);
			boolean isAdmin=isAdmin(userdata);

			if(isAdmin){
				headerData = headerData.replace("[$ADMIN_PAGE$]", "<li><a href=\"/web/guest/admin\">Admin</a></li></li>");
			}else{
				headerData = headerData.replace("[$ADMIN_PAGE$]","");
			}
			
			if(Validator.isNotNull(fullName)){
				headerData = headerData.replace("[$USER_NAME$]",fullName);
			}else{
				headerData = headerData.replace("[$USER_NAME$]","");
			}
		}catch(IOException ioe){
			headerData = headerData.replace("[$ADMIN_PAGE$]","");
			headerData = headerData.replace("[$USER_NAME$]","");
		}

		return headerData;
	}

	// footer methods
	public HeaderFooter addFooter(String footerData) throws SystemException,
			PortalException {

		HeaderFooter header = headerFooterPersistence.create(counterLocalService
				.increment());

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

	public String getFooter(String token) throws SystemException {
		HeaderFooter footer = getCurrentFooter();
		String footerData = footer.getData();
		
		try{
			UserData userdata = RolesUtil.getUserData(token);
			String fullName = getFullName(userdata);
			boolean isAdmin=isAdmin(userdata);

			if(isAdmin){
				footerData = footerData.replace("[$ADMIN_PAGE$]", "<li><a href=\"/web/guest/admin\">Admin</a></li></li>");
			}else{
				footerData = footerData.replace("[$ADMIN_PAGE$]","");
			}
			
			if(Validator.isNotNull(fullName)){
				footerData = footerData.replace("[$USER_NAME$]",fullName);
			}else{
				footerData = footerData.replace("[$USER_NAME$]","");
			}
		}catch(IOException ioe){
			footerData = footerData.replace("[$ADMIN_PAGE$]","");
			footerData = footerData.replace("[$USER_NAME$]","");
		}
		return footerData;
	}

	private static Log _log = LogFactoryUtil.getLog(HeaderFooterLocalServiceImpl.class);
	
}