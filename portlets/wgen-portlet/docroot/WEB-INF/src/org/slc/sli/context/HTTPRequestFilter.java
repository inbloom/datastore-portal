package org.slc.sli.context;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;

/**
 * HTTPRequestFilter.java
 * 
 * Purpose: This filter intercepts all the request coming from url
 * /api/secure/jsonws/* and stores the httprequest object to the
 * HTTPRequestHolder class. since the url of the server which is firing the
 * webservice cannot be found in the implementation classs. this filter is used
 * to get the server url
 * 
 * @author
 * @version 1.0
 */

public class HTTPRequestFilter implements Filter {

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;

		ApplicationContext ctx = AppContext.getApplicationContext();

		HTTPRequestHolder httpRequestHolder = (HTTPRequestHolder) ctx
				.getBean("httpRequestHolder");
		httpRequestHolder.setHttpServletRequest(request);

		chain.doFilter(req, res);
	}

	public void init(FilterConfig config) throws ServletException {

		// Get init parameter
		String testParam = config.getInitParameter("test-param");
	}

	public void destroy() {
		// add code to release any resource
	}
}