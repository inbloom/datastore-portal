<%
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
%>
<%@ include file="/init.jsp" %>
 
Hello I
<portlet:renderURL var="editGreetingURL">
    <portlet:param name="jspPage" value="/view.jsp" />
</portlet:renderURL> 
<%
		String sli_edOrgName = request.getParameter("sli_edOrgName");
		System.out.println(">>>>>>>>sli_edOrgName AFTER>>>>>>>>>" + sli_edOrgName);
		String eduOrg= "";
		System.out.println(">>>>>>>>eduOrg AFTER>>>>>>>>>" + eduOrg);
		String edOrgNameEditor = request.getParameter("edOrgNameEditor");
		System.out.println(">>>>>>>>edOrgNameEditor AFTER>>>>>>>>>" + edOrgNameEditor);
		String licAgree = request.getParameter("licAgree");
		System.out.println(">>>>>>>>licAgree AFTER>>>>>>>>>" + licAgree);
		if(edOrgNameEditor == ""){
			eduOrg = licAgree;
		}else{
			eduOrg = edOrgNameEditor;
		}
		System.out.println(">>>>>>>>eduOrg AFTER>>>>>>>>>" + eduOrg);
		String welcomeMessageEditor = request.getParameter("welcomeMessageEditor");
		System.out.println(">>>>>>>>welcomeMessageEditor AFTER>>>>>>>>>" + welcomeMessageEditor);
		String homeWel = request.getParameter("homeWel");
		System.out.println(">>>>>>>>homeWel AFTER>>>>>>>>>" + homeWel);
		String adminmessageEditor = request.getParameter("adminmessageEditor");
		System.out.println(">>>>>>>>adminmessageEditor AFTER>>>>>>>>>" + adminmessageEditor);
		String adminWel = request.getParameter("adminWel");
		System.out.println(">>>>>>>>adminWel AFTER>>>>>>>>>" + adminWel);
		String footermessageEditor = request.getParameter("footermessageEditor");
		System.out.println(">>>>>>>>footermessageEditor AFTER>>>>>>>>>" + footermessageEditor);
		String footerWel = request.getParameter("footerWel");
		System.out.println(">>>>>>>>footerWel AFTER>>>>>>>>>" + footerWel);
		String sourceFileName = request.getParameter("sourceFileName");
		String encodedImage = request.getParameter("encodedImage");
		System.out.println(">>>>>>>>sourceFileName AFTER>>>>>>>>>" + encodedImage);
   
 
		 
%>
<div id="customize-portal">
	  <span class="aui-field aui-field-text">
            <span class="aui-field-content">
                <label class="aui-field-label">Educational Organization Name</label>
                <span class="aui-field-element ">
					<input name="sli_edOrgName" type="text" style="width:210px;" value="<%=sli_edOrgName%>" />
				</span>
            </span>
        </span>
		<span class="aui-field aui-field-text">
            <span class="aui-field-content">
                <label class="aui-field-label">License Agreement</label>
                <span class="aui-field-element ">
					 
						<textarea id="licAgree" name="licAgree" cols="12" rows="10" onfocus="clearContents(this);" ><%=eduOrg%></textarea>
					
                    
                </span>
            </span>
        </span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Home Page Welcome</label>
				<span class="aui-field-element ">
						 			
								<textarea id="homeWel" name="homeWel" cols="12" rows="10" onfocus="clearContents(this);"><%=sli_edOrgName%></textarea>
							 
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label"> Admin Page Welcome </label>
				<span class="aui-field-element ">
				 					
								<textarea id="adminWel" name="adminWel" cols="12" rows="10" ><%=sli_edOrgName%></textarea>
							 
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Footer</label>
				<span class="aui-field-element ">
					 
							<textarea id="footerWel" name="footerWel" cols="12" rows="10" ><%=sli_edOrgName%></textarea>
						 
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Custom CSS</label>
				<span class="aui-field-element ">
					<label><%=sourceFileName%></label><input type="file" id="file_name" name="<portlet:namespace />File_Name"> 
				</span>
			</span>
		</span>

	</div>
	<style type="text/css">
#customize-portal{

}

#customize-portal a{
	color:#428DCB;
	text-decoration:none;
}
#customize-portal a:hover{
	text-decoration:underline;
}
#customize-portal .aui-field{
	padding-top:10px;
	padding-bottom:10px;
	display:block;
}

#customize-portal .aui-field-element {
	float:left;
	width:65%;
}
#customize-portal .aui-field-label{
    padding-right: 20px;
    text-align: right;
    min-width: 30%;
	float:left;
}

#customize-portal .aui-field-element input[type="text"]{
	background:#FFFFFF;
	border:#DEDEDE solid 1px;
	color:#808180;
	font-size:14px;
	font-family:arial;
	resize:none;
}

#customize-portal textarea{
	width:600px;
	height:150px;
	background:#FFFFFF;
	border:#DEDEDE solid 1px;
	color:#808180;
	font-size:14px;
	font-family:arial;
	resize:none;
}
</style>
