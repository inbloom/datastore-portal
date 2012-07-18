<%--
/**
* Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
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

<%@page import="com.liferay.portal.kernel.util.HttpUtil"%>

<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>


<%@page import="java.util.List"%>
<%@page import="org.slc.sli.json.bean.AppsData"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<portlet:defineObjects />




<%
List<AppsData> appList = null;
if(renderRequest.getAttribute("appList") != null){
	 appList = (List<AppsData>)renderRequest.getAttribute("appList");
}
%>



<table border ="0">
 <c:forEach items="${appList}" var="app">
 <%AppsData apps = (AppsData)pageContext.getAttribute("app");
 String img = apps.getImage_url();
 %>
<tr>
<td><img src='<%=HttpUtil.decodeURL(img)%>' alt="app_logo" width="46" height="45"></img><br><br></td>
<td>&nbsp;&nbsp;&nbsp;</td>
<td style="vertical-align: top"> 

<c:choose>
	<c:when test='${fn:toLowerCase(app.behaviour) eq "wsrp app" }'>
		<a  style="text-decoration: none" onClick="callWsrp('<c:out value="${app.application_url}"></c:out>')"  href='#'>
	</c:when>
	<c:when test='${fn:toLowerCase(app.behaviour) eq "iframe app" }'>
		<a style="text-decoration: none" onClick="callIframe('<c:out value="${app.application_url}"></c:out>')" href='#'>
	</c:when>
	<c:when test='${fn:toLowerCase(app.behaviour) eq "full window app" }'>
		<a style="text-decoration: none" href='<c:out value="${app.application_url}"></c:out>'>
	</c:when>		
</c:choose>
    <div style="font-weight: bold;font-size: 14px;color: #444444"> <c:out value="${app.name}"></c:out></div>
    <div class="clr"></div>
    <div class="r_menu_dis" style="color:#444444"><c:out value="${app.description}"></c:out></div>
	</a>
</td>
</tr>

</c:forEach>
</table>




<aui:form method="post" name="fm">
	<aui:input name="url" type="hidden" />
</aui:form>

<script>
function callIframe(arg1){
	document.<portlet:namespace />fm.action='<portlet:actionURL><portlet:param name="javax.portlet.action" value="openiframepage" /></portlet:actionURL>';
	document.<portlet:namespace />fm.<portlet:namespace />url.value = arg1;
	submitForm(document.<portlet:namespace />fm);
}

function callWsrp(arg1){
	document.<portlet:namespace />fm.action='<portlet:actionURL><portlet:param name="javax.portlet.action" value="openwsrppage" /></portlet:actionURL>';
	document.<portlet:namespace />fm.<portlet:namespace />url.value = arg1;
	submitForm(document.<portlet:namespace />fm);
}
</script>
