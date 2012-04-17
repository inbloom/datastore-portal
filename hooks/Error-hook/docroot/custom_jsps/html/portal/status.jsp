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

<%@ include file="/html/portal/init.jsp" %>
<%@ page isErrorPage="true" %>
<head>
<%
int status = ParamUtil.getInteger(request, "status");

if (status > 0) {
	response.setStatus(status);
}

String exception = ParamUtil.getString(request, "exception");

String url = ParamUtil.getString(request, "previousURL");

if (Validator.isNull(url)) {
	url = PortalUtil.getCurrentURL(request);
}

url = themeDisplay.getPortalURL() + url;

boolean noSuchResourceException = false;

for (String key : SessionErrors.keySet(request)) {
	key = key.substring(key.lastIndexOf(StringPool.PERIOD) + 1);

	if (key.startsWith("NoSuch") && key.endsWith("Exception")) {
		noSuchResourceException = true;
	}
}

if (Validator.isNotNull(exception)) {
	exception = exception.substring(exception.lastIndexOf(StringPool.PERIOD) + 1);

	if (exception.startsWith("NoSuch") && exception.endsWith("Exception")) {
		noSuchResourceException = true;
	}
}
%>

<style type="text/css">

* {
	margin: 0px;
	padding: 0px;
}

.wrapper {
	width: 100%;
	margin: 0 auto;
}

.h1 {
	height: 337px;
	width: 1000px;
	margin: 0 auto;
	border: 1px #aaaaaa solid;
}

.head {
	background-image: url("/sli_images/bg.png");
	background-repeat: repeat-x;
	margin: 0 auto;
	height: 67px;
	border: 1px #aaaaaa solid;
	border-radius: 4px 4px;
	margin-top: 30px;
	width: 1000px;
}

.head_h1 {
	font-family: Arial, Helvetica, sans-serif;
	color: #000000;
	font-size: 25px;
	font-weight: bold;
	text-align: center;
	margin-top: 15px;
}

.text_section {
	width: 405px;
	height: 284px;
	margin: 0 auto;
	margin-top: 25px;
}

.icon_img {
	height: 120px;
	width: 128px;
	margin: 0 auto;
	background-image: url("/sli_images/exception.png");
}

.page_tex {
	height: 15px;
	white-space: 145px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000000;
	margin: 0 auto;
	text-align: center;
	margin-top: 35px;
}

.ex_tex {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	text-align: center;
	color: #000000;
	width: 145px;
	line-height: 30px;
	margin: 0 auto;
	margin-top: 25px;
	width: 320px;
}

</style>
</head>
<body>
<div class="wrapper">
<div class="head"><div class="head_h1">SLI Exception</div></div>
<div class="h1">
<div class="text_section">
<div class="icon_img">
&nbsp;
</div>

<div class="page_tex">Page Not Accessible</div>
<div class="ex_tex">Exception Details :<br />
The page you are requesting is not available!</div>
</div>




</div>

</div>

</body>


<div class="separator"><!-- --></div>

<a href="javascript:history.go(-1);">&laquo; <liferay-ui:message key="back" /></a>

<%!
private static Log _log = LogFactoryUtil.getLog("portal-web.docroot.html.portal.status_jsp");
%>