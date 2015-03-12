package com.tarnea.product.utils;

import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_LOYALITYSTATUS;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PRODUCTNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_ORG_PARTY_ID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_UOMLIMITKEY;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_START_INDEX;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETERl_KEY_NAME_LIMIT;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PRODUCTSTOREGROUPID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PARTNO;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_GROUPNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PARTNAME;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_RETAIL_PARTYID;
import static com.tarnea.common.PortalConstant.SEARCH_VALUE_ROLETYPEID_BILL_FROM_VENDOR;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_START_INDEX;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_VALUE_LOYALITYSTATUS;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETERl_KEY_NAME_LIMIT;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PRODUCTSTOREGROUPID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PARTNO;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_GROUPNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETR_KEY_NAME_PARTNAME;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jettison.json.JSONObject;

import com.google.gson.Gson;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;
import com.tarnea.stockadjustment.model.CartItem;

public class AlternateProductUtils {
	
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
	
	public static String getAlternateProductListAsObject(String startIndex,String limit,String productStoreGroupId, String partSelNo, String grpSelName, String partSelName) {
		String result = "";
		Client client = RestClient.getClient();
		if(startIndex !="" ||  startIndex != null){
			startIndex = SERVICE_PARAMETER_KEY_NAME_START_INDEX + startIndex + "&";
		}else{
			startIndex = "";
		}
		if(limit != "" || limit != null){
			limit = SERVICE_PARAMETERl_KEY_NAME_LIMIT + limit + "&";
		}else{
			limit = "";
		}
		
		if(productStoreGroupId !="" || productStoreGroupId != null){
			productStoreGroupId = SERVICE_PARAMETR_KEY_NAME_PRODUCTSTOREGROUPID +productStoreGroupId+"&";
		}else{
			productStoreGroupId = "";
		}
		
		if(partSelNo !="" || partSelNo != null){
			partSelNo = SERVICE_PARAMETR_KEY_NAME_PARTNO +partSelNo+"&";
		}else{
			partSelNo = "";
		}
		
		if(grpSelName !="" || grpSelName != null){
			grpSelName = SERVICE_PARAMETR_KEY_NAME_GROUPNAME +grpSelName+"&";
		}else{
			grpSelName = "";
		}
		
		if(partSelName !="" || partSelName != null){
			partSelName = SERVICE_PARAMETR_KEY_NAME_PARTNAME +partSelName+"&";
		}else{
			partSelName = "";
		}
		
//productStoreGroupId=1000000000049&startIndex=0&limit=5&groupName=test&partName=Air C&part
		String serviceUrl = TarneaCommon.getServiceHost() + "productportal/getAllAlternate?"+productStoreGroupId+startIndex+limit+partSelNo+partSelName+grpSelName;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("Service URL :: "+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		return result;
	}
	
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
	
	public static String postAlternateProductUpdateAsObject(String postValue){

		String result = "";
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(TarneaCommon.getServiceHost()+ "portalpost/setAllAlternateProduct");
		_log.info("Post Value :: "+postValue);
		_log.info("Service URL :: "+webResource.toString());
		ClientResponse response = webResource.accept("application/json").post(
				ClientResponse.class, postValue);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("Result :: "+result);
		return result;
	}
	
	public static List<Map<String, String>> getCartItems(String jsonCartItems) {
		List<Map<String, String>> items = null;
		if (TarneaCommon.isValidValue(jsonCartItems)) {
			items = new ArrayList<Map<String, String>>();
			Gson gson = new Gson();
			items = gson.fromJson(jsonCartItems, ArrayList.class);
		}
		return items;
	}
	
	private static Log _log = LogFactory.getLog(AlternateProductUtils.class);
}
