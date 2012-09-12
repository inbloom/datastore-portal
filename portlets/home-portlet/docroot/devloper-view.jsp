
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



<link rel="stylesheet" href="css/bootstrap.min.css">
<style>
[class^="icon-"],[class*=" icon-"] {
	background-image: url("images/glyphicons-halflings.png");
}

.icon-white,.nav>.active>a>[class^="icon-"],.nav>.active>a>[class*=" icon-"],.dropdown-menu>li>a:hover>[class^="icon-"],.dropdown-menu>li>a:hover>[class*=" icon-"],.dropdown-menu>.active>a>[class^="icon-"],.dropdown-menu>.active>a>[class*=" icon-"]
	{
	background-image: url("images/glyphicons-halflings-white.png");
}

.devCheckList {
	text-align: center;
	border: 1px solid #DDDDDD;
	padding: 10px 20px;
}

.devCheckList a {
	cursor: pointer;
}

#apply_button {
	position: absolute;
	font-size: 11px;
	margin-left: 10px;
}
</style>
<div class="span4 devCheckList">

	<%
	    List<Map.Entry<String, Boolean>> checkLists = (List<Map.Entry<String, Boolean>>) renderRequest
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
		    for (Map.Entry<String, Boolean> checkList : checkLists) {
		            String taskName = (String) checkList.getKey();
		            Boolean taskState = (Boolean) checkList.getValue();
		%>

		<tr>
			<td>
				<% if (taskState) { %> <i class="icon-ok"></i> <% } %>
			</td>
			<td><a><%=taskName%></a></td>
		</tr>
		<%
		    }
		%>
	</table>
	<form class="form-inline">
		<label class="checkbox"> <input type="checkbox" id="checkbox">
			Don't show this again.
		</label>
		<button type="submit" id="apply_button" class="hide btn btn-primary">Apply</button>
	</form>
	<%
	    } else {
	%>
	//if checkList is null, then a user does not want to see a checkList
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
<script src="js/libs/jquery-1.7.2.min.js" sync></script>
<script>
	$(function() {
		$("#checkbox").click(function() {
			$("#apply_button").toggle();
		});

	});
</script>