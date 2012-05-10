package org.slc.sli.login.events;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slc.sli.login.servlet.filter.sso.SLISSOUtil;
import org.slc.sli.util.PropsKeys;


/**
 * SLILogoutAction.java
 * 
 * Purpose: This class is called automatically every time when a user logged out
 * from liferay. calls the logout rest api to logout from openam and clreas
 * liferay cookies to logout from liferay
 * 
 * @author
 * @version 1.0
 */

public class SLILogoutAction extends Action {

	@Override
	public void run(HttpServletRequest request, HttpServletResponse response) {
		try {
			boolean filterEnabled = GetterUtil.getBoolean(PropsUtil.get(PropsKeys.SLI_SSO_FILTER));

			if (!filterEnabled) {
				return;
			}

			SLISSOUtil.logout(request);

		} catch (Exception e) {
			_log.error(e, e);
		}
	}

	private static Log _log = LogFactoryUtil.getLog(SLILogoutAction.class);

}