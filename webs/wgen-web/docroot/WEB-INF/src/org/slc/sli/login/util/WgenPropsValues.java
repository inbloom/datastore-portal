package org.slc.sli.util;

import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import org.slc.sli.login.util.WgenPropsKeys;

public class WgenPropsValues {
	
	public static final String API_SERVER_URI = GetterUtil.getString(PropsUtil.get(WgenPropsKeys.API_SERVER_URI));
	
	public static final String GET_ROLES_URL = GetterUtil.getString(PropsUtil.get(WgenPropsKeys.GET_ROLES_URL));
	
	public static final String SLI_COOKIE_DOMAIN = GetterUtil.getString(PropsUtil.get(WgenPropsKeys.SLI_COOKIE_DOMAIN));
	
	public static final String SESSION_CHECK_URL = GetterUtil.getString(PropsUtil.get(WgenPropsKeys.SESSION_CHECK_URL));
	
	public static final boolean WGEN_SSO_FILTER = GetterUtil.getBoolean(PropsUtil.get(WgenPropsKeys.WGEN_SSO_FILTER));
	
	public static final boolean WGEN_SSO_LOGOUT_ON_SESSION_EXPIRATION = GetterUtil.getBoolean(PropsUtil.get(WgenPropsKeys.WGEN_SSO_LOGOUT_ON_SESSION_EXPIRATION));
	
}