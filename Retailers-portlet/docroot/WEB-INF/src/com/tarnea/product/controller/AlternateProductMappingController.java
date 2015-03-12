
package com.tarnea.product.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import com.google.gson.Gson;
import com.liferay.portal.util.PortalUtil;
import com.tarnea.common.TarneaCommon;
import com.tarnea.product.utils.AlternateProductUtils;
import com.tarnea.rest.RestClient;

@Controller(value = "AlternateProductMappingController")
@RequestMapping("VIEW")
public class AlternateProductMappingController {
	
	public static String targetPartyId;
	public static String  result="";
	public static String targetPartyName="";
	/**
	 * Rendering to the file upload home page
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RenderMapping
	public String handleRenderRequest(RenderRequest request, RenderResponse response, Model model) {
		targetPartyId = TarneaCommon.getTargetPartyId(request);
		RestClient.partyId = targetPartyId;
		model.addAttribute("targetPartyId", targetPartyId);
		long userId = PortalUtil.getUserId(request);
		targetPartyName = PortalUtil.getUserName(userId, null);
		model.addAttribute("createdUser",targetPartyName);
		return "AlternateProducts";
	}
	
	@ResourceMapping(value="getPartyDetails")
    public void PartyDetails(ResourceRequest request,ResourceResponse response) throws IOException{
    	result = AlternateProductUtils.getPartyDetailAsObject(targetPartyId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="ProductSearch")
	public void ProductSearch(ResourceRequest request,ResourceResponse response) throws IOException{
		String roleTypeId = request.getParameter("partyTypeId");//SERVICE_PARAMETER_VALUE_RETAILER;
		String ProductSearchKe = request.getParameter("partNo");
		String Limit = request.getParameter("limit");
		_log.info("role Type Id :: "+roleTypeId);
		result = AlternateProductUtils.getProductListAsObject(ProductSearchKe, Limit,targetPartyId,roleTypeId);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
	}
    
    @ResourceMapping(value="GetAllAlternateRegReq")
    public void getAllAlternateProducts(ResourceRequest request,ResourceResponse response) throws IOException{
    	String startIndex=request.getParameter("startIndex");
    	String limit=request.getParameter("limit");
    	String productStoreGroupId = request.getParameter("productStoreGroupId");
    	String partSelNo = request.getParameter("partSelNo");
    	String grpSelName = request.getParameter("grpSelName");
    	String partSelName = request.getParameter("partSelName");
    	_log.info("Start Index :: "+startIndex);
    	_log.info("Limit :: "+limit);
    	_log.info("organizationPartyId :: "+productStoreGroupId);
    	_log.info("partSelNo :: "+partSelNo);
    	_log.info("grpSelName :: "+grpSelName);
    	_log.info("partSelName :: "+partSelName);
    	result = getJsonForAlternateProductsLists(startIndex,limit,productStoreGroupId,partSelNo,grpSelName,partSelName);	
    	_log.info("Result :: "+result);
    	response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result);
    }
    
    @ResourceMapping(value="ActionPostUrl")
    public void postAlternateProduct(ResourceRequest request,ResourceResponse response) throws IOException, JSONException{
    	String oldList = request.getParameter("oldList");
    	String newList = request.getParameter("newList");
    	String grpname = request.getParameter("grpName");
    	String prdStrGrpId = request.getParameter("prdStrGrpId");
    	String editFlag = request.getParameter("editFlag");
    	_log.info("Old List :: "+oldList);
    	_log.info("New List :: "+newList);
    	List<Map<String, String>> oldAlterList = AlternateProductUtils.getCartItems(oldList);
    	List<Map<String, String>> newAlterList = AlternateProductUtils.getCartItems(newList);
    	_log.info("String : "+oldAlterList);
    	_log.info("String : "+newAlterList);
    	JSONObject allPostJson;
    	if(editFlag.equalsIgnoreCase("true")){
        	allPostJson = new JSONObject();
        	JSONArray allPrePostJson = new JSONArray();
        	for(int i=0;i<oldAlterList.size();i++){
        		if(newAlterList.contains(oldAlterList.get(i))){
        		}else{
        			JSONObject jsonPrd = new JSONObject();
        			jsonPrd.put("productId",oldAlterList.get(i).get("prdId"));
        			jsonPrd.put("productAssocTypeId", "PRODUCT_ALTERNATE");
        			jsonPrd.put("groupName",grpname);
        			jsonPrd.put("logedInUserName","");
        			jsonPrd.put("fromDate",oldAlterList.get(i).get("fromDate"));
        			jsonPrd.put("action", "REMOVE");
        			allPrePostJson.put(jsonPrd);
        		}
        	}
        	for(int j=0;j<newAlterList.size();j++){
        		if(oldAlterList.contains(newAlterList.get(j))){
        		}else{
        			JSONObject jsonPrd = new JSONObject();
        			jsonPrd.put("productId",newAlterList.get(j).get("prdId"));
        			jsonPrd.put("productAssocTypeId", "PRODUCT_ALTERNATE");
        			jsonPrd.put("groupName",grpname);
        			jsonPrd.put("logedInUserName",targetPartyName);
        			jsonPrd.put("action", "ADD");
        			allPrePostJson.put(jsonPrd);
        		}
        	}
        	
        	allPostJson.put("productStoreGroupId", prdStrGrpId);
        	allPostJson.put("values",allPrePostJson);
        	//result = 
    	}else{
    		allPostJson = new JSONObject();
        	JSONArray allPrePostJson = new JSONArray();
    		for(int j=0;j<newAlterList.size();j++){
        			JSONObject jsonPrd = new JSONObject();
        			jsonPrd.put("productId",newAlterList.get(j).get("prdId"));
        			jsonPrd.put("productAssocTypeId", "PRODUCT_ALTERNATE");
        			jsonPrd.put("groupName",grpname);
        			jsonPrd.put("logedInUserName",targetPartyName);
        			jsonPrd.put("action", "ADD");
        			allPrePostJson.put(jsonPrd);
        	}
        	allPostJson.put("productStoreGroupId", prdStrGrpId);
        	allPostJson.put("values",allPrePostJson);
    	}
    	_log.info(allPostJson.toString());
    	result = postJsonForRuleUpdate(allPostJson.toString());
    	response.setContentType("application/json");
    	response.setCharacterEncoding("UTF-8");
    	response.getWriter().write(result);
    }
    
    /**  
     * postJsonForRuleUpdate
     * @return
     */
	private String postJsonForRuleUpdate(String ruleUpdate) throws IOException {
		String JsonForAlternateProductUpdate = AlternateProductUtils.postAlternateProductUpdateAsObject(ruleUpdate);
		return JsonForAlternateProductUpdate;
	}
	
    public String getJsonForAlternateProductsLists(String startIndex,String limit,String productStoreGroupId, String partSelNo, String grpSelName, String partSelName){
    	String alternateProds = AlternateProductUtils.getAlternateProductListAsObject(startIndex, limit,productStoreGroupId,partSelNo,grpSelName,partSelName);
    	return alternateProds;
    }
	private static Log _log = LogFactory.getLog(AlternateProductMappingController.class);    
}