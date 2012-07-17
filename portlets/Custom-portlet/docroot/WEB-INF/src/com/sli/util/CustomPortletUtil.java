package com.sli.util;

import org.slc.sli.api.client.impl.BasicClient;

public class CustomPortletUtil {

	public CustomPortletUtil(){
		this.instance = this;
	}
	
	public static BasicClient getBasicClientObject() {
		return instance.getBasicClient();
	}
	
	public BasicClient getBasicClient() {
		return basicClient;
	}

	public void setBasicClient(BasicClient basicClient) {
		this.basicClient = basicClient;
	}
	private BasicClient basicClient;
	private static CustomPortletUtil instance;
}
