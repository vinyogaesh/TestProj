package com.tarnea.productcategory.controller;

import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PARTYID;

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
import com.tarnea.productcategory.utils.ProductCategoryServiceUtil;
import com.tarnea.rest.RestClient;

@Controller(value = "ProductCategoryController")   
@RequestMapping("VIEW")  
public class ProductCategoryController {

	
	public static String result ="";
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
		return "ProductCategory";
	}
	@ResourceMapping(value="ProductSearch")
	public void ProductSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request
				.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
				result = getJsonForProductListSearch(partyId);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(result);
	}
	@ResourceMapping(value="ProductCategories")
	public void ProductCategories(ResourceRequest request,ResourceResponse response) throws IOException{
		String categoryTypeId = request
				.getParameter("categoryType");
				result = getJsonForCategoryListSearch(categoryTypeId);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(result);
	}
	@ResourceMapping(value="productCategoryMembers")
	public void productCategoryMembers(ResourceRequest request,ResourceResponse response) throws IOException{
		String productId = request
				.getParameter("productId");
				result = getJsonForCategoryMemberSearch(productId);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(result);
	}
	@ResourceMapping(value="productCategoryPost")
	public void productCategoryPost(ResourceRequest request,ResourceResponse response) throws IOException{
		String valueJson = request.getParameter("savedJson");
		result=ProductCategoryServiceUtil.postCateScreen(valueJson);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
	
	/**
	 * Getting Product list
	 * 
	 * @param partyId
	 * @return
	 */
	public static String getJsonForProductListSearch(String partyId) {
		String productJson = ProductCategoryServiceUtil.getProductListAsObject(partyId);
		return productJson;
	}

	/**
	 * Getting Category list
	 * 
	 * @param parategoryTypeId
	 * @return
	 */
	public static String getJsonForCategoryListSearch(String categoryTypeId) {
		String categoryJson = ProductCategoryServiceUtil.getCategoryListAsObject(categoryTypeId);
		return categoryJson;
	}
	
	/**
	 * Getting Category Members for Product list
	 * @param productId
	 * @return
	 */
	public static String getJsonForCategoryMemberSearch(String productId) {
		String categoryMemberJson = ProductCategoryServiceUtil.getCategoryMemberListAsObject(productId);
		return categoryMemberJson;
	}
}