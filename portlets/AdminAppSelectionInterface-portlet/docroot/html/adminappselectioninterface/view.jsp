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

<c:if test="${app.endpoints eq null }">
<tr>

<td><img src="<%=request.getContextPath() %>/images/cogwheel.png" alt="settings_logo" style="height: 10px;width: 10px"/></td>
<td>&nbsp;</td>
<td> 

<c:choose>
	
	<c:when test='${fn:toLowerCase(app.behaviour) eq "iframe app" }'>
		<a onClick="callIframe('<c:out value="${app.application_url}"></c:out>');return false;" href='<c:out value="${app.application_url}"></c:out>'>
			<c:out value="${app.name}"></c:out>
		</a>
	</c:when>
	
	<c:when test='${fn:toLowerCase(app.behaviour) eq "wsrp app" }'>
		<a onClick="callWsrp('<c:out value="${app.application_url}"></c:out>');return false;"  href='<c:out value="${app.application_url}"></c:out>'>
			<c:out value="${app.name}"></c:out>
		</a>
	</c:when>
	
	<c:when test='${fn:toLowerCase(app.behaviour) eq "full window app" }'>
	
	<a href='<c:out value="${app.application_url}"></c:out>'>
		<c:out value="${app.name}"></c:out>
	</a>
	</c:when>		
</c:choose>    
</td>
</tr>
</c:if>

<c:forEach items="${app.endpoints}" var="innerApp">

<tr>

<td><img src="<%=request.getContextPath() %>/images/cogwheel.png" alt="settings_logo" style="height: 10px;width: 10px"/></td>
<td>&nbsp;</td>
<td> 

<c:choose>
	
	<c:when test='${app.behaviour eq "Iframe App" }'>
		<a onClick="callIframe('<c:out value="${innerApp.url}"></c:out>');return false;" href='<c:out value="${innerApp.url}"></c:out>'>
			<c:out value="${innerApp.name}"></c:out>
		</a>
	</c:when>
	
	<c:when test='${app.behaviour eq "Wsrp App" }'>
		<a onClick="callWsrp('<c:out value="${innerApp.url}"></c:out>');return false;"  href='<c:out value="${innerApp.url}"></c:out>'>
			<c:out value="${innerApp.name}"></c:out>
		</a>
	</c:when>
	
	<c:when test='${app.behaviour eq "Full Window App" }'>
	
	<a href='<c:out value="${innerApp.url}"></c:out>'>
		<c:out value="${innerApp.name}"></c:out>
	</a>
	</c:when>		
</c:choose>    
</td>
</tr>



</c:forEach>



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
