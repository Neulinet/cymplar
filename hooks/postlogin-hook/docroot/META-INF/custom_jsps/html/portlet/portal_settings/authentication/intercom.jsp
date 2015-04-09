<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
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

<%@ include file="/html/portlet/portal_settings/init.jsp" %>

<%
boolean intercomEnabled = PrefsPropsUtil.getBoolean(company.getCompanyId(), "intercom-enabled", false);
String intercomAppId = PrefsPropsUtil.getString(company.getCompanyId(), "intercom-app-id");
String intercomApiKey = PrefsPropsUtil.getString(company.getCompanyId(), "intercom-api-key");
%>

<aui:fieldset>
	<aui:input label="enabled" name='<%= "settings--intercom-enabled--" %>' type="checkbox" value="<%= intercomEnabled %>" />

	<aui:input label="intercom-app-id" name='<%= "settings--intercom-app-id--" %>' type="text" value="<%= intercomAppId %>" wrapperCssClass="lfr-input-text-container" />
	
	<aui:input label="intercom-api-key" name='<%= "settings--intercom-api-key--" %>' type="text" value="<%= intercomApiKey %>" wrapperCssClass="lfr-input-text-container" />
</aui:fieldset>