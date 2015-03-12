<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<portlet:defineObjects />
<portlet:resourceURL var="ProductSearch" id="ProductSearch" />
<portlet:resourceURL var="ProductDetailSearch" id="ProductDetailSearch" />
<portlet:resourceURL var="getPartyDetails" id="getPartyDetails" />
<portlet:resourceURL var="GetAllAlternateRegReq" id="GetAllAlternateRegReq"/>
<portlet:resourceURL var="ActionPostUrl" id="ActionPostUrl"/>
<html>
<head>
<title>Alternate Products</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/ScriptLibrary/angular.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/AlternateProduct.js?<%=System.currentTimeMillis()%>"></script>
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
	var charCode="";
	if(detectBrowser() == "Firefox"){
	    charCode = evt.which;
		charc = getChar(evt);
	}else if(detectBrowser() == "Chrome")	{
		charCode = (evt.which) ? evt.which : evt.keyCode;
	}else{
		charCode = (evt.which) ? evt.which : evt.keyCode;
	}
	/* var charCode = (evt.which) ? evt.which : evt.keyCode; */
	var newchartoenter2 = /^[a-zA-Z 0-9-.,]+/i;
    var key = String.fromCharCode(evt.which);
    if (charCode ==0 || charCode == 8 || charCode == 37 && key != "%"  ||  charCode == 46 || charCode == 97 || charCode == 35 && key != "#"  || charCode == 9 || newchartoenter2.test(key) || charCode == 36 && key !="$" ) {
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
    else if(charCode == 32 || key == 32) return true;
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
	var charCode;
	var charc;
	if(detectBrowser() == "Firefox"){
		charCode = event.which;
		charc = getChar(event);
	}else if(detectBrowser() == "Chrome"){
		charCode = (event.which) ? event.which : event.keyCode;
	}else{
		charCode = (event.which) ? event.which : event.keyCode;
	}
	var key = String.fromCharCode(event.which);
    if (charCode == 0 || charCode == 8 || charCode == 32 || charCode == 9 || (charCode >= 48 && charCode <= 57)||(charCode == 65 && char =="A +ctrl") /* /^(?=.*\d)(?:[\d ]+)$/.test(key) || */ || (charCode == 37 && key != "%") || (charCode == 97 && charc =="a +ctrl")) {
        return true;
    }
    return false;
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
function validPhone(Phone){
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
<div class="product-wrapper">
  <ul class="nav nav-tabs">
    <li class="active"><a href="#alternatePrdcts" data-toggle="tab">Alternate Products</a></li>
<!--     <li><a href="#relatedPrdcts" data-toggle="tab">Related Products</a></li>
 --></ul>
<div class="tab-content">
		<div class="tab-pane fade active in" id="alternatePrdcts">
<div class="product-content">
    <div class="dataTables_wrapper">  
    <div class="searchWrap pull-left">
               <div class="left pull-left">
               <button class='addNewCategory btn btn-primary pull-left' id='idbutAddGrp'>Create New Group</button>
               </div>
               
               <div class="right pull-right">
               	<button class="btn btn-primary buttonAdd pull-right col-lg-1 col-md-1" id="idButSearch"><span class="glyphicon glyphicon-search"></span></button>
                <input type="text" id="searchMethodsBox" class="pull-right col-lg-3 col-md-3">
                <select id="searchMethods" class="pull-right col-lg-2 col-md-2">
                    <option value="">----Select----</option>
                    <option value="partNumber">Poduct Name</option>
<!--                     <option value="partName">Part  Name</option> -->
                    <option value="category">Group Name</option>
                  </select>
                     <label class="pull-right">Search:</label>
                  </div>
			</div> 
          <table id="alternateTable" class="display dataTable" cellspacing="0">
            <thead>
              <tr>
                <th width="18%">Group Name</th>
                <th></th>
                <!-- <th width="26%">Part Number</th> -->
                <th width="35%">Product Name</th>
                <th width="18%">Date Modified</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          
          </table>
          
          <input type="hidden" id="hdnProductSearch" value="${ProductSearch}">
		  <input type="hidden" id="hdnProductDetailSearch" value="${ProductDetailSearch}">
          <input type="hidden" id="idHdnPartyTypeId" />
          <input type="hidden" id="idHdnProductStoreGroupId" />
          <input type="hidden" id="idHdnPrdId">
          <input type="hidden" id="idorderIdListValue">
          <input type="hidden" id="idHdnCreatedUser" value="${createdUser}">
          <input type="hidden" id="TarneaPartyId" value="${targetPartyId}">
          <input type="hidden" id="idhiddenPartyDetails" value="${getPartyDetails}">
          <input type="hidden" id="idHdnGetAllAlternateRegReq" value="${GetAllAlternateRegReq}">
          <input type="hidden" id="idHdnActionPostUrl" value="${ActionPostUrl}">
          <div class="fg-toolbar ui-toolbar ui-widget-header ui-helper-clearfix ui-data ui-corner-br margin0">
						<div class="pull-left" id="dataInfo"></div>
								<div class="paginate pagination pull-right">
								<ul><li class="prev"><button id="prevbut">Previous</button></li>
									<li class="next"><button id="nextbut">Next</button></li>
								</ul>
					</div>
				</div>
    </div>
 </div>
 <!-- <div class="tab-pane fade" id="relatedPrdcts">
 <div class="product-content">
 Related Products Content
 </div>
 </div> -->
 </div></div>
  <div id="addNewCategory" class="addNew modal fade" aria-hidden="false">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title">Create Alternate Product Group</h4>
      </div>
      <div class="modal-body">
        <table class="display" cellspacing="0" width="100%" id="itemList">
          <thead>
            <tr>
              <th width="30%">Group Name</th>
              <th width="70%;">Add Products</th>
          </tr></thead>
          <tbody>
            <tr>
              <td><input type="text" class="searchProduct pull-left" placeholder="Create Alternate Group" id="idTxtAlternateGrp" onkeypress="return isAlphaNumKey(event)"><span class="glyphicon glyphicon-remove-sign pull-left" style="margin:4px 0 0 5px;" id="idButRemoveAll"></span></td>
              <td><input type="text" class="searchProduct searchPart col-lg-5 col-md-5" placeholder="Product Name" id="idPartNo" required>
              <input type="hidden" id="idHdnPartNo" readonly>
              <input type="hidden" id="idHdnPartName" readonly>
              <input type="hidden" id="idHdnmanufac" readonly>
              <input type="hidden" id="idHdnuom" readonly>
              <img style="display: none; float:inherit" id="idProductLoadingImage" src="<%=request.getContextPath()%>/img/ajax.gif" />
              <ul class="typeahead dropdown-menu"></ul>
              <button class="btn btn-primary buttonAdd" id="idButAdd">Add</button></td>
            </tr>
            <tr>
              <td></td>
              <td><label class="col-md-3 col-lg-3">Product Name</label>
                <!-- <label class="col-md-7 col-lg-7">Part Name</label> --></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary secondBtn pull-left" data-dismiss="modal">Cancel</button>
        <button class="btn btn-primary mainBtn pull-right" id="idButSubmit">Submit</button>
      </div>
    </div>
  </div>
</div>
<div id="commonModal" class="fade modal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="commonModalHead"></h4>
			</div>
			<div class="modal-body"><h5 id="commonModalBody"></h5>
		</div>
		<div class="modal-footer">
		<!-- btn btn-primary pull-left secondBtn -->
			<button type="button" class="btn btn-primary pull-right mainBtn" data-dismiss="modal">Close</button>
			<!-- <button type="button" class="btn btn-primary pull-right mainBtn" id="btnConfirm" >Confirm</button> -->
        </div>
    </div>
</div>
</div></div>
<div id="waitModal" class="fade modal" data-backdrop="static">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Please Wait</h4>
					</div>
						<div class="modal-body"><h5>Your request is Processing Please wait a while...</h5>
					</div>
				<!-- <div class="modal-footer">
              </div> -->
            </div>
          </div>
        </div>
<div id="loadingAnimation" class="modal fade">
  <div class="bulat">
    <div id="dalbulat"> <span>L</span> <span>O</span> <span>A</span> <span>D</span> <span>I</span> <span>N</span> <span>G</span> </div>
    <div class="luarbulat"></div>
  </div>
</div>

</body>
</html>