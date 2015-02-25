<%@include file="/html/init.jsp" %>

<portlet:actionURL name="saveProfile" var="saveProfileURL"/>

<aui:form method="post" name="fm" action="<%= saveProfileURL %>">

	<aui:input autocomplete="off" label="current-password" name="password0" size="30" type="password" />

	<aui:input autocomplete="off" label="new-password" name="password1" size="30" type="password" />

	<aui:input autocomplete="off" label="enter-again" name="password2" size="30" type="password">
		<aui:validator name="equalTo">
			'#<portlet:namespace />password1'
		</aui:validator>
	</aui:input>
	
	<aui:button-row>
		<aui:button type="submit"/>
	</aui:button-row>
</aui:form>