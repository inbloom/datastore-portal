package com.sli.util;

import org.slc.sli.api.client.impl.CustomClient;

public class TextUtil {

	public TextUtil(){
		this.instance = this;
	}
	
	public static CustomClient getCustomClientObject() {
		return instance.getCustomClient();
	}
	
	public CustomClient getCustomClient() {
		return customClient;
	}

	public void setCustomClient(CustomClient customClient) {
		this.customClient = customClient;
	}
	private CustomClient customClient;
	private static TextUtil instance;
}
