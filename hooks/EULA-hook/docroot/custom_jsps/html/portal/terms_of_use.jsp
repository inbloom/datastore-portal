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

<%@page import="org.slc.sli.constant.StaticText"%>
<%@ include file="/html/portal/init.jsp" %>

<%@ page import="org.slc.sli.service.ClientServiceUtil"%>
<%@ page import="org.slc.sli.api.client.impl.CustomClient"%>

<%@ page import="org.slc.sli.api.client.EntityCollection"%>

<%@ page import="org.slc.sli.common.constants.v1.PathConstants"%>
<%@ page import="org.slc.sli.api.client.impl.BasicQuery"%>
<%@ page import="java.net.URISyntaxException"%>
<script type="text/javascript" src="/sli-new-theme/js/scroll.js"></script>
<%
String currentURL = PortalUtil.getCurrentURL(request);

String referer = ParamUtil.getString(request, WebKeys.REFERER, currentURL);

if (referer.equals(themeDisplay.getPathMain() + "/portal/update_terms_of_use")) {
	referer = themeDisplay.getPathMain() + "?doAsUserId=" + themeDisplay.getDoAsUserId();
}

//  Display Logo,Organization Name,Eula text and Footer text from API
String logo = "";
String orgName = "";
String footerText = "";
String eulaText = "";

HttpSession httpSession = (HttpSession)request.getSession(false);
String token = (String)httpSession.getAttribute("OAUTH_TOKEN");

CustomClient  bc= ClientServiceUtil.getCustomClientService();
bc.setToken(token);
System.out.println("inside bottom ext jsp ************"+bc);

try{
	EntityCollection collection = new EntityCollection();
	EntityCollection collection2 = new EntityCollection();
	EntityCollection collection3 = new EntityCollection();
	
	bc.read(collection, StaticText.eulaContent);
	if (collection != null && collection.size() >= 1) {
		eulaText = String.valueOf((String)collection.get(0).getData().get("eulaText"));
		}
	
	bc.read(collection2, StaticText.jsonContent);
	if (collection2 != null && collection2.size() >= 1) {
		footerText = String.valueOf((String)collection2.get(0).getData().get("footerText"));
		orgName = String.valueOf((String)collection2.get(0).getData().get("orgName"));
		}

	bc.read(collection3, StaticText.logoContent);

	if (collection3 != null && collection3.size() >= 1) {
		logo = String.valueOf((String)collection3.get(0).getData().get("logo"));
		}
}catch(Exception e){
	
}

%>
     <div id="sli_banner">
         <div id="sli_heading">
              <div class="portlet-layout">
                   <div class="portlet-column portlet-column-only" id="column-1">
                         <div class="sli_logo_main"> <a href="<%= themeDisplay.getURLHome() %>"><img class="company-logo" src="data:image/png;base64,<%=logo%>" width="<%= themeDisplay.getCompanyLogoWidth() %>" height="<%= themeDisplay.getCompanyLogoHeight() %>"/>  </a> 
 <a href="<%= themeDisplay.getURLHome() %>"><span><%=orgName %></span></a>
</div>
                   </div>
              </div>
        </div>
        
    </div>
    <div id="sli_content_main">
    <div class="sli_home_title">HOME</div>
	</div>
    
<div class="d_popup">
<span class="aui-legend" style="font-weight:bold;font-size: 18px; color:#333333; width:700px;">License Agreement</span>
<br /><br />
<!-- US 2854- update static text as per environment -->

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
<!-- US 1579- Display EULA text from API -->
<%= eulaText%><br><br>
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
	  <!-- US 1577-Display footer text from API -->
        <%= footerText %>
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