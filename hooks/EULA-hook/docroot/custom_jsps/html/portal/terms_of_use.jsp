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
			<p><strong>Terms of Use for Access to SLI Portal Site</strong></p>
			<p>Effective Date: December 12, 2012</p>
			<br>
			<p><strong>Introduction</strong></p>
			<p>Welcome to the Shared Learning Infrastructure Portal Site and Service.</p>
			<p>This site located at [portal.slcedu.org and other hostnames within the slcedu.org domain] (the "<strong>Site</strong>") is provided by the Shared Learning Collaborative, LLC (the "<strong>SLC</strong>", "<strong>we</strong>", "<strong>us</strong>", etc.). The Shared Learning Collaborative, LLC is a limited liability company existing under the laws of the State of Washington, U.S.A. The SLC is a not-for-profit entity organized and operated to carry out the charitable and educational purposes of its members within the meaning of Section 501(c)(3) of the Internal Revenue Code of 1986.</p>
			<p>These Terms of Use for Access to the Shared Learning Infrastructure (SLI) Portal Site ("<strong>Terms</strong>"), including the <a target="_blank" href="http://dev.slcedu.org/legal/portal-privacy-policy">Portal Privacy Statement</a>, are an agreement between the SLC and you and govern your use of the Site.</p>
			<p><strong><u>Note to State and District Employees and Their Contractors:</u></strong>  In the event that any of the provisions in these Terms conflict with any terms relating to your obligations as an Authorized User under the SLI Service Agreement entered into between the SLC and a School District or State Educational Agency that employs you or that you are serving as a contractor, such SLI Service Agreement will control.</p>
			<br>
			<ol style="list-style-type:decimal;">
				<li>
					<p><strong>Eligibility.</strong></p>
					<p>This Site is provided as part of the Shared Learning Infrastructure software system ("<strong>SLI Service</strong>") and is only accessible to users who have been authorized by a School District or State Educational Agency to access this Site ("<strong>you</strong>" or "<strong>Authorized User</strong>").</p>
					<p>By using the Site you agree to these Terms, as amended from time to time. You further agree that (1) you are at least 18 years old, and (2) you have the full power, capacity and authority to accept these Terms on behalf of yourself, and, if applicable, your employer or other institution that you represent.</p>
					<p>YOU MAY NOT USE THIS SITE IF YOU DO NOT AGREE TO THE TERMS. Please read these Terms carefully. If you do not accept and agree to be bound by any of these Terms, you are not authorized to access or otherwise use this Site or any information contained on this Site.  Your access to and use of this Site constitutes your acceptance of and agreement to abide by each of these terms.  These Terms may be changed, modified, supplemented or updated by the SLC from time to time without advance notice by posting here and you will be bound by any such changed, modified, supplemented, or updated Terms if you continue to use this Site after such changes are posted.   Unless otherwise indicated, any new content, products, software, services or Third Party Applications added to this Site will also be subject to these Terms effective upon the date of any such addition. You are encouraged to review the Site and these Terms periodically for updates and changes.</p>

				</li>

				<li>
					<p><strong>Definitions.</strong></p>
					<p><strong>Customer</strong> means a School District or State Educational Agency authorized to access the SLI Service and this Site.</p>
					<p><strong>Customer Data</strong> means all information, records, files, and data stored in the SLI Service by or on behalf of a Customer, including by an Authorized User.  Customer Data may include Personally Identifiable Information.</p>
					<p><strong>Personally Identifiable Information</strong> means any information defined as personally identifiable information under the Family Educational Rights and Privacy Act, 20 U.S.C. &#167;1232g, and the regulations promulgated thereunder ("<strong>FERPA</strong>").</p>
					<p><strong>School District</strong> means a local educational agency or independent special purpose school system, school network, or a dependent school system under the control of a state or local government.</p>
					<p><strong>State Educational Agency or SEA</strong> means the state educational agency primarily responsible for the supervision of public elementary and secondary schools in any of the 50 United States, the Commonwealth of Puerto Rico, or the District of Columbia.</p>
					<p><strong>SLI Service</strong> means a web-based software system, provided as a service, which is designed to allow personalized learning for students and to improve student achievement by providing  curriculum content, assessments and professional development and to facilitate evaluation and compliance of state- and federal-supported education programs.</p>
					<p><strong>Third Party Application</strong> means a software application, provided by a Third Party Application Provider, that is designed to be used through the SLI Service.</p>
					<p><strong>Third Party Application Providers</strong> means (1) third party program application providers who have been granted access to the SLI Service and Customer Data in order to  make their software applications available through the Site, through separate agreements with a School District and/or SEA, and (2) authorized representatives of State Educational Agencies that assist the State Educational Agency in evaluation or compliance-related activities regarding state- or federal-supported education programs.</p>
				</li>

				<li>
					<p><strong>Registration and Creating Profiles etc.; Attribution of Electronic Acts to You</strong></p>
					<p>To access the Site and use the SLI Service, you may be assigned an account by a Customer's administrator, or you may have to complete a registration process to create an account - approved by a Customer's administrator -- including user name and password that identifies you as an Authorized User ("<strong>User ID</strong>"). You agree to guard your User ID as confidential information-if you are careless with it, others may be able to access you're and/or such Customer's information. Access to portions and functionality of the Site may be limited based on role-based permissions linked to your User ID that are granted by a School District and/or State Educational Agency.  If you are using an account assigned to you by an administrator, different or additional terms may apply and your administrator may be able to access or disable your account.</p>
					<p>You agree that all uses of the User ID established for you during the registration  process will be attributed to and legally bind you and may be relied upon by the SLC and our agents, affiliates, and other third parties with whom we work in order to provide the Site and SLI Service (including but not limited to our and their respective affiliates, officers, employees and agents) (collectively "<strong>SLC Third Parties</strong>"), as being a use made by you, even if someone else used your User ID.</p>
					<p>You agree to provide accurate, current and complete information at all times. You also agree that you will review, maintain, correct, and update such information in a timely manner to maintain its accuracy and completeness by using the means allowed for the relevant information or, when appropriate, by contacting us. </p>
					<p>Use of your account information will be governed by the <a target="_blank" href="http://dev.slcedu.org/legal/portal-privacy-policy">Portal Privacy Statement</a>. We may use your account information (including any email addresses you provide) to send you service announcements, administrative messages and other information. </p>

				</li>
				<li>
					<p><strong>Use of the Service</strong></p>
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
					<p><strong>Use of Data, Content and Applications</strong></p>
					<p>The Site contains a variety of content, including (without limitation) information, data, Customer Data, text, software applications,  graphics, video, messages or other materials that are available for access and use via the Site.  Except as stated in these Terms, you may review and use such content solely for educational or service purposes authorized in the applicable SLI Service Agreement between the SLC and a School District or State Educational Agency participating in the SLI - and consistent with your responsibilities to such School District or State Educational Agency.  YOU MAY NOT SELL THE SITE CONTENT OR OTHERWISE DISTRIBUTE IT FOR A FEE. YOU WILL NOT USE OR PROVIDE ACCESS TO THE SITE OR ITS CONTENT TO ANY THIRD PARTIES EXCEPT AS EXPRESSLY PERMITTED BY THESE TERMS. </p>
					<ol style="list-style-type:upper-alpha;">
						<li>
							<p><strong>Use of Personally Identifiable Information</strong></p>
							<p>Your use of Customer Data consisting of Personally Identifiable Information is limited to the purposes described in the SLI Service Agreement or your agreement with your respective School District or SEA, and you agree that the use of any Customer Data you have access to will be in accordance with such agreements, as well as applicable federal and state law, including FERPA.  Third Party Application Providers are also subject to the additional terms set forth in Section 6.</p>
						</li>
						<li>
							<p><strong>SLC Applications</strong></p>
							<p>Any content consisting of SLI software applications (including those forming part of the SLI Service) accessible to you on the Site are made available for your use subject to these Terms.  The SLC gives you a non-assignable and non-exclusive license to use the SLI software applications provided to you as part of the SLI Service for the purpose of a Customer’s educational purposes and in its operations.</p>
							<p>We note that software applications used in the SLI Service may be offered under an open source license that we will make available to you.  There may be some provisions in the open source license that expressly override these Terms. Except where permitted under an open source license or separate agreement, you may not copy, modify, distribute sell or lease any part of the SLI Service, including the SLI software applications, nor may you reverse engineer or attempt to extract the source code of that software, unless applicable law prohibits these restrictions.</p>
						</li>
						<li>
							<p><strong>Use of Third Party Applications</strong></p>
							<p>You may also be able to access and use SLI-compatible Third Party Applications developed by Third Party Application Providers and approved for use by each Customer for its Authorized Users. Each Third Party Application Provider is solely responsible for all of the content of its Third Party Applications.</p>
							<p>Each respective Customer’s agreement with that Third Party Application Provider will control how such Third Party Applications can use, store, and transfer Customer Data, including Personally Identifiable Information.  Third Party Application Providers will be required by the to adhere to certain privacy practices with respect to any Customer Data that may be shared with their Third Party Applications (see Section 6 below).</p>
							<p>Some of the Third Party Applications provided by Third Party Application Providers may be covered by separate terms for such Third Party Applications (such as an end user license agreement, an open source license and/or terms of use). You can find the terms under which each such Third Party Application is being distributed on the information page of that Third Party Application.</p>
						</li>
						<li>
							<p><strong>Submission of Content</strong></p>
							<p>When you submit content to the SLI Service, as between the parties, you retain any ownership of any intellectual property rights that you have in that content. You give the SLC a worldwide, perpetual, irrevocable, sublicensable and transferable license to use, host store, reproduce, modify, create derivative works, publish, publicly perform, publicly display and distribute such content.  The rights you grant are for the limited purpose of operating and improving the SLI Service.</p>
							<p>When you provide content through the Site, you represent and warrant that the content is wholly your original work, or that you have all necessary right, title, interest and licenses to upload it and make it available to the SLC and other users for download, distribution and use under these Terms without any violation (by you, us, SLC Third Parties, users or anyone else) of any applicable license, restriction or law.</p>
						</li>
					</ol>
				</li>
				<li>
					<p><strong>Special Provisions for Third Party Application Providers</strong></p>
					<p>As a Third Party Application Provider, you are responsible for your Third Party Application, its content and all uses you make of the Site. This includes ensuring your Third Party Application or use of Site and any Customer Data (including Personally Identifiable Information) meets the requirements described in your agreements your Customers. Your access to and use of data you receive from the SLI Service, will be limited as follows: </p>
					<ul>
						<li>You will only request access to Customer Data you need to operate your Third Party Application.</li>
						<li>You will have a privacy policy posted in a clear and conspicuous manner that tells users what Customer Data you are going to use and how you will use, display, share, or transfer that data and you will include your privacy policy URL in your Third Party Application.</li>
						<li>You will not use, display, share, or transfer Customer Data in a manner inconsistent with your privacy policy.</li>
						<li>You will delete all Customer Data you receive from a Customer concerning a user of the Third Party Application if the Customer asks you to do so, and will provide a mechanism for users of the Third Party Application to make such a request.</li>
						<li>You will not directly or indirectly transfer any Customer Data or information you receive from the Site, without permission of Customer.  If you are acquired by or merge with a third party, you can continue to use user data within your Third Party Application, but you cannot transfer user data outside of your Third Party Application.</li>
						<li>You acknowledge that we can limit your access to Customer Data if you use it in a way that we determine is inconsistent with the [Data Privacy and Security Policy and/or our Terms of Service. You will not give us information that you independently collect from a user or a user's account without that user's consent.</li>
					</ul>
					<p>Further, with respect to any Third Party Application:</p>
					<ul>
						<li>You will make it easy for users to remove or disconnect from your Third Party Application.</li>
						<li>You will make it easy for users to contact you. We can also share your email address with users and others claiming that you have infringed or otherwise violated their rights.</li>
						<li>You will provide Customer and user support for your Third Party Application.</li>
						<li>You will not show any advertisements or web search boxes through your Third Party Application.</li>
						<li>You will comply with all applicable laws with respect to the handling of Customer Data and your interaction with this Site, including FERPA.   </li>
						<li>You will give the SLC all rights necessary to enable your Third Party Application to work with the SLI Service.</li>
						<li>To ensure your Third Party Application is safe for users, you agree we may audit it.  </li>
						<li>We can create applications that offer similar features and services to, or otherwise compete with, your Third Party Application.</li>
						<li>You will notify the SLC of any known or suspected unauthorized access to Personally Identifiable Information or confirmed breach of such Third Party Application Provider's security measures.</li>
					</ul>
				</li>
				<li>
					<p><strong>Intellectual Property Rights</strong></p>
					<p>This Site is protected by intellectual property laws and you agree to respect them. Unless otherwise specified, the SLC and its licensors retain full copyright ownership, rights and protection in all content and material it provides on the Site. Except as otherwise expressly provided in these Terms, you may not copy, distribute, transmit, display, perform, reproduce, publish, license, rewrite, create derivative works from, transfer or sell any material contained on the Site without the prior consent of the SLC or the copyright owner.  The SLC does not condone the infringement of intellectual property rights on our Site. </p>
				</li>
				<li>
					<p><strong>Feedback; Your License to Us</strong></p>
					<p>We hope that you will provide your Feedback (as defined below) so that we may better support, improve and pursue our educational purposes. However, you agree that you will not supply Feedback that infringes or violates the rights of others, and you hereby grant a License to the SLC (as defined below) in your Feedback. You agree that we have no obligation to pay you or anyone else for Feedback or for the License to the SLC. "<strong>Feedback</strong>" means all remarks, data, suggestions, methods, surveys, reports, processes and ideas (including patentable ideas) and other content that you provide by using the Site or provide about it, or any aspect of our operations, whether provided to us or persons working with us or the Feedback, and whether provided through the Site or through another forum or media such as a chat room, survey, report, software tool, bulletin board or otherwise.</p>
					<p>As used above, "License to the SLC" means a non-exclusive, perpetual, irrevocable, royalty-free, transferable, sub-licensable, worldwide license to the SLC to exercise all now or later existing intellectual property rights or other rights of yours or others in the Feedback, for purposes of supporting the SLC's educational purposes (as determined by us in our discretion from time to time) in full or in part and in all possible media (now known or later developed). The foregoing rights include (but are not limited to), the right to display, perform, read (on air or otherwise), and publish in public or private sites, newspapers or other media, brochures, reports and so on, all or part of the Feedback and any other information that you provide through or relating to our Site or the Content. The License to the SLC is in addition to any (if any) that you may be required to provide under any separate agreement between us and you (including grants or other agreements).</p>
				</li>
				<li>
					<p><strong>Indemnification</strong></p>
					<p>You agree to defend, indemnify and hold harmless the SLC, its contractors and its licensors, and their respective directors, officers, employees and agents from and against any and all third party claims and expenses, including attorneys' fees, arising out of your use of the Site or Content, including but not limited to out of your violation of any representation, warranty, obligation or agreement contained in these Terms. </p>
				</li>
				<li>
					<p><strong>NO WARRANTIES, CONDITIONS OR OTHER DUTIES</strong></p>
					<p>The Site and all Content (regardless of who generates it), Site functionality, assistance and services provided by the Site, the SLC or any SLC Third Parties (collectively, "Complete Site") are subject to change and are provided by us or any SLC Third Parties "AS IS" and "AS AVAILABLE, without any assurance, warranty and conditions, and without the undertaking of any duty, of any kind either express or implied, including but not limited to, any (if any) warranties or conditions of merchantability and fitness for a particular purpose, any duty (if any) of workmanlike effort or lack of negligence and any representation that this technology will fit your needs.</p>
					<p>The Complete Site is provided: (1) WITH ALL FAULTS and the entire risk as to satisfactory quality, performance, accuracy and effort is with you; and (2) without any assurance, or warranty, condition or duty of or regarding: functionality; privacy; security; accuracy; availability; back-up or preservation of Content you provide; lack of: negligence, interruption, viruses or other harmful code, components or transmissions; or the nature or consequences of content, such as whether software or other content is subject to any particular license or restrictions that may be triggered by any exercise of a right granted under these Terms.</p>
					<p>Also, there is no warranty by us or SLC Third Parties of title or against infringement or interference with enjoyment of any aspect of the Complete Site.  You agree that you will obtain any Content entirely at your own risk, and that you will be solely responsible for any resulting infringement, breach of contract, consequence or damage, including to your computer system or loss of data.</p>
				</li>
				<li>
					<p><strong>NO INCIDENTAL, CONSEQUENTIAL OR CERTAIN OTHER DAMAGES</strong></p>
					<p>TO THE FULL EXTENT ALLOWED BY LAW, YOU AGREE THAT NEITHER THE SLC, ANY SLC THIRD PARTY NOR ANY OTHER THIRD PARTY MENTIONED ON THE WEBSITE, WILL BE LIABLE TO YOU OR ANYONE ELSE FOR ANY SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, DAMAGES FOR LOST PROFITS, FOR LOSS OF PRIVACY OR SECURITY, FOR LOSS OF REPUTATION, FOR FAILURE TO MEET ANY DUTY, OR FOR ANY OTHER SIMILAR DAMAGES WHATSOEVER THAT ARISE OUT OF OR ARE RELATED TO ANY ASPECT OF THE COMPLETE SITE OR TO ANY BREACH OF THESE TERMS, EVEN IF WE OR A THIRD PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS MAY NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES OR THE EXCLUSION OR LIMITATION OF LIABILITY FOR CERTAIN INCIDENTAL OR CONSEQUENTIAL DAMAGES. IF THESE LAWS APPLY TO YOU, SOME OR ALL OF THE ABOVE DISCLAIMERS, EXCLUSIONS, OR LIMITATIONS MAY NOT APPLY TO YOU, AND YOU MIGHT HAVE ADDITIONAL RIGHTS.</p>
				</li>
				<li>
					<p><strong>EXCLUSIVE REMEDY; DAMAGE LIMITATION</strong></p>
					<p>YOU AGREE THAT YOUR EXCLUSIVE REMEDY FOR ANY BREACH OF THESE TERMS (INCLUDING WITHOUT LIMITATION, THE PORTAL PRIVACY STATEMENT) AND FOR ANY AGGREGATE DAMAGES DUE YOU (OR OTHERS RELATED TO YOU) BY THE SLC OR ANY OF THE SLC THIRD PARTIES FOR ANY REASON RELATING TO ANY PART OF THE SITE, WILL BE AT OUR OPTION: (A) SUBSTITUTION, CORRECTION OR REPLACEMENT OF ALL OR PART OF THE CONTENT OR SERVICE CAUSING YOUR DAMAGE (IF ANY); OR (B) THE AMOUNT OF YOUR DAMAGES THAT ARE NOT EXCLUDED IN THE PRECEDING SECTION AND WHICH YOU ACTUALLY INCUR IN REASONABLE RELIANCE, WHICH AMOUNT WILL BE THE LESSER OF THE AMOUNT YOU ACTUALLY PAID US FOR THE ITEM CAUSING THE DAMAGE (IF ANY) OR ONE HUNDRED U.S. DOLLARS ($100). The damage exclusions and limitations in these Terms are independent and will apply even if any remedy fails of its essential purpose.</p>
				</li>
				<li>
					<p><strong>Amendments</strong></p>
					<p>You agree that from time to time we may alter (including adding or eliminating all or parts of provisions) these Terms ("<strong>Amendments</strong>"). Amended versions of these Terms will take effect on the date specified for the amended version ("<strong>Effective Date</strong>") and will apply to all information that was collected after the Effective Date.  Those terms will change from time to time and the changes will be effective when they appear in a replacement version of these Terms as posted by us on the Site. We may also notify you through email.  No other Amendments will be valid unless they are in a paper writing signed by us and by you.  If you have any questions about these Terms or the Site, please contact us.</p>
					<p>Each time you return to the Site, you are responsible for checking the effective date of the then posted version of these Terms-if it is later than the date of the version last reviewed, the Terms have been changed and the new version should be reviewed before using the Site. USE OF THE SITE AFTER THE EFFECTIVE DATE WILL CONSTITUTE YOUR CONSENT TO THE AMENDMENTS, SO IF YOU DO NOT WANT TO BE BOUND BY AN AMENDED VERSION, DO NOT USE THE SITE AND CEASE ALL USE OF THE CONTENT OR SERVICES.</p>
				</li>
				<li>
					<p><strong>GOVERNING LAW AND EXCLUSIVE JURISDICTION </strong></p>
					<p>These Terms and your use of the Site are governed by the laws of the State of Washington, U.S.A., without regard to its choice of law provisions, except where you are required by published governmental law, ordinance, regulation, directive, order, or other governmental requirement (collectively, "Mandate") to contract for application of the law of your local jurisdiction. You expressly consent to exclusive jurisdiction for any dispute with the SLC in a state or federal court of general jurisdiction sitting in King County, Washington, U.S.A. except to the extent you are prohibited from doing so by a Mandate. You further agree and expressly consent to the exercise of personal jurisdiction in the courts of King County in the State of Washington in connection with any such dispute. Any Legal Action that is subject to the jurisdiction of federal courts shall be instituted in a federal court in the Western District of Washington. </p>
					<p>This Site is controlled by us from our offices within the United States of America. If you choose to access this Site from locations outside the U.S. you do so at your own risk and you are responsible for compliance with any local laws. You may not use or export anything (including information) from the Site in violation of U.S. export laws, regulations or the Terms. </p>
				</li>
				<li>
					<p><strong>Legal and Other Notices or Disclosures</strong></p>
					<p>Notice to You: You agree that we may give all notices we are required to give you by posting notice on the Site or, if we have your email address, by sending notice by email at our discretion, including (without limitation), disclosures that we are required to give you, legal notices, notice of subpoenas or other legal process (if any), and all other communications. When we communicate by email, we may use any email address you provide when communicating with us or that we otherwise have in our records, so only supply to us an email address at which you are willing to receive all communications. You agree to check for notices posted on the Site.</p>
					<p>Notice to Us (Our Legal Notices Address): We receive many emails and not all employees are trained to deal with every kind of communication. Accordingly, you agree to send us notice by mailing it to the following ("Our Legal Notice Address"):</p>
					<p>
						Shared Learning Collaborative, LLC<br/>
						P.O. Box 23350<br/>
						Seattle, WA 98102</br>
						Attn: Legal</br>
					</p>
				</li>
				<li>
					<p><strong>Termination or Cancellation; No Continuing Rights</strong></p>
					<p>You have no continuing right to use the Site and we may deny or suspend access, or terminate or cancel these Terms with or without cause and at any time and without prior notice. We may give notice of termination or cancellation in the same way that we may provide other notices.</p>
					<p>Termination or cancellation will not eliminate the surviving provisions of these Terms (see "Entire Agreement; Miscellaneous") and you will still be liable for obligations incurred before these Terms or access ended. </p>
				</li>
				<li>
					<p><strong>Entire Agreement; Miscellaneous</strong></p>
					<p>These Terms, including the Portal Privacy Statement (including any of the supplemental privacy policies), Amendments and any:  (a) notices, terms and items incorporated into any of them; (b) additional terms and conditions contained on the Site for particular activities or Content; and (c) our disclosures and your consents provided on or in connection with the Site or any Content, service or other activity; constitute the entire agreement between you and the SLC regarding the Complete Site or the subject matter of the foregoing (collectively, "Entire Agreement").  If any provision of the Entire Agreement is found by a court of competent jurisdiction to be invalid, its remaining provisions will remain in full force and effect, provided that the allocation of risks described herein is given effect to the fullest extent possible.  The foregoing does not impair the enforceability of additional agreements you enter into with the SLC including, without limitation, the SLI Service Agreement and SLC Data and Information Security Policy.</p>
					<p>Our failure to act with respect to a breach by you does not waive our right to act with respect to subsequent or similar breaches.  The terms of Sections 2, 3, 5, 7-9, 10-12, 14-19 and our rights under the Portal Privacy Statement will survive termination or cancellation of this Agreement. You may print or make an electronic copy of the Entire Agreement for your official records; to the extent required by law, we hereby instruct you to do so. You may not assign these Terms or any of your rights or obligations under these Terms without our prior written consent.</p>
					<p>The SLC retains the right to assign its rights, privileges, responsibilities, and obligations, as identified in these Terms or in other documents, to a third party, in whole or in part, for administration, technical support, marketing, or any other purpose at any time without providing notice to you or other users through the Site or by any other means.</p>
				</li>
				<li>
					<p><strong>Electronic Transactions</strong></p>
					<p>We, our employees, agents, affiliates, assigns and each of the SLC Third Parties may deal with you electronically now and in the future in their respective discretion during the entire course of activities pursued with you (e.g., applying for, obtaining, implementing, terminating and enforcing a grant or anything else), including but not limited to having you electronically sign documents and receive electronic notices.  We and each of the SLC Third Parties also reserve the right to deal non-electronically and to require you to do so.</p>
				</li>
				<li>
					<p><strong>Additional or Required Notices</strong>
					<p>Various laws require or allow us to give users certain notices and any such required notice is incorporated into these Terms. Users may review the notices by clicking on their link:</p>
					<ul>
						<li>Notice: No Harvesting or Dictionary Attacks Allowed (this provides information about conduct that is unlawful under the U.S. CAN SPAM Act of 2003). </li>
						<li>Notice Re Trademarks (this provides notice regarding who owns the trademarks used on our Site and cautions against infringement). </li>
						<li>Notice Re Copyright Ownership (this provides notice regarding who owns the copyrights in the Site and its contents and cautions against infringement). </li>
						<li>Notice of Copyright Agent (this provides contact and other information regarding the Site's copyright agent who may be notified of claimed infringement). </li>
						<li>Notice of Availability of Filtering Software (this provides a notice under the U.S. Communications Decency Act). </li>
					</ul>
					<p><strong>Notice: No Harvesting or Dictionary Attacks Allowed.</strong></p>
					<p>The SLC will not give, sell, or otherwise transfer addresses maintained by it to any other party for the purposes of initiating, or enabling others to initiate, electronic mail messages except as authorized by law or appropriate SLC personnel or policies. Except for parties authorized to have such addresses, persons may violate federal law if they: (1) initiate the transmission to our computers or devices of a commercial electronic mail message (as defined in the U.S. "CAN-SPAM Act of 2003") that does not meet the message transmission requirements of that act; or (2) assist in the origination of such messages through the provision or selection of addresses to which the messages will be transmitted.</p>
					<p><strong>Notice Regarding Trademarks.</strong></p>
					<p>All trademarks, service marks, and trade names used in the Site (including without limitation: the SLC, the SLC and the associated designs and logos) (collectively "Marks") are owned by (1) the SLC or (2) their respective trademark owners, and are either trademarks or registered trademarks of the SLC, its affiliates, partners or licensors. You may not use, copy, reproduce, republish, upload, post, transmit, distribute, or modify the Marks in any way, including in advertising or publicity pertaining to distribution of materials on this Site, without the SLC's prior written consent. The use of the Marks on any other website or networked computer environment is not allowed. You may not use the Marks as a "hot" link on or to any other website unless establishment of such a link is approved in advance.</p>
					<p><strong>Notice Regarding Copyright ownership: </strong></p>
					<p>Copyright 2012 Shared Learning Collaborative, LLC and/or its affiliates and suppliers. All rights reserved. </p>
					<p><strong>Notice Regarding Copyright Agent</strong></p>
					<p>The SLC respects the intellectual property rights of others and requests that Site users do the same. Anyone who believes that their work has been infringed under copyright law may provide a notice to the designated Copyright Agent for the Site containing the following:</p>
					<ul>
						<li>An electronic or physical signature of a person authorized to act on behalf of the owner of the copyright interest; </li>
						<li>Identification of the copyrighted work claimed to have been infringed; </li>
						<li>Identification of the material that is claimed to be infringing and information reasonably sufficient to permit the SLC to locate the material; </li>
						<li>The address, telephone number, and, if available, an e-mail address at which the complaining party may be contacted; </li>
						<li>A representation that the complaining party has a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law; and</li>
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
					<p><strong>Notice of Availability of Filtering Software</strong></p>
					<p> We do not believe that the Site contains materials that would typically be the subject of filtering software and minors are not authorized to visit our Site. Nevertheless, all users are hereby informed that parental control protections (such as computer hardware, software, or filtering services) are commercially available that may assist in limiting access to material that is harmful to minors. A report detailing some of those protections can be found at Children's Internet Protection Act: Report on the Effectiveness of Internet Protection Measures and Safety Policies. </p>
					<br>
					<br>
					<br>
					<p><strong>Supplemental Terms of Use for Access to SLI Portal Site for Super Administrators</strong></p>
					<p><strong>Introduction:</strong> These Terms of Use apply to individuals who have been designated as Super Administrators by their School District or State Education Agency.  The Super Administrator portion of the Site is for use only by Authorized Users who have been authorized by a School District or State Educational Agency to function as administrators for such institution for the SLI Service ("<strong>Super Administrators</strong>") in accordance with the SLI Service Agreement entered into between your School District or State Educational Agency and the SLC.</p>
					<p>By using the Super Administrator portion of the Site, you represent and warrant that you have the authority to function as a Super Administrator and perform the responsibilities and obligations described in the SLI Service Agreement by and on behalf of a School District participating in the SLI Pilot.</p>
					<p><strong>Incorporated Terms:</strong> Your use of the Site is governed by this agreement and includes all of the provisions of the Terms of Use for Access to the Portal Site, as amended from time to time. </p>
					<p><strong>Security:</strong> You agree to adhere to commercially reasonable security practices relevant to your interaction with the SLI Service. You agree to use commercially reasonable efforts to notify the SLC in writing no more than twenty-four (24) hours after your detection of a security breach or privacy violations related to data provided through the SLI Service. </p>
				</li>
			</ol>
			</br>
			</br>
			<p>These Terms were last updated and posted on December 12, 2012.</p>
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
