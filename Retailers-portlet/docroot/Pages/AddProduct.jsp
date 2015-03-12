<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<portlet:defineObjects/>
<portlet:resourceURL var='ProductCategories' id='ProductCategories' />
<portlet:resourceURL var='AddingProduct' id='AddingProduct'/>
<portlet:resourceURL var='AddingManufacturer' id='AddingManufacturer'/>
<portlet:resourceURL var='getStates' id='getStates'/>
<portlet:resourceURL var='getPrincipalNames' id='getPrincipalNames'/>
<portlet:resourceURL var='getUomList' id='getUomList'/>
<portlet:resourceURL var='CustomerDetails' id='CustomerDetails'/>
<portlet:resourceURL var='getProductNames' id='getProductNames'/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="Content-Type">
<title>Add Products</title>
<style type="text/css">
  .highlightNew {
  	display: none;
  }
  .notValid{
  color: #FF0000;
    font-size: 15px;
    line-height: 12px;
    margin-top: 2px;
    padding: 7px 0;
    }
 </style>
<script src="<%=request.getContextPath()%>/scripts/AddProduct.js?<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript">
function allowDrop(ev) {
    ev.preventDefault();
 }

 function drag(ev) {
    ev.dataTransfer.setData("Text", ev.target.id);
 }

 function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("Text");
    ev.target.appendChild(document.getElementById(data));
 }
var vala="";
var valb="";
var flag =false;
/* browser detection code */
function detectBrowser(){
	var objAgent = navigator.userAgent;
	var objOffsetName,objOffsetVersion,ix; 
	// In Chrome 
	if ((objOffsetVersion=objAgent.indexOf("Chrome"))!=-1){ objbrowserName = "Chrome"; objfullVersion = objAgent.substring(objOffsetVersion+7); } 
	// In Microsoft internet explorer 
	else if ((objOffsetVersion=objAgent.indexOf("MSIE"))!=-1){ objbrowserName = "Microsoft Internet Explorer"; objfullVersion = objAgent.substring(objOffsetVersion+5); } 
	// In Firefox 
	else if ((objOffsetVersion=objAgent.indexOf("Firefox"))!=-1){ objbrowserName = "Firefox"; } 
	// In Safari 
	else if ((objOffsetVersion=objAgent.indexOf("Safari"))!=-1){ objbrowserName = "Safari"; objfullVersion = objAgent.substring(objOffsetVersion+7); }
	return objbrowserName;
}
/* getting pressed ctrl key code */
function getChar(event) {
	  
	    return String.fromCharCode(event.keyCode || event.charCode)+(event.shiftKey ? ' +shift' : '') +
	    (event.ctrlKey ? ' +ctrl' : '') +
	    (event.altKey ? ' +alt' : '') +
	    (event.metaKey ? ' +meta' : ''); // special key
	  
	}
/* validating float nos */
function validateFloatKeyPress(el, evt) {
	
	if(detectBrowser() == "Firefox"){
			var charCode = evt.which;
			var char = getChar(evt);
		}else if(detectBrowser() == "Chrome"){
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}else{
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}
	 var a=el.value.split(".") ;
	 var b = el.value.indexOf(".");
	 if(b >-1)
	 {
		 flag = true;
	 }
	 var key = String.fromCharCode(evt.keyCode);
	 var newLimit = /^[0-9]+$/i;
	 /* (charCode == 37 && key != "%") || (charCode == 39 && key != "'") ||  (charCode == 35 && key != "#") (charCode == 36 && key != "$") ||*/
	 if (charCode == 0 || charCode == 8 || charCode == 9 || (charCode == 97 && key != "a" && char =="a +ctrl")||  (charCode == 190 && el.value.indexOf(".") < 0)) /* // back space, tab, delete, enter */{
		 if(flag == true){
		  	vala=a[0];
		  	valb=a[1];
		  
			  if(a[0]===vala){
				  if(a[1].length>2){
					  $("#idMrp").val(a[0]+"."+a[1].substring(0, 2));
				  }
			  }else{
				  if(a[0].length>16){
				  }
			  }
			}
		   return true;
	   }
	  else if (charCode > 31 && (charCode < 48 || charCode > 57)){
		  if(flag == true){
		  	vala=a[0];
		  	valb=a[1];
		  
			  if(a[0]===vala){
				  if(a[1].length>2){
					  $("#idMrp").val(a[0]+"."+a[1].substring(0, 2));
				  }
			  }else{
				  if(a[0].length>16){
				  }
			  }
			}
		  return false;
	  }else {
		  if(flag == true){
		  	vala=a[0];
		  	valb=a[1];
			  if(a[0]===vala){
				  if(a[1].length>2){
					  $("#idMrp").val(a[0]+"."+a[1].substring(0, 2));
				  }
			  }else{
				  if(a[0].length>16){
				  }
			  }
			}
	  }
	 return true;
}

function validateFloatKeyPressNew(el,evt){

	if(detectBrowser() == "Firefox"){
			var charCode = evt.which;
			var char = getChar(evt);
		}else if(detectBrowser() == "Chrome"){
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}else{
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}
	var flagy=false;
	 var a=el.value.split(".") ;
	 var b = el.value.indexOf(".");
	 if(b >-1){
		 flagy = true;
	 }
	  var key = String.fromCharCode(evt.keyCode);
	 var newLimit = /^[0-9]+$/i;
	 /* (charCode == 37 && key != "%") || (charCode == 39 && key != "'") ||  (charCode == 35 && key != "#") (charCode == 36 && key != "$") ||*/
	 if (charCode == 0 || charCode == 8 || charCode == 9 || (charCode == 97 && key != "a" && char =="a +ctrl")||  (charCode == 46 && el.value.indexOf(".")<0)) /* // back space, tab, delete, enter */{
		   return true;
	   }else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
	  /* else if(flag == true)
	  {
	  }
	  */else if(flagy == false){ 
		  if(el.value.length >15) return false;
	  }   
	  return true;
}
function validateFloatKeyPressTax(el, evt) {
	if(detectBrowser() == "Firefox"){
			var charCode = evt.which;
			var char = getChar(evt);
		}else if(detectBrowser() == "Chrome"){
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}else{
			var charCode = (evt.which) ? evt.which : evt.keyCode;
		}
	var flagx =false;
	 var a=el.value.split(".") ;
	 var b = el.value.indexOf(".");
	 if(b >-1){
		 flagx = true;
	 }
	 var key = String.fromCharCode(evt.keyCode);
	 var newLimit = /^[0-9]+$/i;
	 /* (charCode == 37 && key != "%") || (charCode == 39 && key != "'") ||  (charCode == 35 && key != "#") (charCode == 36 && key != "$") ||*/
	 if (charCode == 0 || charCode == 8 || charCode == 9 || (charCode == 97 && key != "a" && char =="a +ctrl")||  (charCode == 46 && el.value.indexOf(".")<0)) /* // back space, tab, delete, enter */{
		   return true;
	   }else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
	    else if(flagx == true){
			   if(a[0].length >19 && a[1].length >1){
				    return false;
				 }else if(a[1].length >1){
					  return false;
				 }else if(a[0].length >19){
					  return false;
			     }
	  }else if(flagx == false){ 
		  if(el.value.length >17) return false;
	  }  
	  return true;
}


/* limiting maximum limit is 100 */
function minmax(value, min, max) 
{
	if(value == 0 || value == 5 || value == 14.5){
			return value;
		}else{
			$("#taxCheckModel").modal('show');
		return 0;
		}
    /* if(parseInt(value) == 0 || isNaN(value)) 
    	return value; 
    else if(parseFloat(value) >= 100.01)
    	{
    		$("#taxCheckModel").modal('show');
        	return 0;    	
    	}
    else return value; */
}
/* checking productname,product code,principal name */
function isProductKey(evt) {
	if(detectBrowser() == "Firefox"){
		var charCode = evt.which;
		var char = getChar(evt);
	}else if(detectBrowser() == "Chrome"){
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}else{
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}
	/* var charCode = (evt.which) ? evt.which : evt.keyCode; */
	var newchartoenter2 = /^[a-zA-Z 0-9-:;!@*&%.()+=\/]+$/i;
    var key = String.fromCharCode(evt.which);
    if (charCode ==0 || charCode == 8 || charCode == 37  ||  charCode == 46 || charCode == 97 || charCode == 35  || charCode == 9 || newchartoenter2.test(key) || charCode == 36 ) {
        return true;
    }
    return false;
};
/* checking tin no */
function isTinNoKey(evt) {
	if(detectBrowser() == "Firefox"){
		var charCode = evt.which;
		var char = getChar(evt);
	}else if(detectBrowser() == "Chrome"){
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}else{
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}
    var newchartoenter2 = /^[0-9-:;!@*&%.()+=]+$/i;
    var key = String.fromCharCode(evt.which);
    if (charCode == 0 || charCode == 8 || charCode == 37  || charCode == 46  || charCode == 35  || charCode == 36 || newchartoenter2.test(key) || (charCode == 97  && char =="a +ctrl") ||(charCode == 65 && char =="A +ctrl") ) {
        return true;
    }
    return false;
};
/* checking alphanumeric key */
function isAlphaNumKey(evt) {

    var charCode = (evt.which) ? evt.which : evt.keyCode;

    var newchartoenter = /^[a-z\d\,\s]+$/i;
    var key = String.fromCharCode(evt.which);
    //alert(key +" code :: "+charCode);
     /* charCode == 37 || charCode == 38 || charCode == 46 || charCode == 39 || charCode == 40 removing %&(*/
        if (charCode == 8 || charCode == 9 || (charCode == 46 && key != ".") || charCode == 97 || newchartoenter.test(key) || (charCode == 37 && key != "%") || (charCode == 39 && key != "'")) /* back space, tab, delete, enter*/
    	return true;
    else if (charCode > 31 && (charCode < 48 || charCode > 57) ) return false;
    return true;
}
/* checking alphanumeric key */
function isAlphaNumWithSpecKey(evt) {

    var charCode = (evt.which) ? evt.which : evt.keyCode;

    var newchartoenter = /^[a-z-\d\,\s]+$/i;
    var key = String.fromCharCode(evt.which);
    //alert(key +" code :: "+charCode);
     /* charCode == 37 || charCode == 38 || charCode == 46 || charCode == 39 || charCode == 40 removing %&(*/
        if (charCode == 8 || charCode == 9 || charCode == 46  || charCode == 97 || newchartoenter.test(key) || (charCode == 37 && key != "%") || (charCode == 39 && key != "'")) /* back space, tab, delete, enter*/
    	return true;
    else if (charCode > 31 && (charCode < 48 || charCode > 57) ) return false;
    return true;
}
/* code for allowing charecter and space */
function isCharSpacKey(evt) {

    var charCode = (evt.which) ? evt.which : evt.keyCode;

    var key = String.fromCharCode(evt.which);
        if (charCode == 8 || charCode == 9 || (charCode == 39 && key != "'") || charCode == 97 || /^[a-zA-Z ]*$/.test(key) || (charCode == 37 && key != "%") || (charCode == 46 && key != ".")){ /* back space, tab, delete, enter*/
    	return true;
        }
    return false;
}
/* allowing only nos */
function isNumberKey(event) {
	if(detectBrowser() == "Firefox"){
		var charCode = event.which;
		var char = getChar(event);
	}else if(detectBrowser() == "Chrome"){
		var charCode = (event.which) ? event.which : event.keyCode;
	}else{
		var charCode = (event.which) ? event.which : event.keyCode;
	}
	var key = String.fromCharCode(event.which);
    if (charCode == 0 || charCode == 8 || charCode == 9 || (charCode >= 48 && charCode <= 57)||(charCode == 65 && char =="A +ctrl") /* /^(?=.*\d)(?:[\d ]+)$/.test(key) || */ || (charCode == 37 && key != "%") || (charCode == 97 && char =="a +ctrl")) {
        return true;
    }
    return false;
}
/* allowing number and space only */
function isNumberSpacKey(event) {
	if(detectBrowser() == "Firefox"){
		var charCode = event.which;
		var char = getChar(event);
	}else if(detectBrowser() == "Chrome"){
		var charCode = (event.which) ? event.which : event.keyCode;
	}else{
		var charCode = (event.which) ? event.which : event.keyCode;
	}
	var key = String.fromCharCode(event.which);
    if (charCode == 0 || charCode == 8 || charCode == 32 || charCode == 9 || (charCode >= 48 && charCode <= 57)||(charCode == 65 && char =="A +ctrl") /* /^(?=.*\d)(?:[\d ]+)$/.test(key) || */ || (charCode == 37 && key != "%") || (charCode == 97 && char =="a +ctrl")) {
        return true;
    }
    return false;
}
/* validating email */
function validateEmail(emailField){
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (reg.test(emailField.value) == false){
        $('#emailErrorlbl').removeClass('highlightNew');
        return false;
    }
    $('#emailErrorlbl').addClass('highlightNew');
    return true;
}
/* allowing only fax nos */
function faxValidation(fax){
		
	var regPhone= /^\(?([0-9]{5})\)?[-. ]?([0-9]{6})$/;
	if (regPhone.test(fax.value) == false){
        $("#faxErrorLbl").removeClass('highlightNew');
        return false;
    }
	$("#faxErrorLbl").addClass('highlightNew');
    return true;
}
/* defination for mrp,min,max stock validation */
function initManualValidation(){
		if($("#idMinStock").val() =="" || $("#idMinStock").val() == null){
			$("#minErrorLbl").removeClass('highlightNew');
		}else if($("#idMaxStock").val() =="" || $("#idMaxStock").val()==null){
			$("#minErrorLbl").removeClass('highlightNew');
		}else if(parseInt($("#idMinStock").val()) == 0 && parseInt($("#idMaxStock").val()) == 0){
			$("#minErrorLbl").addClass('highlightNew');
		}else if(parseInt($("#idMinStock").val()) < parseInt($("#idMaxStock").val())){
		    $("#minErrorLbl").addClass('highlightNew');
		}else{
			$("#minErrorLbl").removeClass('highlightNew');
		}
}
/* allow valid url */
function validUrl(Url){
	/* var regUrl = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
	 */
	 var myRegExp =/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i;
	 var RegExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/; 
     var newReg = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/;
	 if(newReg.test(Url.value)){ 
		$("#urlErrorLbl").addClass('highlightNew');	
	    return true;
	 } 
	 $("#urlErrorLbl").removeClass('highlightNew');
	    return false;
}
/* allow valid mobile no */
function validMobile(Mobile){
	var regMobile= /^\d{10}$/;
	if (regMobile.test(Mobile.value) == false){
        $("#mobileErrorLbl").removeClass('highlightNew');
        return false;
    }
	$("#mobileErrorLbl").addClass('highlightNew');
    return true;
}
/* allow valid phone */
function validPhone(Phone){
	var regPhone= /^\(?([0-9]{5})\)?[-. ]?([0-9]{6})$/;
	if (regPhone.test(Phone.value) == false)
    {
        $("#phoneErrorLbl").removeClass('highlightNew');
        return false;
    }
	$("#phoneErrorLbl").addClass('highlightNew');
    return true;
}

function hideModal(){
	$("#alertModal").modal('hide');
	if($("#spanHeader").text() == "Invalid Type"){
			$("#idUom").focus();
		}else{
			$("#idTax").focus();
		}
}
</script>
</head>
<body>
	<div class="wrap">
		<div class="top-tabs">
			<div class="tabPurchaseOrder">
				<ul class="nav nav-tabs" id="myTab">
					<li class="active"><a href="#addProduct" data-toggle="tab">Add Product</a></li>
				</ul>
			</div>
		</div>
		<div class="main">
			<div class="tab-content" id="myTabContent">
				<div class="tab-pane active" id="query">
					<h1>Add Product</h1>
					<form id="idNewProductForm">
						<div class="menu-tabs">
							<div class="clean4">
								<div style="padding-left: 10px">
									Fields marked as <span style="color: red">*</span> are
									mandatory.
								</div>
								<table>
									<tr>
										<td>
											<div class="lft-tbl">
												<table cellpadding="0" cellspacing="0" border="0"
													width="100%">
													<tr>
														<td class="pad-top">Product Name <span
															style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input type="text" id="idProductName"
															class="search-box" name="nameProductName" onkeypress="return isProductKey(event)"  maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)"/> <img
															style="display: none" id="idProductLoadingImage"
															src="<%=request.getContextPath()%>/img/ajax.gif" /> <input
															id="hdnProductId" hidden="true" name="nameProductId" />
															<input id="hdnPrincipalId" hidden="true"
															name="namePrincipalId" /> <input id="clientTarneaId"
															hidden="true" name="clientTarneaId"
															value="${targetPartyId}" />
															<input type="hidden" id="idCreatedUser" name="nameCreatedUser" value="${createdUser}">
															<input type="hidden" id="idhiddenProductCategories" name="namehiddenProductCategories" value="<%=ProductCategories%>">
															<input type="hidden" id="idhiddenAddingProduct" name="namehiddenAddingProduct" value="<%=AddingProduct%>">
															<input type="hidden" id="idhiddenAddingManufacturer" name="nameAddingManufacturer" value="<%=AddingManufacturer%>">
															<input type="hidden" id="idhiddengetStates" name="namehiddengetStates" value="<%=getStates%>">
															<input type="hidden" id="idhiddengetPrincipalNames" name="namehiddengetPrincipalNames" value="<%=getPrincipalNames%>">
															<input type="hidden" id="idhiddengetUomList" name="namehiddengetUomList" value="<%=getUomList%>">
															<input type="hidden" id="idhiddenCustomerDetails" name="namehiddenCustomerDetails" value="<%=CustomerDetails%>">
															<input type="hidden" id="idhiddengetProductNames" name="namehiddengetProductNames" value="<%=getProductNames%>">
															</td>
													</tr>
													<tr>
														<td class="pad-top">Product Code</td>
													</tr>
													<tr>
														<td><input type="text" name="nameExternalProductId"
															id="idExternalProductId" class="search-box" onkeypress="return isProductKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
													</tr>
													<!-- <tr> removed for new development by vinoth
														<td class="pad-top">Strength <span style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input type="text" name="nameStrength"
															id="idStrength" class="search-box"></td>
													</tr> -->
													<tr>
														<td class="pad-top">MRP (INR)<span style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input name="nameMrp" type="text" id="idMrp"
															class="search-box" onkeypress="return validateFloatKeyPressNew(this,event)" onkeyup="return validateFloatKeyPress(this,event)" maxlength="19" autocomplete="off" ondragover="allowDrop(event)" ondrop="drop(event)"><!-- <label id="mrpErrorLbl" class="notValid">Please Check MRP should Not be ZERO or Empty</label> --></td>
													</tr>
													<tr>
														<td class="pad-top">Min Stock</td>
													</tr>
													<tr>
														<td><input type="text" name="nameMinStock"
															id="idMinStock" class="search-box" value="0" onkeypress="return isNumberKey(event)" onblur="initManualValidation()" maxlength="16" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="minErrorLbl" class="notValid">Please Check Min stock shoud be less than Max stock</label></td>
													</tr>
													<tr>
														<td class="pad-top">Reorder Level </td>
													</tr>
													<tr>
														<td><input type="text" name="nameReorderLevel"
															id="idReorderLevel" class="search-box" value="0" onkeypress="return isNumberKey(event)" maxlength="16" ondragover="allowDrop(event)" ondrop="drop(event)">
														</td>
													</tr>
													<tr>
														<td class="pad-top">Package Info (e.g. 1, 10
															etc.) <span style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input type="text" id="idPackageInfo"
															name="namePackageInfo" class="search-box" onkeypress="return isNumberKey(event)" maxlength="6" autocomplete="off" ondragover="allowDrop(event)" ondrop="drop(event)"/></td>
													</tr>
													<tr>
														<td class="pad-top">Type (e.g. Cap, Tab, Inj, etc.) <span
															style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input id="idUom" type="text" name="nameUom"
															class="search-box" onkeypress="return isCharSpacKey(event)" ondragover="allowDrop(event)" ondrop="drop(event)"> <img style="display: none"
															id="idUomLoadingImage"
															src="<%=request.getContextPath()%>/img/ajax.gif" /></td>
													</tr>


												</table>
											</div>
											<div class="rgt-tbl">
												<table cellpadding="0" cellspacing="0" border="0"
													width="100%">

													<tr>
														<td class="pad-top">Tax (in %) <span
															style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input type="hidden" id="taxPercentage" value="${taxPercentage}"><select name="nameTax" id="idTax">
														</select></td>
													</tr>
													<tr>
														<td class="pad-top">Max Stock</td>
													</tr>
													<tr>
														<td><input type="text" name="nameMaxStock"
															id="idMaxStock" class="search-box" value="0" onkeypress="return isNumberKey(event)" onblur="initManualValidation()" maxlength="16" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
													</tr>
													<tr>
														<td class="pad-top">Generic Name <span
															style="color: red">*</span>
														</td>
													</tr>
													<tr>
														<td><input type="text" id="idGenericName"
															name="nameGeneric" class="search-box" onkeypress="return isProductKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
													</tr>
													<tr>
														<td class="pad-top" style="padding-top: 30px;"> 
															<table class="border-tab">
																<tr>
																	<td class="border-tab1"><label class="lable-Cate ">Category</label>
																	</td>
																	<td><label class="lable-Cate ">Schedule</label></td>
																</tr>

																<tr>

																	<td class="border-tab1">


																		<div class=" div-Category">
																			<div class="div-pop-wi1">
																				<input name="group1" type="radio" id="radio"
																					value="Scheduled" class="css-checkbox"
																					style="margin-top: 2px;" Onclick="enableFields()">
																				<label class="css-label" for="radio">Scheduled</label>
																			</div>
																			<div class="div-pop-wi2">
																				<input id="radio_1" type="radio" id="radio_1"
																					class="css-checkbox" name="group1"
																					value="Non-Scheduled" style="margin-top: 2px;"
																					Onclick="disableFields()"> <label for="radio_1"
																					class="css-label">Non-Scheduled</label>
																			</div>
																		</div>
																	</td>
																	<td>
																		<div class="lable-Cate" id="schedul1">
																			<table class="table-inside " id="schedule">
																				<thead>
																					<tr>
																						<th></th>
																				</thead>
																				<tbody>
																				</tbody>
																			</table>
																		</div>
																	</td>

																</tr>
															</table>

														</td>
													</tr>
												</table>
											</div>
										</td>
									</tr>
									<tr>
										<td class="pad-top">
											<div id="wrapper2">
												<div class="newPdtHeader">
													<div class="names">
														Principal Name <span style="color: red">*</span>
													</div>
													<input name="namePrincipal" type="text" id="idPrincipal"
														class="search-box" onkeypress="return isAlphaNumWithSpecKey(event)" ondragover="allowDrop(event)" ondrop="drop(event)" maxlength="100"> <img style="display: none"
														id="idPrincipalLoadingImage"
														src="<%=request.getContextPath()%>/img/ajax.gif" />
														<input id="facilityId" type="hidden">
														<input id="productStoreId" type="hidden">
														<input id="productStoreGroupId" type="hidden">
														<input id="partyRoleTypeId" type="hidden">
														<input id="datasourceId" type="hidden">
												</div>
												<div class="newPdtContent">
													<div class="lft-tbl">
														<table cellpadding="0" cellspacing="0" border="0"
															width="100%">
															<tr>
																<td class="pad-top">Principal address</td>
															</tr>
															<tr>
																<td><input type="text" name="nameAddress"
																	id="idAddress" class="search-box" onkeypress="return isAlphaNumKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Principal City</td>
															</tr>
															<tr>
																<td><input name="nameCity" type="text" id="idCity"
																	class="search-box" onkeypress="return isCharSpacKey(event)" maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>
															<!-- <tr>
																<td class="pad-top">Principal Code</td>
															</tr>
															<tr>
																<td><input type="text" name="nameExtrPartyId"
																	id="idExtrPartyId" class="search-box"></td>
															</tr> -->
															<tr>
																<td class="pad-top">Principal State</td>
															</tr>
															<tr>
																<td><select name="nameState" id="idState" ></select><!-- <input type="text" name="nameState"
																	id="idState" class="search-box" onkeypress="return isCharSpacKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)"> --></td>
															</tr>
															<tr>
																<td class="pad-top">Principal Pincode</td>
															</tr>
															<tr>
																<td><input type="text" name="namePincode"
																	id="idPincode" class="search-box" onkeypress="return isNumberSpacKey(event)" maxlength="6" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>

															<tr>
																<td class="pad-top">Url</td>
															</tr>
															<tr>
																<td><input name="nameUrl" type="text" id="idUrl"
																	class="search-box" onblur="validUrl(this)" maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="urlErrorLbl" class="notValid">Please Check URL is not valid</label></td>
															</tr>
															<tr>
																<td class="pad-top">TN-GST Number</td>
															</tr>
															<tr>
																<td><input name="nameTnGst" type="text" id="idTnGst"
																	class="search-box" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>

															<!-- <tr>
																<td class="pad-top">Product Discount (%)</td>
															</tr>
															<tr>
																<td><input name="namePrdDisc" type="text" id="idPrdDisc"
																	class="search-box" onkeypress="return isNumberKey(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Credit Days</td>
															</tr>
															<tr>
																<td><input name="nameCrDays" type="text" id="idPrdCrDays"
																	class="search-box" onkeypress="return isNumberKey(event)"></td>
															</tr> -->
														</table>
													</div>
													<div class="rgt-tbl">
														<table cellpadding="0" cellspacing="0" border="0"
															width="100%">
															<tr>
																<td class="pad-top">DL Number</td>
															</tr>
															<tr>
																<td><input name="nameDl" type="text" id="idDl"
																	class="search-box" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Tin Number</td>
															</tr>
															<tr>
																<td><input name="nameTin" type="text" id="idTin"
																	class="search-box" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">CST Number</td>
															</tr>
															<tr>
																<td><input name="nameCst" type="text" id="idCst"
																	class="search-box" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Principal Email</td>
															</tr>
															<tr>
																<td><input type="email" name="nameEmail"
																	id="idEmail" class="search-box" maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)">
																	</td>
															</tr>

															<tr>
																<td class="pad-top">Fax</td>
															</tr>
															<tr>
																<td><input name="nameFax" type="text" id="idFax"
																	class="search-box" onkeypress="return isNumberKey(event)" onblur="faxValidation(this)" maxlength="11" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="faxErrorLbl" class="notValid">Please Check FAX No is Invalid</label></td>
															</tr>
															<tr>
																<td class="pad-top">Principal Phone</td>
															</tr>
															<tr>
																<td><input type="tel" name="namePhone"
																	id="idPhone" class="search-box" onkeypress="return isNumberKey(event)" onblur="validPhone(this)" maxlength="11" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="phoneErrorLbl" class="notValid">Please Check Phone No is Invalid</label></td>
															</tr>
															<tr>
																<td class="pad-top">Principal Mobile</td>
															</tr>
															<tr>
																<td><input type="text" name="nameMobile"
																	id="idMobile" class="search-box" onkeypress="return isNumberKey(event)" onblur="validMobile(this)" maxlength="10" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="mobileErrorLbl" class="notValid">Please Check Mobile No is Invalid</label></td>
															</tr>

															<!-- <tr>
																<td class="pad-top">Product Margin (%)</td>
															</tr>
															<tr>
																<td><input name="namePrdMargin" type="text" id="idPrdMargin"
																	class="search-box" onkeypress="return isNumberKey(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Credit Limit</td>
															</tr>
															<tr>
																<td><input name="nameCrLimit" type="text" id="idCrLimit"
																	class="search-box" onkeypress="return isNumberKey(event)"></td>
															</tr>
															<tr>
																<td class="pad-top">Credit Balance</td>
															</tr>
															<tr>
																<td><input name="nameCrBalance" type="text" id="idCrBalance"
																	class="search-box" onkeypress="return isNumberKey(event)"></td>
															</tr> -->
														</table>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</div>
							<div class="btn-new">
								<input type="submit" id="btnIdSave" class="btn btn-map"
									onClick="javascript:showSavePopUp()" data-toggle="modal"
									style="margin-left: 10px;" value="Save">
							</div>
							<div class="btn-new">
								<a class="btn btn-review" href="#" style="margin-left: 10px;"
									onClick="javascript:resetForm()"> Reset</a>
							</div>
						</div>
					</form>
				</div>
			</div>

			<!-- Modals Started -->
			<div class="modal hide fade" id="connectionCheckModel" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3 id="myModalLabel">Please Check...</h3>
				</div>
				<div class="modal-body">
					<div class="mod-pop">
						<table width="100%">
							<tr>
								<td colspan="2" width="100%"><b>server is not connected</b></td>
							</tr>
						</table>

					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" data-dismiss="modal" id="btnScClose">Close</button>
				</div>
			</div>
			<div class="modal hide fade" id="schduleCheckModel" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3 id="myModalLabel">Please Check...</h3>
				</div>
				<div class="modal-body">
					<div class="mod-pop">
						<table width="100%">
							<tr>
								<td colspan="2" width="100%"><b>You are selected schedule ,so please select atleast one schedule...</b></td>
							</tr>
						</table>

					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" data-dismiss="modal" id="btnScClose">Close</button>
				</div>
			</div>
			<div class="modal hide fade" id="myModal" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3 id="myModalLabel">Add New Products</h3>
				</div>
				<div class="modal-body">
					<div class="mod-pop">
						<table width="100%">
							<tr>
								<td colspan="2" width="100%"><b>Do you want to save the
										records?</b></td>
							</tr>
						</table>

					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" data-dismiss="modal" id="btnSave">Yes</button>
					<button class="btn btn-review" type="button" data-dismiss="modal"
						style="margin: 0px 0 0 10px;" aria-hidden="true">No</button>
				</div>
			</div>
			<div id="tableModal" class="modal hide fade"
				style="width: 90%; left: 5%" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3 id="myModalLabel">The product you have chosen is already
						associated to you.</h3>
				</div>
				<div class="modal-body">
					<div class="clean">
						<table id="idTable" width="100%">
							<thead>
								<tr>
									<th width="20%">Product Name</th>
									<th width="25%">Principal Name</th>
									<th width="10%">UOM</th>
									<th width="6%">Price</th>
									<th width="18%">Strength</th>
									<th>Package Info</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" data-dismiss="modal">OK</button>
				</div>
			</div>
			<div class="modal hide fade" id="alertModal" tabindex="-1"
				role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3>
						<span id="spanHeader"></span>
					</h3>
				</div>
				<div class="modal-body">
					<div class="mod-pop" id="divMessage"></div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" onclick="hideModal()" id="btnalok">OK</button>
				</div>
			</div>
			<div class="modal hide fade" id="waitModal" tabindex="-1"
				role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<h3>
						<span>Please Wait...</span>
					</h3>
				</div>
				<div class="modal-body">
					<div class="mod-pop">Your product is being added.</div>
				</div>
			</div>
			<!-- Modals finished -->
		</div>
	</div>
</body>
</html>