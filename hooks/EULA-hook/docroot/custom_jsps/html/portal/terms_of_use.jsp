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
 <a href="<%= themeDisplay.getURLHome() %>"><span>SLC</span></a>
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
			You are in the Shared Learning Collaborative developer sandbox environment which is subject to the <a target="_blank"  href="http://dev.slcedu.org/legal/terms-of-use">Terms of Use</a> and <a target="_blank" href="http://dev.slcedu.org/legal/privacy">Privacy Policy</a> of the Shared Learning Collaborative developer website. <br/><br/>

Please note:  No actual student data or other personally identifiable information under the Family Educational Rights and Privacy Act, 20 U.S.C. &sect;1232 g, and its regulations ("<b>FERPA</b>") or other personal information may be accessed, uploaded or otherwise provided to the developer sandbox environment.
			
				
			<%}else{%>
			<p><b>Terms of Use for Access to SLI Portal Site</b></p>
			<p><b>With Supplemental Terms of Use for Access to SLI Portal Site for Super Administrators</b></p>
			<br>
			<br>
			<p>Effective Date: August 27, 2012</p>
			<br>
			<p><b>Introduction</b></p>
			<p>Welcome to the Shared Learning Infrastructure Portal Site and Service.</p>
			<p>This site located at portal.slcedu.org (the "<b>Site</b>") is provided by the Shared Learning Collaborative, LLC (the "<b>SLC</b>", "<b>we</b>", "<b>us</b>", <b>etc</b>.).</p>
			<p>These Terms, including the Portal Privacy Statement <a target="_blank" href="http://dev.slcedu.org/legal/portal-privacy-policy">http://dev.slcedu.org/legal/portal-privacy-policy</a>, are an agreement between the SLC and you and govern your use of the Site.  In the event that any of the provisions in these Terms conflict with the SLI Service Agreement entered into between SLC and a School District or State Educational Agency that employs you, or to whom you are serving as a contractor, such SLI Service Agreement will control.</p>


			<br>

			<ol style="list-style-type:decimal;">
				<li>
					<p><b>Eligibility.</b></p>
					<p>This Site is provided as part of the ALPHA release of the Shared Learning Infrastructure software system ("<b>SLI Service</b>") and is only accessible to users who have been authorized by a School District or State Educational Agency participating in the SLI Pilot ("<b>you</b>" or "<b>Authorized User</b>").</p>
					<p>By using the Site you agree to these Terms, as amended from time to time. You further agree that (1) you are at least 18 years old, and (2) you have the full power, capacity and authority to accept these Terms on behalf of yourself, or if applicable, your employer or other institution that you represent.</p>
					<p>PLEASE DO NOT USE THE SITE IF YOU DO NOT AGREE TO THE TERMS AND IF YOU ARE NOT AN AUTHORIZED USER.</p>

				</li>

				<li>
					<p><b>Definitions.</b></p>
					<p><b>Customer</b> means a school district or state educational agency ("SEA") participating in the SLI Pilot.</p>
					<p><b>Customer Data</b> means all information, records, files, and data stored in the SLI Service by or on behalf of a Customer, including by an Authorized User.  Customer Data may include Personally Identifiable Information.</p>
					<p><b>Personally Identifiable Information</b> means any information defined as personally identifiable information under the Family Educational Rights and Privacy Act, 20 U.S.C. &sect;1232g, and the regulations promulgated thereunder ("<b>FERPA</b>").</p>
					<p><b>Third Party Application Providers</b> means third party program application providers who have been granted access to the SLI Service and Customer Data and who may make their software applications available through the Site, through separate agreements with a School District and/or SEA.</p>
				</li>

				<li>
					<p><b>Registration and Creating Profiles etc.; Attribution of Electronic Acts to You.</b></p>
					<p>To access the Site and use the SLI Service, you may be assigned an account by a Customer's administrator, or you may have to complete a registration process to create an account, including user name and password that identifies you as an Authorized User ("<b>User ID</b>").  You agree to guard your User ID as confidential information-if you are careless with it, others may be able to access the information. Access to portions and functionality of the Site may be limited based on role-based permissions linked to your User ID that are granted by a School District and/or State Educational Agency.</p>
					<p>You agree that all uses of the User ID established for you during a registration or similar process will be attributed to and legally bind you and may be relied upon by SLC and our agents, affiliates, and other third parties with whom we work in order to provide the Site and SLI Service (including but not limited to our and their respective affiliates, officers, employees and agents) (collectively "<b>SLI Third Parties</b>"), as being a use made by you, even if someone else used your User ID.</p>
					<p>Use of your account information will be governed by the Portal Privacy Statement <a target="_blank" href="http://dev.slcedu.org/legal/portal-privacy-policy">http://dev.slcedu.org/legal/portal-privacy-policy</a>.   We may use your account information (including any email addresses you provide) to send you service announcements, administrative messages and other information.</p>

				</li>
				<li>
					<p><b>Use of the Service.</b></p>
					<p>By accessing and using the Site, you agree that you will not:</p>
					<ul>
						<li>do anything that could disable, overburden or impair the proper working of the Site;</li>
						<li>use any robot, spider, scraper or other automated means to access the Site;</li>
						<li>do anything that is illegal, infringing, fraudulent, malicious or could expose SLC or users of the Site to harm or liability; or</li>
						<li>attempt, encourage or facilitate any of the above.</li>
					</ul>
					<p>You further agree not to upload, post or otherwise transmit through the Site any content or materials whatsoever that are or could appear to:</p>
					<ul>
						<li>be defamatory, obscene, invasive to another person's privacy or protected data, or tortious;</li>
						<li>be infringing upon anyone's intellectual property rights, including any patent, trademark, trade secret, copyright, or right of publicity;</li>
						<li>contain any software viruses or any other harmful computer code, files, or programs, including any designed to interrupt, destroy, or limit the functionality of any computer software or hardware or telecommunications equipment; and</li>
						<li>be in violation of any applicable license, law or contractual or fiduciary duty or provision.</li>
					</ul>
				</li>
				<li>
					<p><b>Use of Data, Content and Applications.</b></p>
					<p>The Site contains a variety of content, including (without limitation) information, data, Customer Data, text, software applications,  graphics, video, messages or other materials that are available for access and use via the Site.  Except as stated in these Terms, you may review and use such content solely for the purpose of your governmental or educational purpose and attendant operations, or as reasonably required to fulfill your duties to School Districts and/or SEAs participating in the SLI Pilot.  YOU MAY NOT SELL THE CONTENT OR OTHERWISE DISTRIBUTE IT FOR A FEE.</p>
					<ol style="list-style-type:upper-alpha;">
						<li>
							<p><b>Use of Personally Identifiable Information.</b></p>
							<p>Your use Customer Data consisting of Personally Identifiable Information is limited to the purposes described in the SLI Service Agreement or your agreement with your respective School District or SEA, and you agree that the use of any Customer Data you have access to will be in accordance with such agreements, as well as applicable federal and state law, including FERPA.</p>
						</li>
						<li>
							<p><b>SLC Applications.</b></p>
							<p>Any content consisting of SLI software applications accessible to you on the Site are made available for your use subject to these Terms.  SLC gives you a non-assignable and non-exclusive license to use the SLI software applications provided to you as part of the SLI Service for the purpose of a Customer's educational purposes and in its operations.   You may not copy, modify, distribute sell or lease any part of the SLI Service, including the SLI Applications, nor may you reverse engineer or attempt to extract the source code of that software, unless the laws prohibit these restrictions or you have permission to do so under a separate license.</p>
							<p>We note that some software used in the SLI Service may be offered under an open source license that we will make available to you.  There may be some provisions in the open source license that expressly override these terms.</p>
						</li>
						<li>
							<p><b>Third Party Applications.</b></p>
							<p>You will also be able to access and use SLI compatible applications developed by Third Party Application Providers and approved for use by each Customer for its Authorized Users.  Each Third Party Application Provider is solely responsible for all of the content of its applications.</p>
							<p>Third Party Application Providers will be required to adhere to certain privacy practices with respect to certain Customer Data that may be shared with the application.  Each respective Customer's agreement with that Third Party Application Provider will control how such applications can use, store, and transfer Customer Data consisting of Personally Identifiable Information.</p>
							<p>Some of the applications provided by Third Party Application Providers may be covered by separate terms for such application (such as an end user license agreement, an open source license and/or terms of use).  You can find the terms under which such application is being distributed on the information page of that application.</p>
						</li>
					</ol>
				</li>
				<li>
					<p><b>Intellectual Property Rights.</b></p>
					<p>This Site is protected by intellectual property laws and you agree to respect them. Except as otherwise expressly provided in these Terms, you may not copy, distribute, transmit, display, perform, reproduce, publish, license, rewrite, create derivative works from, transfer or sell any material contained on the Site without the prior consent of SLC or the copyright owner.  The SLC does not condone the infringement of intellectual property rights on our Site.</p>

				</li>
				<li>
					<p><b>Amendments.</b></p>
					<p>You agree that from time to time we may alter (including adding or eliminating all or parts of provisions) these Terms ("<b>Amendments</b>"). Amended versions of these Terms will take effect on the date specified for the amended version ("<b>Effective Date</b>") and will apply to all information that was collected after the Effective Date.  Changes will be effective when they appear in a replacement version of these Terms as posted by us on the Site. We may also notify you through email.  USE OF THE SITE AFTER THE EFFECTIVE DATE WILL CONSTITUTE YOUR CONSENT TO THE AMENDMENTS, SO IF YOU DO NOT WANT TO BE BOUND BY AN AMENDED VERSION, DO NOT USE THE SITE AND CEASE ALL USE OF THE CONTENT OR SERVICES.</p>

				</li>

				<li>
					<p><b>Additional or Required Notices. </b>Various laws require or allow us to give users certain notices and any such required notice is incorporated into these Terms:</p>
					<p><b>Notice: No Harvesting or Dictionary Attacks Allowed.</b> The SLC will not give, sell, or otherwise transfer addresses maintained by it to any other party for the purposes of initiating, or enabling others to initiate, electronic mail messages except as authorized by law or appropriate SLC personnel or policies. Except for parties authorized to have such addresses, persons may violate federal law if they: (1) initiate the transmission to our computers or devices of a commercial electronic mail message (as defined in the U.S. "CAN-SPAM Act of 2003") that does not meet the message transmission requirements of that act; or (2) assist in the origination of such messages through the provision or selection of addresses to which the messages will be transmitted.</p>
					<p><b>Notice: Regarding Trademarks</b> All trademarks, service marks, and trade names used in the Site (including without limitation: the SLC, the SLC and the associated designs and logos) (collectively "Marks") are owned by (1) the SLC or (2) their respective trademark owners, and are either trademarks or registered trademarks of the SLC, its affiliates, partners or licensors. You may not use, copy, reproduce, republish, upload, post, transmit, distribute, or modify the Marks in any way, including in advertising or publicity pertaining to distribution of materials on this Site, without the SLC's prior written consent. The use of the Marks on any other website or networked computer environment is not allowed. You may not use the Marks as a "hot" link on or to any other website unless establishment of such a link is approved in advance. </p>
					<p><b>Notice: Regarding Copyright ownership.</b> Copyright 2012 Shared Learning Collaborative, LLC</p>
					<p><b>Notice: Regarding Copyright Agent.</b> The SLC respects the intellectual property rights of others and requests that Site users do the same. Anyone who believes that their work has been infringed under copyright law may provide a notice to the designated Copyright Agent for the Site containing the following:</p>
					<ul>
						<li>An electronic or physical signature of a person authorized to act on behalf of the owner of the copyright interest;</li>
						<li>Identification of the copyrighted work claimed to have been infringed;</li>
						<li>Identification of the material that is claimed to be infringing and information reasonably sufficient to permit the SLC to locate the material;</li>
						<li>The address, telephone number, and, if available, an e-mail address at which the complaining party may be contacted;</li>
						<li>A representation that the complaining party has a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law;</li>
						<li>A representation that the information in the notice is accurate, and under penalty of perjury, that the complaining party is authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.</li>
					</ul>
					<br>
					Copyright infringement claims and notices should be sent to:<br>
					<br>
					Shared Learning Collaborative, LLC<br>
					Attn: Legal<br>
					P.O. Box 23350<br>
					Seattle, WA 98102<br>
					<br>
					<br>
					<p><b>Notice of Availability of Filtering Software.</b> We do not believe that the Site contains materials that would typically be the subject of filtering software and minors are not authorized to visit our Site. Nevertheless, all users are hereby informed that parental control protections (such as computer hardware, software, or filtering services) are commercially available that may assist in limiting access to material that is harmful to minors. A report detailing some of those protections can be found at Children's Internet Protection Act: Report on the Effectiveness of Internet Protection Measures and Safety Policies.</p>
					<br>
					<br>
					<br>
					<p><b>Supplemental Terms of Use for Access to SLI Portal Site for Super Administrators</b><br></p>
					<p><b>Introduction:</b> These Terms of Use apply to individuals who have been designated as Super Administrators by their School District or State Education Agency.  The Super Administrator portion of the Site is for use only by Authorized Users who have been authorized by a School District or State Educational Agency to function as administrators for such institution for the SLI Service ("<b>Super Administrators</b>") in accordance with the SLI Service Agreement entered into between your School District or State Educational Agency and the SLC.</p>
					<br>
					<p>By using the Super Administrator portion of the Site, you represent and warrant that you have the authority to function as a Super Administrator and perform the responsibilities and obligations described in the SLI Service Agreement by and on behalf of a School District participating in the SLI Pilot.</p>
					<p><b>Incorporated Terms:</b> Your use of the Site is governed by this agreement and includes all of the provisions of the Terms of Use for Access to the Portal Site, as amended from time to time.</p>
					<p><b>Security:</b> You agree to adhere to commercially reasonable security practices relevant to your interaction with the SLI Service. You agree to use commercially reasonable efforts to notify the SLC in writing no more than twenty-four (24) hours after your detection of a security breach or privacy violations related to data provided through the SLI Service.</p>
				</li>
			</ol>
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
        <p>(C) Shared Learning Collaborative, LLC. <a target="_blank" href="http://dev.slcedu.org/legal/privacy">Privacy Policy</a>  <a target="_blank"  href="http://dev.slcedu.org/legal/terms-of-use">Terms of Use</a> </p>
      <%}else{ %>
      <p>&copy; Shared Learning Collaborative, LLC. <a target="_blank" href="http://dev.slcedu.org/legal/portal-privacy-policy">Privacy Policy</a> <a target="_blank" href="http://dev.slcedu.org/legal/portal-terms-use">Terms of Use</a></p>
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
