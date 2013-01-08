<%--
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */
--%>

<%@ include file="/html/portal/init.jsp" %>
<script type="text/javascript" src="/sli-new-theme/js/scroll.js"></script>
<%
String currentURL = PortalUtil.getCurrentURL(request);

String referer = ParamUtil.getString(request, WebKeys.REFERER, currentURL);

if (referer.equals(themeDisplay.getPathMain() + "/portal/update_terms_of_use")) {
	referer = themeDisplay.getPathMain() + "?doAsUserId=" + themeDisplay.getDoAsUserId();
}
%>
     <div id="sli_banner">
         <div id="sli_heading">
              <div class="portlet-layout">
                   <div class="portlet-column portlet-column-only" id="column-1">
                         <div class="sli_logo_main"> <a href="<%= themeDisplay.getURLHome() %>"> <img class="company-logo" src="<%= themeDisplay.getCompanyLogo() %>" width="<%= themeDisplay.getCompanyLogoWidth() %>" height="<%= themeDisplay.getCompanyLogoHeight() %>"/> </a> 
</div>
                   </div>
              </div>
        </div>
        
    </div>
    <div id="sli_content_main">
    <div class="sli_home_title">HOME</div>
	</div>
    
<div class="d_popup">
<span class="aui-legend" style="font-weight:bold;font-size: 18px; color:#333333; width:700px;">Terms of Use</span>
<br /><br /><br /><br />
<!-- US 2854- update static text as per environment -->
<%boolean is_sandbox = false; %>
<aui:form action='<%= themeDisplay.getPathMain() + "/portal/update_terms_of_use" %>' name="fm">
	<aui:input name="doAsUserId" type="hidden" value="<%= themeDisplay.getDoAsUserId() %>" />
	<aui:input name="<%= WebKeys.REFERER %>" type="hidden" value="<%= referer %>" />
    	
        <div id="scroll" style="overflow: hidden;">
        <div id="scrollcontent">
	<c:choose>
		<c:when test="<%= (PropsValues.TERMS_OF_USE_JOURNAL_ARTICLE_GROUP_ID > 0) && Validator.isNotNull(PropsValues.TERMS_OF_USE_JOURNAL_ARTICLE_ID) %>">
			<liferay-ui:journal-article groupId="<%= PropsValues.TERMS_OF_USE_JOURNAL_ARTICLE_GROUP_ID %>" articleId="<%= PropsValues.TERMS_OF_USE_JOURNAL_ARTICLE_ID %>" />
		</c:when>

		<c:otherwise>
		<br>
<br>
<!-- US 2854- display EULA text as per environment -->
<%is_sandbox = GetterUtil.getBoolean(PropsUtil.get("is_sandbox")); 
			
			if(is_sandbox){%>
			You are in the inBloom developer sandbox environment which is subject to the <a target="_blank"  href="http://www.inbloom.org/terms-of-use">Terms of Use</a> and <a target="_blank" href="http://www.inbloom.org/privacy-policy">Privacy Policy</a> of the inBloom website. <br/><br/>

Please note:  No personally identifiable information under the Family Educational Rights and Privacy Act, 20 U.S.C. &sect;1232 g, and its regulations ("<b>FERPA</b>") or other personal information may be accessed, uploaded or otherwise provided to the developer sandbox environment.
				
			<%}else{%>
				<p>You are requesting access to the production environment of inBloom. By using this portion of the inBloom website (the "Site") and accessing the inBloom production environment, you acknowledge and agree that you are bound by the terms and conditions outlined in the <a target="_blank" href="http://www.inbloom.org/terms-of-use">Terms of Use</a> and <a target="_blank" href="http://www.inbloom.org/privacy-policy">Portal Privacy</a> for the site, inclusive of the production usage. Be good.</p>
			<%}%><br><br>
		</c:otherwise>

	</c:choose>
        </div>
          <div id="scrollbar" style="display: block; top: 0pt;">
            <div class="scroller" id="scroller" style="height: 134.128px; top: 0pt;">&nbsp;</div>
          </div>
        </div>
        
	<c:if test="<%= !user.isAgreedToTermsOfUse() %>">
		<aui:button-row>
			
            <aui:button type="submit" value="i-agree" />
			<%
			String taglibOnClick = " ";
			%>
<a href="/portal/c/portal/logout" >
			<aui:button onClick="<%= taglibOnClick %>" type="cancel" value="i-disagree" />
            </a>            
            
		</aui:button-row>
	</c:if>
</aui:form>
</div>
<br /><br /><br /><br /><br /><br />
 
    <footer id="sli_footer">
      <div class="sli_footer_wrap">
	  <!-- US 2854- display footer text as per environment -->
        <%if(is_sandbox){ %>
        <p>&copy; 2012 inBloom, Inc. and its affiliates <a target="_blank" href="http://www.inbloom.org/privacy-policy">Privacy Policy</a>  <a target="_blank"  href="http://www.inbloom.org/terms-of-use">Terms of Use</a> </p>
      <%}else{ %>
      <p>&copy; 2012 inBloom, Inc. and its affiliates  <a target="_blank" href="http://www.inbloom.org/privacy-policy">Privacy Policy</a> <a target="_blank" href="http://www.inbloom.org/terms-of-use">Terms of Use</a></p>
      <%} %>
      </div>
    </footer>
 
<style type="text/css">
.d_popup{
	width:700px;
	height:450px;
	padding:20px;
	margin:0 auto;
	border:solid 1px #B2B2B2;
	-moz-box-shadow: 0 0 20px #888;
	-webkit-box-shadow: 0 0 20px#888;
	box-shadow: 0 0 20px #888;
}

#portlet_terms-of-use .portlet-topper{
	display:none;
}
#portlet_terms-of-use .portlet-content{
	padding:0;
}

.d_popup .aui-button-holder{
	border-top:#E5E5E5 solid 1px;
	padding-top:20px;
	margin-top:30px;
}

.d_popup .aui-button-holder .aui-button{
	float:right;
	margin-left:10px;
}
</style>
<script type="text/javascript"> 
TINY.scroller.init('scroll','scrollcontent','scrollbar','scroller','buttonclick');
</script>
