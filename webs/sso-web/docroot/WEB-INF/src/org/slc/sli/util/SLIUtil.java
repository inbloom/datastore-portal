package org.slc.sli.util;

import java.util.List;

import com.liferay.portal.kernel.util.Validator;
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

	public static boolean isAdmin(UserData userdata) {
		return userdata.isAdminUser();
	}

	public static boolean isLiferayAdmin(UserData userdata) {
		boolean isLiferayAdmin = false;
		String[] SLI_ROLE_LIFERAY_ADMINISTRATOR = PropsUtil
				.getArray(PropsKeys.SLI_ROLE_LIFERAY_ADMINISTRATOR);

		if (Validator.isNotNull(userdata)) {
			List<String> granted_authorities = userdata.getGranted_authorities();
			for (String role : granted_authorities) {
				for (String liferayAdmin : SLI_ROLE_LIFERAY_ADMINISTRATOR) {
					if (role.equalsIgnoreCase(liferayAdmin)) {
						isLiferayAdmin = true;
						break;
					}
				}
			}
		}
		return isLiferayAdmin;
	}

}