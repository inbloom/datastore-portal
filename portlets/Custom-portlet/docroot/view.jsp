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
<link class="jsbin" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<script class="jsbin" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script class="jsbin" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js"></script>
<%@ include file="/init.jsp" %>
 <%
 String doAsUserId = Long.toString(themeDisplay.getUserId());
 String connectorURL = themeDisplay.getPathMain() + "/portal/portal/fckeditor?p_l_id=" + plid + "&doAsUserId=" + doAsUserId;
 %>
<portlet:renderURL var="editGreetingURL">
    <portlet:param name="jspPage" value="/success.jsp" />
</portlet:renderURL>
<portlet:actionURL var="saveDataURL">
	<portlet:param name="<%= ActionRequest.ACTION_NAME %>" value="saveData" />
</portlet:actionURL>

<aui:form id="formFile" action="<%= saveDataURL %>" method="post" onsubmit="<portlet:namespace />extractCodeFromEditor()" name="fm"  enctype="multipart/form-data">
	<div id="customize-portal">
	
	 <span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Logo</label>
				<span class="">
					
					  <img id="blah" src="/Custom-portlet/images/default.png" alt="" />
					  <input id="selectedFile" type="file" onpropertychange="add()" style="position:absolute;visibility:hidden;" name="<portlet:namespace />File_Name" onchange="readURL(this);">
					  <input type="button" id="browseButton" value="Choose File" onclick="selectedFile.click()">
					   
				</span>
				 <label id="noFile">no file selected</label>
				 <div style="margin-left:310px;" id="aui_3_4_0_1_1337">max ?k size of ?K, GIF, JPG, PNG</div>
					
				 
			</span>
		</span>
	  <span class="aui-field aui-field-text">
            <span class="aui-field-content">
                <label class="aui-field-label">Educational Organization Name</label>
                <span class="aui-field-element ">
					<input name="sli_edOrgName" type="text" style="width:210px;" onclick="if(this.value=='SLC...'){this.value=''}" onblur="if(this.value==''){this.value='SLC'}" />
				</span>
            </span>
        </span>
		<span class="aui-field aui-field-text">
            <span class="aui-field-content">
                <label class="aui-field-label">License Agreement</label>
                <span class="aui-field-element ">
					<a id="richTextLic" href="javascript:richtoggle('Lic');" style="display: block;text-decoration: none;">Rich formatting</a>
					<a id="defaultTextLic" href="javascript:richtoggle('Lic');" style="display: none;text-decoration: none;">Plain formatting</a>			
					<div id ="richEditorLic" style="display: none ;">						
						<liferay-ui:input-editor /> 
						<input  name="<portlet:namespace />edOrgNameEditor" type="hidden" value="" />
					</div>
					<div id ="defaultEditorLic" style="display: block;">						
						<textarea id="licAgree" name="licAgree" cols="12" rows="10" onfocus="clearContents(this);" > </textarea>
					</div>
                    <a onclick="add('licAgree')">restore to default</a>
                </span>
            </span>
        </span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Home Page Welcome</label>
				<span class="aui-field-element ">
						<div id="sli_richEditor">
							<a id="richTextHome" href="javascript:richtoggle('Home');" style="display:block;text-decoration: none;">Rich formatting</a>
							<a id="defaultTextHome" href="javascript:richtoggle('Home');" style="display: none;text-decoration: none;">Plain formatting</a> 				
							<div id ="richEditorHome" style="display: none;">						
								<liferay-ui:input-editor name="welcomeMessageEditor" /> 
								<input  name="<portlet:namespace />welcomeMessageEditor" type="hidden" value="" />
							</div>
							<div id ="defaultEditorHome" style="display: block;">						
								<textarea id="homeWel" name="homeWel" cols="12" rows="10" onfocus="clearContents(this);"> </textarea>
							</div>
							<a onclick="add('homeWel')">restore to default</a>
						</div>
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label"> Admin Page Welcome </label>
				<span class="aui-field-element ">
					<div id="sli_richEditor">
							 <a id="richTextAdmin" href="javascript:richtoggle('Admin');" style="display:block;text-decoration: none;">Rich formatting</a>
							 <a id="defaultTextAdmin" href="javascript:richtoggle('Admin');" style="display: none;text-decoration: none;">Plain formatting</a> 				
							 <div id ="richEditorAdmin" style="display: none ;">						
								 <liferay-ui:input-editor name="adminmessageEditor" /> 
								 <input  name="<portlet:namespace />adminmessageEditor" type="hidden" value="" />
							</div>
							<div id ="defaultEditorAdmin" style="display: block;">						
								<textarea id="adminWel" name="adminWel" cols="12" rows="10" ></textarea>
							</div>
							<a  onclick="add('adminWel')">restore to default</a>
					 </div>
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Footer</label>
				<span class="aui-field-element ">
					<div id="sli_richEditor">
						<a id="richTextFooter" href="javascript:richtoggle('Footer');" style="display:block;text-decoration: none;">Rich formatting</a>
						<a id="defaultTextFooter" href="javascript:richtoggle('Footer');" style="display: none;text-decoration: none;">Plain formatting</a> 				
						<div id ="richEditorFooter" style="display: none;">						
							 <liferay-ui:input-editor name="footeressageEditor" /> 
							 <input  name="<portlet:namespace />footermessageEditor" type="hidden" value="" />
						</div>
						<div id ="defaultEditorFooter" style="display: block;">			
							<textarea id="footerWel" name="footerWel" cols="12" rows="10" ></textarea>
						</div>
						<a  onclick="add('footerWel')">restore to default</a>
					</div>
				</span>
			</span>
		</span>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label">Custom CSS</label>
				<span class="">
					<input type="file" id="file_name" style="visibility: hidden;"  name="<portlet:namespace />File_Name"> 
					
				</span>no file selected
			</span>
		</span>
		<div class=lfr-upload-container id="<portlet:namespace />testaui_holder"></div>
		<span class="aui-field aui-field-text">
			<span class="aui-field-content">
				<label class="aui-field-label"> &nbsp; </label>
				<span class="aui-field-element ">
					<div class="pop_btn_pnl">
						<aui:button type="submit" value="Save Changes" />
						<aui:button type="reset"  value="Cancel" />
					</div>
				</span>
			</span>
		</span>

	</div>
	 
</aui:form>
 
 <aui:script use="aui-base">
  
var form = A.one('#<portlet:namespace />fm');
	if (form) {
			form.on(
			'submit',function extractCodeFromEditor() {			 
				  var x = document.<portlet:namespace />fm.<portlet:namespace />edOrgNameEditor.value = window.<portlet:namespace />editor.getHTML();      
				  var a = document.<portlet:namespace />fm.<portlet:namespace />welcomeMessageEditor.value = window.<portlet:namespace />welcomeMessageEditor.getHTML();		     
				  var z = document.<portlet:namespace />fm.<portlet:namespace />adminmessageEditor.value = window.<portlet:namespace />adminmessageEditor.getHTML();	
				  var y = document.<portlet:namespace />fm.<portlet:namespace />footermessageEditor.value = window.<portlet:namespace />footermessageEditor.getHTML();					  
				},function submitForm(){					 
					document.getElementById("file_name").value;
					document.fm.submit();
				}
			);
	}
</aui:script>

 
<script type="text/javascript">
document.getElementById("mybutton").onclick = function() {
document.fm.tapan.value = "Test";
}
 
function <portlet:namespace />initEditor() {
                //if you dont want the default text you can remove.       				
}
 
function richtoggle(type) {
	var richele     = document.getElementById("richText"+type);
	var richeditor    = document.getElementById("richEditor"+type);
	var defaultele  = document.getElementById("defaultText"+type);
	var defaulteditor = document.getElementById("defaultEditor"+type);
	
	if(richele.style.display == "block") {
    		richele.style.display = "none";		
    		defaulteditor.style.display = "none";		
    		richeditor.style.display = "block";		
    		defaultele.style.display = "block";		
  	}
	else {
		richele.style.display = "block";		
    	defaulteditor.style.display = "block";		
    	richeditor.style.display = "none";		
    	defaultele.style.display = "none";			
	}
} 
function SetUrl(mainCover) {		
		document.getElementById('picImage').src = mainCover;		
		document.getElementById('imagePath').value = mainCover; 		
	}
function clearContents(element) {
  element.value = '';
}
function add(type){
	if(type == "licAgree"){
		var licAgree = document.getElementById("licAgree");
		licAgree.value = "Default license agreement lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rhoncus magna id lorem sagittis vitae bibendum ligula ultricies. Curabitur at velit diam. Phasellus malesuada vehicula est, eu cursus ligula tempor id. Nunc pellentesque, est ut iaculisaliquam, leo tortor varius est, ac malesuada velit purus sit amet nibh. Mauris quis elit leo. Fusce rhoncus erat a augue rhoncus viverra. Morbi id ligula nec felis viverra pulvinar eu sed dui";
	}else if(type == "homeWel"){
		var homeWel = document.getElementById("homeWel");
		homeWel.value = "Default welcome text lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rhoncus magna id lorem sagittis vitae bibendum ligula ultricies. Curabitur at velit diam. Phasellus malesuada vehicula est, eu cursus ligula tempor id. Nunc pellentesque, est ut iaculis aliquam, leo tortor varius est, ac malesuada velit purus sit amet nibh. Mauris quis elit leo. Fusce rhoncus erat a augue rhoncus viverra. Morbi id ligula nec felis viverra pulvinar eu sed dui.";
	}else if(type == "adminWel"){
		var adminWel = document.getElementById("adminWel");
		adminWel.value = "Default welcome text lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rhoncus magna id lorem sagittis vitae bibendum ligula ultricies. Curabitur at velit diam. Phasellus malesuada vehicula est, eu cursus ligula tempor id. Nunc pellentesque, est ut iaculis aliquam, leo tortor varius est, ac malesuada velit purus sit amet nibh. Mauris quis elit leo. Fusce rhoncus erat a augue rhoncus viverra. Morbi id ligula nec felis viverra pulvinar eu sed dui.";
	}else if(type == "footerWel"){
		var footerWel = document.getElementById("footerWel");
		footerWel.value = "copyright 2012";
	}
}
function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#blah').attr('src', e.target.result);
                }

                reader.readAsDataURL(input.files[0]);
            }
			  document.getElementById("noFile").style.display="none";
			 
        }

</script>
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
