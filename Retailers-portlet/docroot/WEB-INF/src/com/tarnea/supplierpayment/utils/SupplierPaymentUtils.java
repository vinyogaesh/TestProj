package com.tarnea.supplierpayment.utils;

import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_COMPANYNAME;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SEARCH_STRING_PARTYID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_TOPARTYID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_ROLETYPEID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_PARTYIDTO;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_NAME_INVOICETYPEID;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_VALUE_SUPPLIER;
import static com.tarnea.common.PortalConstant.SERVICE_PARAMETER_KEY_PARTYIDFROM;
import static com.tarnea.common.PortalConstant.SERVICE_HOST;

import javax.portlet.PortletRequest;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
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
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;
public class SupplierPaymentUtils {
	public static String getServiceHost() {
		return SERVICE_HOST;
	}

	/**
	 * Getting Retailer Details
	 * @param partyId
	 * @return
	 */
	public static String getRetailerDetailAsObject(String partyId) {	
		String result = "";
		Client client = RestClient.getClient();
		
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_PARTYID + partyId + "&";
		} else {
			partyId = "";
		}
		
		String serviceUrl = getServiceHost() + "partyportal/partylist?" + partyId + SERVICE_PARAMETER_KEY_NAME_ROLETYPEID + SERVICE_PARAMETER_VALUE_SUPPLIER;
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
	 * Getting Reatiler List
	 * @param partyId
	 * @param retailerName
	 * @param tin
	 * @param area
	 * @return
	 */
	public static String getRetailerListAsObject(String partyId, String retailerName,String partyIdTo) {	
		
		String result = "";
		Client client = RestClient.getClient();
		
		String roleTypeId = SERVICE_PARAMETER_VALUE_SUPPLIER;
		
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SEARCH_STRING_PARTYID + partyId + "&";
		} else {
			partyId = "";
		}

		if(retailerName != null && !"".equalsIgnoreCase(retailerName)) {
			retailerName = SERVICE_PARAMETER_KEY_COMPANYNAME + retailerName + "&";
		} else {
			retailerName = "";
		}
		
		
		if(roleTypeId != null && !"".equalsIgnoreCase(roleTypeId)) { 
			roleTypeId = SERVICE_PARAMETER_KEY_ROLETYPEID + roleTypeId + "&";
		} else {
			roleTypeId = "";
		}
		
		
		if(partyIdTo != null && !"".equalsIgnoreCase(partyIdTo)) { 
			partyIdTo = SERVICE_PARAMETER_KEY_NAME_TOPARTYID + partyIdTo + "&";
		} else {
			partyIdTo = "";
		}
		
		String serviceUrl = getServiceHost() + "partyportal/partydetail?" +  partyId + retailerName + roleTypeId + partyIdTo +"&";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("service url::"+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("Result value:-"+result);
		return result;
	}
	
	
	
	/**
	 * Getting Invoice List
	 * @param partyId
	 * @param retailerName
	 * @param tin
	 * @param area
	 * @return
	 */
	public static String getinvoiceListAsObject(String partyId, String invoiceTypeId,String fromPartyId, String createdDateAfter) {	
		String result = "";
		Client client = RestClient.getClient();
		if(partyId != null && !"".equalsIgnoreCase(partyId)){
			partyId = SERVICE_PARAMETER_KEY_PARTYIDTO + partyId + "&";
		} else {
			partyId = "";
		}
		if(invoiceTypeId != null && !"".equalsIgnoreCase(invoiceTypeId)){
			invoiceTypeId = SERVICE_PARAMETER_KEY_NAME_INVOICETYPEID + invoiceTypeId + "&";
		} else {
			invoiceTypeId = "";
		}
		
		if(fromPartyId != null && !"".equalsIgnoreCase(fromPartyId)){
			fromPartyId = SERVICE_PARAMETER_KEY_PARTYIDFROM + fromPartyId + "&";
		} else {
			fromPartyId = "";
		}
		
		if(createdDateAfter != null && !"".equalsIgnoreCase(createdDateAfter)){
			createdDateAfter = "createdDateAfter=" + createdDateAfter + "&";
		} else {
			createdDateAfter = "";
		}
		
		String serviceUrl = getServiceHost() + "orderportal/relatedinvoiceforpayment?" + fromPartyId + partyId + invoiceTypeId + createdDateAfter;
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("service url::"+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("Result value:-"+result);
		return result;
	}

	/**
	 * Getting Payments Method
	 * @param partyId
	 * @param retailerName
	 * @param tin
	 * @param area
	 * @return
	 */
	public static String getPaymentMethodtAsObject() {	
		String result = "";
		Client client = RestClient.getClient();
		String serviceUrl = getServiceHost() + "lookupportal/paymentMethodTypes";
		serviceUrl = TarneaCommon.encodeUrl(serviceUrl);
		_log.info("service url::"+serviceUrl);
		WebResource webResource = client.resource(serviceUrl);
		ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("Result value:-"+result);
		return result;
	}
	
	/**
	 * Getting Posting Of Paid Invoices
	 * @param Invoice data
	 * @return
	 */
	
public static String postJsonForInvoicePayment(String resultJson) {
	String result = "";	
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(getServiceHost()
				+ "payment/payforinvoice");
		_log.info("Posting URL :: "+webResource.toString());
		_log.info("Posting Json "+resultJson);
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class, resultJson);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		result = object.toString();
		_log.info("after jsonposting " + result.toString());
		return result;
	}
private static Log _log=LogFactoryUtil.getLog(SupplierPaymentUtils.class);
}