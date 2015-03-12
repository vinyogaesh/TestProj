/**
 * While Page Starts
 */
$(document).ready(function() {
	initPageAction();
	initProductNameAutoComplete();
	initAutoCompleteHighlight();
	initValidation();
	
});

/**
 * Initial Validation
 */
function initValidation(){
	$("#frmLstDiscVal").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) || 
             // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
}

/**
 * Page Initiation Action
 */
function initPageAction(){
	
	var urlPartyDeail = $("#idhiddenPartyDetails").val();
	$.ajax({
		type: 'GET',
		url: urlPartyDeail,
		async:false,
		cache:false,
		success: function(data) {
			/*alert(JSON.stringify(data));*/
			$("#idHdnPartyTypeId").val(data.customerDetail.partyTypeId);
			/*$("#idHdnProductStoreId").val(data.customerDetail.productStoreId);*/
		},
		error : function(data){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);
		}
	});

	/**
	 * Get Server Date
	 */
	/*var urlServerDateDeail = $("#idurlServerDateDeail").val();
	$.ajax({
		type: 'GET',
		url: urlServerDateDeail,
		async:false,
		cache:false,
		success: function(data) {
			alert(JSON.stringify(data));
			
		},
		error : function(data){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);
		}
	});*/
	formHides();
	initiateAction();
	$("#btnEdit").click(function(){
		$("#frmLstDiscVal").prop('readonly',false);
		$("#frmLstDiscBut").attr("disabled",false);
		$("#btnEdit").hide();
		$("#btnSave").show();
    });
	$("#btnCancel").click(function(){
		resetForm();
    });
	
	$("#frmLstDiscVal").keyup(function(){
		var priceActionId = "";
		var pAi = $('.dropdown-menu li.selectedLi').attr('id');
		if(pAi == "" || pAi == null || pAi == undefined ){
			priceActionId = "PRICE_POL";
		}else{
			priceActionId = pAi;
		}
		if($(this).val() > 0){
			//getDiscountValue($(this).val(), priceActionId);
			
			if(isNaN(getDiscountValue(priceActionId,$(this).val(),"LSP").toFixed(2))){
				$("#lspDiscVal").text("NA");
			}else{
				$("#lspDiscVal").text(getDiscountValue(priceActionId,$(this).val(),"LSP").toFixed(2));
			}
			
			if(isNaN(getDiscountValue(priceActionId,$(this).val(),"HSP").toFixed(2))){
				$("#hspDiscVal").text("NA");
			}else{
				$("#hspDiscVal").text(getDiscountValue(priceActionId,$(this).val(),"HSP").toFixed(2));
			}

			var aflsVal = $("#frmLstPriceLsp").text()-getDiscountValue(priceActionId,$(this).val(),"LSP");
			var afhsVal = $("#frmLstPriceHsp").text()-getDiscountValue(priceActionId,$(this).val(),"HSP");
			if(isNaN(aflsVal)){
				$("#lspDiscAmtVal").text("NA");
			}else{
				//$("#lspDiscAmtVal").text("NA");
				$("#lspDiscAmtVal").text(aflsVal.toFixed(2));
			}
			
			if(isNaN(afhsVal)){
				$("#hspDiscAmtVal").text("NA");
			}else{
				$("#hspDiscAmtVal").text(afhsVal.toFixed(2));
			}
			
		}else{
			$("#lspDiscVal").text('0.00');
			$("#hspDiscVal").text('0.00');
			$("#lspDiscAmtVal").text('0.00');
			$("#hspDiscAmtVal").text('0.00');
		}
	});
	
	$("#frmLstDiscVal").keypress(function(){
		var priceActionId = "";
		var pAi = $('.dropdown-menu li.selectedLi').attr('id');
		if(pAi == "" || pAi == null || pAi == undefined ){
			priceActionId = "PRICE_POL";
		}else{
			priceActionId = pAi;
		}
		if($(this).val() > 0){
			return $(this).val();
		}
		if($(this).val() >= 100.01 && priceActionId == "PRICE_POL"){
			return 0;
		}
		if($(this).val() >= $("#frmLstPriceHsp").text() && priceActionId == "PRICE_FOL"){
			return 0;
		}
	});
	
$("#frlLstMet").click(function(){
	$("#frmLstDiscVal").val('');
	$("#lspDiscVal").text('0.00');
	$("#hspDiscVal").text('0.00');
	$("#lspDiscAmtVal").text('0.00');
	$("#hspDiscAmtVal").text('0.00');
});
	
}

/**
 * Create Discount or Edit Existing Discount
 */
function CreateDiscount(){
	var priceActionId = "";
	var pAi = $('.dropdown-menu li.selectedLi').attr('id');
	if(pAi == "" || pAi == null || pAi == undefined ){
		priceActionId = "PRICE_POL";
	}else{
		priceActionId = pAi;
	}
	
	var ISTFrom = $("#frmdate").val().split("-"); 
	ISTFrom = new Date(ISTFrom[2], ISTFrom[1] - 1, ISTFrom[0]);
	var ISTTo = $("#toDate").val().split("-");
	ISTTo = new Date(ISTTo[2], ISTTo[1] - 1, ISTTo[0]);
	var currentDateFrm = ISTFrom.getDate();
	if(currentDateFrm<10){
		currentDateFrm='0'+currentDateFrm;
    }
	var currentDateTo = ISTTo.getDate();
	if(currentDateTo<10){
		currentDateTo='0'+currentDateTo;
    }
	var currentMonthFrm = (ISTFrom.getMonth()+1);
    if(currentMonthFrm<10){
    	currentMonthFrm='0'+currentMonthFrm;
    }
    var currentMonthTo = (ISTTo.getMonth()+1);
    if(currentMonthTo<10){
    	currentMonthTo='0'+currentMonthTo;
    }
	
	var prodJsonValue = {};
	var prodDescValue = {
			/*"productStoreId":$("#idHdnProductStoreId").val(),*/
			"partyId": $("#TarneaPartyId").val(),
			"productId": $("#hdnProductId").val(),
			"productName": $("#frmLstPartNum").text(),
			"amount": $("#frmLstDiscVal").val(),
			"fromDate": ISTFrom.getFullYear()+'-'+currentMonthFrm +'-'+currentDateFrm,
			"thruDate": ISTTo.getFullYear()+'-'+currentMonthTo +'-'+currentDateTo,
			"priceActionTypeId":priceActionId
			};
	prodJsonValue = {"values":prodDescValue};
	$("#commonModal").modal('hide');
	$("#waitModal").modal('show');
	var createProdurl = $("#idhiddenCreateProductDiscount").val();
	$.ajax({
		type : 'POST',
		url : createProdurl,
		async : false,
		cache : false,
		data : {
			'service' : 'CreateProductDiscount',
			'createProductJson': JSON.stringify(prodJsonValue)
		},
		success : function(data) {
			if(data.responseMessage == "success")
			{
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Success!");
				$("#divMessage").html("Discount Created successfully!.");
				resetForm();
			}else{
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Failure");
				$("#divMessage").html(data.status);
			}
		},
		error : function(data){
			$("#waitModal").modal('hide');
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);		
		}
	});
}

/**
 * Reset the Form
 */
function resetForm(){
	$("#commonModal").modal('hide');
	$("#hdnProductId").val('');
	$("#idProductName").val('');
	$("#frmLstDiscVal").val('');
	$("#lspDiscVal").text('0.00');
	$("#hspDiscVal").text('0.00');
	$("#lspDiscAmtVal").text('0.00');
	$("#hspDiscAmtVal").text('0.00');
	formHides();
}

/**
 * Remove The Existing Discount
 */
function RemoveDiscount(){
	$("#commonModal").modal('hide');
	$("#waitModal").modal('show');
	var removeProdurl = $("#idhiddenRemoveProductDiscount").val();
	$.ajax({
		type : 'POST',
		url : removeProdurl,
		async : false,
		cache:false,
		data : {
			'service' : 'RemoveDiscount',
			'productId': $("#hdnProductId").val()
		},
		success : function(data) {
			if(data.responseMessage == "success")
			{
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Success!");
				$("#divMessage").html("Discount removed successfully!.");
				resetForm();
			}else{
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Failure");
				$("#divMessage").html(data.status);
			}
		},
		error : function(data){
			$("#waitModal").modal('hide');
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);		
		}
	});
}

/**
 * dropdown Actions
 */

function dropActions(){
	$(".dropdown-menu li").click(function(e){
		$('.selectedLi').removeClass('selectedLi');
	    // add class `selectedLi`
	    $(this).addClass('selectedLi');
	  var selText = $(this).text();
	  $(this).parents('.input-group').find('.dropdown-toggle').html(selText+' <span class="caret"></span>');
	});
}

/**
 * Initial Action
 */
function initiateAction(){
	$('.popper').popover({
	    placement: 'right',
	    container: 'body',
	    html: true,
	    content: function () {
	        return $(this).next('.popper-content').html();
	    }
	});
	$(".popper").popover({ trigger: "hover" });
	
	dropActions();
	$("#frmLstDescic").text("%");
	$("#btnRemove").click(function(){
		$("#commonModal").modal('show');
		$("#commonModalHead").text("Confirm Remove");
		$("#commonModalBody").text("Do you want to Remove ? ");
		$("#modalButOk").unbind('click');
		$("#modalButOk").bind('click',RemoveDiscount);
	});

	$("#btnSave").click(function(){
		var serverDate = $("#idServerdate").val();
		var startdate = $("#frmdate").val();
		var enddate = $("#toDate").val();
		var dateFirst = serverDate;
		//dateFirst = dateFirst.split('-');
		var dateSecond = startdate.split('-');
		dateSecond = dateSecond[2]+'-'+dateSecond[1]+'-'+dateSecond[0];
		var dateThird = enddate.split('-');
		dateThird = dateThird[2]+'-'+dateThird[1]+'-'+dateThird[0];
		/*alert(" first date :: "+dateFirst);
		alert(" second date :: "+ dateSecond);
		alert(" second date :: "+ dateThird);*/
		if($("#frmLstDiscVal").val() <= 0 || $("#frmLstDiscVal").val() == null || $("#frmLstDiscVal").val() == ""){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Please check ...");
			$("#divMessage").html("Discount value Shouldn't be empty or 0");	
		}else if(dateFirst > dateSecond ){//new Date(dateFirst[2],dateFirst[1],dateFirst[0]) > new Date(dateSecond[0],dateSecond[1],dateSecond[2])){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Please check ...");
			$("#divMessage").html("Start date Should not be past date.");
		}else if(dateFirst > dateThird ){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Please check ...");
			$("#divMessage").html("End date Should not be past date.");
		}else{
			$("#commonModal").modal('show');
			$("#commonModalHead").text("Confirm Save Discount");
			$("#commonModalBody").text("Do you want to Save ? ");
			$("#modalButOk").unbind('click');
			$("#modalButOk").bind('click',CreateDiscount);
		}
	});
}

/**
 * Hide Components
 */
function formHides(){
	$("#frmPrdDetailBody").hide();
	$("#frmPrdDetailFooter").hide();
	$("#btnCancel").hide();
	$("#btnSave").hide();
	$("#btnEdit").hide();
	$("#btnRemove").hide();
}

/**
 * Show Hided values
 */
function formShows(){
	$("#frmPrdDetailBody").show();
	$("#frmPrdDetailFooter").show();
	$("#btnCancel").show();
	//$("#btnSave").show();
	//$("#btnEdit").show();
	$("#btnRemove").show();
}

/**
 * Lock Input Values
 */
function lockInput(){
	$("#frmLstDiscVal").prop('readonly',true);
	$("#frmLstDiscBut").attr("disabled",true);
	$("#frmdate").attr("disabled",true);
	$("#toDate").attr("disabled",true);
	//$("#btnSave").text("Edit");
}

/**
 * Unlock Input Values
 */
function unLockInput(){
	$("#frmLstDiscVal").prop('readonly',false);
	$("#frmLstDiscBut").attr("disabled",false);
	$("#frmdate").attr("disabled",false);
	$("#toDate").attr("disabled",false);
	//$("#btnSave").text("Save");
}

/**
 * Get Discount Values
 * @param mType
 * @param mValue
 * @param baseValue
 * @returns {Number}
 */
function getDiscountValue(mType,mValue,baseValue){
	var unitPrice = 0;
	var pVal = 0;
	if(baseValue == "LSP"){
		unitPrice = $("#frmLstPriceLsp").text();
	}else if(baseValue == "HSP"){
		unitPrice = $("#frmLstPriceHsp").text();
	}
	if(mType == "PRICE_POL"){
		pVal = parseFloat((unitPrice * mValue)/100 );
	}else if(mType == "PRICE_FOL"){
		pVal = parseFloat(mValue);
	}
	return pVal;
}

/**
 * Initiate Product auto complete
 */
function initProductNameAutoComplete(){
	//alert($("#idHdnPartyTypeId").val());
 	$('#idProductName').autocomplete({ source: function( request, response ) {
 		$("#idProductLoadingImage").show();
 		 var urlprodser = $("#hdnProductSearch").val();
 		$.ajax({
 			type: 'GET',
 			url: urlprodser,
 			async: false,
 			cache:false,
 			data: {
 				'service': 'ProductSearch',
 				'productName':$("#idProductName").val(),
 				'partyTypeId':$("#idHdnPartyTypeId").val(),
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
 						"value" : products[i].productName,
 						"prdId" : products[i].productId
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
 			$('#hdnProductId').val(ui.item.prdId);
 			productSelect(ui.item.prdId);
 			return false;
 		}
 	});
 }


/**
 * Product Details
 * @param productId
 */

function productSelect(productId){
	$("#frmLstDiscVal").val('');
	//https://localhost:8443/restcomponent/productportal/poproductdetail?targetPartyId=1000000019502&productId=1000000153729
	var urlprodser = $("#hdnProductDetailSearch").val();
		$.ajax({
			type: 'GET',
			url: urlprodser,
			async: false,
			cache:false,
			data: {
				'service': 'ProductDetailSearch',
				'productId':productId
			},
			success: function(data) {
				var productDetails = data;
				formShows();
				var prdList = productDetails.productList;
				if(prdList != "" || prdList != null){
					for(var i=0;i<prdList.length;i++){
						$("#frmManufacturer").text(prdList[i].principalName);
						$("#frmLstPartNum").text(prdList[i].productName);
//						$("#frmLstPartName").text(prdList[i].description);
					}
				}
				var uomList = productDetails.uomList;
				if(uomList != "" || uomList != null){
					$("#frmUom").text(uomList[0].uomId);
				}
				
				var priceList = productDetails.priceList;
				if(priceList.length > 0){
					for(var p=0;p<priceList.length;p++){
						if(priceList[p].productPricePurposeId == "SLB")
							$("#frmLstPriceLsp").text(priceList[p].price);
						if(priceList[p].productPricePurposeId == "PURCHASE")
							$("#frmLstPriceHsp").text(priceList[p].price);
						if(priceList[p].productPricePurposeId == "COMPONENT_PRICE")
							$("#hdnProductUnitPrice").val(priceList[p].price);
					}
				}else{
					$("#frmLstPriceLsp").text('NA');
					$("#frmLstPriceHsp").text('NA');
					$("#hdnProductUnitPrice").val('0.00');
				}
				
				getProductDiscount(productId);
				$("#idProductLoadingImage").hide();
				$(".search-box").prop('readonly', false);
			}
		});
}

/**
 * Initilize get Product Discount Details
 * @param productId
 */

function getProductDiscount(productId){
	/**/
	var urlprodescser = $("#hdnProductDiscountSearch").val();
	$.ajax({
		type: 'GET',
		url: urlprodescser,
		async: false,
		cache:false,
		data: {
			'service': 'ProductDiscountSearch',
			'productId':productId
		},
		success: function(data) {
			var productDiscountDetails = data;
			var prdDscList = productDiscountDetails.discountDetail;
			if(prdDscList.length > 0){
				for(var i=0;i<prdDscList.length;i++){
					var descVal = prdDscList[i].amount;
					var mType = prdDscList[i].productPriceActionTypeId;
					var descValbe=0;
					descVal = descVal.toString();
					if(descVal.indexOf("-") > -1){
						 descValbe = descVal.slice(0, descVal.indexOf("-")) + descVal.slice(descVal.indexOf("-")+1);
						$("#frmLstDiscVal").val(descValbe);
					}else{
						$("#frmLstDiscVal").val(descVal);
					}
					var ISTFrom = new Date(prdDscList[i].fromDate); 
					var ISTTo = new Date(prdDscList[i].thruDate);
					var currentDateFrm = ISTFrom.getDate();
					if(currentDateFrm<10){
						currentDateFrm='0'+currentDateFrm
				    }
					var currentDateTo = ISTTo.getDate();
					if(currentDateTo<10){
						currentDateTo='0'+currentDateTo
				    }
					var currentMonthFrm = (ISTFrom.getMonth()+1);
				    if(currentMonthFrm<10){
				    	currentMonthFrm='0'+currentMonthFrm
				    }
				    var currentMonthTo = (ISTTo.getMonth()+1);
				    if(currentMonthTo<10){
				    	currentMonthTo='0'+currentMonthTo
				    }
					$("#frmdate").val(currentDateFrm+'-'+currentMonthFrm +'-'+ISTFrom.getFullYear());
					$("#toDate").val(currentDateTo+'-'+currentMonthTo +'-'+ISTTo.getFullYear());
					$("#hdfrmdate").val(ISTFrom.getFullYear()+'-'+currentMonthFrm +'-'+currentDateFrm);
					$("#hdtoDate").val(ISTTo.getFullYear()+'-'+currentMonthTo +'-'+currentDateTo);
					lockInput();
					
					if(isNaN(getDiscountValue(mType,descValbe,"LSP").toFixed(2))){
						$("#lspDiscVal").text("NA");
					}else{
						$("#lspDiscVal").text(getDiscountValue(mType,descValbe,"LSP").toFixed(2));
					}
					
					if(isNaN(getDiscountValue(mType,descValbe,"HSP").toFixed(2))){
						$("#hspDiscVal").text("NA");
					}else{
						$("#hspDiscVal").text(getDiscountValue(mType,descValbe,"HSP").toFixed(2));
					}
					
					var aflsVal = $("#frmLstPriceLsp").text()-getDiscountValue(mType,descValbe,"LSP");
					var afhsVal = $("#frmLstPriceHsp").text()-getDiscountValue(mType,descValbe,"HSP");
					if(isNaN(aflsVal)){
						$("#lspDiscAmtVal").text("NA");
					}else{
						$("#lspDiscAmtVal").text(aflsVal.toFixed(2));
					}
					
					if(isNaN(afhsVal)){
						$("#hspDiscAmtVal").text("NA");
					}else{
						$("#hspDiscAmtVal").text(afhsVal.toFixed(2));
					}

					$("#btnSave").hide();
					$("#btnEdit").show();
					if(mType == "PRICE_POL"){
						$("#frmLstDescic").text("%");
						 $("#PRICE_POL").addClass('selectedLi');
						 $("#PRICE_FOL").removeClass('selectedLi');
					}else if(mType == "PRICE_FOL"){
						$("#frmLstDescic").text("Rs");
						 $("#PRICE_FOL").addClass('selectedLi');
						 $("#PRICE_POL").removeClass('selectedLi');
					}
				}
			}else{
				var date = new Date();
				var currentDate = date.getDate();
				var currentMonth = date.getMonth() + 1;
				var addMon = date.getMonth()+ 2;
				var currentYear = date.getFullYear();
				if(currentDate<10){
					currentDate='0'+currentDate;
			    } 
				if(addMon<10){
					addMon = '0'+addMon;
				}
			    if(currentMonth<10){
			    	currentMonth='0'+currentMonth;
			    } 
				$("#frmdate").datepicker({preventPast : true,minDate:0,dateFormat:'dd-mm-yy'});
				$("#toDate").datepicker({minDate:0,preventPast:true,dateFormat:'dd-mm-yy'});
				$("#frmdate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
				$("#toDate").val(currentDate + '-'+ addMon + '-'	+ currentYear );
				$("#hdfrmdate").val(currentYear + '-'+ currentMonth + '-'	+ currentDate);
				$("#hdtoDate").val(currentYear+'-'+ addMon +'-'+currentDate);
				unLockInput();
				 $("#frmLstDescic").text("%");
				 $("#PRICE_POL").addClass('selectedLi');
				 $("#PRICE_FOL").removeClass('selectedLi');
				$("#btnEdit").hide();
				$("#btnSave").show();
				$("#btnRemove").hide();
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
 * Find the index of char in nth occurance
 */
function nth_occurrence (string, char, nth) {
    var first_index = string.indexOf(char);
    var length_up_to_first_index = first_index + 1;

    if (nth == 1) {
        return first_index;
    } else {
        var string_after_first_occurrence = string.slice(length_up_to_first_index);
        var next_occurrence = nth_occurrence(string_after_first_occurrence, char, nth - 1);

        if (next_occurrence === -1) {
            return -1;
        } else {
            return length_up_to_first_index + next_occurrence;  
        }
    }
}