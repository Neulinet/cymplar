<%@include file="/html/init.jsp" %>

<%@page import="com.liferay.portal.UserPasswordException"%>
<%@page import="com.liferay.portal.service.PasswordPolicyLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.PasswordPolicy"%>


<%
User selUser = themeDisplay.getUser();

Contact selContact = null;

if (selUser != null) {
	selContact = selUser.getContact();
}

PasswordPolicy passwordPolicy = null;

if (selUser == null) {
	passwordPolicy = PasswordPolicyLocalServiceUtil.getDefaultPasswordPolicy(company.getCompanyId());
}
else {
	passwordPolicy = selUser.getPasswordPolicy();
}



%>
<portlet:actionURL name="saveProfile" var="saveProfileURL"/>

<aui:form method="post" name="fm" action="<%= saveProfileURL %>">

	<liferay-ui:error-marker key="errorSection" value="password" />
	
	
<liferay-ui:error exception="<%= UserPasswordException.class %>">

	<%
	UserPasswordException upe = (UserPasswordException)errorException;
	%>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_ALREADY_USED %>">
		<liferay-ui:message key="that-password-has-already-been-used-please-enter-in-a-different-password" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_CONTAINS_TRIVIAL_WORDS %>">
		<liferay-ui:message key="that-password-uses-common-words-please-enter-in-a-password-that-is-harder-to-guess-i-e-contains-a-mix-of-numbers-and-letters" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_INVALID %>">
		<liferay-ui:message key="that-password-is-invalid-please-enter-in-a-different-password" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_LENGTH %>">

		<%
		int passwordPolicyMinLength = Integer.valueOf(PropsUtil.get(PropsKeys.PASSWORDS_DEFAULT_POLICY_MIN_LENGTH));

		if (passwordPolicy != null) {
			passwordPolicyMinLength = passwordPolicy.getMinLength();
		}
		%>

		<%= LanguageUtil.format(pageContext, "that-password-is-too-short-or-too-long-please-make-sure-your-password-is-between-x-and-512-characters", String.valueOf(passwordPolicyMinLength), false) %>
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_NOT_CHANGEABLE %>">
		<liferay-ui:message key="your-password-cannot-be-changed" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_SAME_AS_CURRENT %>">
		<liferay-ui:message key="your-new-password-cannot-be-the-same-as-your-old-password-please-enter-in-a-different-password" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_TOO_TRIVIAL %>">
		<liferay-ui:message key="that-password-is-too-trivial" />
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORD_TOO_YOUNG %>">

		<%
		long passwordPolicyMinAge = Long.valueOf(PropsUtil.get(PropsKeys.PASSWORDS_DEFAULT_POLICY_MIN_AGE));

		if (passwordPolicy != null) {
			passwordPolicyMinAge = passwordPolicy.getMinAge();
		}
		%>

		<%= LanguageUtil.format(pageContext, "you-cannot-change-your-password-yet-please-wait-at-least-x-before-changing-your-password-again", LanguageUtil.getTimeDescription(pageContext, passwordPolicyMinAge * 1000), false) %>
	</c:if>

	<c:if test="<%= upe.getType() == UserPasswordException.PASSWORDS_DO_NOT_MATCH %>">
		<liferay-ui:message key="the-passwords-you-entered-do-not-match-each-other-please-re-enter-your-password" />
	</c:if>
</liferay-ui:error>
	<aui:model-context bean="<%= selUser %>" model="<%= User.class %>" />
	
	<aui:input autocomplete="off" label="current-password" name="password0" size="30" type="password" />

	<aui:input autocomplete="off" label="new-password" name="password1" size="30" type="password" />

	<aui:input autocomplete="off" label="enter-again" name="password2" size="30" type="password">
		<aui:validator name="equalTo">
			'#<portlet:namespace />password1'
		</aui:validator>
	</aui:input>
	
	
	<aui:input name="jobTitle" />
	
	<aui:button-row>
		<aui:button type="submit"/>
	</aui:button-row>
</aui:form>