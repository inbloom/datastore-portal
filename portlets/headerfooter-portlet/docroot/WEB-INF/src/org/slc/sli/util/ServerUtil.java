package org.slc.sli.util;

import javax.servlet.http.HttpServletRequest;

import org.slc.sli.context.AppContext;
import org.slc.sli.context.HTTPRequestHolder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * ServerUtil.java
 * 
 * Purpose: To fetch the server url used to populate the header preferences and
 * footer preferences.
 * 
 * @author
 * @version 1.0
 */

public class ServerUtil {

	/**
	 * Get the server url from the httpservletrequest object wfrom the singleton
	 * class HTTPRequestHolder. this method is used in
	 * headerfooterlocalserviceimpl class to fetch the server url.
	 * 
	 */
	public static String getServerURL() {

		ApplicationContext ctx = AppContext.getApplicationContext();
		HTTPRequestHolder httpRequestHolder = (HTTPRequestHolder) ctx
				.getBean("httpRequestHolder");

		HttpServletRequest httpServletRequest = httpRequestHolder
				.getHttpServletRequest();

		return httpServletRequest.getServerName();
	}

}