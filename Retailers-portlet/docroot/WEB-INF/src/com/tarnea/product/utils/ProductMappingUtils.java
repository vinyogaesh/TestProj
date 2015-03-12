package com.tarnea.product.utils;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jettison.json.JSONObject;

import static com.tarnea.common.PortalConstant.SEARCH_STRING_CATEGORYTYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_DISTINCTMANUFACTUREKEY;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARENTCATEGORYTYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRINCIPALNAMEKEY;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTNAME;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_RETAIL_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_UOMLIMITKEY;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_UOMNAMEKEY;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;
public class ProductMappingUtils
{
	public static String getServiceHost() {
		return SERVICE_HOST;
	}

	/**
	 * Getting Category List
	 * @param CategoryTypeId
	 * @return
	 */
	public static String getCategoryListAsObject(String CategoryTypeId, String parentCategoryId) {

		String result = "";
		Client client = RestClient.getClient();
		if (CategoryTypeId != null && !"".equalsIgnoreCase(CategoryTypeId)) {

			CategoryTypeId = SEARCH_STRING_CATEGORYTYPEID + CategoryTypeId + "&";
		} else {
			CategoryTypeId = "";
		}

		if (parentCategoryId != null && !"".equalsIgnoreCase(parentCategoryId)) {

			parentCategoryId = SEARCH_STRING_PARENTCATEGORYTYPEID + parentCategoryId + "&";
		} else {
			parentCategoryId = "";
		}

		String serviceUrl = getServiceHost() + "productportal/getProductCategories?" + CategoryTypeId + parentCategoryId;
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
	 * Getting Manufacturer List
	 * @param principalName
	 * @return
	 */
	public static String getManufacturerListAsObject(String principalName, String limit, String distinctManufactureName) {

		String result = "";
		Client client = RestClient.getClient();
		if (principalName != null && !"".equalsIgnoreCase(principalName)) {

			principalName = SEARCH_STRING_PRINCIPALNAMEKEY + principalName + "&";
		} else {
			principalName = "";
		}

		if (limit != null && !"".equalsIgnoreCase(limit)) {

			limit = SEARCH_STRING_UOMLIMITKEY + limit + "&";
		} else {
			limit = "";
		}

		if (distinctManufactureName !=null && !"".equalsIgnoreCase(distinctManufactureName))
		{
			distinctManufactureName = SEARCH_STRING_DISTINCTMANUFACTUREKEY + distinctManufactureName;
		}

		else
		{
			distinctManufactureName = "";
		}

		String serviceUrl = getServiceHost() + "partyportal/manufacturerlist?" + principalName + limit + distinctManufactureName;
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
	 * Getting Uom List
	 * @return
	 */
	public static String getJsonForUomListSearch(String UomsearchKey, String Limit) {

		String result = "";
		Client client = RestClient.getClient();

		if (UomsearchKey != null && !"".equalsIgnoreCase(UomsearchKey)) {

			UomsearchKey = SEARCH_STRING_UOMNAMEKEY + UomsearchKey + "&";
		} else {
			UomsearchKey = "";
		}

		if (Limit != null && !"".equalsIgnoreCase(Limit)) {

			Limit = SEARCH_STRING_UOMLIMITKEY + Limit + "&";
		} else {
			Limit = "";
		}

		String serviceUrl = getServiceHost() +"lookupportal/uomlist?" + UomsearchKey + Limit;
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

		//System.out.println("service party Id :: "+partyId);
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
	 * Getting ProductList
	 * @param Productname
	 * @return
	 */
	public static String getJsonForProductDetailsAsObject(String prdName, String limit) {

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

		String serviceUrl = getServiceHost() + "productportal/productlist?" + prdName + limit;
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
	 * Creating New Product
	 * @param Product Details
	 * @return
	 */
	public static String jsonForAddProduct(String resultJson) {
		String result = "";
			Client client = RestClient.getClientToPost();
			WebResource webResource = client.resource(getServiceHost()+ "productportal/createproduct");
			_log.info("Service URL :: "+webResource.toString());
			ClientResponse response = webResource.accept("application/json").post(
			ClientResponse.class, resultJson);
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
	private static Log _log = LogFactory.getLog(ProductMappingUtils.class);
}