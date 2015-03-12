package com.tarnea.productcategory.utils;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_CATEGORYTYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARENTCATEGORYTYPEID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_VALUE_PARENT_CATEGORY_TYPE_ID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_VALUE_SUPPLIER;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;

import org.codehaus.jettison.json.JSONObject;

import com.liferay.portal.kernel.log.*;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;


public class ProductCategoryServiceUtil {

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
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	/**
	 * Getting Category List
	 * @param CategoryTypeId
	 * @return
	 */
	public static String getCategoryListAsObject(String CategoryTypeId) {	
		String result = "";
		Client client = RestClient.getClient();
		String ParentCategoryTypeId;
		ParentCategoryTypeId=SERVICE_PARAMETER_VALUE_PARENT_CATEGORY_TYPE_ID;
		if(CategoryTypeId != null && !"".equalsIgnoreCase(CategoryTypeId)){
			CategoryTypeId = SEARCH_STRING_CATEGORYTYPEID + CategoryTypeId + "&";
		} else {
			CategoryTypeId = "";
		}
		if(ParentCategoryTypeId != null && !"".equalsIgnoreCase(ParentCategoryTypeId)){
			
			ParentCategoryTypeId = SEARCH_STRING_PARENTCATEGORYTYPEID + ParentCategoryTypeId + "&";
		} else {
			ParentCategoryTypeId = "";
		}

		String serviceUrl = getServiceHost() + "productportal/getProductCategories?" + CategoryTypeId + ParentCategoryTypeId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL:- "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Getting Category List
	 * @param CategoryTypeId
	 * @return
	 */
	public static String getCategoryMemberListAsObject(String productId) {	
		
		String result = "";
		Client client = RestClient.getClient();
		if(productId != null && !"".equalsIgnoreCase(productId)){
			productId = SEARCH_STRING_PRODUCTID + productId + "&";
		} else {
			productId = "";
		}

		String serviceUrl = getServiceHost() + "productportal/getproductcategorymember?" + productId;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL:- "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
	/**
	 * Getting Category List
	 * @param CategoryTypeId
	 * @return
	 */
	
public static String postCateScreen(String resultJson) {
	
	String result = "";	
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(getServiceHost()+ "portalpost/mapproductcategory");
		_log.info("Posting URL :: "+webResource.toString());
		_log.info("after replacing "+resultJson);
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class, resultJson);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("after jsonposting " + result.toString());
		return result;
	}
private static Log _log=LogFactoryUtil.getLog(ProductCategoryServiceUtil.class);
}