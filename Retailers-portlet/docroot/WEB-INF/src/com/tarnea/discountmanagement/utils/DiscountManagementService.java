package com.tarnea.discountmanagement.utils;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SERVICE_SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTNAME;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_UOMLIMITKEY;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_RETAIL_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_VALUE_ROLETYPEID_BILL_FROM_VENDOR;

import org.codehaus.jettison.json.JSONObject;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;

public class DiscountManagementService {

	/**
	 * Party details
	 * @param partyId
	 * @return
	 */

	public static String getPartyDetailAsObject(String partyId) {
		String result = "";
		Client client=RestClient.getClient();
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_RETAIL_PARTYID + partyId + "&";
		}else{
			partyId ="";
		}
		
		String serviceUrl = TarneaCommon.getServiceHost() + "partyportal/customermasterdetail?" + partyId;
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
	 * Product List As Object
	 * @param prdName
	 * @param limit
	 * @param partyId
	 * @param roleTypeId
	 * @return
	 */
	
	public static String getProductListAsObject(String prdName, String limit,String partyId,String roleTypeId) {

		String result = "";
		Client client = RestClient.getClient();
		if (prdName != null && !"".equalsIgnoreCase(prdName)) {
			prdName = SEARCH_STRING_PRODUCTNAME + prdName + "&";
		} else {
			prdName = "";
		}

		if (limit != null && !"".equalsIgnoreCase(limit)) {
			limit = SEARCH_STRING_UOMLIMITKEY + limit + "&";
		} else {
			limit = "";
		}

		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_PARTYID + partyId + "&";
		}else{
			partyId ="";
		}

		if(roleTypeId != null && !"".equalsIgnoreCase(roleTypeId)){
			roleTypeId = SEARCH_STRING_ROLETYPEID + SEARCH_VALUE_ROLETYPEID_BILL_FROM_VENDOR + "&";
		}else{
			roleTypeId = "";
		}

		String serviceUrl = TarneaCommon.getServiceHost() + "productportal/productlist?" + prdName + limit + partyId + roleTypeId;
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
	 * Product Detail As Object
	 * @param productId
	 * @param partyId
	 * @return
	 */
	public static String getProductDetailAsObject(String productId,String partyId) {
		//https://localhost:8443/restcomponent/productportal/poproductdetail?targetPartyId=1000000019502&productId=1000000153729
		String result = "";
		Client client = RestClient.getClient();
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_PARTYID + partyId + "&";
		}else{
			partyId = "";
		}
		
		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId + "&";
		}else{
			productId = "";
		}
		String serviceUrl = TarneaCommon.getServiceHost() + "productportal/poproductdetail?" +  partyId+ productId;
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
	 * Product Discount As Object
	 * @param productId
	 * @param partyId
	 * @return
	 */
	public static String getProductDiscountAsObject(String productId,String partyId) {
		//https://sportal.tarnea.com:8443/restcomponent/productportal/getProductDiscount?partyId=1000000019502&productId=1000000153730
		String result = "";
		Client client = RestClient.getClient();
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SERVICE_SEARCH_STRING_PARTYID + partyId + "&";
		}else{
			partyId = "";
		}
		
		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId + "&";
		}else{
			productId = "";
		}
		String serviceUrl = TarneaCommon.getServiceHost() + "productportal/getProductDiscount?" +  partyId+ productId;
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
	 * Remove Product Discount
	 * @param Product Details
	 * @return
	 */

	public static String postProductDiscountRemoveAsObject(String productId,String partyId){
		//https://sportal.tarnea.com:8443/restcomponent/productportal/deleteProductDiscount?partyId=1000000019502&productId=1000000153730
		String result="";
		Client client = RestClient.getClientToPost();
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SERVICE_SEARCH_STRING_PARTYID + partyId + "&";
		}else{
			partyId = "";
		}
		
		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId + "&";
		}else{
			productId = "";
		}
		WebResource webResource = client.resource(TarneaCommon.getServiceHost()+ "productportal/deleteProductDiscount?"+partyId+productId);
		_log.info("Service URL :: "+webResource.toString());
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Remove Product Discount
	 * @param Product Details
	 * @return
	 */

	public static String postProductDiscountCreateAsObject(String prodJson){
		//https://sportal.tarnea.com:8443/restcomponent/productportal/deleteProductDiscount?partyId=1000000019502&productId=1000000153730
		String result="";
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(TarneaCommon.getServiceHost()+ "portalpost/setDiscount");
		_log.info("Service Value :: "+prodJson);
		_log.info("Service URL :: "+webResource.toString());
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class,prodJson);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	
	/**
	 * Server Date and Time
	 */
	/*public static String getServerDateAndTime() {
		String result = "";
		Client client = RestClient.getClient();
		String serviceUrl = TarneaCommon.getServiceHost() + "lookupportal/getServerTime";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		StringBuilder object = response.getEntity(StringBuilder.class);
		return object.toString();
	}*/

	private static Log _log=LogFactoryUtil.getLog(DiscountManagementService.class);
}