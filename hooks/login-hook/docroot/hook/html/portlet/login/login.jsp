<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
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
--%>

<%@ include file="/html/portlet/login/init.jsp" %>

<c:choose>
	<c:when test="<%= themeDisplay.isSignedIn() %>">

		<%
		String signedInAs = HtmlUtil.escape(user.getFullName());

		if (themeDisplay.isShowMyAccountIcon() && (themeDisplay.getURLMyAccount() != null)) {
			String myAccountURL = String.valueOf(themeDisplay.getURLMyAccount());

			if (PropsValues.DOCKBAR_ADMINISTRATIVE_LINKS_SHOW_IN_POP_UP) {
				signedInAs = "<a href=\"javascript:Liferay.Util.openWindow({dialog: {destroyOnHide: true}, title: '" + LanguageUtil.get(pageContext, "my-account") + "', uri: '" + HtmlUtil.escape(myAccountURL) + "'});\">" + signedInAs + "</a>";
			}
			else {
				myAccountURL = HttpUtil.setParameter(myAccountURL, "controlPanelCategory", PortletCategoryKeys.MY);

				signedInAs = "<a href=\"" + HtmlUtil.escape(myAccountURL) + "\">" + signedInAs + "</a>";
			}
		}
		%>

		<%= LanguageUtil.format(pageContext, "you-are-signed-in-as-x", signedInAs, false) %>
	</c:when>
	<c:otherwise>

		<%
		String redirect = ParamUtil.getString(request, "redirect");

		String login = LoginUtil.getLogin(request, "login", company);
		String password = StringPool.BLANK;
		boolean rememberMe = ParamUtil.getBoolean(request, "rememberMe");

		if (Validator.isNull(authType)) {
			authType = company.getAuthType();
		}
		%>

		<portlet:renderURL var="loginRedirectURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
			<portlet:param name="struts_action" value="/login/login_redirect"/>
		</portlet:renderURL>

		<portlet:actionURL secure="<%= PropsValues.COMPANY_SECURITY_AUTH_REQUIRES_HTTPS || request.isSecure() %>"
						   var="loginURL">
			<portlet:param name="struts_action" value="/login/login"/>
		</portlet:actionURL>

		<portlet:renderURL var="forgotPasswordURL">
			<portlet:param name="struts_action" value="/login/forgot_password"/>
		</portlet:renderURL>

		<%
			String facebookAuthRedirectURL = FacebookConnectUtil.getRedirectURL(themeDisplay.getCompanyId());

			facebookAuthRedirectURL = HttpUtil.addParameter(facebookAuthRedirectURL, "redirect", HttpUtil.encodeURL(loginRedirectURL.toString()));

			String facebookAuthURL = FacebookConnectUtil.getAuthURL(themeDisplay.getCompanyId());

			facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "client_id", FacebookConnectUtil.getAppId(themeDisplay.getCompanyId()));
			facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "redirect_uri", facebookAuthRedirectURL);
			facebookAuthURL = HttpUtil.addParameter(facebookAuthURL, "scope", "email");

			String taglibOpenFacebookConnectLoginWindow = "javascript:var facebookConnectLoginWindow = window.open('" + facebookAuthURL.toString() + "', 'facebook', 'align=center,directories=no,height=560,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no,width=1000'); void(''); facebookConnectLoginWindow.focus();";

			String strutsAction = ParamUtil.getString(request, "struts_action");

			boolean showCreateAccountIcon = false;

			if (!strutsAction.equals("/login/create_account") && company.isStrangers() && !portletName.equals(PortletKeys.FAST_LOGIN)) {
				showCreateAccountIcon = true;
			}

			String registerURL = PortalUtil.getCreateAccountURL(request, themeDisplay);
		%>
		<c:set value="" var="hide"/>
		<c:set value="" var="show"/>
		<c:if test='<%= SessionMessages.contains(request, "userAdded") %>'>
			<c:set value="display:none;" var="hide"/>
			<c:set value="display:block;" var="show"/>
		</c:if>
		<div id="<portlet:namespace/>login-container">
			<!-- Login Buttons -->
			<div id="<portlet:namespace/>login-buttons" style="${hide}">
				<h5 class="page-header-sub"><liferay-ui:message key="login-title" /></h5>
				<a href="<%= taglibOpenFacebookConnectLoginWindow %>" id="<portlet:namespace/>login-btn-facebook" class="btn btn-primary">
					<i class="fa fa-facebook"></i> <liferay-ui:message key="facebook-button-title" />
				</a>

				<a id="<portlet:namespace/>login-btn-email" href="javascript:void(0);" class="btn btn-default"><liferay-ui:message key="email-button-title" /> <i class="fa fa-envelope"></i></a>
			
				<h5 class="page-header-sub">Don't have account yet?</h5>
				<c:if test="<%= showCreateAccountIcon %>">
					<a id="<portlet:namespace/>login-btn-register" class="btn btn-info" href="<%= registerURL %>">
						<liferay-ui:message key="registration-button-title" />
					</a>
				</c:if>
			</div>

			<!-- END Login Buttons -->

			<!-- Login Form -->
			<aui:form action="<%= loginURL %>"
					  style="${show}"
					  autocomplete='<%= PropsValues.COMPANY_SECURITY_LOGIN_FORM_AUTOCOMPLETE ? "on" : "off" %>'
					  class="form-horizontal"
					  cssClass="sign-in-form form-horizontal" method="post" name="fm">
				<aui:input name="saveLastPath" type="hidden" value="<%= false %>"/>
				<aui:input name="redirect" type="hidden" value="<%= redirect %>"/>
				<aui:input name="doActionAfterLogin" type="hidden"
						   value="<%= portletName.equals(PortletKeys.FAST_LOGIN) ? true : false %>"/>

				<div class="form-group">
					<a href="javascript:void(0)" class="login-back"><i class="fa fa-arrow-left"></i></a>
				</div>

				<c:choose>
					<c:when test='<%= SessionMessages.contains(request, "userAdded") %>'>

						<%
							String userEmailAddress = (String) SessionMessages.get(request, "userAdded");
							String userPassword = (String) SessionMessages.get(request, "userAddedPassword");
						%>

						<div class="alert alert-success">
							<c:choose>
								<c:when test="<%= company.isStrangersVerify() || Validator.isNull(userPassword) %>">
									<%= LanguageUtil.get(pageContext, "thank-you-for-creating-an-account") %>

									<c:if test="<%= company.isStrangersVerify() %>">
										<%= LanguageUtil.format(pageContext, "your-email-verification-code-has-been-sent-to-x", userEmailAddress) %>
									</c:if>
								</c:when>
								<c:otherwise>
									<%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account.-your-password-is-x", userPassword, false) %>
								</c:otherwise>
							</c:choose>

							<c:if test="<%= PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsKeys.ADMIN_EMAIL_USER_ADDED_ENABLED) %>">
								<%= LanguageUtil.format(pageContext, "your-password-has-been-sent-to-x", userEmailAddress) %>
							</c:if>
						</div>
					</c:when>
					<c:when test='<%= SessionMessages.contains(request, "userPending") %>'>

						<%
							String userEmailAddress = (String) SessionMessages.get(request, "userPending");
						%>

						<div class="alert alert-success">
							<%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account.-you-will-be-notified-via-email-at-x-when-your-account-has-been-approved", userEmailAddress) %>
						</div>
					</c:when>
				</c:choose>

				<liferay-ui:error exception="<%= AuthException.class %>" message="authentication-failed"/>
				<liferay-ui:error exception="<%= CompanyMaxUsersException.class %>"
								  message="unable-to-login-because-the-maximum-number-of-users-has-been-reached"/>
				<liferay-ui:error exception="<%= CookieNotSupportedException.class %>"
								  message="authentication-failed-please-enable-browser-cookies"/>
				<liferay-ui:error exception="<%= NoSuchUserException.class %>" message="authentication-failed"/>
				<liferay-ui:error exception="<%= PasswordExpiredException.class %>"
								  message="your-password-has-expired"/>
				<liferay-ui:error exception="<%= UserEmailAddressException.class %>" message="authentication-failed"/>
				<liferay-ui:error exception="<%= UserLockoutException.class %>" message="this-account-has-been-locked"/>
				<liferay-ui:error exception="<%= UserPasswordException.class %>" message="authentication-failed"/>
				<liferay-ui:error exception="<%= UserScreenNameException.class %>" message="authentication-failed"/>

				<aui:fieldset>

					<%
						String loginLabel = null;

						if (authType.equals(CompanyConstants.AUTH_TYPE_EA)) {
							loginLabel = "email-address";
						} else if (authType.equals(CompanyConstants.AUTH_TYPE_SN)) {
							loginLabel = "screen-name";
						} else if (authType.equals(CompanyConstants.AUTH_TYPE_ID)) {
							loginLabel = "id";
						}
					%>

					<div class="form-group">
							<div class="input-append">
								<div class="display-inline">
									<aui:input
											autoFocus="<%= windowState.equals(LiferayWindowState.EXCLUSIVE) || windowState.equals(WindowState.MAXIMIZED) %>"
											cssClass="clearable" label="" name="login" id="login-email"
											showRequiredLabel="<%= false %>" type="text" value="<%= login %>" placeholder="Email..">
										<aui:validator name="required"/>
									</aui:input>
								</div>
								<span class="add-on" id="envelope"><i class="fa fa-envelope-o fa-fw"></i></span>
							</div>
					</div>

					<div class="form-group">
							<div class="input-append">
								<div class="display-inline">
									<aui:input name="password" showRequiredLabel="<%= false %>" class="form-control" placeholder="Password.."
											   id="login-password" type="password" label="" value="<%= password %>">
										<aui:validator name="required"/>
									</aui:input>
								</div>
								<span class="add-on" id="asterisk"><i class="fa fa-asterisk fa-fw"></i></span>
							</div>
					</div>

					

				</aui:fieldset>

				<div class="clearfix">
					
					<c:if test="<%= company.isAutoLogin() && !PropsValues.SESSION_DISABLED %>">
						<label id="<portlet:namespace/>topt-fixed-header-top" class="switch switch-success pull-left" data-toggle="tooltip" title="Remember me"><aui:input checked="<%= rememberMe %>" name="rememberMe" type="checkbox" label=""/><span></span></label>
					</c:if>
					<div class="btn-group btn-group-sm pull-right">
						<a href="<%= forgotPasswordURL %>" id="<portlet:namespace/>login-button-pass" class="btn btn-warning" data-toggle="tooltip"
								title='<liferay-ui:message key="forgot-password" />'><i class="fa fa-lock"></i></a>
						<aui:button type="submit" id="login" class="btn btn-success" value="Login" />					
					</div>
				</div>
			</aui:form>

		</div>

		<aui:script use="aui-base">
			var password = A.one('#<portlet:namespace />password');

			if (password) {
				password.on(
					'keypress',
					function(event) {
						Liferay.Util.showCapsLock(event, '<portlet:namespace />passwordCapsLockSpan');
					}
				);
			}
		</aui:script>
	</c:otherwise>
</c:choose>