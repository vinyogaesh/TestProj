package com.tarnea.discountmanagement.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.tarnea.common.TarneaCommon;
import com.tarnea.discountmanagement.utils.DiscountManagementService;
import com.tarnea.rest.RestClient;

@Controller(value = "DiscountManagementController")
@RequestMapping("VIEW")
public class DiscountManagementController
{
	public static String targetPartyId; 
	public static String result = "";
        /**
     * 
     * Default show page
     * 
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RenderMapping
    public String handleRenderRequest(RenderRequest request,
	    RenderResponse response, Model model){
    	String serverDateFormatted = "";
		targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		Date serverDate = new Date();
		SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd"); 
		serverDateFormatted = ft.format(serverDate);
		model.addAttribute("serverDate",serverDateFormatted);
		return "DiscountManagement";
    }
    
    @ResourceMapping(value="PartyDetails")
    public void PartyDetails(ResourceRequest request,ResourceResponse response) throws IOException{
    	String partyId = targetPartyId;
		result = getJsonForPartyDetails(partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="ProductSearch")
	public void ProductSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = targetPartyId;
		String roleTypeId = request.getParameter("partyTypeId");//SERVICE_PARAMETER_VALUE_RETAILER;
		String ProductSearchKe = request.getParameter("productName");
		String Limit = request.getParameter("limit");
		System.out.println("role Type Id :: "+roleTypeId);
		result = getJsonForProductListSearch(ProductSearchKe, Limit,partyId,roleTypeId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
    
    
    @ResourceMapping(value="ProductDetailSearch")
    public void ProductDetailSearch(ResourceRequest request,ResourceResponse response) throws IOException{
    	String partyId = targetPartyId;
		String ProductId = request.getParameter("productId");
		//String Limit = request.getParameter("limit");
		result = getJsonForProductDetailSearch(ProductId, partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    
    
    @ResourceMapping(value="ProductDiscountSearch")
    public void ProductDiscountSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = targetPartyId;
		String productId = request.getParameter("productId");
		result = getJsonForProductDiscountSearch(productId,partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
    
    @ResourceMapping(value="RemoveProductDiscount")
    public void RemoveProductDiscount(ResourceRequest request,ResourceResponse response) throws IOException{
    	String partyId = targetPartyId;
		String productId = request.getParameter("productId");
		result = postJsonForProductDiscountRemove(productId,partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="CreateProductDiscount")
    public void CreateProductDiscount(ResourceRequest request,ResourceResponse response) throws IOException{
		String productId = request.getParameter("createProductJson");
		result = postJsonForProductDiscountCreate(productId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    
    /*@ResourceMapping(value="ServerDateDeail")
    public void GetServerDate(ResourceRequest request,ResourceResponse response) throws IOException, JSONException{
    	result = GetServerDateDeail();
    	JSONObject DateTime = new JSONObject();
    	DateTime.put("ServerDate", result);
    	result = DateTime.toString();
    	response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }*/
    
    /**
	 * Getting Party Details
	 * @param partyId
	 * @return
	 */
	public static String getJsonForPartyDetails(String partyId) {
		String partyDetailJson = DiscountManagementService.getPartyDetailAsObject(partyId);
		return partyDetailJson;
	}
    
    /**
	 * Getting Product list
	 * 
	 * @param partyId
	 * @return
	 */
	public static String getJsonForProductListSearch(String ProductSearchKe, String Limit,String partyId,String roleTypeId) {
		String productJson = DiscountManagementService.getProductListAsObject(ProductSearchKe, Limit,partyId,roleTypeId);
		return productJson;
	}
	
	/**
	 * Getting Product Details
	 * @param partyId
	 * @param productId
	 * @return
	 */
	public static String getJsonForProductDetailSearch(String productId,String partyId){
		String productDetailJson = DiscountManagementService.getProductDetailAsObject(productId,partyId);
		return productDetailJson;
	}
	
	
	/**
	 * Getting Product Discount
	 * @param partyId
	 * @param productId
	 * @return
	 */
	public static String getJsonForProductDiscountSearch(String productId,String partyId){
		String productDiscountJson = DiscountManagementService.getProductDiscountAsObject(productId, partyId);
		return productDiscountJson;
	}
	
	/**
	 * Getting Product Discount
	 * @param partyId
	 * @param productId
	 * @return
	 */
	public static String postJsonForProductDiscountRemove(String productId,String partyId){
		String productRemoveDiscountJson = DiscountManagementService.postProductDiscountRemoveAsObject(productId, partyId);
		return productRemoveDiscountJson;
	}
	
	/**
	 * Create Product Discount
	 * @param partyId
	 * @param productId
	 * @return
	 */
	public static String postJsonForProductDiscountCreate(String prodJson){
		String productCreateDiscountJson = DiscountManagementService.postProductDiscountCreateAsObject(prodJson);
		return productCreateDiscountJson;
	}
	
	/**
	 * Get Server Date and Time
	 */
	/*public static String GetServerDateDeail(){
		String ServerDate = DiscountManagementService.getServerDateAndTime();
		return ServerDate;
	}*/
}