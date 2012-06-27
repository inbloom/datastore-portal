package org.slc.sli.events;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import org.slc.sli.util.PropsKeys;

import com.liferay.portal.LARFileException;
import com.liferay.portal.LARTypeException;
import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.lar.PortletDataHandlerKeys;
import com.liferay.portal.kernel.lar.UserIdStrategy;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;

/**
 * @author Tapan
 */

public class LarStartUpAction extends SimpleAction {

	@Override
	public void run(String[] ids) {
		long companyId = GetterUtil.getLong(ids[0]);

		importLar(companyId);

	}

	protected void importLar(long companyId) {

		try {
			Map<String, String[]> parameterMap = new HashMap<String, String[]>();
			parameterMap
					.put(PortletDataHandlerKeys.DATA_STRATEGY,
							new String[] { PortletDataHandlerKeys.DATA_STRATEGY_MIRROR });
			parameterMap.put(PortletDataHandlerKeys.USER_ID_STRATEGY,
					new String[] { UserIdStrategy.CURRENT_USER_ID });
			parameterMap.put(PortletDataHandlerKeys.DELETE_MISSING_LAYOUTS,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PERMISSIONS,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PORTLET_DATA,
					new String[] { Boolean.TRUE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PORTLET_DATA_ALL,
					new String[] { Boolean.TRUE.toString() });
			parameterMap.put(
					PortletDataHandlerKeys.PORTLET_DATA_CONTROL_DEFAULT,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PORTLET_SETUP,
					new String[] { Boolean.TRUE.toString() });
			parameterMap.put(PortletDataHandlerKeys.USER_PERMISSIONS,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PORTLET_ARCHIVED_SETUPS,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.CATEGORIES,
					new String[] { Boolean.FALSE.toString() });
			parameterMap.put(PortletDataHandlerKeys.PORTLET_USER_PREFERENCES,
					new String[] { Boolean.TRUE.toString() });
			parameterMap.put(PortletDataHandlerKeys.THEME,
					new String[] { Boolean.TRUE.toString() });
			parameterMap.put(PortletDataHandlerKeys.THEME_REFERENCE,
					new String[] { Boolean.TRUE.toString() });
			
			Group group = GroupLocalServiceUtil.getGroup(companyId,
					RoleConstants.GUEST);

			boolean privateLayout = false;

			File deployDir = new File(
					PropsUtil.get(PropsKeys.AUTO_DEPLOY_DEPLOY_DIR));

			String fileName = PropsUtil.get(PropsKeys.LAYOUT_LAR_FILE_NAME);

			File file = new File(deployDir + StringPool.FORWARD_SLASH
					+ fileName);

			_log.info("Importing lar from location" + file);

			if (!file.exists()) {
				throw new LARFileException("Import file does not exist");
			}

			User user = UserLocalServiceUtil.getDefaultUser(companyId);

			LayoutLocalServiceUtil.importLayouts(user.getUserId(),
					group.getGroupId(), privateLayout, parameterMap, file);

		} catch (Exception e) {
			if ((e instanceof LARFileException)
					|| (e instanceof LARTypeException)) {
				_log.error("Error while importing lar file");
			} 
			//DE867 removed error log regarding work flow handler exception
		}

	}

	private static Log _log = LogFactoryUtil.getLog(LarStartUpAction.class);

}