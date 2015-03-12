package com.tarnea.supplier.utils;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_RETAIL_PARTYID;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.List;

import javax.portlet.RenderRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jettison.json.JSONObject;

import com.liferay.portal.model.Organization;
import com.liferay.portal.service.OrganizationServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;

public class SupplierMappingUtils {
	public static String getServiceHost() {
		return SERVICE_HOST;
	}
	
	/**
	 * Getting States List
	 * @return
	 */
	public static String getStatesListAsObject() {

		String result = "";
		Client client = RestClient.getClient();
		String serviceUrl = getServiceHost() + "partyportal/getStateList";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Getting CustmerDetails
	 * @param partyId
	 * @return
	 */
	public static String getJsonForCustomerDetailsAsObject(String partyId) {

		String result = "";
		Client client = RestClient.getClient();
		if (partyId != null && !"".equalsIgnoreCase(partyId)) {

			partyId = SEARCH_STRING_RETAIL_PARTYID + partyId + "&";
		} else {
			partyId = "";
		}

		String serviceUrl = getServiceHost() + "partyportal/customermasterdetail?" + partyId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	
	/**
	 * Creating New Manufacturer
	 * @param Manufacturer Details
	 * @return
	 */
	public static String jsonForAddManufacturer(String resultJson) {
		String result = "";
			Client client = RestClient.getClientToPost();
			WebResource webResource = client.resource(getServiceHost()+ "portalpost/createpartymaster");
			_log.info("Service URL :: "+webResource.toString());
			ClientResponse response = webResource.accept("application/json").post(
					ClientResponse.class, resultJson);
			client.addFilter(new GZIPContentEncodingFilter(false));
			JSONObject object = response.getEntity(JSONObject.class);
			result = object.toString();
			return result;
		}
	private static Log _log = LogFactory.getLog(SupplierMappingUtils.class);
}