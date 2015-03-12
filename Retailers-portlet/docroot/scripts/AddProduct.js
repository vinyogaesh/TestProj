$(document).ready(function(){
	initErrorMessagereomve();
	loadParentCategory();
	disableFields();
	resetAllFlag = 1;
	resetPrincipalFlag = 1;
	//Remove this comment incase of not direct ofbiz interaction
	//initProductAutoComplete();
	initProductNameAutoComplete();
	initPrincipalAutoComplete();
	initUomAutoComplete();
	initAutoCompleteHighlight();
	initListeners();
	initSaveButtonAction();
	initValidation();
	
});

$('#idPrincipal').change(function(){
	/*hidePrincipalFields(true);*/
	/*alert("content hiding...");*/
	$(".newPdtContent").hide();
});

function initErrorMessagereomve() {
	$("#urlErrorLbl").addClass('highlightNew');
	$("#emailErrorlbl").addClass('highlightNew');
	$("#phoneErrorLbl").addClass('highlightNew');
	$("#mobileErrorLbl").addClass('highlightNew');
	$("#faxErrorLbl").addClass('highlightNew');
	$("#minErrorLbl").addClass('highlightNew');
	$("#radio_1").prop("checked",true);
}
function enableFields() {
	$("#schedul1").find("input,button,textarea").attr("disabled", false);
	$("#schedul1 tr").removeClass("nonhighlight");
	$("#schedul1 tr").addClass("highlight");
}
function disableFields() {
	//$('input:checkbox').removeAttr('checked');
	$("#schedul1").find("input,button,textarea").attr("disabled", true);
	$("#schedul1 tr").removeClass("highlight");
	$("#schedul1 tr").addClass("nonhighlight");
}
function loadParentCategory()
{
	var taxPercentageValue = $("#taxPercentage").val();
	var res = taxPercentageValue.split(",");
	for (var i=0;i < res.length;i++){
		$("#idTax").append('<option value="' + res[i] + '">' + res[i] + '</option>');
	}
	var schedule = $("#schedule").dataTable({
		"sDom": '<"top">rt<"bottom"flp><"clear">',
		"bInfo" : false,
		"fnDrawCallback": function(oSettings) {
			if ($('#example tr').length < 11) {
				$('.dataTables_paginate').hide();
			}
		}
	});
	var urlprodcate = $("#idhiddenProductCategories").val();
	$.ajax({
		type: 'GET',
		url: urlprodcate,
		async: false,
		cache:false,
		data: {
			'service': 'ProductCategories',
			'categoryType':'PHARMA_CATEGORY',
			'parentCategoryId':'SCHEDULED'
		},
		success: function(data) {
			$(".loadingImage").hide();
			var categoryList=data.productCategories;
			for(var i=0;i<categoryList.length;i++)
			{
				schedule.fnAddData(['<input type="checkbox" name="categoryLi" value="'+categoryList[i].productCategoryId+'" id="'+categoryList[i].productCategoryId+'" /><span style="font-size:12px">'+categoryList[i].productCategoryId+'</span>']);
			}
		},
		error: function() {
			$("#connectionCheckModel").modal('show');
		}
	});
	
	var urlcustomer = $("#idhiddenCustomerDetails").val();
	$.ajax({
		type: 'GET',
		url: urlcustomer,
		async: false,
		cache:false,
		data: {
			'service': 'CustomerDetails',
			'retailerPartyId':$("#clientTarneaId").val()
		},
		success: function(data) {
			$(".loadingImage").hide();
			var customerDetail=data.customerDetail;
				$("#facilityId").val(customerDetail.facilityId);
				$("#datasourceId").val(customerDetail.dataSourceId);
				$("#productStoreId").val(customerDetail.productStoreId);
				$("#productStoreGroupId").val(customerDetail.productStoreId);
				$("#partyRoleTypeId").val(customerDetail.partyTypeId);
			},
		error: function() {
			$("#connectionCheckModel").modal('show');
		}
	});
	
	var urlstate = $("#idhiddengetStates").val();
	$.ajax({
		type: 'GET',
		url: urlstate,
		async: false,
		cache:false,
		data: {
			'service': 'getStates'
		},
		success: function(data) {
			$(".loadingImage").hide();
			var statesList = data.stateList;
			for (var i=0;i < statesList.length;i++){
				$("#idState").append('<option value="' + statesList[i].geoId + '">' + statesList[i].geoName + '</option>');
			}
			},
		error: function() {
			$("#connectionCheckModel").modal('show');
		}
	});

}
function initValidation()
{
	// http://docs.jquery.com/Plugins/Validation/validate#toptions
	/*$.validator.addMethod("nameMrpValue",function(value, element) {return !/[0-9].test(value);},"Alpha Characters Only.");*/
	
	$.validator.addMethod("nameMrpValue",function(value, element) {
		/*custom method*/
		if(value > 0 ){return true;}else{return false;}},"MRP should not be Zero.");
	$.validator.addMethod("namePackageValue",function(value, element) {
		/*custom method*/
		if(value > 0 ){return true;}else{return false;}},"Package Info should not be Zero.");
	
	$.validator.addMethod("nameminStockValue",function(value, element) {
		/*custom method*/
		if($("#idMinStock").val() == 0 && $("#idMaxStock").val() == 0){return true;}
		else if(parseInt($("#idMinStock").val())<parseInt($("#idMaxStock").val())){return true;}
		else{return false;}},"");
	/*default validation*/
	$('#idNewProductForm').validate({
		rules : {
			nameProductName : {
				minlength : 3,
				required : true
			},
			namePackageInfo : {
				/*minlength : 1,*/
				required : true,
				namePackageValue :true
			},
			namePrincipal : {
				minlength : 3,
				required : true
			},
			nameMrp : {
				//minlength : 1,
				required : true,
				nameMrpValue : true
			},
			nameUom : {
				required : true
			},
			nameTax : {
				required : true
			},
			nameMinStock :{
				nameminStockValue : true
			},
			nameMaxStock :{
				nameminStockValue : true
			},
			nameGeneric : {
				//minlength : 2,
				required : true
			},
			nameState : {
				required : true
			}
			
		},
		
		/*highlight : function(element)
		{
			$(element).closest('.control-group').removeClass('success').addClass('error');
		},
		success : function(element)
		{
			element.text('OK!').addClass('valid').closest('.control-group').removeClass('error').addClass('success');
		},*/
		/*errorPlacement: function () {
            return false;
        },*/
		submitHandler : function(form)
		{
			/*callAddProductModal();*/
			submitForm(form);
		}
	});
}


function initProductNameAutoComplete()
{
	$('#idProductName').autocomplete({ source: function( request, response ) {
		$("#idProductLoadingImage").show();
		var urlprod = $("#idhiddengetProductNames").val();
		$.ajax({
			type: 'GET',
			url: urlprod,
			async: false,
			cache:false,
			data: {
				'service': 'getProductNames',
				'productName':$("#idProductName").val(),
				'limit':10
			},
			success: function(data) {
				var products = data.productList;
				var autoProducts = new Array();
				$.each(products, function(i, product)
				{
					/*autoProducts["label"] = products[i].productName;
					autoProducts["value"] = products[i].productName;
					*/autoProducts.push({
						"label" : products[i].productName,
						"value" : products[i].productName
					});
				});
				$("#idProductLoadingImage").hide();
				$(".search-box").prop('readonly', false);
				response(autoProducts);
			}
		});
	},minLength: 3,delay: 500,autoFocus:true,select : function(event, ui)
		{
			$('#idProductName').val(ui.item.label);
		return false;
		}
	});
}
/**
 * Initializes the product auto complete option and data
 */
function initProductAutoComplete()
{
	$("#idProductName").keyup(function(event)
	{
		if (resetAllFlag != 1)
		{
			/*
			 * Since user already selected a product, If he changes any thing in
			 * product name, its a new product. So clear all the fields
			 * populated earlier.
			 */
			clearForm();
			enableAllFields();
		}
		if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 65 && event.keyCode <= 90) || event.keyCode == 8)
		{

			var productName = $(this).val();
			if (productName != "")
			{
				resetAllFlag = 1;
				$("#idProductName").autocomplete({
					source : function(request, response)
					{
						$("#idProductLoadingImage").show();
						$(".search-box").prop('readonly', true);
						$.getJSON('/MasterDataMappingWeb/NewProductOfbizAction.do', {
							method : "getProductNames",
							qr : productName
						}, function(products)
						{
							var autoProducts = new Array();
							$.each(products, function(i, product)
							{
								autoProducts.push({
									"label" : product[1],
									"value" : product[1],
									"id" : product[0]
								});
							});
							$("#idProductLoadingImage").hide();
							$(".search-box").prop('readonly', false);
							response(autoProducts);
						});

					},
					select : function(event, ui)
					{
						$('#idProductName').val(ui.item.label);
						$('#hdnProductId').val(ui.item.id);
						loadProductDetails(ui.item.id);
						disableAllFields();
						resetAllFlag = 0;// So i should not clear form fields as I just populated them.
						return false;
					}
				});

			}
		}
	});
}

/**
 * Loads the form with the data retrieved from server.
 * 
 * @param productId
 */
function loadProductDetails(productId)
{
	$.getJSON('/MasterDataMappingWeb/NewProductOfbizAction.do', {
		method : "getProductDetails",
		pId : productId
	}, function(productDetails)
	{
		$("#idPrincipal").val(productDetails.PrincipalName);
		$("#hdnPrincipalId").val(productDetails.PrincipalMasterId);
		$("idMobile").val(productDetails.PrincipalMobile);
		$("#idPhone").val(productDetails.PrincipalPhone1);
		$("#idState").val(productDetails.PrincipalState);
		$("#idTin").val(productDetails.PrincipalTinNumber);
		$("#idUrl").val(productDetails.PrincipalUrl);
		$("#idAddress").val(productDetails.PrincipalAddress1);
		$("#idEmail").val(productDetails.PrincipalPrimaryEmail);
		$("#idCity").val(productDetails.PrincipalCity);
		$("#idPincode").val(productDetails.PrincipalPincode);
		$("#idFax").val(productDetails.PrincipalFax);
		$("#idStrength").val(productDetails.Strength);
		$("#idMrp").val(productDetails.Mrp);
		$("#idMinStock").val(0);
		$("#idReorderLevel").val(0);
		$("#idUom").val(productDetails.Uom);
		$("#idTax").val(0);
		$("#idPackageInfo").val(productDetails.PackageInfo);
		$("#idMaxStock").val(0);
		$("#idGenericName").val(productDetails.GenericName);
	});
}

function loadPrincipalDetails(principalId)
{
	$.getJSON('/MasterDataMappingWeb/NewProductOfbizAction.do', {
		method : "getPrincipalDetails",
		pId : principalId
	}, function(principalDetails)
	{
		$("#idPrincipal").val(principalDetails.PrincipalName);
		$("#hdnPrincipalId").val(principalDetails.PrincipalMasterId);
		$("idMobile").val(principalDetails.PrincipalMobile);
		$("#idPhone").val(principalDetails.PrincipalPhone1);
		$("#idState").val(principalDetails.PrincipalState);
		$("#idTin").val(principalDetails.PrincipalTinNumber);
		$("#idUrl").val(principalDetails.PrincipalUrl);
		$("#idAddress").val(principalDetails.PrincipalAddress1);
		$("#idEmail").val(principalDetails.PrincipalPrimaryEmail);
		$("#idCity").val(principalDetails.PrincipalCity);
		$("#idPincode").val(principalDetails.PrincipalPincode);
		$("#idFax").val(principalDetails.PrincipalFax);
	});
}
/**
 * Initializes auto complete option for principal names
 */
function initPrincipalAutoComplete()
{
	
	/*$("#idPrincipal").keyup(function(event)
	 * */
	$("#idPrincipal").focus(function(){
		/*vinoth modified because after selecting principal principal address filed showing .... this code use for hiding..
		 * if focus is on idPrincipal then it will call keyupevent 
		 * 
		 */
		$("#idPrincipal").keyup(function(event){
		if (resetPrincipalFlag != 1)
			{
				/*
				 * Since user already selected a product, If he changes any thing in
				 * product name, its a new product. So clear all the fields
				 * populated earlier.
				 */
				clearPrincipalForm();

				//Remove this comment incase of not direct ofbiz interaction
				//disablePrincipalFields(false);
				showPrincipalFields();
			}
				resetPrincipalFlag = 1;
					$('#idPrincipal').autocomplete({ source: function( request, response ) {
						$("#idPrincipalLoadingImage").show();
						var urlPrincipal = $("#idhiddengetPrincipalNames").val();
						$.ajax({
							type: 'GET',
							url: urlPrincipal,
							async: false,
							cache:false,
							data: {
								'service': 'getPrincipalNames',
								'principalName':$("#idPrincipal").val(),
								'limit':10,
								'distinctManufactureName':'y'
							},
							success: function(data) {
								var principals = data.manufacturerList;
								var autoPrincipals = new Array();
								$.each(principals, function(i, principal)
								{
									autoPrincipals.push({
										"label" : principal.groupName,
										"value" : principal.groupName,
										"id" : principal.partyId
									});
								});
								$("#idPrincipalLoadingImage").hide();
								$(".search-box").prop('readonly', false);
								response(autoPrincipals);
							}
						});
					},minLength: 3,autoFocus:true,select : function(event, ui)
						{
						$('#idPrincipal').val(ui.item.label);
						$('#hdnPrincipalId').val(ui.item.id);
						//Remove this comment incase of not direct ofbiz interaction
						//loadPrincipalDetails(ui.item.id);
						//disablePrincipalFields(true);
						resetPrincipalFlag = 0;// So i should not clear
						hidePrincipalFields(true);
						$("#btnIdSave").focus();
						// form fields
						// as I just populated them.
						return false;
						}
					});
		});
	});
}

/**
 * Initializes the uom auto complete option and data
 */
function initUomAutoComplete()
{
		var uom = $("#idUom").val();
			$("#idUom").autocomplete({
				source : function( request, response ){
					$("#idUomLoadingImage").show();
					$(".search-box").prop('readonly', true);
					var urlUom = $("#idhiddengetUomList").val();
					$.ajax({
					type: 'GET',
					url: urlUom,
					async: false,
					cache:false,
					data: {
						'service': 'getUomList',
							'searchKey':$("#idUom").val(),
							'limit':10
					},
					success: function(data) {
						var uoms = data.uomList;
						var autoUoms = new Array();
						$.each(uoms, function(i, principal)
						{
							autoUoms.push({
								"label" : uoms[i].uomId,
								"value" : uoms[i].uomId,
							});
						});
						$("#idUomLoadingImage").hide();
						$(".search-box").prop('readonly', false);
						response(autoUoms);
					}
				})},
				minLength:1,
				delay:500,
				autoFocus:true,
				select : function(event, ui)
				{
					$('#idUom').val(ui.item.label);
					return false;
				},
				change : function(event, ui)
				{
					if (ui.item == null || ui.item == undefined)
					{
						$("#alertModal").modal('show');
						//$("#btnInOk").focus();
						/*alert("Invalid Type");*/
						$("#spanHeader").html("Invalid Type");
						$("#divMessage").html("Please choose Type from suggested list.");
						$("#idUom").val("");
						$("#idUom").attr("disabled", false);
					} else
					{
						//$("#idUom").attr("disabled", true);
					}
				}
			});
}
/**
 * Initializes highlight option for auto complete search texts
 */
function initAutoCompleteHighlight()
{
	String.prototype.replaceAt = function(index, char)
	{
		return this.substr(0, index) + "<span style='font-weight:bold;color:Red;'>" + char + "</span>";
	};

	$.ui.autocomplete.prototype._renderItem = function(ul, item)
	{
		this.term = this.term.toLowerCase();
		var resultStr = item.label.toLowerCase();
		var tmp = item.label;
		var t = "";
		while (resultStr.indexOf(this.term) != -1)
		{
			var index = resultStr.indexOf(this.term);
			t = t + tmp.replaceAt(index, tmp.slice(index, index + this.term.length));
			resultStr = resultStr.substr(index + this.term.length);
			tmp = tmp.substr(index + this.term.length);
		}
		return $("<li></li>").data("item.autocomplete", item).append("<a>" + t + tmp + "</a>").appendTo(ul);

	};
}
/**
 * Clears all the text boxes except product name text box.
 */
function clearForm()
{
	$.each($("input[type='text']"), function()
	{
		if (this.id != "idProductName")
		{
			this.value = "";
		}
	});
	$("#hdnProductId").val("");
}

/**
 * Clears principal detail text boxes.
 */
function clearPrincipalForm()
{
	$("#idMobile").val("");
	$("#idPhone").val("");
	$("#idState").val("");
	$("#idTin").val("");
	$("#idUrl").val("");
	$("#idAddress").val("");
	$("#idEmail").val("");
	$("#idCity").val("");
	$("#idPincode").val("");
	$("#idFax").val("");

	$("#hdnPrincipalId").val("");
}

/**
 * Enables All form fields
 */
function enableAllFields()
{
	$.each($("input[type='text']"), function()
	{
		$(this).prop('readonly', false);
	});
}
/**
 * Enables/Disables Principal data fields based on the param
 */
function disablePrincipalFields(status)
{
	$("#idMobile").prop("readonly", status);
	$("#idPhone").prop("readonly", status);
	$("#idState").prop("readonly", status);
	$("#idTin").prop("readonly", status);
	$("#idUrl").prop("readonly", status);
	$("#idAddress").prop("readonly", status);
	$("#idEmail").prop("readonly", status);
	$("#idCity").prop("readonly", status);
	$("#idPincode").prop("readonly", status);
	$("#idFax").prop("readonly", status);
}

function hidePrincipalFields(status)
{
	$(".newPdtContent").hide();
}
function showPrincipalFields()
{
	$(".newPdtContent").show();
}
/**
 * Disables all form fields except Productname, mrp, tax, min and max stock,
 * reorder level.
 */
function disableAllFields()
{
	$.each($("input[type='text']"), function()
	{
		if (this.id != "idProductName" && this.id != "idMrp" && this.id != "idTax" && this.id != "idMinStock" && this.id != "idMaxStock" && this.id != "idReorderLevel")
		{
			$(this).prop('readonly', true);
		}
	});
}

function submitForm(form)
{
	$("#waitModal").modal('show');
	
	var array = jQuery(form).serializeArray();
    var json = {};
    jQuery.each(array, function() {
    	if(this.name=="nameReorderLevel" || this.name== "nameMinStock" || this.name=="nameMaxStock")
    		{
    			//this.value=this.value.substring(0, this.value.length - 2);
    			if(this.value == "" || this.value == null)
    				{
    					this.value = 0;
    				}
    			json[this.name] = this.value.trim() || '0';
    		}
    	else
    		{
    			json[this.name] = this.value.trim() || '';
    		}
    	   
    });
    
    //initiate all values
    
    
	if ($("#radio").prop("checked")) {
		// do something
		var checkboxes = document.getElementsByName('categoryLi');
		var jsonArr = [];
		for (var i=0, n=checkboxes.length;i<n;i++) {
			if (checkboxes[i].checked) 
			{
				jsonArr.push(checkboxes[i].value);

			}
		}
	}
		
	else
	{
		var checkboxes = document.getElementsByName('categoryLi');
		var jsonArr = [];
	}
    
	if( json.namePrincipalId =="" || json.namePrincipalId ==null )
	{
		var manufactureDetail ={};
		var prod ={};
		prod={
			    "productName":json.nameProductName,
	    		"manufacturerPartyId":"",
	    		"productStoreGroupId":$("#productStoreGroupId").val(),
	    		"uom":json.nameUom,
	    		"externalId":json.nameExternalProductId,
	    		"minStock":json.nameMinStock,
	    		"partyId":json.clientTarneaId,
	    		"categoryId":jsonArr,
	    		"dataSourceId":$("#datasourceId").val(),
	    		"maxStock":json.nameMaxStock,
	    		"facilityId": $("#facilityId").val(),
	    	    "mrp": json.nameMrp,
	    	    "taxPercentage": json.nameTax,
	    	    "genericName": json.nameGeneric,
	    	    "conversionFactor": json.namePackageInfo,
	    	    "productStoreId": $("#productStoreId").val(),
	    	    "partyRoleTypeId": $("#partyRoleTypeId").val(),
	    	    "reorderLevel": json.nameReorderLevel,
	    	    "manufactureDetail": {
	    			    "organizationPartyId":json.clientTarneaId,
	    			    "organizationPartyType": $("#partyRoleTypeId").val(),
	    			    "partyType": "MANUFACTURER",
	    			    "dataSourceId": $("#datasourceId").val(),
	    			   // "externalPartyId": json.nameExtrPartyId,
	    			    "partyName": json.namePrincipal,
	    			    "telephoneNumber": json.namePhone,
	    			    "mobileNumber": json.nameMobile,
	    			    "emailId": json.nameEmail,
	    			    "state":json.nameState,
	    			    "url":json.nameUrl,
	    			    "address1": json.nameAddress,
	    			    "city": json.nameCity,
	    			    "postalCode": json.namePincode,
	    			    "cstNumber": json.nameCst,
	    			    "tnGstNumber": json.nameTnGst,
	    			    "dlNumber": json.nameDl,
	    			    "tinNumber": json.nameTin,
	    			    //"productMargin": json.namePrdMargin,
	    			    //"productDiscount": json.namePrdDisc,
	    			    //"creditLimit": json.nameCrLimit,
	    			    //"creditDays": json.nameCrDays,
	    			    //"creditBalance": json.nameCrBalance,
	    			    "createdByUser": $("#idCreatedUser").val()
	    		}
			};
		//I'm Just Calling function for posting product
	    postProduct(prod);

	}
	else
	{
		var JSONObj = {};
	    JSONObj = {
	    		
	    		"productName":json.nameProductName,
	    		"manufacturerPartyId":json.namePrincipalId,
	    		"productStoreGroupId":$("#productStoreGroupId").val(),
	    		"uom":json.nameUom,
	    		"externalId":json.nameExternalProductId,
	    		"minStock":json.nameMinStock,
	    		"partyId":json.clientTarneaId,
	    		"categoryId":jsonArr,
	    		"dataSourceId":$("#datasourceId").val(),
	    		"maxStock":json.nameMaxStock,
	    		"facilityId": $("#facilityId").val(),
	    	    "mrp": json.nameMrp,
	    	    "taxPercentage": json.nameTax,
	    	    "genericName": json.nameGeneric,
	    	    "conversionFactor": json.namePackageInfo,
	    	    "productStoreId": $("#productStoreId").val(),
	    	    "partyRoleTypeId": $("#partyRoleTypeId").val(),
	    	    "reorderLevel": json.nameReorderLevel
	 };
	
	    //I'm Just Calling function for posting product
	    postProduct(JSONObj);
		
	}
}

/**
 * Posting Product after successfull posting Manufacturer
 */
function postProduct(JSONObj)
{
	var url = $("#idhiddenAddingProduct").val();
	$.ajax({
	type : 'POST',
	url : url,
	async : false,
	cache:false,
	data : {
		'service' : 'AddingProduct',
		'addProductPost':JSON.stringify(JSONObj)
	},
	success : function(data) {
		if(data.responseMessage == "success")
		{
			$("#waitModal").modal('hide');
			$("#alertModal").modal('show');
			$("#spanHeader").html("Success!");
			$("#divMessage").html("Product request sent successfully!.");
			resetForm();
			
		}
		else
		{
			$("#waitModal").modal('hide');
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);
		}
	},
	error : function(data)
	{
		$("#waitModal").modal('hide');
		$("#alertModal").modal('show');
		$("#spanHeader").html("Failure");
		$("#divMessage").html(data.status);
	}
});
	
}


/**
 * Initializes save button action
 */
function initSaveButtonAction()
{
	$("#btnSave").click(function()
	{
		$("#myModal").modal('hide');
		if ($('#hdnProductId').val() != "")
		{
			// This method will not force validation.
			// Since this is master product.
			submitForm($("#idNewProductForm"));
		} else
		{
			// This will force the validation.
			$("#idNewProductForm").submit();
			/*callAddProductModal();*/
		}
	});
}

/**
 * Shows confirmation popup.
 */
function showSavePopUp()
{
	//if($("#radio_1").prop("checked",true);)
	var isChecked = $('#radio').attr('checked')?true:false;
	if(isChecked == true)
	{
		//$('#radio').attr('checked')
		var atLeastOneIsChecked = $('input[name="categoryLi"]:checked').length;
		if(atLeastOneIsChecked > 0)
		{
			/*callAddProductModal();*/
			$("#myModal").modal('show');
		}
		else
		{
			$("#schduleCheckModel").modal('show');
		}
	}
	else
	{
		/*callAddProductModal();*/
		$("#myModal").modal('show');
	}	
}

function resetForm()
{
	$('#idNewProductForm').each(function()
	{
		this.reset(); // Here form fields will be cleared.
	});
	enableAllFields();
	clearPrincipalForm();
	//Remove this comment incase of not direct ofbiz interaction
	//disablePrincipalFields(false);
	showPrincipalFields();
	//for default disable category
	$("#radio_1").prop("checked",true);
	disableFields();
	
	
	
}

/**
 * prompts mrp with selected package info and uom.
 */
function initListeners()
{
	$("#idMrp, #idPackageInfo, #idUom").blur(function()
	{
		var packageInfo = $("#idPackageInfo").val();
		var uom = $("#idUom").val();
		var mrp = $("#idMrp").val();
		if (mrp !== "" && packageInfo !== "" && uom !== "")
		{
			if (packageInfo.indexOf("'") != -1)
			{
				packageInfo = packageInfo.substring(0, packageInfo.indexOf("'"));
			} else
			{
				//packageInfo = "1 ".concat(packageInfo);
				packageInfo = " ".concat(packageInfo);
			}
			$("#alertModal").modal('show');
			$("#spanHeader").html("Please check..!");
			$("#divMessage").html("You have chosen price (Mrp) : <span style='color:red'>Rs." + mrp + "</span> for <span style='color:red'>" + packageInfo + " " + uom + ".</span>");
		}
	});

	/*$('#alertModalTest').keypress(function(e)
	{
		if (e.keyCode == $.ui.keyCode.ENTER)
		{
			$("#alertModalTest").modal('hide');
			$("#idTax").focus();
		}
	});*/
	$('#alertModal').keypress(function(e)
			{
				if (e.keyCode == $.ui.keyCode.ENTER)
				{
					$("#alertModal").modal('hide');
					if($("#idUom").val()=="" || $("#idUom").val()==null )
					{
						$("#idUom").focus();
					}
					else
					{
						/*alert()*/
						$("#idTax").focus();
					}
						
					
				}
			});
	
}
