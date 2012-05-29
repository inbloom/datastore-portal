package org.slc.sli.app.events;

import com.liferay.portal.kernel.events.SimpleAction;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.PasswordPolicy;
import com.liferay.portal.service.PasswordPolicyLocalServiceUtil;

/**
 * s
 * 
 * @author Tapan
 */

public class DisableDefaultPasswordPolicy extends SimpleAction {

	@Override
	public void run(String[] ids) {
		long companyId = GetterUtil.getLong(ids[0]);

		try {

			PasswordPolicy passPolicy = PasswordPolicyLocalServiceUtil
					.getDefaultPasswordPolicy(companyId);

			if (Validator.isNotNull(passPolicy)
					&& passPolicy.getChangeable() == true) {
				passPolicy.setChangeable(false);
				PasswordPolicyLocalServiceUtil.updatePasswordPolicy(passPolicy);
				_log.info("Password policy updated...");
			}

		} catch (Exception e) {
			_log.error(e, e);
		}

	}

	private static Log _log = LogFactoryUtil
			.getLog(DisableDefaultPasswordPolicy.class);

}