package com.tarnea.common;

import com.liferay.portal.kernel.util.PropsUtil;

public class PortalConstant {
	
	/**
	 * @category Common for all Portal
	 * @see Common Constant For All Portals
	 * @author vinoth
	 */
	
	public static String SERVICE_HOST = "https://sportal.tarnea.com:8443/restcomponent/"; //202.154.165.68, 192.168.2.21, 172.30.155.68
	public static String SERVICE_PARAMETER_VALUE_USERNAME = "TarneaSyncManager";
	public static String SERVICE_PARAMETER_VALUE_PASSWORD = "T@rne@SyncM@n@ger";
		
//	public static  String SERVICE_HOST = PropsUtil.get("ofiz.rest.pharma.host");
//	public static String SERVICE_PARAMETER_VALUE_USERNAME = PropsUtil.get("ofiz.rest.pharma.username");
//	public static String SERVICE_PARAMETER_VALUE_PASSWORD = PropsUtil.get("ofiz.rest.pharma.password");
	
	public static String SERVICE_PARAMETER_KEY_USERNAME = "login.username";
	public static String SERVICE_PARAMETER_KEY_PASSWORD = "login.password";
	public static String SERVICE_PARAMETER_KEY_PARTY_ID = "partyId";
	public static String SERVICE_PARAMETER_KEY_CONTENT_TYPE = "Content-Type";
	
	public static String SERVICE_PARAMETER_VALUE_CONTENT_TYPE = "application/json";

	public static String SERVLET_PARAMETER_KEY_NAME_SERVICE = "service";
	public static String SERVLET_PARAMETER_KEY_NAME_SEARCH = "search";
	public static String SERVLET_PARAMETER_KEY_NAME_PARTYID = "targetPartyId";
	public static String SERVLET_PARAMETER_KEY_NAME_PRODUCTID = "productId";
	public static String SERVLET_PARAMETER_KEY_NAME_PRODUCTNAME = "productName";
	public static String SERVLET_PARAMETER_KEY_NAME_PRODUCTLIST = "productList";

	public static String SERVICE_PARAMETER_KEY_VALUE_PRODUCTSEARCH = "ProductSearch";
	public static String SERVICE_PARAMETER_KEY_VALUE_PRODUCTCATEGORIES = "ProductCategories";
	public static String SERVICE_PARAMETER_KEY_VALUE_PRODUCTCATEGORYMEMBERS = "productCategoryMembers";

	public static String SEARCH_STRING_PARTYID = "targetPartyId=";
	public static String SEARCH_STRING_CATEGORYTYPEID = "categoryType=";
	public static String SEARCH_STRING_PRINCIPALNAMEKEY = "searchKey=";
	public static String SEARCH_STRING_UOMNAMEKEY = "searchKey=";
	public static String SEARCH_STRING_UOMLIMITKEY = "limit=";
	public static String SEARCH_STRING_DISTINCTMANUFACTUREKEY = "distinctManufactureName=";

	public static String SEARCH_STRING_RETAIL_PARTYID = "retailerPartyId=";
	public static String SEARCH_STRING_PARENTCATEGORYTYPEID = "parentCategory=";
	public static String SEARCH_STRING_PRODUCTID = "productId=";
	public static String SEARCH_STRING_PRODUCTNAME = "productName=";
	public static String SEARCH_STRING_ROLETYPEID = "roleTypeId=";

	public static String SEARCH_VALUE_ROLETYPEID_BILL_FROM_VENDOR = "BILL_FROM_VENDOR";
	public static String SEARCH_VALUE_SUPPLIER = "BILL_FROM_VENDOR";
	
	public static String RESPONSE_STATUS_VALUE_SUCCESS = "success";
	
	public static String SEARCH_VALUE_TAX_PER = "0,5,14.5";
	
	public static  String SERVICE_SEARCH_STRING_PARTYID = "partyId=";
	public static  String SERVLET_PARAMETER_KEY_NAME_BATCHID = "batchId";
	public static  String SERVLET_PARAMETER_KEY_NAME_ORDERHEADER = "orderHeader";
	public static  String SERVICE_PARAMETER_KEY_VALUE_PRODUCTDETAIL = "ProductDetail";	
	public static  String SERVICE_PARAMETER_KEY_VALUE_POST_SINGLE_ORDER = "PostSingleOrder";	
	
    public static String SERVICE_PARAMETER_KEY_NAME_FROMPARTYID = "partyIdFrom=";
    public static String SERVICE_PARAMETER_KEY_NAME_TOPARTYID = "partyIdTo=";
    public static String SERVICE_PARAMETER_KEY_NAME_AUTHORID="authorId=";
    
    public static String SERVICE_PARAMETER_KEY_NAME_CREATEDDATE="cratedDate=";
    public static String SERVICE_PARAMETER_KEY_NAME_ROLETYPEID = "roleTypeId=";
    public static String SERVICE_PARAMETER_KEY_NAME_ROLETYPEIDFROM = "roleTypeIdFrom=";

    public static String SERVICE_PARAMETER_NAME_ROLETYPEIDFROM = "CUSTOMER";
    public static String SERVICE_PARAMETER_KEY_NAME_INVOICETYPEID = "invoiceTypeId=";
    public static  String SERVICE_PARAMETER_KEY_ROLETYPEID = "roleTypeId=";
    public static  String SERVICE_PARAMETER_KEY_PARTYIDTO = "toPartyId=";
    public static  String SERVICE_PARAMETER_KEY_PARTYIDFROM = "fromPartyId=";
    
    public static  String SERVICE_PARAMETER_VALUE_SUPPLIER = "SUPPLIER";
    public static  String SERVICE_PARAMETER_VALUE_RETAILER = "RETAILER";
    public static  String SERVICE_PARAMETER_VALUE_CUSTOMER = "CUSTOMER";
    
    public static  String SERVICE_PARAMETER_VALUE_PARENT_CATEGORY_TYPE_ID="SCHEDULED";
   
    public static  String SERVICE_PARAMETER_KEY_COMPANYNAME = "companyName=";
	public static  String SERVICE_PARAMETER_KEY_TIN = "tin=";
	public static  String SERVICE_PARAMETER_KEY_AREA = "areaName=";
	
	
    public static String SERVICE_PARAMETER_KEY_NAME_LOYALITYSTATUS ="loyaltyStatusId=";
    public static String SERVICE_PARAMETER_KEY_VALUE_LOYALITYSTATUS ="LOYALTY_APPLIED";
    public static String SERVICE_PARAMETER_KEY_VALUE_LOYALITYSTATUSAPPOVED ="LOYALTY_APPROVED";
    public static String SERVICE_PARAMETER_KEY_NAME_START_INDEX = "startIndex="; 
    public static String SERVICE_PARAMETERl_KEY_NAME_LIMIT = "limit=";
    
	public static String SERVICE_PARAMETER_KEY_NAME_productStoreId = "productStoreId=";
	public static String SERVICE_PARAMETERl_KEY_NAME_FNACCONTID = "finAccountId=";
	public static String SERVICE_PARAMETERl_KEY_NAME_PRODUCTSTOREID ="productStoreId=";
	public static String SERVICE_PARAMETERl_KEY_NAME_PURPOSEENUMID ="purposeEnumId=";
	public static String SERVICE_PARAMETER_KEY_NAME_ORG_PARTY_ID = "organizationPartyId=";
	
	public static String SERVICE_PARAMETR_KEY_NAME_PRODUCTSTOREGROUPID = "productStoreGroupId=";
    public static String SERVICE_PARAMETR_KEY_NAME_GROUPNAME = "groupName=";
    public static String SERVICE_PARAMETR_KEY_NAME_PARTNAME = "partName=";
    public static String SERVICE_PARAMETR_KEY_NAME_PARTNO = "partNumber=";
	
	    
}