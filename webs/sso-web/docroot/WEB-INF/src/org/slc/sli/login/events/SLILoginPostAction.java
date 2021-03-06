
package org.slc.sli.login.events;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slc.sli.login.json.bean.UserData;
import org.slc.sli.login.servlet.filter.sso.SLISSOUtil;
import org.slc.sli.util.SLIUtil;
import org.slc.sli.util.Constants;
import org.slc.sli.util.PropsKeys;

/**
 * SLILoginPostAction.java
 * 
 * Purpose: This class is called automatically every time when a user logged in
 * to liferay. Responsible for mapping the SLI roles with Liferay roles
 * 
 * @author
 * @version 1.0
 */

public class SLILoginPostAction extends Action {

	@Override
	public void run(HttpServletRequest request, HttpServletResponse response) {

		try {
			HttpSession session = request.getSession();

			User user = (User) session.getAttribute(WebKeys.USER);

			UserData userData = SLISSOUtil.getUserDetails(request);

			boolean isAdmin = SLIUtil.isAdmin(userData);

			boolean isLiferayAdmin = SLIUtil.isLiferayAdmin(userData);

			long companyId = PortalUtil.getCompanyId(request);

			Role sliEducatorRole = RoleLocalServiceUtil
					.getRole(companyId, GetterUtil.getString(PropsUtil
							.get(PropsKeys.ROLE_EDUCATOR)));

			Role adminRole = RoleLocalServiceUtil.getRole(companyId,
					RoleConstants.ADMINISTRATOR);

			if (isLiferayAdmin) {
				if (!RoleLocalServiceUtil.hasUserRole(user.getUserId(),
						adminRole.getRoleId())) {

					long[] adminRoleIds = { adminRole.getRoleId() };

					RoleLocalServiceUtil.addUserRoles(user.getUserId(),
							adminRoleIds);
					if (_log.isDebugEnabled()) {
						_log.debug("Adding Liferay Admin role ");
					}
				}
			} else {
				if (!RoleLocalServiceUtil.hasUserRole(user.getUserId(),
						sliEducatorRole.getRoleId())) {

					long[] educatorRoleIds = { sliEducatorRole.getRoleId() };
					RoleLocalServiceUtil.addUserRoles(user.getUserId(),
							educatorRoleIds);
					if (_log.isDebugEnabled()) {
						_log.debug("Adding Educator role ");
					}
				}
			}
		} catch (Exception e) {
			_log.error(e, e);
		}

	}

	private static Log _log = LogFactoryUtil.getLog(SLILoginPostAction.class);

}