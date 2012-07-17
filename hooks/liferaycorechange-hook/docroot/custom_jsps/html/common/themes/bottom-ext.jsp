<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ page import="org.slc.sli.service.ClientServiceUtil"%>
<%@ page import="org.slc.sli.api.client.impl.CustomClient"%>

<%@ page import="org.slc.sli.api.client.EntityCollection"%>

<%@ page import="org.slc.sli.common.constants.v1.PathConstants"%>
<%@ page import="org.slc.sli.api.client.impl.BasicQuery"%>
<%@ page import="java.net.URISyntaxException"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonElement"%>

<%

	String jsoncss="{\"css\":\"#sli_content{border:1px dotted blue;}\"}";
	
	HttpSession httpSession = (HttpSession)request.getSession(false);
	String token = (String)httpSession.getAttribute("OAUTH_TOKEN");

	CustomClient  bc= ClientServiceUtil.getCustomClientService();
	bc.setToken(token);

	String css="";

	EntityCollection collection1 = new EntityCollection();
	try {
			bc.read(collection1, jsoncss);
		if (collection1 != null && collection1.size() >= 1) {
				css = String.valueOf((String) collection1.get(0)
						.getData().get("css"));
			}
	} catch (URISyntaxException e) {
		}
%>

<style>
	<%=css%>
</style>
