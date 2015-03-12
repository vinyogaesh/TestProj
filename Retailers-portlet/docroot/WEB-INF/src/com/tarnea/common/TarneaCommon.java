package com.tarnea.common;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.List;

import javax.portlet.PortletRequest;
import javax.portlet.RenderRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.liferay.portal.model.Organization;
import com.liferay.portal.service.OrganizationServiceUtil;
import com.liferay.portal.util.PortalUtil;

import static com.tarnea.common.PortalConstant.SERVICE_HOST;

public class TarneaCommon {
	private static Log log = LogFactory.getLog(TarneaCommon.class);
	
	public static String getServiceHost() {
		return SERVICE_HOST;
	}
	/**
	 * Checks value not null and not empty
	 * 
	 * @param objectValue
	 * @return boolean
	 */
	public static boolean isValidValue(Object objectValue) {
		boolean isValid = false;

		if (!"".equals(objectValue) && objectValue != null) {
			isValid = true;
		}

		return isValid;
	}
	/**
	 * Encoding URL
	 * @param URL
	 * @return
	 */
	public static String encodeUrl(String serviceUrl) {
		URL url = null;
		URI uri = null;
		try {
			url = new URL(serviceUrl);
			uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(),
					url.getPort(), url.getPath(), url.getQuery(), url.getRef());
			url = uri.toURL();
		} catch (MalformedURLException e) {
			log.error(e);
		} catch (URISyntaxException e) {
			log.error(e);
		}

		return url.toString();
	}

	/**
	 * Getting TargetpartyId
	 * @param request
	 * @return
	 */
	public static String getTargetPartyId(RenderRequest request){
		String targetPartyId = "";
		long userId = PortalUtil.getUserId(request);
		try
		{
			List orgs = OrganizationServiceUtil.getUserOrganizations(userId);
			Organization org = null;
			if (orgs != null)
			{
				org = (Organization) orgs.get(0);
				targetPartyId = org.getComments();
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		}

		return targetPartyId;
	}
	
	/**
	 * Getting liferay user id
	 * @param request
	 * @return
	 */
	public static long getCurrentUserId(PortletRequest request) {
		long userId = PortalUtil.getUserId(request);
		return userId;
	}
}