package ru.emdev.cymplar.events;

import javax.portlet.PortletRequest;
import javax.portlet.WindowState;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Portlet;
import com.liferay.portal.service.LayoutLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;

/** Custom ServicePreAction  - required only to fir a bug with displaying custom profile portlet in 6.2.1
 * Not required for 6.2.2 or later versions
 * 
 * @author akakunin
 *
 */
public class ServicePreAction extends Action {
	private static Log _log = LogFactoryUtil.getLog(ServicePreAction.class);

	@Override
	public void run(HttpServletRequest request, HttpServletResponse response)
			throws ActionException {
		try {
			ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
			Portlet myAccountPortlet = PortalUtil.getFirstMyAccountPortlet(themeDisplay);
		
			if (myAccountPortlet != null) {
				long controlPanelPlid = PortalUtil.getControlPanelPlid(themeDisplay.getCompanyId());
				long scopeGroupId = PortalUtil.getScopeGroupId(request);
				
				long refererPlid = ParamUtil.getLong(request, "refererPlid");
	
				if (LayoutLocalServiceUtil.fetchLayout(refererPlid) == null) {
					refererPlid = 0;
				}
				long plid = ParamUtil.getLong(request, "p_l_id");
				
				
				LiferayPortletURL myAccountURL = PortletURLFactoryUtil.create(request,  myAccountPortlet.getPortletId(), controlPanelPlid, PortletRequest.RENDER_PHASE);
		
				if (scopeGroupId > 0) {
					myAccountURL.setDoAsGroupId(scopeGroupId);
				}
		
				if (refererPlid > 0) {
					myAccountURL.setRefererPlid(refererPlid);
				}
				else {
					myAccountURL.setRefererPlid(plid);
				}
		
				myAccountURL.setWindowState(WindowState.MAXIMIZED);
		
				themeDisplay.setURLMyAccount(myAccountURL);
			}
		} catch (Exception ex) {
			_log.warn("Cannot fix my account url", ex);
		}

	}
}
