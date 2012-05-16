package org.slc.sli.context;

import javax.servlet.http.HttpServletRequest;

/**
 * HTTPRequestHolder.java
 * 
 * Purpose: Acts as a singleton class, used to hold the httpservletrequest
 * object captured from the filter class HTTPRequestFilter class.
 * 
 * @author
 * @version 1.0
 */

public class HTTPRequestHolder {

	public HttpServletRequest getHttpServletRequest() {
		return httpServletRequest;
	}

	public void setHttpServletRequest(HttpServletRequest httpServletRequest) {
		this.httpServletRequest = httpServletRequest;
	}

	HttpServletRequest httpServletRequest;

}