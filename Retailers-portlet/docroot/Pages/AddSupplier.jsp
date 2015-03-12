<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<portlet:defineObjects />
<portlet:resourceURL var="CustomerDetails" id="CustomerDetails"/>
<portlet:resourceURL var="AddingManufacturer" id="AddingManufacturer"/>
<portlet:resourceURL var="getStates" id="getStates"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Supplier</title>
<style type="text/css">
  .highlightNew {
  	display: none;
  }
 </style>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/scripts/AddSupplier.js?<%=System.currentTimeMillis()%>"></script>
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
function isNumberKey(evt)
{
   var charCode = (evt.which) ? evt.which : event.keyCode;
   if (charCode != 46 && charCode > 31 
     && (charCode < 48 || charCode > 57))
      return false;

   return true;
}
/* browser detection code */
function detectBrowser()
{
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
/* checking productname,product code,principal name */
function isProductKey(evt) {
	if(detectBrowser() == "Firefox")
	{
		var charCode = evt.which;
		var char = getChar(evt);
	}
else if(detectBrowser() == "Chrome")
	{
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}
else
	{
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}
	/* var charCode = (evt.which) ? evt.which : evt.keyCode; */
	var newchartoenter2 = /^[a-zA-Z 0-9-.,]+/i;
    var key = String.fromCharCode(evt.which);
    if (charCode ==0 || charCode == 8 || charCode == 37 && key != "%"  ||  charCode == 46 || charCode == 97 || charCode == 35 && key != "#"  || charCode == 9 || newchartoenter2.test(key) || charCode == 36 && key !="$" ) {
        return true;
    }
    return false;
};
/* checking tin no */
function isTinNoKey(evt) {
	if(detectBrowser() == "Firefox")
	{
		var charCode = evt.which;
		var char = getChar(evt);
	}
else if(detectBrowser() == "Chrome")
	{
		var charCode = (evt.which) ? evt.which : evt.keyCode;
	}
else
	{
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
/* checking alphanumeric with space key */
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
/* checking alphanumeric with space key */
function isAlphaNumWithSpecSlaKey(evt) {

    var charCode = (evt.which) ? evt.which : evt.keyCode;

    var newchartoenter = /^[a-z-\d\,\s/\/]+$/i;
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
	if(detectBrowser() == "Firefox")
	{
		var charCode = event.which;
		var char = getChar(event);
	}
else if(detectBrowser() == "Chrome")
	{
		var charCode = (event.which) ? event.which : event.keyCode;
	}
else
	{
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
	if(detectBrowser() == "Firefox")
	{
		var charCode = event.which;
		var char = getChar(event);
	}
else if(detectBrowser() == "Chrome")
	{
		var charCode = (event.which) ? event.which : event.keyCode;
	}
else
	{
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

    if (reg.test(emailField.value) == false)
    {
        $('#emailErrorlbl').removeClass('highlightNew');
        return false;
    }
    $('#emailErrorlbl').addClass('highlightNew');
    return true;
}
/* allowing only fax nos */
function faxValidation(fax)
{
		
	var regPhone= /^\(?([0-9]{5})\)?[-. ]?([0-9]{6})$/;
	if (regPhone.test(fax.value) == false)
    {
        $("#faxErrorLbl").removeClass('highlightNew');
        return false;
    }
	$("#faxErrorLbl").addClass('highlightNew');
    return true;
}
/* allow valid url */
function validUrl(Url)
{
	if(Url.value == "" || Url.value == null){
		$("#urlErrorLbl").addClass('highlightNew');
		$("#idSupplierForm").find("label[for=nameUrl]").removeClass('error valid');
	}else{
	/* var regUrl = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
	 */
	 var myRegExp =/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i;
	 var RegExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/; 
     var newReg = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/;
	 if(newReg.test(Url.value)){ 
		 $("#urlErrorLbl").addClass('highlightNew');	
		 $("#idSupplierForm").find("label[for=nameUrl]").addClass('error valid');
		//$("#nameUrlLbl").addClass('newvinoth validVinoth');
		//$('[name="nameUrl"]').removeClass('success valid').addClass('error');
	    return true;
	 } 
	 $("#urlErrorLbl").removeClass('highlightNew');
     $("#idSupplierForm").find("label[for=nameUrl]").removeClass('error valid');
	return false;
	}
}
/* allow valid mobile no */
function validMobile(Mobile)
{
	if(Mobile.value == "" || Mobile.value == null){
		$("#mobileErrorLbl").addClass('highlightNew');
		$("#idSupplierForm").find("label[for=nameMobile]").removeClass('error valid');
	}else{	
	var regMobile= /^\d{10}$/;
	if (regMobile.test(Mobile.value) == false)
    {
        $("#mobileErrorLbl").removeClass('highlightNew');
        $("#idSupplierForm").find("label[for=nameMobile]").removeClass('error valid');
        return false;
    }
	$("#mobileErrorLbl").addClass('highlightNew');
	$("#idSupplierForm").find("label[for=nameMobile]").addClass('error valid');
    return true;
	}
}
/* allow valid phone */
function validPhone(Phone)
{
	//namePhone
	if(Phone.value == "" || Phone.value == null){
		$("#phoneErrorLbl").addClass('highlightNew');
		$("#idSupplierForm").find("label[for=namePhone]").removeClass('error valid');
	}else{	
	    	var regPhone= /^\(?([0-9]{5})\)?[-. ]?([0-9]{6})$/;
	    	if (regPhone.test(Phone.value) == false){
	            $("#phoneErrorLbl").removeClass('highlightNew');
	            $("#idSupplierForm").find("label[for=namePhone]").removeClass('error valid');
	            return false;
	        }
	    	$("#idSupplierForm").find("label[for=namePhone]").addClass('error valid');
	    	$("#phoneErrorLbl").addClass('highlightNew'); 	
    return true;
	}
}
</script>
</head>
<body>
	<div class="wrap">
		<div class="main">
			<div id="myTabContent" class="tab-content">
				<div class="tab-pane active" id="supplier">
					<h1>Add Supplier</h1>
					<div class="menu-tabs">
						<form id="idSupplierForm">
							<div class="clean4">
								<div>
									Fields marked as <span style="color: red">*</span> are
									mandatory.
								</div>
								<div class="lft-tbl">
									<div class="form-group">
										<label>Supplier name <span style="color: red">*</span></label>
										<input type="hidden" name="namedatasourceId" id="datasourceId">
											<input type="hidden" name="namepartyTypeId" id="partyTypeId"><input type="hidden" id="idCreatedUser" name="nameCreatedUser" value="${createdUser}">
											<input type="hidden" name="namehiddenCustomerDetails" id="idhiddenCustomerDetails" value="<%=CustomerDetails%>">
											<input type="hidden" name="namehiddengetStates" id="idhiddengetStates" value="<%=getStates%>">
											<input type="hidden" name="namehiddenAddingManufacturer" id="idhiddenAddingManufacturer" value="<%=AddingManufacturer%>">
												<input type="text" name="nameSupplierName" onkeypress="return isProductKey(event)" ondragover="allowDrop(event)" ondrop="drop(event)" maxlength="100" class="search-box">
									</div>
									<!-- <div class="form-group control-group">
									<label>Supplier Code</label>
									<input type="text" name="nameSupplierCode" onkeypress="return isProductKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box"/>
									</div> -->
									<div class="form-group control-group">
										<label>Address 1 <span style="color: red">*</span></label>
										<textarea style="width: 82%" name="nameAddress1" onkeypress="return isAlphaNumWithSpecSlaKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)"></textarea>
									</div>
									<div class="form-group control-group">
										<label>Address 2</label>
										<textarea name="nameAddress2" onkeypress="return isAlphaNumWithSpecSlaKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)"></textarea>
									</div>
									<div class="form-group control-group">
										<label>City <span style="color: red">*</span></label><input type="text" name="nameCity" onkeypress="return isCharSpacKey(event)" maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">
										<label>State <span style="color: red">*</span></label> <select name="nameState" id="idState"></select><!-- <input type="text" name="nameState" onkeypress="return isCharSpacKey(event)" maxlength="250" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box"> -->
									</div>
									<div class="form-group control-group">
										<label>Email <span style="color: red">*</span></label> <input type="email" name="nameEmail" maxlength="100" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">
										<label>Pincode <span style="color: red">*</span></label> <input type="text" name="namePincode" class="search-box" onKeyPress="return isNumberKey(event)" maxlength="6" ondragover="allowDrop(event)" ondrop="drop(event)" >
									</div>
								</div>
								<div class="rgt-tbl">
								<div class="form-group control-group">
										<label>Phone </label> <input type="text" name="namePhone" class="search-box" onKeyPress="return isNumberKey(event)" onblur="validPhone(this)" maxlength="11" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="phoneErrorLbl" class="notValid">Please Check Phone No is Invalid</label>
									</div>
									<div class="form-group control-group">
										<label>Mobile <span style="color: red">*</span></label> <input type="text" name="nameMobile" class="search-box" onKeyPress="return isNumberKey(event)" onblur="validMobile(this)" maxlength="10" ondragover="allowDrop(event)" ondrop="drop(event)"><label id="mobileErrorLbl" class="notValid">Please Check Mobile No is Invalid</label>
									</div>
									<div class="form-group control-group">
										<label>CST Number</label> <input type="text" name="nameCstno" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">
										<label>Tin Number <span style="color: red">*</span></label> <input type="text" name="nameTinno" onkeypress="return isTinNoKey(event)" maxlength="20" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">
										<label>DL Number.</label> <input type="text" name="nameDlNumber" maxlength="20" onkeypress="return isTinNoKey(event)" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">

										<label>GST Number.</label> <input type="text" name="nameGstNumber" maxlength="20" onkeypress="return isTinNoKey(event)" ondragover="allowDrop(event)" ondrop="drop(event)" class="search-box">
									</div>
									<div class="form-group control-group">
										<label>URL</label>
										<input type="text" name="nameUrl" onblur="validUrl(this)" ondragover="allowDrop(event)" ondrop="drop(event)" maxlength="100" class="search-box">
										<label id="urlErrorLbl" class="notValid" >Please Check URL is not valid</label>
										<label id="nameUrlLbl"></label>
										<input id="clientTarneaId" hidden="true" name="clientTarneaId" value="${targetPartyId}" />
									</div>
								</div>
							</div>
							<div class="btn-new">
								<input type="submit" class="btn btn-map"
									onClick="javascript:showSavePopUp()" data-toggle="modal"
									style="margin-left: 10px;" value="Save">
							</div>
							<div class="btn-new">
								<a class="btn btn-review" href="#" style="margin-left: 10px;"
									onClick="javascript:resetForm()"> Reset</a>
							</div>
						</form>
					</div>
				</div>
				<!-- Modals -->
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
				<div id="saveConfirmModal" class="modal hide fade" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-header">
						<h3 id="myModalLabel">Add New Supplier</h3>
					</div>
					<div class="modal-body">
						<div class="mod-pop">
							<table width="100%">
								<tr>
									<td colspan="2" width="100%"><b>Do you want to save
											the records?</b></td>
								</tr>
							</table>

						</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-primary" id="btnSupplierSave"
							data-dismiss="modal">Yes</button>
						<button type="button" class="btn btn-review" data-dismiss="modal"
							style="margin: 0px 0 0 10px;" aria-hidden="true">No</button>
					</div>
				</div>
				<div id="SuccessModal" class="modal hide fade" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
					<div class="modal-header">
						<h3>
							<span id="spanHeader">Success!</span>
						</h3>
					</div>
					<div class="modal-body">
						<div class="mod-pop" id="divMessage">Supplier added successfully!.</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-primary" id="sucessOkButton" >OK</button>
					</div>
				</div>
				<div id="alertModal" class="modal hide fade" tabindex="-1"
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
						<button class="btn btn-primary" data-dismiss="modal">OK</button>
					</div>
				</div>
				<div id="waitModal" class="modal hide fade" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
					<div class="modal-header">
						<h3>
							<span>Please Wait...</span>
						</h3>
					</div>
					<div class="modal-body">
						<div class="mod-pop">Your supplier is being added.</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>