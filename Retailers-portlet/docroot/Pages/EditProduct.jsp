<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<portlet:defineObjects />
<portlet:actionURL var="processCart">
	<portlet:param name="myaction" value="processEditProduct" />
</portlet:actionURL>

<portlet:resourceURL var="ProductSearch" id="ProductSearch" />
<portlet:resourceURL var="ProductDetail" id="ProductDetail" />
<portlet:resourceURL var="BatchList" id="BatchList" />
<portlet:resourceURL var="ProductNew" id="ProductNew" />
<portlet:resourceURL var="ProductRemove" id="ProductRemove" />
<portlet:resourceURL var="GetUOMlist" id="GetUOMlist" />
<portlet:resourceURL var="Inventoryempty" id="Inventoryempty" />
<portlet:resourceURL var="CustomerDetails" id="CustomerDetails" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="Content-Type">
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/EditProduct.js?<%System.currentTimeMillis();%>"></script>
<script type="text/javascript">
	var partyId = ${targetPartyId};
	var globaldata;
	var globalstock;
	var lastSavedJson;
	var result = {};
	var finalresult = [];
	var resultMap1 = [];
	var removebatch = [];
	var resultRemove = [];
	var uomTo;
	var uomFo;
	var packval;
	var uomc = 0;
	var packc = 0;
	var cpack1 = 0;
	var packsize;
	var checkval;
</script>
<title>Edit Product</title>
<style>
	    .fnt3
		{
		 color: #FF0000;
		 font-size:10pt;
		 margin-right:8px; 	
		}
		
		.fnt4
		{
		 color: #ea700d;
		 font-size:15pt;
		 margin-left:2px
		}
		
		.fnt5
		{
		 color: #FF0000;
		 font-size:12pt;
		}
		
		.fnt6
		{
		 color: #828282;
		 font-size:12pt;
		}
		
		.fnt7
		{
		 color: #4C4C4C;
		 font-size:10pt;
		}
		.fnt8
		{
		 color: #4C4C4C;
		 font-size:12pt;
		}
		
		.fnt9
		{
		 color: #4C4C4C;
		 font-size:12pt;
		}
		
		.fnt10
		{
		 color: #FAFFBD;
		 font-size:12pt;
		}
		
		.fnt11
		{
		 color: #FF0000;
		 font-size:8pt;
		 line-height:1;
		}
		
		.fnt12
		{
		 color: #167001;
		 font-size:8pt;
		}
		
		.fnt13
		{
		 color: #167001;
		 font-size:12pt;
		}
		
		
.loading {
  font-family: "Arial Black", "Arial Bold", Gadget, sans-serif;
  text-transform:uppercase;
  
  width:150px;
  text-align:center;
  line-height:50px;
  
  position:absolute;
  left:0;right:0;top:50%;
  margin:auto;
  transform:translateY(-50%);
}

.loading span {
  position:relative;
  z-index:999;
  color:#fff;
}
.loading:before {
  content:'';
  background:#61bdb6;
  width:128px;
  height:36px;
  display:block;
  position:absolute;
  top:0;left:0;right:0;bottom:0;
  margin:auto;
  
  animation:2s loadingBefore infinite ease-in-out;
}

@keyframes loadingBefore {
  0%   {transform:translateX(-14px);}
  50%  {transform:translateX(14px);}
  100% {transform:translateX(-14px);}
}


.loading:after {
  content:'';
  background:#ff3600;
  width:14px;
  height:60px;
  display:block;
  position:absolute;
  top:0;left:0;right:0;bottom:0;
  margin:auto;
  opacity:.5;
  
  animation:2s loadingAfter infinite ease-in-out;
}

@keyframes loadingAfter {
  0%   {transform:translateX(-50px);}
  50%  {transform:translateX(50px);}
  100% {transform:translateX(-50px);}
}
		
</style>
</head>
<body>
	<div class="container">
		<div class="wrap">
			<div class="row-fluid">
				<div class="span10">
					<!-- Primary Tab's -->
					<div class="row-fluid">
						<div class="span12">
							<div class="tabPurchaseOrder">
								<ul id="myTab" class="nav nav-tabs">
									<li id="order_tab" class="tabHeading"></li>
									<li class="active"><a href="#create_order" data-toggle="tab">Change Product UOM/Package</a></li>
								</ul>
							</div>
						</div>
					</div>

					<!-- Status Message to be displayed -->
					<input type="hidden" value="${statusMessage}" id="hiddenmsg" />

					<!-- Content's -->
					<div class="row-fluid">
						<div class="span12">
							<div >
								<div class="left-align">
									<span class = "fnt4">Change Product UOM/Package</span>
								</div>
								<!-- <div class="left-align"> -->
								<div style="margin-right:0px;float:right;" >		 
						    		<span class = "fnt3" >Note: Values in red are changed</span>
						    	</div>
							</div>
						</div>
					</div>
					<div id="myTabContent" class="tab-content">
						<div class="tab-content1">
								<div class="tab-pane active" id="create_order">
									
									<div class="row-fluid">
										<div class="span12" style="text-align: center;">
										<span></span>
											<table class="table table-bordered">
												<tbody>
													<tr>
														<th class="span4">Search Product Name</th>
													</tr>
												</tbody>
												<tbody>
													<tr>
														<td class="span4">
														<!--  <input id="productNamec" name="productNamec" type="text" />-->
														<input type="text" id="productName" class = "fnt6" name="productName" class="search-box"/>
														<input id="hdnProductId" hidden="true" name="ProductId" />
														<input type="hidden" id="partyRoleTypeId" name="partyRoleTypeId">
														<input type="hidden" id="idhiddenProductSearch" name="namehiddenProductSearch" value="<%=ProductSearch%>">
														<input type="hidden" id="idhiddenProductDetail" name="namehiddenProductDetail" value="<%=ProductDetail%>">
														<input type="hidden" id="idhiddenBatchList" name="namehiddenBatchList" value="<%=BatchList%>">
														<input type="hidden" id="idhiddenProductNew" name="namehiddenProductNew" value="<%=ProductNew%>">
														<input type="hidden" id="idhiddenProductRemove" name="namehiddenProductRemove" value="<%=ProductRemove%>">
														<input type="hidden" id="idhiddenGetUOMlist" name="namehiddenGetUOMlist" value="<%=GetUOMlist%>"> 
														<input type="hidden" id="idhiddenInventoryempty" name="namehiddenInventoryempty" value="<%=Inventoryempty%>">
														<input type="hidden" id="idhiddenCustomerDetails" name="namehiddenCustomerDetails" value="<%=CustomerDetails%>">
														<div class="loadingImage"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath() %>/img/ajax.gif" />
														</div></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								<div class = "editproduct" style="display:none">	
									<div class="row-fluid">
										<div class="span12" style="text-align: center;">
											<table class="table table-bordered">
											<caption>Enter New UOM or Package</caption>
												<tbody>
													<tr>
														<td width = "20%" class = "fnt6" class="span4">UOM</td>
														<td width = "30%" class = "fnt6" class="span4">Package Info (e.g. 1'S, 10'S etc.) <span style="color: red">*</span></td>
														<td width = "40%"></td>
													</tr>
													<tr>
														<td class="span4">
														 <input class = "fnt6" id="uomchange" name="uomchange" tabindex="3" type="text" autocomplete="on" />
														 <input id="hdnuomchange" hidden="true" name="uomchange" />
															<div class="idUomLoadingImage"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath() %>/img/ajax.gif" />
															</div> 
															<div class="loadingImage2"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath() %>/img/ajax.gif" />
															</div> 
														</td>
														<td class="span4"><input class="input-small"
															type="text" id="packchange" class = "fnt6" tabindex="4" maxlength="8"/></td>
														<td></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid">
										<div class="span13" style="text-align: center;">
											<table class="table table-bordered">
												<caption>Product Detail</caption>
												<thead>
													<tr>
														<th width = "5%"></th>
														<th width = "10%" class = "fnt7">VAT %</th>
														<th width = "15%" class = "fnt7">UOM</th>
														<th width = "15%" class = "fnt7">Package</th>
														<th width = "15%" class = "fnt7">Conversion</th>
														<th width = "35%"></th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td></td>
														<td><span id="vatId" class = "fnt8"></span></td>
														<td><span id="uomId" class = "fnt8" style="text-transform:capitalize;"></span></td>
														<td><span id="packId" class = "fnt8"></span></td>
														<td>
															<span id="conversionId" class = "fnt8" style="text-transform:capitalize;"></span>
															<span class = "fnt8" id="conversionId1"></span>
															<span class = "fnt8" id="conversionId2" style="text-transform:capitalize;"></span>
														</td>
														<td></td>
													</tr>
													<tr class = "editproduct1" style="display:none">
														<td></td>
														<td></td>
														<td style=" background-color:#ffdec9;"><span class = "fnt9" id="cuomId" style="text-transform:capitalize;"></span></td>
														<td style=" background-color:#ffdec9;"><span class = "fnt9" id="cpackId"></span></td>
														<td style=" background-color:#ffdec9;">
															<span class = "fnt9" id="cconversionId" style="text-transform:capitalize;"></span>
															<span class = "fnt9" id="cconversionId1"></span>
															<span class = "fnt9" id="cconversionId2" style="text-transform:capitalize;"></span>
														</td>
														<td></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid">
										<div class="span13" style="text-align: center;">
											<table class="table table-bordered">
												<caption>Stock and Price Value</caption>
												<thead id ="batchhead">
												</thead>
												<tbody id ="batchProduct" style=" background-color:#eeeeee;">
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid" id = "editproduct2" style="display:none">
										<div class="span13" style="text-align: left;">
											<div>
												<span class = "fnt11">* For Stock Mismatch use Stock Adjustment Portal.</span>
											</div>
											<div>
												<span class = "fnt11">* For MRP Mismatch use MRP Adjustment Portal.</span>
											</div>
											<div>
												<span class = "fnt12" id = "stockerror" style="display:none">* Stock in this color may require stock adjusment.</span>
											</div>											
										</div>
									</div>
								</div>
							</div>
						</div>
						</div>
						<div class="row-fluid">
							<div class="span12" style="margin:10px;">
								<button class="btn left-align" type="button" id="submitcancel" tabindex="7">Cancel</button>
								<button class="btn btn-success right-align" type="button" id="submitUpdateCon" tabindex="8">Edit Product</button>
								<input  type="hidden" id="submitUpdate" >
							</div>
						</div>
					<!-- Modal's -->
					<div id="change" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">Cancel</h4>
						</div>
						<div class="modal-body">
							<h5>All field's are mandatory</h5>
						</div>
						<div class="modal-footer">
						<input type="checkbox" name="isync1" id="isync1"> I have synced all the tablet devices successfully
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>
					
					<div id="editerror" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">Submit Error...</h4>
						</div>
						<div class="modal-body">
							<h5>>Product Not Edited</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					
					
					<div id="packalert" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">Pack Alert...</h4>
						</div>
						<div class="modal-body">
							<h5>Enter a Valid Pack</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					
					<div id="errorpack" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">Pack Error...</h4>
						</div>
						<div class="modal-body">
							<h5>Please enter a Valid Package Inforamtion</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					
					<div id="ConnectionCheck" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">Please check...</h4>
						</div>
						<div class="modal-body">
							<h5>Check your Internet Connection....</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					
					
					<div id="erroruom" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color:black;">UOM Error...</h4>
						</div>
						<div class="modal-body">
							<h5>Please Select UOM from the Drop Down</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>

					<div id="changeError" class="modal hide fade">
						<div class="modal-header">
							<h4>Edit Product</h4>
						</div>
						<div class="modal-body">
							<h5>No change applicable</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					
					<div id="changing" class="modal hide fade">
						<div class="modal-header">
							<span>Editing Product  </span>
						</div>
						<div class="modal-body" style="float: center;" >
						<img src="<%=request.getContextPath() %>/img/loading.gif" />
						<!-- <div class="loading">
						<span>Editing </span>
						</div> -->
						</div> 
						<div class="modal-footer">
						</div>
					</div>
					
					<div id="SuccessProduct" class="modal hide fade">
						<div class="modal-header">
							<h4>Success</h4>
						</div>
						<div class="modal-body">
							<h5>Product Edited Sucessfully</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Ok</a>
						</div>
					</div>
					<div id="Confirmation" class="modal hide fade">
						<div class="modal-header">
							<span align="center" >Product Edit Confirmation</span>
						</div>
						<div class="modal-body">
						<form>
						<table>
							<tr><td><input type="checkbox" name="isync" id="isync"> I have synced all the tablet devices successfully</td></tr>
							<tr><td></td></tr>
						<tr><td></td></tr>
						<tr><td><span style="color:red" id='error'></span></td></tr>
						</table>
						</form>
						<div class="modal-footer">
						<input type="button" name="submitUpdateCheck" onClick="submitUpdateCheck()" value="Ok"> 
						<input type="button" name="submitUpdateCancel" onClick="submitUpdateCancel()" value="Cancel">
					</div>
					</div>
				</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>