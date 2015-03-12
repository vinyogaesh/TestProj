package com.tarnea.product.controller;

import java.io.IOException;

import com.liferay.portal.util.PortalUtil;
import com.tarnea.common.TarneaCommon;
import com.tarnea.product.utils.ProductMappingUtils;
import com.tarnea.rest.RestClient;

import static com.tarnea.common.PortalConstant.SEARCH_VALUE_TAX_PER;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;
@Controller(value = "MappingController")
@RequestMapping("VIEW")
public class ProductMappingController {
	public static String message = "";
	public static String result = "";
	
	/**
	 * Rendering to the file upload home page
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RenderMapping
	public String handleRenderRequest(RenderRequest request, RenderResponse response, Model model) {
	String targetPartyId = TarneaCommon.getTargetPartyId(request);
	RestClient.partyId = targetPartyId;
	model.addAttribute("targetPartyId", targetPartyId);
	long userId = PortalUtil.getUserId(request);
	String targetPartyName = PortalUtil.getUserName(userId, null);
	model.addAttribute("createdUser",targetPartyName);
	model.addAttribute("taxPercentage",SEARCH_VALUE_TAX_PER);
	return "AddProduct";
	}
	
	@ResourceMapping(value="ProductCategories")
	public void ProductCategories(ResourceRequest request,ResourceResponse response) throws IOException{
		String categoryType = request.getParameter("categoryType");
		String parentCategoryId = request.getParameter("parentCategoryId");
		result = getJsonForCategoryListSearch(categoryType, parentCategoryId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	
	}
	
	@ResourceMapping(value="AddingProduct")
	public void AddingProduct(ResourceRequest request,ResourceResponse response) throws IOException{
		String addProductPost = request.getParameter("addProductPost");
		_log.info("addProductPost :: "+addProductPost);
		result = ProductMappingUtils.jsonForAddProduct(addProductPost);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	@ResourceMapping(value="AddingManufacturer")
	public void AddingManufacturer(ResourceRequest request,ResourceResponse response) throws IOException{

		String AddManufacturerPost = request.getParameter("AddManufacturerPost");
		_log.info("AddManufacturerPost :: "+AddManufacturerPost);
		result = ProductMappingUtils.jsonForAddManufacturer(AddManufacturerPost);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	@ResourceMapping(value="getStates")
	public void getStates(ResourceRequest request,ResourceResponse response) throws IOException{
		result = getJsonForStatesListSearch();	
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	@ResourceMapping(value="getPrincipalNames")
	public void getPrincipalNames(ResourceRequest request,ResourceResponse response) throws IOException{
		String principalName = request.getParameter("principalName");
		String limit = request.getParameter("limit");
		String distinctManufactureName =request.getParameter("distinctManufactureName");
		result = getJsonForManufacturerListSearch(principalName, limit, distinctManufactureName);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	@ResourceMapping(value="getUomList")
	public void getUomList(ResourceRequest request,ResourceResponse response) throws IOException{
		String SearchKe = request.getParameter("searchKey");
		String Limit = request.getParameter("limit");
		result = getJsonForUomListSearch(SearchKe, Limit);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	
	@ResourceMapping(value="CustomerDetails")
	public void CustomerDetails(ResourceRequest request,ResourceResponse response) throws IOException{
		String retailPartyId = request.getParameter("retailerPartyId");
		result = getJsonForCustomerDetails(retailPartyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	@ResourceMapping(value="getProductNames")
	public void getProductNames(ResourceRequest request,ResourceResponse response) throws IOException{
		String ProductSearchKe = request.getParameter("productName");
		String Limit = request.getParameter("limit");
		result = getJsonForProductListSearch(ProductSearchKe, Limit);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}		
	
	/**
	 * Getting Category list
	 * @param categoryTypeId
	 * @return
	 */
	public static String getJsonForCategoryListSearch(String categoryTypeId, String parentCategoryId) {
		String categoryJson = ProductMappingUtils.getCategoryListAsObject(categoryTypeId, parentCategoryId);
		return categoryJson;
	}
	
	/**
	 * Getting Manufacturer list
	 * @param manufacturerName
	 * @return
	 */
	public static String getJsonForManufacturerListSearch(String principalName, String limit, String distinctManufactureName) {
		String principalJson = ProductMappingUtils.getManufacturerListAsObject(principalName, limit, distinctManufactureName);
		return principalJson;
	}
	
	/**
	 * Getting States list
	 *
	 * @return
	 */
	public static String getJsonForStatesListSearch() {
		String statesJson = ProductMappingUtils.getStatesListAsObject();
		return statesJson;
	}
	/**
	 * Getting Uom list
	 * @return
	 */
	public static String getJsonForUomListSearch(String SearchKey, String Limit) {
		String uomJson = ProductMappingUtils.getJsonForUomListSearch(SearchKey, Limit);
		return uomJson;
	}

	/**
	 * Getting Customer Details
	 * @param partyId
	 * @return
	 */
	public static String getJsonForCustomerDetails(String partyId) {
		String customerDetailJson = ProductMappingUtils.getJsonForCustomerDetailsAsObject(partyId);
		return customerDetailJson;
	}


	/**
	 * Getting Customer Details
	 * @param partyId
	 * @return
	 */
	public static String getJsonForProductListSearch(String ProdName, String Limit) {
		String productDetailJson = ProductMappingUtils.getJsonForProductDetailsAsObject(ProdName, Limit);
		return productDetailJson;
	}
	private static Log _log = LogFactory.getLog(ProductMappingController.class);
}