package org.slc.sli.util;

import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;

import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.util.PropsKeys;

/**
 * SLIUtil.java
 * 
 * Purpose: Utility methods used in the project.
 * 
 * @author
 * @version 1.0
 */

public class SLIUtil {

	/**
	 * this method is used to check if the user is a sli admin user
	 */
	
	public static boolean isAdmin(UserData userdata){
		boolean isAdmin=false;
		if(Validator.isNotNull(userdata)){
			String[] granted_authorities = userdata.getGranted_authorities();
			for(String role : granted_authorities){
				if(role.equalsIgnoreCase(GetterUtil.getString(PropsUtil.get(PropsKeys.ROLE_IT_ADMINISTRATOR))) || 
						role.equalsIgnoreCase( GetterUtil.getString(PropsUtil.get(PropsKeys.ROLE_SLI_ADMINISTRATOR))))
				{
					isAdmin=true;
					break;
				}
			}
		}
		return isAdmin;
	}
	
}