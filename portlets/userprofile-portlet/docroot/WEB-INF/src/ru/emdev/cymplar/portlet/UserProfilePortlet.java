package ru.emdev.cymplar.portlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.servlet.http.HttpServletRequest;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet to render and process user profile portlet actions
 * 
 * @author akakunin
 *
 */
public class UserProfilePortlet extends MVCPortlet {
	private static Log log = LogFactoryUtil.getLog(UserProfilePortlet.class);

	/**
	 * Action to save changes in profile
	 * 
	 * @param request
	 * @param response
	 * @throws SystemException
	 * @throws PortalException
	 * @throws IOException
	 */
	public void saveProfile(ActionRequest request, ActionResponse response)
			throws SystemException, PortalException, IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request
				.getAttribute(WebKeys.THEME_DISPLAY);
		User user = themeDisplay.getUser();

		
		// TODO Verify how Liferay checks old password in standard portlet
		String oldPassword = getUpdateUserPassword(request, user.getUserId());
		String newPassword1 = ParamUtil.getString(request, "password1");
		String newPassword2 = ParamUtil.getString(request, "password2");

		if (Validator.isNotNull(newPassword1) ||
				Validator.isNotNull(newPassword2)) {
			log.info("Attempt to change password for user " + user.getScreenName() + "(" + user.getUserId() + ")");
			
				user = UserLocalServiceUtil.updatePassword(user.getUserId(), newPassword1, newPassword2, false);
			}
	}

	/**
	 * Private util function copied from AdminUtil class from portal-impl
	 * 
	 * @param actionRequest
	 * @param userId
	 * @return
	 */
	private String getUpdateUserPassword(ActionRequest actionRequest,
			long userId) {

		HttpServletRequest request = PortalUtil
				.getHttpServletRequest(actionRequest);

		return getUpdateUserPassword(request, userId);
	}

	/**
	 * Private util function copied from AdminUtil class from portal-impl
	 * 
	 * @param actionRequest
	 * @param userId
	 * @return
	 */
	private String getUpdateUserPassword(HttpServletRequest request, long userId) {

		String password = PortalUtil.getUserPassword(request);

		if (userId != PortalUtil.getUserId(request)) {
			password = StringPool.BLANK;
		}

		if (password == null) {
			password = StringPool.BLANK;
		}

		return password;
	}

}
