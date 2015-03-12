package com.tarnea.supplier.controller;

import java.io.IOException;

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

import com.liferay.portal.util.PortalUtil;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;
import com.tarnea.supplier.utils.SupplierMappingUtils;

@Controller(value = "MappingController")
@RequestMapping("VIEW")
public class SupplierMappingController {

	private static Log log = LogFactory.getLog(SupplierMappingController.class);
    public static String message = "";
    public static String result = "";
    /**
     * Rendering to the file upload home page
     * 
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RenderMapping
    public String handleRenderRequest(RenderRequest request, RenderResponse response, Model model) {
	String targetPartyId = TarneaCommon.getTargetPartyId(request);
	RestClient.partyId = targetPartyId;
	long userId = PortalUtil.getUserId(request);
	String targetPartyName = PortalUtil.getUserName(userId, null);
	model.addAttribute("createdUser",targetPartyName);
	model.addAttribute("targetPartyId", targetPartyId);
	return "AddSupplier";
    }
    
    
    @ResourceMapping(value="CustomerDetails")
    public void CustomerDetails(ResourceRequest request,ResourceResponse response) throws IOException{
    	String retailPartyId = request.getParameter("retailerPartyId");
    	result = getJsonForCustomerDetails(retailPartyId);
    	response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="AddingManufacturer")
    public void AddingManufacturer(ResourceRequest request,ResourceResponse response) throws IOException{
    	String AddManufacturerPost = request.getParameter("AddManufacturerPost");
		log.info("Posted Value :: "+AddManufacturerPost);
		result = SupplierMappingUtils.jsonForAddManufacturer(AddManufacturerPost);
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
    
    /**
	 * Getting States list
	 *
	 * @return
	 */
	public static String getJsonForStatesListSearch() {
		String statesJson = SupplierMappingUtils.getStatesListAsObject();
		return statesJson;
	}
	
	/**
	 * Getting Customer Details
	 *
	 * @param partyId
	 * @return
	 */
	public static String getJsonForCustomerDetails(String partyId) {
		String customerDetailJson = SupplierMappingUtils.getJsonForCustomerDetailsAsObject(partyId);
		return customerDetailJson;
	}
}