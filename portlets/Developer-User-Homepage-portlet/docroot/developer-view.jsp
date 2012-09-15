
<%@page import="org.slc.sli.util.CheckListHelper"%>
<%
    /**
     * SLI Copy right here
     */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ page import="org.slc.sli.home.HomePage"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.slc.sli.home.HomePage"%>
<%@ page import="javax.portlet.PortletPreferences"%>

<portlet:defineObjects />



<link rel="stylesheet"
	href="<%=renderRequest.getContextPath()%>/css/bootstrap.min.css">
<link rel="stylesheet"
	href="<%=renderRequest.getContextPath()%>/css/main.css">
<div class="span4 devCheckList">

	<%
	    List<CheckListHelper.CheckList> checkLists = (List<CheckListHelper.CheckList>) renderRequest
	            .getAttribute(HomePage.CHECK_LIST);
	    //if checkLists is not null, then a user would like to see a checkList
	    if (checkLists != null) {
	%>
	<h4>How to Get Up and Running</h4>
	<table class="table table-bordered">

		<tr>
			<th></th>
			<th>Task</th>
		</tr>

		<%
		    for (CheckListHelper.CheckList checkList : checkLists) {
		            String taskName = checkList.getTaskName();
		            boolean taskState = checkList.isTaskFinished();
		            String taskDescription = checkList.getTaskDescription();
		%>

		<tr>
			<td>
				<% if (taskState) { %> <i class="icon-ok"></i> <% } %>
			</td>
			<td><a class="tasks"
				data-content="<%=taskDescription%>"
				data-original-title="<%=taskName%>"><%=taskName%></a></td>
		</tr>
		<%
		    }
		%>
	</table>

	<portlet:actionURL var="developerViewURL">
    	<portlet:param name="jspPage" value="/developer-view.jsp" />
	</portlet:actionURL>

	<form class="form-inline" action="<%= developerViewURL.toString() %>" method="post">
		<label class="checkbox">
            <input type="checkbox" class="action_checkbox" id="<%= HomePage.DO_NOT_SHOW_CHECK_LIST %>"> Don't show this again.
		</label>
		<button type="submit" id="apply_button" class="hide btn btn-primary">Apply</button>
	</form>
	<%
	    } else {
	%>
	<%
	//if checkList is null, then a user does not want to see a checkList
	%>
	<h4>How to Get Up and Running</h4>
	<table class="table table-bordered">
		<tr>
			<th>Resource</th>
		</tr>
		<tr>
			<td>Help Documentation</td>
		</tr>
		<tr>
			<td>Developer Forum</td>
		</tr>
		<tr>
			<td>SLC Developer Blog</td>
		</tr>
		<tr>
			<td>SLC Developer Camps</td>
		</tr>
		<tr>
			<td>Get Involved</td>
		</tr>
	</table>
	<%
	    }
	%>
</div>
<script src="<%=renderRequest.getContextPath()%>/js/libs/bootstrap-tooltip.js" sync></script>
<script src="<%=renderRequest.getContextPath()%>/js/libs/bootstrap-popover.js" sync></script>
