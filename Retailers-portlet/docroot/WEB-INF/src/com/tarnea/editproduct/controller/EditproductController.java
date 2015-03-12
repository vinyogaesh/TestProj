package com.tarnea.editproduct.controller;

import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PARTYID;
import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PRODUCTID;

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

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.tarnea.common.TarneaCommon;
import com.tarnea.editproduct.utils.EditProductUtils;
import com.tarnea.rest.RestClient;

@Controller(value = "EditproductController")   
@RequestMapping("VIEW")  
public class EditproductController {

	public static String message = "";
	public static String cartItems = "";
	public static String purchasedItems = "[]";
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
			RenderResponse response, Model model) { 
		String targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		return "EditProduct";
	}
	
	/**
	 * Redirects to  page
	 * @param request
	 * @param response
	 * @param model
	 * @return String
	 */
	@RenderMapping(params = "myaction=showEditedProd")
	public String showCreateReturns(RenderRequest request,
			RenderResponse response, Model model) { 
		String targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		model.addAttribute("message", message);
		message = "";
		return "EditProduct";
	}
	

	@ResourceMapping(value="ProductSearch")
	public void ProductSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		if (TarneaCommon.isValidValue(partyId))
				result = getJsonForProductListSearch(partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="ProductDetail")
	public void ProductDetail(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request
				.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		String productId = request
				.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		result = getJsonForProductDetailSearch(productId, partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="BatchList")
	public void BatchList(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request
				.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		String productId = request
				.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		result = getJsonForBatchValueSearch(productId, partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="ProductNew")
	public void ProductNew(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		String productId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		String productList = request.getParameter("newproduct");
		result = newProduct(productId, partyId, productList);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="ProductRemove")
	public void ProductRemove(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		String productId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		String roletypeId = request.getParameter("roletypeId");
		result = removeProduct(productId, partyId, roletypeId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="GetUOMlist")
	public void GetUOMlist(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		result = getUOM(partyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="Inventoryempty")
	public void Inventoryempty(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		String productId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		String productList = request.getParameter("emptyproduct");
		_log.info("emptyproduct :: "+productList);
		result = emptyInventory(productId, partyId, productList);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	@ResourceMapping(value="CustomerDetails")
	public void CustomerDetails(ResourceRequest request,ResourceResponse response) throws IOException{
		String retailerPartyId = request.getParameter("retailerPartyId");
		result = getJsonForCustomerDetails(retailerPartyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	/**
	 * Getting Batch list
	 * @param productId, partyId
	 * @return
	 */
	public static String getJsonForBatchValueSearch(String productId, String partyId) {
		String batchJson = EditProductUtils.getBatchListAsObject(productId, partyId);
		return batchJson;
	}
	
	/**
	 * Getting Customer Details
	 *
	 * @param partyId
	 * @return
	 */
	public static String getJsonForCustomerDetails(String partyId) {
		String customerDetailJson = EditProductUtils.getJsonForCustomerDetailsAsObject(partyId);
		return customerDetailJson;
	}
	
	/**
	 * Getting UOM list
	 * @param productId, partyId
	 * @return
	 */
	public static String getUOM(String partyId) {
		String batchJson = EditProductUtils.getUOMObject(partyId);
		return batchJson;
	}
	/**
	 * Getting Product list
	 * 
	 * @param partyId
	 * @return
	 */
	public static String getJsonForProductListSearch(String partyId) {
		String productJson = EditProductUtils.getProductListAsObject(partyId);
		return productJson;
	}

	/**
	 * Getting Product detail
	 * 
	 * @param productId
	 *            , partyId
	 * @return
	 */
	public static String getJsonForProductDetailSearch(String productId,
			String partyId) {
		String productJson = EditProductUtils.getProductDetailAsObject(productId,
				partyId);
		return productJson;
	}
	
	/**
	 * Post New Product
	 * 
	 * @param productId
	 *            , partyId
	 *            , productList
	 *            
	 * @return
	 */
	public static String newProduct(String productId,String partyId, String productList ) {
		String productJson = EditProductUtils.postNewProduct(productList);
		return productJson;
	}
	
	/**
	 * Remove Old Product
	 * 
	 * @param productId
	 *            , partyId
	 * @return
	 */
	public static String removeProduct(String productId,String partyId, String roletypeId) {
		String productJson = EditProductUtils.getRemoveProduct(productId,partyId,roletypeId);
		return productJson;
	}
	
	/**
	 * Empty old Product Inventory 
	 * 
	 * @param productId
	 *            , partyId
	 *            , productList
	 * @return
	 */
	public static String emptyInventory(String productId,String partyId, String productList) {
		String productJson = EditProductUtils.postEmptyInventory(productList);
		return productJson;
	}
	private static Log _log=LogFactoryUtil.getLog(EditproductController.class);
}