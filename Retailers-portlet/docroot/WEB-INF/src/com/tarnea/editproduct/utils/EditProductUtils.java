package com.tarnea.editproduct.utils;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_RETAIL_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_VALUE_SUPPLIER;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;
import static com.tarnea.common.PortalConstant.SERVICE_SEARCH_STRING_PARTYID;

import org.codehaus.jettison.json.JSONObject;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;

public class EditProductUtils {
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
		_log.info("Service Url ::"+serviceUrl);
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
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
			targetPartyId = SERVICE_SEARCH_STRING_PARTYID + targetPartyId + "&";
		} else {
			targetPartyId = "";
		}

		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId;
		} else {
			productId = "";
		}

		String serviceUrl = getServiceHost() + "product/productdetail?" + targetPartyId + productId;
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
	
	
	
		public static String getUOMObject(String targetPartyId) {
	
		String result = "";
		Client client = RestClient.getClient();
		String serviceUrl = getServiceHost() + "lookupportal/uomlist";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Srvice Url :: "+serviceUrl);
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
	
	/**
	 * Remove Product 
	 * @param productId
	 * @param targetPartyId
	 * @return
	 */
	public static String getRemoveProduct(String productId, String targetPartyId, String roleType) {	
		
		String result = "";
		Client client = RestClient.getClient();

		if(targetPartyId == null || "".equalsIgnoreCase(targetPartyId)) {
			targetPartyId = "";
		}
		
		if(targetPartyId != null && !"".equalsIgnoreCase(targetPartyId)){
			targetPartyId = SERVICE_SEARCH_STRING_PARTYID + targetPartyId + "&";
		} else {
			targetPartyId = "";
		}

		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId + "&";
		} else {
			productId = "";
		}
		String roleTypeId = SEARCH_STRING_ROLETYPEID+roleType; 
		String serviceUrl = getServiceHost() + "productportal/removeproductpartyrelation?" + targetPartyId + productId + roleTypeId;
		_log.info("PostNew  Product :: "+serviceUrl);
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Empty Inventory 
	 * @param productId
	 * @param targetPartyId
	 * @return
	 */
	public static String postEmptyInventory(String productList) {
		
		String result = "";
		
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(getServiceHost()
				+ "portalpost/createstockadjustment");
		_log.info("Post empty Inventory :: "+webResource);
		ClientResponse response = webResource.accept("application/json").post(
				ClientResponse.class, productList);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Add Product 
	 * @param productId
	 * @param targetPartyId
	 * @return
	 */
	public static String postNewProduct(String productList) {	
		
		String result = "";
		
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(getServiceHost()+ "productportal/editProduct");
		_log.info("PostNew  Product :: "+webResource);
		ClientResponse response = webResource.accept("application/json").post(
				ClientResponse.class, productList);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	private static Log _log=LogFactoryUtil.getLog(EditProductUtils.class);
}