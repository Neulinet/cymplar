package ru.emdev.cymplar.event;

import io.intercom.api.Intercom;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.PrefsPropsUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;



public class PostLoginAction extends Action {
	public static final String GROUP_MEMBERS = "Members";

	@Override
	public void run(HttpServletRequest request, HttpServletResponse response) throws ActionException {

		try {
			doRun(request, response);
		} catch (Exception e) {
			throw new ActionException(e);
		}
	}

	protected void doRun(HttpServletRequest request, HttpServletResponse response) throws Exception {

        long companyId = PortalUtil.getCompanyId(request);
        long userId = PortalUtil.getUserId(request);

		try {
			User user = UserLocalServiceUtil.getUser(userId);
			
			
			try {
				boolean intercomEnabled = PrefsPropsUtil.getBoolean(companyId, "intercom-enabled", false);
				String intercomAppId = PrefsPropsUtil.getString(companyId, "intercom-app-id");
				String intercomApiKey = PrefsPropsUtil.getString(companyId, "intercom-api-key");

				if (intercomEnabled && 
						intercomAppId != null && !intercomAppId.isEmpty() &&
						intercomApiKey != null && !intercomApiKey.isEmpty()) {
					Date now = new Date();
					
					// initialize intercom
					Intercom.setAppID(intercomAppId);
					Intercom.setApiKey(intercomApiKey);
					
					// initialize user
					io.intercom.api.User intercomUser = new io.intercom.api.User();
					intercomUser.setEmail(user.getEmailAddress());
					intercomUser.setName(user.getFullName());
					intercomUser.setLastSeenIp(user.getLastLoginIP());
					intercomUser.setSignedUpAt(user.getCreateDate().getTime());
					intercomUser.setLastRequestAt(now.getTime());
					
					io.intercom.api.User.create(intercomUser);
					
					_log.debug("Sent notification to intercom");
				}
			} catch (Exception ex) {
				_log.error("Cannot register user in intercom", ex);
			}
			
			List<UserGroup> userGroups = UserGroupLocalServiceUtil
					.getUserUserGroups(userId);
			UserGroup membersGroup = null;

			for (UserGroup group : userGroups) {
				if (group.getName().equals(GROUP_MEMBERS)) 	{
					membersGroup = group;
					break;
				}
			}

			if (membersGroup != null) {
				String redirectUrl = "/group/" + user.getScreenName() + "/~/"
						+ membersGroup.getUserGroupId()
						+ "/my-dashboard";
				_log.debug("Redirect user " + userId + " to Dashboard "
						+ redirectUrl);
				response.sendRedirect(redirectUrl);
			}
		} catch (Exception ex) {
			_log.warn("Cannot redirect user: " + ex.getMessage());
		}
    }

	private static Log _log = LogFactoryUtil.getLog(PostLoginAction.class);
}
