<%--
/**
 * Copyright 2012 Shared Learning Collaborative, LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
--%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ page import="org.slc.sli.util.CheckListHelper"%>
<%@ page import="org.slc.sli.web.controller.HomePageController"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.slc.sli.web.controller.HomePageController"%>
<%@ page import="javax.portlet.PortletPreferences"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<portlet:defineObjects />

<link rel="stylesheet"
	href="<%=renderRequest.getContextPath()%>/css/bootstrap.min.css">
<link rel="stylesheet"
	href="<%=renderRequest.getContextPath()%>/css/main.css">
<script type="text/javascript">
	$("div.sli_home_title").text("Developer Home");
</script>
<div class="span4 devCheckList">

	<%
	    List<CheckListHelper.CheckList> checkLists = (List<CheckListHelper.CheckList>) renderRequest
	            .getAttribute(HomePageController.CHECK_LIST);
	pageContext.setAttribute("checkLists", checkLists);
	%>
	<c:choose>
		<c:when test="${checkLists != null}">
			<h4>How to Get Up and Running</h4>
			<table class="table table-bordered">

				<tr>
					<th></th>
					<th>Task</th>
				</tr>
				<c:forEach items="${checkLists}" var="checkList">

					<tr>
						<td><c:if test="${checkList.isTaskFinished()}">
								<i class="icon-ok"></i>
							</c:if></td>
						<td><a class="tasks"
							data-content="<c:out value="${checkList.getTaskDescription() }" />"
							data-original-title="<c:out value="${checkList.getTaskName()}"/>"><c:out
									value="${checkList.getTaskName()}" /></a></td>
					</tr>
				</c:forEach>
			</table>

			<portlet:actionURL var="developerViewURL">
				<portlet:param name="jspPage"
					value="<%=HomePageController.DEVELOPER_VIEW%>" />
			</portlet:actionURL>

			<form class="form-inline" action="<%=developerViewURL.toString()%>"
				method="post">
				<label class="checkbox"> <input type="checkbox"
					class="action_checkbox"
					id="<%=HomePageController.DO_NOT_SHOW_CHECK_LIST%>"> Don't
					show this again.
				</label>
				<button type="submit" id="apply_button" class="hide btn btn-primary">Apply</button>
			</form>
		</c:when>
		<c:otherwise>
			<h4>How to Get Up and Running</h4>
			<table class="table table-bordered">
				<tr>
					<th>Resource</th>
				</tr>
				<tr>
					<td><a href="http://dev.slcedu.org/documentation"
						target="_blank">Help Documentation</a></td>
				</tr>
				<tr>
					<td><a
						href="http://dev.slcedu.org/getting-started/mailing-list"
						target="_blank">Developer Forum</a></td>
				</tr>
				<tr>
					<td><a href="http://dev.slcedu.org/blog" target="_blank">SLC
							Developer Blog</a></td>
				</tr>
				<tr>
					<td><a href="http://dev.slcedu.org/slc-camps" target="_blank">SLC
							Developer Camps</a></td>
				</tr>
				<tr>
					<td><a href="http://dev.slcedu.org/get-involved"
						target="_blank">Get Involved</a></td>
				</tr>
			</table>
		</c:otherwise>
	</c:choose>

</div>
<script
	src="<%=renderRequest.getContextPath()%>/js/libs/jquery-1.7.2.min.js"
	sync></script>
<script
	src="<%=renderRequest.getContextPath()%>/js/libs/bootstrap-tooltip.js"
	sync></script>
<script
	src="<%=renderRequest.getContextPath()%>/js/libs/bootstrap-popover.js"
	sync></script>
