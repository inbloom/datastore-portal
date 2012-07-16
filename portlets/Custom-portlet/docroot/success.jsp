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
<%
	String encode = ParamUtil.getString(renderRequest,"encode");
	String adminData = ParamUtil.getString(renderRequest,"adminData");
	String footerData = ParamUtil.getString(renderRequest,"footerData");
%>

	<div id="customize-portal">
	
	 <span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<span class="">
					  <label>Your data has been submitted successfully.</label>
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
