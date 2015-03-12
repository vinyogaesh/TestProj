$(document).ready(function()
{
	initErrorMessagereomve();
	initLoading();
	initValidation();
	initSaveButtonAction();
});

function initLoading(){
	var custurl = $("#idhiddenCustomerDetails").val();
	$.ajax({
		type: 'GET',
		url: custurl,
		async: false,
		cache: false,
		data: {
			'service': 'CustomerDetails',
			'retailerPartyId':$("#clientTarneaId").val()
		},
		success: function(data) {
			$(".loadingImage").hide();
			var customerDetail=data.customerDetail;
				$("#datasourceId").val(customerDetail.dataSourceId);
				$("#partyTypeId").val(customerDetail.partyTypeId);
			},
		error: function() {
			$("#connectionCheckModel").modal('show');
		}
	});
	var stateurl = $("#idhiddengetStates").val();
	$.ajax({
		type: 'GET',
		url: stateurl,
		async: false,
		cache: false,
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
function initErrorMessagereomve() {
	$("#urlErrorLbl").addClass('highlightNew');
	$("#emailErrorlbl").addClass('highlightNew');
	$("#phoneErrorLbl").addClass('highlightNew');
	$("#mobileErrorLbl").addClass('highlightNew');
	$("#faxErrorLbl").addClass('highlightNew');
	$("#minErrorLbl").addClass('highlightNew');
	$("#radio_1").prop("checked",true);
}
function initValidation()
{
	$('#idSupplierForm').validate({
		rules : {
			nameSupplierName : {
				minlength : 3,
				required : true
			},
			nameAddress1 : {
				required : true
			},
			nameCity : {
				required : true
			},
			nameState : {
				required : true
			},
			namePincode : {
				required : true
			}/*,
			country : {
				required : true
			}*/,
			nameTinno : {
				required : true
			},
			nameMobile : {
				required : true
			},
			nameEmail : {
				required : true,
				email : true
			}

		},
		highlight : function(element)
		{
			$(element).closest('.form-group').removeClass('success valid').addClass('error');
		},
		success : function(element)
		{
			element.addClass('valid').closest('.form-group').removeClass('error');
		},
		submitHandler : function(form)
		{
			submitForm(form);
		}
	});
}
function showSavePopUp()
{
	$("#saveConfirmModal").modal('show');
}
function submitForm(form)
{
	$("#waitModal").modal('show');
	var array = jQuery(form).serializeArray();
    var json = {};
    jQuery.each(array, function() {
    	if(this.value == "" || this.value == null){
			this.value = "";
		}
	json[this.name] = this.value.trim() || '';
   });
    
    var manufacturer ={};
	manufacturer = {
		    "organizationPartyId":json.clientTarneaId,
		    "organizationPartyType": $("#partyTypeId").val(),
		    "partyType": "SUPPLIER",
		    "dataSourceId": $("#datasourceId").val(),
		    /*"externalPartyId": json.nameSupplierCode,*/
		    "partyName": json.nameSupplierName,
		    "telephoneNumber": json.namePhone,
		    "mobileNumber": json.nameMobile,
		    "emailId": json.nameEmail,
		    "address1": json.nameAddress1,
		    "address2": json.nameAddress2,
		    "city": json.nameCity,
		    "state":json.nameState,
		    "url":json.nameUrl,
		    "postalCode": json.namePincode,
		    "cstNumber": json.nameCstno,
		    "tnGstNumber": json.nameGstNumber,
		    "dlNumber": json.nameDlNumber,
		    "tinNumber": json.nameTinno,
		    //"productMargin": json.namePrdMargin,
		    //"productDiscount": json.namePrdDisc,
		    //"creditLimit": json.nameCrLimit,
		    //"creditDays": json.nameCrDays,
		    //"creditBalance": json.nameCrBalance,
		    "createdByUser": $("#idCreatedUser").val()
		};
	
	var addManuurl = $("#idhiddenAddingManufacturer").val();
	$.ajax({
		type : 'POST',
		url : addManuurl,
		async : false,
		cache : false,
		data : {
			'service' : 'AddingManufacturer',
			'AddManufacturerPost':JSON.stringify(manufacturer)
		},
		success : function(data) {
			$("#waitModal").modal('hide');
			if(data.responseMessage == "success"){ 
				$("#SuccessModal").modal('show');
				$("#spanHeader").html("Success!");
				$("#divMessage").html("Supplier added successfully!.");
				$("#sucessOkButton").click( function(){
					resetForm();
				});
			}else if(responseMessage == "error"){
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Failure");
				$("#divMessage").html("Error while adding Supplier.");
			}else{
				$("#waitModal").modal('hide');
				$("#alertModal").modal('show');
				$("#spanHeader").html("Failure");
				$("#divMessage").html("Error while adding Supplier.");
			}
		},
		error : function()
		{
			$("#waitModal").modal('hide');
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html("Error while adding Supplier.");
		}
	});
}
function resetForm()
{
	location.reload();
	/*$('#idSupplierForm').each(function()
	{
		this.reset(); // Here form fields will be cleared.
		//$('label').removeClass('error valid');
		$('.error valid').css('visibility', 'hide');
		//display: none;
	});*/
}
/**
 * Initializes save button action
 */
function initSaveButtonAction()
{
	$("#btnSupplierSave").click(function()
	{
		// This will force the validation.
		$("#saveConfirmModal").modal('hide');
		$("#idSupplierForm").submit();
	});
}
function clearText(field)
{
	if (field.defaultValue == field.value)
		field.value = '';
	else if (field.value == '')
		field.value = field.defaultValue;
}