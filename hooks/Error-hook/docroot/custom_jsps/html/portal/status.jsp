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

<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="com.liferay.portal.NoSuchLayoutException" %>
<%@ page import="com.liferay.portal.service.LayoutLocalServiceUtil" %>
<%@ page import="com.liferay.portal.util.WebKeys" %>
<%@ page import="com.liferay.portal.model.LayoutSet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
    It seems we cannot directly specify a portal page in the layout.friendly.url.page.not.found property
    So do a jstl import and fake it
--%>
<%! private static final String NOT_FOUND_LAYOUT_FRIENDLY_URL = "/portal/web/guest/error"; %>
<%
boolean notFoundPageExists = true;
%>
<c:if test="<%= notFoundPageExists %>">
    <c:import url="<%= PortalUtil.getPortalURL(request) + NOT_FOUND_LAYOUT_FRIENDLY_URL + ";jsessionid=" + session.getId() %>"/>
</c:if>