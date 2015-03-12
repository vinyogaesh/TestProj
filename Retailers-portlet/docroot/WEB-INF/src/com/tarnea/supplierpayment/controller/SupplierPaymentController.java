package com.tarnea.supplierpayment.controller;

import java.io.IOException;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;
import com.tarnea.supplierpayment.utils.SupplierPaymentUtils;

@Controller(value = "SupplierPaymentController")
@RequestMapping("VIEW")
public class SupplierPaymentController
{
	public static String targetPartyId; 
	public static String result = "";
	
    /**
     * Default show page
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RenderMapping
    public String handleRenderRequest(RenderRequest request,
	    RenderResponse response, Model model)
    {
		targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		return "SupplierPayment";
    }
    
    @ResourceMapping(value="RetailerNameSearch")
    public static void RetailerNameSearch(ResourceRequest request,ResourceResponse response) throws IOException{
    	result = getJsonForRetailerSearch(targetPartyId);
    	response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");		
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="RetailerDetailsSearch")
    public static void RetailerDetailsSearch(ResourceRequest request,ResourceResponse response) throws IOException{
    	String retailerName = request.getParameter("retailerName");
		String partyIdTo = request.getParameter("partyIdTo");
		result = getJsonForRetailerDetailsSearch(targetPartyId, retailerName ,partyIdTo);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");		
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="invoiceList")
    public static void invoiceList(ResourceRequest request,ResourceResponse response) throws IOException{
    	String invoiceTypeId = "PURCHASE_INVOICE";
		String fromPartyId = request.getParameter("fromPartyId");
		String createdDateAfter = request.getParameter("createdDateAfter");
		result = getJsonForInvoiceListsSearch(targetPartyId, invoiceTypeId,fromPartyId,createdDateAfter);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");		
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="paymentMethodTypes")
    public static void paymentMethodTypes(ResourceRequest request,ResourceResponse response) throws IOException{
    	result = getJsonForPaymentMethodTypesSearch();
    	response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");		
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="PostingPayment")
    public static void PostingPayment(ResourceRequest request,ResourceResponse response) throws IOException{
    	String invPost = request.getParameter("invPost");
		result = SupplierPaymentUtils.postJsonForInvoicePayment(invPost);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");		
		response.getWriter().write(result);
    }
    
    /**
	 * Getting Supplier List
	 * @param targetPartyId
	 * @return
	 */
	public static String getJsonForRetailerSearch(String targetPartyId) {
		String retailerJson = SupplierPaymentUtils.getRetailerDetailAsObject(targetPartyId);
		return retailerJson;
	}
	
	/**
	 * Getting Supplier Details
	 * 
	 * @param targetPartyId
	 * @param retailerName
	 * @param tin
	 * @param areaName
	 * @return
	 */
	public static String getJsonForRetailerDetailsSearch(String targetPartyId, String retailerName, String partyIdTo){
		String retailerDetailsJson = SupplierPaymentUtils.getRetailerListAsObject(targetPartyId, retailerName, partyIdTo);
		return retailerDetailsJson;
	}
	
	
	
	/**
	 * Getting Supplier Details
	 * 
	 * @param targetPartyId
	 * @param retailerName
	 * @param tin
	 * @param areaName
	 * @return
	 */
	public static String getJsonForPaymentMethodTypesSearch(){
		String PaymentMethodJson = SupplierPaymentUtils.getPaymentMethodtAsObject();
		return PaymentMethodJson;
	}
	
	/**
	 * Getting Invoice List
	 * 
	 * @param targetPartyId
	 * @param retailerName
	 * @param tin
	 * @param areaName
	 * @return
	 */
	public static String getJsonForInvoiceListsSearch(String targetPartyId, String invoiceTypeId,String fromPartyId,String createdDateAfter){
		String invoiceListJson = SupplierPaymentUtils.getinvoiceListAsObject(targetPartyId, invoiceTypeId,fromPartyId,createdDateAfter);
		return invoiceListJson;
	}
}