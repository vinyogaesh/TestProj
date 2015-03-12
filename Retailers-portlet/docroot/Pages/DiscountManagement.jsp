<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<portlet:defineObjects />
<portlet:resourceURL var="ProductSearch" id="ProductSearch" />
<portlet:resourceURL var="ProductDetailSearch" id="ProductDetailSearch" />
<portlet:resourceURL var="ProductDiscountSearch" id="ProductDiscountSearch" />
<portlet:resourceURL var="RemoveProductDiscount" id="RemoveProductDiscount" />
<portlet:resourceURL var="CreateProductDiscount" id="CreateProductDiscount" />
<portlet:resourceURL var="PartyDetails" id="PartyDetails" />
<portlet:resourceURL var="ServerDateDeail" id="ServerDateDeail" />
<html>
<head>
<title>Discount Management</title>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/scripts/DiscountManagement.js?<%=System.currentTimeMillis()%>"></script>
	<script type="text/javascript">
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
		var charCode;
		var chara;
		if(detectBrowser() == "Firefox"){
				charCode = evt.which;
				 chara = getChar(evt);
			}else if(detectBrowser() == "Chrome"){
				charCode = (evt.which) ? evt.which : evt.keyCode;
			}else{
				charCode = (evt.which) ? evt.which : evt.keyCode;
			}
		 var a=el.value.split(".") ;
		 var b = el.value.indexOf(".");
		 if(b >-1){
			 flag = true;
		 }
		 var key = String.fromCharCode(evt.keyCode);
		 var newLimit = /^[0-9]+$/i;
		 /* (charCode == 37 && key != "%") || (charCode == 39 && key != "'") ||  (charCode == 35 && key != "#") (charCode == 36 && key != "$") ||*/
		 if (charCode == 0 || charCode == 8 || charCode == 9 || (charCode == 97 && key != "a" && chara =="a +ctrl")||  (charCode == 190 && el.value.indexOf(".") < 0)) /* // back space, tab, delete, enter */{
			 if(flag == true){
			  	vala=a[0];
			  	valb=a[1];
			  
				  if(a[0]===vala){
					  if(a[1].length>6){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }
				  }else{
					  if(a[0].length>12){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }
				  }
				}
			   return true;
		   }else if (charCode > 31 && (charCode < 48 || charCode > 57)){
			  if(flag == true){
			  	vala=a[0];
			  	valb=a[1];
			  
				  if(a[0]===vala){
					  if(a[1].length>6){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }
				  }else{
					  if(a[0].length>12){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }
				  }
				}
			  return false;
		  }else {
			  if(flag == true){
			  	vala=a[0];
			  	valb=a[1];
				  if(a[0]===vala){
					  if(a[1].length>6){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }else if(a[0].length>12){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
					  }
				  }else{
					  if(a[0].length>12){
						  $("#frmLstDiscVal").val(a[0].substring(0, 12)+"."+a[1].substring(0, 6));
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
			  if(el.value.length >11) return false;
		  }   
		  return true;
	}
	
	/* limiting maximum limit is 100 */
	function minmax(value, min, max) 
	{
	     if(parseInt(value) == 0 || isNaN(value)) 
	    	return value; 
	    else if(parseFloat(value) >= 100.01)
	    	{
	    		$("#alertModel").modal('show');
				$("#spanHeader").html("Please Check...");
				$("#divMessage").html("Discount shouldn't be more than 100%");
	        	return 0;    	
	    	}
	    else return value;
	}
	</script>
</head>
<body>
	<div class="product-content">
		<div class="discSearch col-lg-12 col-md-12 margin0">
			<div class="head">Search Product</div>
			<div class="bodyContent col-lg-12 col-md-12">
				<div class="col-lg-5 col-md-5 padding0 pull-left">
					<label>Search by Product Name</label>
						<div class="right-inner-addon discValue searchPart">
    <i class="icon-search"></i>
           <input type="search" class="form-control" id="idProductName"	placeholder="Part Number"> 
					<img style="display: none" id="idProductLoadingImage"	src="<%=request.getContextPath()%>/img/ajax.gif" />
						<input type="hidden" id="hdnProductSearch" value="${ProductSearch}">
						<input type="hidden" id="hdnProductDetailSearch" value="${ProductDetailSearch}">
						<input type="hidden" id="hdnProductDiscountSearch" value="${ProductDiscountSearch}">
						<input type="hidden" id="hdnProductId" />
						<input type="hidden" id="hdnProductUnitPrice" />
						<input type="hidden" id="hdfrmdate" />
						<input type="hidden" id="hdtoDate" />
						<input type="hidden" id="idHdnPartyTypeId" />
						<!-- <input type="hidden" id="idHdnProductStoreId" /> -->
						<input type="hidden" id="TarneaPartyId" value="${targetPartyId}">
						<input type="hidden" id="idhiddenRemoveProductDiscount" value="${RemoveProductDiscount}">
						<input type="hidden" id="idhiddenCreateProductDiscount" value="${CreateProductDiscount}">
						<input type="hidden" id="idhiddenPartyDetails" value="${PartyDetails}">
						<%-- <input type="hidden" id="idurlServerDateDeail" value="${ServerDateDeail}"> --%> 
						<input type="hidden" id="idServerdate" value="${serverDate}">
					</div>
				</div>
			</div>
		</div>
		<div class="discSearch discW col-lg-12 col-md-12" id="frmPrdDetailBody">
<!-- 			<div class="head">Search Results</div> -->
       			<div class="bodyContent discountData col-lg-12 col-md-12">
				<div class="contentHead">
				<div class="col-1"></div>
				<div class="col-2">Product Name</div>
<!-- 		    <div class="col-3">Part Name</div>
				<div class="col-4">LSP* (Rs)</div> -->
				<div class="col-3">MRP* (Rs)</div>
				<div class="col-4">Discount Value</div>
				<div class="col-5">Start Date</div>
				<div class="col-6">End Date</div>
			</div>
			<div class="contentBody">
			    <div class="col-1">
			    <a href="#" class="expand popper" data-toggle="popover" data-trigger="hover"></a>
			    <div class="popper-content hide">
			<ul class="addtnInfo">
              <li>
                <div class="left">Manufacturer:</div>
                <div class="right discV" id="frmManufacturer"></div>
              </li>
              <li>
                <div class="left">UOM:</div>
                <div class="right discV" id="frmUom"></div>
              </li>
            </ul>
				</div>
			    </div>
				<div class="col-2" id="frmLstPartNum"></div>
				<!-- <div class="col-3" id="frmLstPartName"></div> -->
				<!-- <div class="col-4" id="frmLstPriceLsp"></div> -->
				<div class="col-3" id="frmLstPriceHsp"></div>
				<div class="col-4">
					<div class="input-group discValue editable padding0">
						<div class="input-group-btn">
							<!-- <select id="frlLstMet"> <option value="PRICE_POL" selected="selected">%</option> <option value="PRICE_FOL">RS</option> </select> -->
							 <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="frmLstDiscBut">
								<span data-bind="label" id="frmLstDescic"></span><span class="caret"></span>
							</button>
							<ul class="dropdown-menu" id="frlLstMet">
								<li id="PRICE_POL"><a>%</a></li>
								<li id="PRICE_FOL"><a>Rs</a></li>
							</ul> 
						</div>
						<input type="text" class="form-control" id="frmLstDiscVal" maxlength="19" onkeypress="return validateFloatKeyPressNew(this,event)" onkeyup="return validateFloatKeyPress(this,event)">
					</div>
				</div>
				<div class="col-5">
					<div class="input-group editable date">
						<input size="16" type="text" readonly="readonly" placeholder=" From" class="discDate" id="frmdate"> <span
							class="input-group-addon"><span
							class="glyphicon glyphicon-calendar"></span></span>
					</div>
				</div>
				<div class="col-6">
					<div class="input-group editable date">
						<input size="16" type="text" readonly="readonly" placeholder=" To" class="discDate" id="toDate"> <span
							class="input-group-addon"><span
							class="glyphicon glyphicon-calendar"></span></span>
					</div>
				</div>
			</div>
			<ul class="addtnInfo">
              <li>
                <div class="left">Discount(Rs):</div>
                <!-- <div class="right discV" id="lspDiscVal">0.00</div> -->
                <div class="right discV" id="hspDiscVal">0.00</div>
              </li>
              <li>
                <div class="left">Amount after Discount(Rs):</div>
                 <!-- <div class="right totalPaymnt" id="lspDiscAmtVal">0.00</div> -->
               <div class="right totalPaymnt" id="hspDiscAmtVal">0.00</div>
              </li>
            </ul>
           <!--  <div class="heighlight"></div> -->
		</div>
		</div>
		<div class="footerC" id="frmPrdDetailFooter">*Shown prices are taken from the most recent batch only.</div>
		<a href="#" class="btn btn-primary pull-left secondBtn" id="btnCancel">Cancel</a>
		<a class="btn btn-primary pull-right mainBtn" id="btnSave">Save</a>
		<a class="btn btn-primary pull-right mainBtn" id="btnEdit">Edit</a>
		<a href="#" class="btn btn-primary pull-right removeBtn" id="btnRemove">Remove</a>
	</div>
	
<div id="commonModal" class="modal fade" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="commonModalHead"></h4>
      </div>
      <div class="modal-body" >
        <h5 id="commonModalBody"></h5>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary secondBtn pull-left" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary mainBtn pull-right removeB" id="modalButOk">Submit</button>
      </div>
    </div>
  </div>
</div>

<div id="waitModal" class="modal fade" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Please Wait...</h4>
      </div>
      <div class="modal-body" >
        <h5>Please Wait...</h5>
      </div>
    </div>
  </div>
</div>

<div id="alertModal" class="modal fade" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="spanHeader"></h4>
      </div>
      <div class="modal-body" >
        <h5 id="divMessage"></h5>
      </div>
      <div class="modal-footer">
        <button class="btn mainBtn btn-primary" data-dismiss="modal">OK</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>