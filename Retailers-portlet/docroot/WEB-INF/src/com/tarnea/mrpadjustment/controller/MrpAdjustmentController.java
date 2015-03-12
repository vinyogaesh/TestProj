package com.tarnea.mrpadjustment.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.google.gson.Gson;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.GZIPContentEncodingFilter;
import com.tarnea.common.TarneaCommon;
import com.tarnea.rest.RestClient;
import com.tarnea.stockadjustment.model.JsonResult;
import com.tarnea.stockadjustment.utils.StockAdjustmentUtils;

import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PARTYID;
import static com.tarnea.common.PortalConstant.SERVLET_PARAMETER_KEY_NAME_PRODUCTID;

@Controller(value = "StockAdjustmentController")   
@RequestMapping("VIEW")  
public class MrpAdjustmentController {

	public static String message = "";
	public static String cartItems = "";
	public static String purchasedItems = "[]";
	String targetPartyId = "";
	public static String result="";
	
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
		return "MrpAdjustment";
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
		return "MrpAdjustment";
	}

	/**
	 * Render to create order page
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RenderMapping(params = "myaction=showCreateOrder")
	public String showCreateOrder(RenderRequest request,
			RenderResponse response, Model model) { 
		model.addAttribute("targetPartyId", targetPartyId);
		model.addAttribute("statusMessage", message);

		message = "";
		purchasedItems = "[]";

		return "MrpAdjustment";
	}
		public void processCustomer(ActionRequest request, ActionResponse response)
			throws IOException {
			_log.info("inside controller ");
		String billingAccountId = request.getParameter("billingAccountId");
		String billingCreditLimit = request
				.getParameter("billing_acc_term_credit_limit");
		String billingCreditdays = request
				.getParameter("billing_acc_term_credit_days");
		String billingAccMargin = request
				.getParameter("billing_acc_term_margin");
		String billingAccDiscount = request
				.getParameter("billing_acc_term_disc");

		String productmargin = request.getParameter("product_margin");
		String productDisc = request.getParameter("product_disc");
		String qtyFound = request.getParameter("qtyFound");
		String batchNo = request.getParameter("batchN0");
		String partyIdFrom = request.getParameter("targetPartyid");
		
		String productId =  request.getParameter("productId");

		JSONObject objMain;
		try {
			JSONObject obj = new JSONObject();
			obj.put("productId", partyIdFrom);//product id
			obj.put("partyId", productId);
			
			objMain = new JSONObject();
			objMain.put("productDetail", obj);//Product Detai;l

			JSONObject accDiscount = new JSONObject();
			accDiscount.put("batch", batchNo);
			accDiscount.put("pricePurposeId", "MRP");
			accDiscount.put("priceValue", qtyFound);
			
			JSONObject accMarginperc = new JSONObject();
			accMarginperc.put("batch", batchNo);
			accMarginperc.put("pricePurposeId", "PURCHASE");
			accMarginperc.put("priceValue",qtyFound);

			JSONArray jsonarr = new JSONArray();
			jsonarr.put(accDiscount);
			jsonarr.put(accMarginperc);
			objMain.put("batchPriceList", jsonarr);//second
			_log.info("objMain .stostring "+objMain.toString());
			JsonResult customerDataRes = postStockAdj(objMain.toString());
			_log.info("customerDataRes tostring "+customerDataRes.getResponseMessage());
		} catch (NumberFormatException e) {
			_log.error(e);
		} catch (JSONException e) {
			_log.error(e);
		}
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
			_log.info("partyID ** " + partyId);
				String productId = request
					.getParameter(SERVLET_PARAMETER_KEY_NAME_PRODUCTID);
				_log.info("productId ** " + productId);
				result = getJsonForBatchValueSearch(productId, partyId);
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(result);
		}

		
	/** 
	 * Getting cart item and processing item to purchase order screen
	 * 
	 * @param request
	 * @param response
	 * @throws IOException 
	 */
	@ActionMapping(params = "myaction=processCartItem")
	public void processCartItem(ActionRequest request, ActionResponse response) throws IOException {

		String result = "";
		String valueJSON = "";

		if (request.getParameter("purchaseItem") != null) 
			valueJSON = request.getParameter("purchaseItem");

		if(TarneaCommon.isValidValue(valueJSON)) {
			result = getCreateOrderCartItemsToPurchase(targetPartyId, valueJSON);
		}
		JsonResult jsonResult = postStockAdj(result);
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		String portletName = (String) request.getAttribute(WebKeys.PORTLET_ID);
		PortletURL redirectURL = PortletURLFactoryUtil.create(PortalUtil.getHttpServletRequest(request), portletName,
		themeDisplay.getLayout().getPlid(), PortletRequest.RENDER_PHASE);
		redirectURL.setParameter("myaction", "showStocks");
		response.sendRedirect(redirectURL.toString());
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
    public static String getJsonForProductDetailSearch(String productId,
	    String partyId)
    {
	String productJson = StockAdjustmentUtils.getProductDetailAsObject(productId,
		partyId);
	return productJson;
    }
	
	public static JsonResult postStockAdj(String resultJson) {
		_log.info("Mrp adj json :" + resultJson);
		Client client = RestClient.getClientToPost();
		WebResource webResource = client.resource(StockAdjustmentUtils.getServiceHost()+ "portalpost/updateproductprice");
		ClientResponse response = webResource.accept("application/json").post(ClientResponse.class, resultJson);
		client.addFilter(new GZIPContentEncodingFilter(false));
		JSONObject object = response.getEntity(JSONObject.class);
		Gson result = new Gson();
		JsonResult json = result.fromJson(object.toString(), JsonResult.class);
		_log.info("ResponseMessage " + json.getResponseMessage());
		_log.info("Message " + json.getMessage());
		return json;
	}
	
	
	public static String getCartItems(String jsonCartItems) {
		Map resultMap = new HashMap();
		try {
			JSONObject inputJSON = new JSONObject(jsonCartItems);
			if (TarneaCommon.isValidValue(jsonCartItems)) {
				JSONArray inputJSONArray = (JSONArray) inputJSON.get("inventoryItem");
				Map headerItemMap = new HashMap();
				List batchList= new ArrayList();
				for (int i = 0; i < inputJSONArray.length(); i++) {
					JSONObject eachSrcJSONObject = inputJSONArray.getJSONObject(i);
					if (i == 0) {
						headerItemMap.put("productId",
								eachSrcJSONObject.get("productId"));
						headerItemMap.put("partyId",
								eachSrcJSONObject.get("partyId"));
					}
					JSONObject eachConvertedJSONObject = new JSONObject();
					// One object for MRP.
					eachConvertedJSONObject.put("batch",eachSrcJSONObject.get("batch"));
					eachConvertedJSONObject.put("pricePurposeId", "MRP");
					eachConvertedJSONObject.put("priceValue",eachSrcJSONObject.get("price"));
					eachConvertedJSONObject.put("modifiedByUser",eachSrcJSONObject.get("modifiedByUser"));
					batchList.add(eachConvertedJSONObject);
					// Another object for Purchase prices
					eachConvertedJSONObject = new JSONObject();
					eachConvertedJSONObject.put("batch",eachSrcJSONObject.get("batch"));
					eachConvertedJSONObject.put("pricePurposeId", "PURCHASE");
					eachConvertedJSONObject.put("priceValue",eachSrcJSONObject.get("price"));
					eachConvertedJSONObject.put("modifiedByUser",eachSrcJSONObject.get("modifiedByUser"));
					batchList.add(eachConvertedJSONObject);
				}
				resultMap.put("productDetail", headerItemMap);
				resultMap.put("batchPriceList", batchList);
				_log.info("Map is :"+resultMap);
			}
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		return resultMap.toString();
	}
	public static String getCreateOrderCartItemsToPurchase(
			String distributorPartyId, String jsonCartItems) {
		String result = "";

		LinkedHashMap<String, Object> orderHeaderMap = new LinkedHashMap<String, Object>();

		if (TarneaCommon.isValidValue(distributorPartyId)) {
			result = getCartItems(jsonCartItems);
		}
		return result;
	}
	
	public static Log _log=LogFactoryUtil.getLog(MrpAdjustmentController.class);
}