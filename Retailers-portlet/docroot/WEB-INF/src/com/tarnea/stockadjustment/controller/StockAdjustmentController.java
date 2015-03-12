
package com.tarnea.stockadjustment.controller;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.tarnea.rest.RestClient;
import com.tarnea.stockadjustment.model.JsonResult;
import com.tarnea.common.PortalConstant;
import com.tarnea.common.TarneaCommon;
import com.tarnea.stockadjustment.utils.StockAdjustmentUtils;

import static com.tarnea.common.PortalConstant.RESPONSE_STATUS_VALUE_SUCCESS;
import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PARTYID;
import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PRODUCTID;

@Controller(value = "StockAdjustmentController")   
@RequestMapping("VIEW")  
public class StockAdjustmentController {

	public static String message = "";
	public static String cartItems = "";
	public static String purchasedItems = "[]";
	public static String result = "";
	public static String targetPartyId =  "";

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
		targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		return "StockAdjustment";
	}
	
	/**
	 * Redirects to  page
	 * @param request
	 * @param response
	 * @param model
	 * @return String
	 */
	@RenderMapping(params = "myaction=showStocks")
	public String showCreateReturns(RenderRequest request,
			RenderResponse response, Model model) { 
		targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		model.addAttribute("message", message);
		message = "";
		return "StockAdjustment";
	}
	
	/** 
	 * Getting cart item and processing item to purchase order screen
	 * 
	 * @param request
	 * @param response
	 * @throws IOException 
	 */
	@ActionMapping(params = "myaction=processStockAdjustment")
	public void processCartItem(ActionRequest request, ActionResponse response) throws IOException {
		String valueJSON = "";
		if (request.getParameter("AdjustedStock") != null) 
			valueJSON = request.getParameter("AdjustedStock");

		if(TarneaCommon.isValidValue(valueJSON)) {
			result = StockAdjustmentUtils.getCreateOrderCartItemsToPurchase(targetPartyId, valueJSON);
		}
		JsonResult jsonResult = StockAdjustmentUtils.postStockAdj(result);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String portletName = (String) request.getAttribute(WebKeys.PORTLET_ID);
		PortletURL redirectURL = PortletURLFactoryUtil.create(PortalUtil.getHttpServletRequest(request), portletName,themeDisplay.getLayout().getPlid(), PortletRequest.RENDER_PHASE);
		redirectURL.setParameter("myaction", "showStocks");
		response.sendRedirect(redirectURL.toString());
	}
	
	@ResourceMapping(value="ProductSearch")
	public void ProductSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
	    result = getJsonForProductListSearch(partyId);
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
	}
	
	@ResourceMapping(value="ProductDetail")
	public void ProductDetail(ResourceRequest request,ResourceResponse response) throws IOException{
		 String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		 String productId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		 result = getJsonForProductDetailSearch(productId, partyId);
		 response.setContentType("application/json");
		 response.setCharacterEncoding("UTF-8");
		 response.getWriter().write(result);
	}
	
	@ResourceMapping(value="BatchList")
	public void BatchList(ResourceRequest request,ResourceResponse response) throws IOException{
		String partyId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PARTYID);
		    String productId = request.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
		    result = getJsonForBatchValueSearch(productId, partyId);
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(result);
	}
	
	@ResourceMapping(value="ReasonList")
	public void ReasonList(ResourceRequest request,ResourceResponse response) throws IOException{
		result = getJsonForReasonValueSearch();
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(result);
	}
	
	/**
     * Getting Batch list
     * 
     * @param productId
     *            , partyId
     * @return
     */
    public static String getJsonForBatchValueSearch(String productId, String partyId)
    {
	String batchJson = StockAdjustmentUtils.getBatchListAsObject(productId, partyId);
	return batchJson;
    }
    
    /**
     * Getting Reason list
     * 
     * @param productId
     *            , partyId
     * @return
     */
    public static String getJsonForReasonValueSearch()
    {
	String reasonJson = StockAdjustmentUtils.getReasonListAsObject();
	return reasonJson;
    }
    
    
    

    /**
     * Getting Product list
     * 
     * @param partyId
     * @return
     */
    public static String getJsonForProductListSearch(String partyId)
    {
	String productJson = StockAdjustmentUtils.getProductListAsObject(partyId);
	return productJson;
    }

    /**
     * Getting Product detail
     * 
     * @param productId
     *            , partyId
     * @return
     */
    public static String getJsonForProductDetailSearch(String productId,String partyId){
	String productJson = StockAdjustmentUtils.getProductDetailAsObject(productId,partyId);
	return productJson;
    }
}