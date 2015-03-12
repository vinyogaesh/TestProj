package com.tarnea.stockadjustment.utils;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_VALUE_SUPPLIER;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import javax.portlet.PortletRequest;

import org.codehaus.jettison.json.JSONObject;

import com.google.gson.Gson;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.model.Organization;
import com.liferay.portal.service.OrganizationServiceUtil;
import com.liferay.portal.util.PortalUtil;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.stockadjustment.model.CartItem;
import com.tarnea.stockadjustment.model.JsonResult;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;

public class StockAdjustmentUtils {
	
	public static String getServiceHost() {
		return SERVICE_HOST;
	}
	
	/**
	 * Getting Product List
	 * @param partyId
	 * @return
	 */
	public static String getProductListAsObject(String partyId) {	
		
		String result = "";
		Client client = RestClient.getClient();
		String roleTypeId = SEARCH_VALUE_SUPPLIER;
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_PARTYID + partyId + "&";
		} else {
			partyId = "";
		}

		if(roleTypeId != null && !"".equalsIgnoreCase(roleTypeId)) { 
			roleTypeId = SEARCH_STRING_ROLETYPEID + roleTypeId;
		} else {
			roleTypeId = "";
		}

		String serviceUrl = getServiceHost() + "productportal/productlist?" + partyId + roleTypeId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service Url :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	

	/**
	 * Getting Product Details 
	 * @param productId
	 * @param targetPartyId
	 * @return
	 */
	public static String getProductDetailAsObject(String productId, String targetPartyId) {	
		
		String result = "";
		Client client = RestClient.getClient();
		if(targetPartyId != null && !"".equalsIgnoreCase(targetPartyId)){
			targetPartyId = SEARCH_STRING_PARTYID + targetPartyId + "&";
		} else {
			targetPartyId = "";
		}

		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId;
		} else {
			productId = "";
		}

		String serviceUrl = getServiceHost() + "productportal/poproductdetail?" + targetPartyId + productId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service Url :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	public static String getBatchListAsObject(String productId, String partyId) {
		String result = "";
		Client client = RestClient.getClient();
		if (partyId != null && !"".equalsIgnoreCase(partyId)) {
			partyId = SEARCH_STRING_PARTYID + partyId;
		}
		if (productId != null && !"".equalsIgnoreCase(productId)) {
			productId = SEARCH_STRING_PRODUCTID + productId;
		}
		String serviceUrl = getServiceHost() + "productportal/batchavailability?" + partyId + "&" + productId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service Url :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	public static String getReasonListAsObject() {

		String result = "";
		Client client = RestClient.getClient();
		String serviceUrl = getServiceHost() + "lookupportal/stockvariancereasonlist?";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service Url :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
		
	/**
	 * Construct the order Cart Items to Purchase Used in create order screen to
	 * purchase order screen
	 * 
	 * @param distributorPartyId
	 * @param jsonCartItems
	 * @return String
	 */
	public static String getCreateOrderCartItemsToPurchase(String distributorPartyId, String jsonCartItems) {
		String result = "";

		LinkedHashMap<String, Object> orderHeaderMap = new LinkedHashMap<String, Object>();

		if (TarneaCommon.isValidValue(distributorPartyId)) {
			orderHeaderMap.put("stockAdjustmentDetails",getCartItems(jsonCartItems));
			Gson gson = new Gson();
			result = gson.toJson(orderHeaderMap);
			_log.info("after converting to JSON :: "+result);
		}
		return result;
	}
	
	/**
	 * Construct the Json String of Item created in order as List of CartItem
	 * 
	 * @param jsonCartItems
	 * @return List of CartItem
	 */
	public static List<CartItem> getCartItems(String jsonCartItems) {
		List<CartItem> items = null;
		if (TarneaCommon.isValidValue(jsonCartItems)) {
			items = new ArrayList<CartItem>();

			Gson gson = new Gson();
			items = gson.fromJson(jsonCartItems, ArrayList.class);
		}

		return items;
	}
	
	public static JsonResult postStockAdj(String resultJson) {
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(getServiceHost()+ "portalpost/createstockadjustment");
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class, resultJson);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		Gson result = new Gson();
        JsonResult json = result.fromJson(object.toString(), JsonResult.class);
        _log.info("Json Value After Post :: " + json.toString());
		return json;
	}
	
	public static Log _log=LogFactoryUtil.getLog(StockAdjustmentUtils.class);
}