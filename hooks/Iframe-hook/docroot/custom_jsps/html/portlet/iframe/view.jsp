<%--
/**  6.0000
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

<%@ include file="/html/portlet/iframe/init.jsp" %>
<%
 
String iframeSrc = StringPool.BLANK;

if (relative) {
	iframeSrc = themeDisplay.getPathContext();
}

iframeSrc += (String)request.getAttribute(WebKeys.IFRAME_SRC);

if (Validator.isNotNull(iframeVariables)) {
	if (iframeSrc.indexOf(StringPool.QUESTION) != -1) {
		iframeSrc = iframeSrc.concat(StringPool.AMPERSAND).concat(StringUtil.merge(iframeVariables, StringPool.AMPERSAND));
	}
	else {
		iframeSrc = iframeSrc.concat(StringPool.QUESTION).concat(StringUtil.merge(iframeVariables, StringPool.AMPERSAND));
	}
}
%>
<script type="text/javascript">

 var hash1 = document.location.hash;

if(hash1 == ''){
	var errorPage = '/portal/web/guest/error';
	window.location = errorPage;
} 

</script>
<%

iframeSrc = (String)session.getAttribute("iframeSrc"); 

if(Validator.isNull(iframeSrc)){%>
<script type="text/javascript">
var error = '/portal/web/guest/error';
window.location = error;
</script>
<%}

String iframeHeight = heightNormal;

if (windowState.equals(WindowState.MAXIMIZED)) {
	iframeHeight = heightMaximized;
}
%>

	<div>
		<iframe alt="<%= alt %>" border="<%= border %>" bordercolor="<%= bordercolor %>" frameborder="<%= frameborder %>" height="<%= iframeHeight %>" hspace="<%= hspace %>" id="<portlet:namespace />iframe" longdesc="<%= longdesc%>" name="<portlet:namespace />iframe" onload="<%= resizeAutomatically ?  renderResponse.getNamespace() + "resizeIframe();" : StringPool.BLANK %>" scrolling="<%= scrolling %>" src="<%= iframeSrc %>" vspace="<%= vspace %>" width="<%= width %>">
				<%= LanguageUtil.format(pageContext, "your-browser-does-not-support-inline-frames-or-is-currently-configured-not-to-display-inline-frames.-content-can-be-viewed-at-actual-source-page-x", iframeSrc) %>
			</iframe>
	</div>
<aui:script>
	function <portlet:namespace />maximizeIframe(iframe) {
		var winHeight = 0;

		if (typeof(window.innerWidth) == 'number') {

			// Non-IE

			winHeight = window.innerHeight;
		}
		else if ((document.documentElement) &&
				 (document.documentElement.clientWidth || document.documentElement.clientHeight)) {

			// IE 6+

			winHeight = document.documentElement.clientHeight;
		}
		else if ((document.body) &&
				 (document.body.clientWidth || document.body.clientHeight)) {

			// IE 4 compatible

			winHeight = document.body.clientHeight;
		}

		// The value 139 here is derived (tab_height * num_tab_levels) +
		// height_of_banner + bottom_spacer. 139 just happend to work in
		// this instance in IE and Firefox at the time.

		iframe.height = (winHeight - 139);
	}


	function <portlet:namespace />resizeIframe() {
		var iframe = document.getElementById('<portlet:namespace />iframe');

		var height = null;

		try {
			height = iframe.contentWindow.document.body.scrollHeight;
		}
		catch (e) {
			if (themeDisplay.isStateMaximized()) {
				<portlet:namespace />maximizeIframe(iframe);
			}
			else {
				iframe.height = <%= heightNormal %>;
			}

			return true;
		}

		iframe.height = height + 50;

		return true;
	}
</aui:script>