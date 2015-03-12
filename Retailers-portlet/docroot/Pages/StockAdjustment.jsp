<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<portlet:defineObjects />
<liferay-theme:defineObjects />
<portlet:actionURL var="processstockAdjuctment">
	<portlet:param name="myaction" value="processStockAdjustment" />
</portlet:actionURL>
<portlet:resourceURL var="ProductSearch" id="ProductSearch" />
<portlet:resourceURL var="ProductDetail" id="ProductDetail" />
<portlet:resourceURL var="BatchList" id="BatchList" />
<portlet:resourceURL var="ReasonList" id="ReasonList" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Purchase Order</title>
<%
	long userId = themeDisplay.getUserId();
	User userObj = UserLocalServiceUtil.getUser(userId);
	String screenname = userObj.getScreenName();
	String firstname = userObj.getFirstName();
%>
<script type="text/javascript">
var username = '<%=screenname%>';
		var itemsCount = 0;
		var proCount=0;
		jQuery(document).ready(function() {
			
			jQuery("#productName").select2({
				placeholder: "Search Product",
				allowClear: true,
				minimumInputLength: 3				
		}); 

			
		$("#productName").select2("focus");
		$('.select2-choice').attr('tabindex', '-1');
			$(".loadingImage").show();
			$('.loadingImage').animate({ opacity: 1	}, 500, function() {
				var urlprodser = '${ProductSearch}';
				$.ajax({
				    type: 'GET',
				    url: urlprodser,
				    async: false,
				    data: {
				        'service': 'ProductSearch',
				        'targetPartyId': ${targetPartyId}
				    },
				    success: function(data) {
				        productslist = data.productList;
						$("#productName").append('<option value="0"></option>');
				        for (var i = 0; i < productslist.length; i++) {
				            $("#productName").append('<option value=' + productslist[i].productId + '>' + productslist[i].productName + '</option>');
				        }
				        $(".loadingImage").hide();
				    },
				    error: function() {
				    	$(".loadingImage").hide();
				    	$("#productListError").modal('show');
				    	$('#productListError .btn').focus();
				    }
				});
			});
		});
	</script>
</head>
<body>
	<div class="container">
		<div class="wrap">
			<div class="row-fluid">
				<div class="span12">
					<!-- Primary Tab's -->
					<div class="row-fluid">
						<div class="span12">
							<div class="tabPurchaseOrder">
								<ul id="myTab" class="nav nav-tabs">
									<li id="order_tab" class="tabHeading"></li>
									<li class="active"><a href="#create_order"
										data-toggle="tab">Stock adjustment</a></li>
								</ul>
							</div>
						</div>
					</div>

					<!-- Status Message to be displayed -->
					<input type="hidden" value="${statusMessage}" id="hiddenmsg" />

					<!-- Content's -->
					<div class="row-fluid">
						<div class="span12">
							<h4>Stock Adjustment</h4>
							<div id="myTabContent" class="tab-content">
								<div class="tab-pane active" id="create_order">
									<div class="row-fluid">
										<div class="span12">
											<table class="table table-bordered">
												<thead>
													<tr>
														<th class="span4">Product List</th>
														<th class="span3">UOM</th>
														<th class="span3">Batch No.</th>
														<th class="span3">Qty in System</th>
														<th class="span3">Actual Physical Qty</th>
														<th class="span3">Reason</th>
														<th class="span2">Action</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td class="span4"><select id="productName"
															tabindex="1" class="no-space selectProduct"
															name="productName" data-placeholder="Select Product"
															autofocus="autofocus">
														</select>
															<div class="loadingImage"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath()%>/img/ajax.gif" />
															</div></td>
														<td class="span3"><select id="uomId" tabindex="2"
															class="no-space" name="uomId"
															data-placeholder="Select Uom">
														</select>
															<div class="loadingImage2"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath()%>/img/ajax.gif" />
															</div> <input id="principalName" type="hidden" value="" /> <input
															id="principalPartyId" type="hidden" value="" /> <input
															id="division" type="hidden" value="" /> <input
															id="amount" type="hidden" value="" /></td>

														<td class="span3"><select id="batchNo" tabindex="2"
															class="no-space" name="batchNo">
														</select></td>

														<td class="span2"><input class="input-small"
															type="text" id="qtyInSystem" disabled /> <input
															id="inventoryItemId" type="hidden" value="" /></td>
														<td class="span2"><input class="input-small"
															type="text" id="qtyFound" tabindex="4" maxlength="8"
															onkeypress="return isNumberKey(event)" /></td>

														<td class="span2"><select id="reason" tabindex="5"
															class="no-space" name="reason">
														</select> <input type="hidden" id="reasonVal" value="" tabindex="4" /></td>
														<td class="span2"><a class="btn" id="addrow"
															tabindex="6" href="#" data-bind="click: $root.addItem"><i
																class="icon-plus icon-black"></i>Add</a></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid">
										<div class="span12">
											<table id="purchaseProduct" class="table table-bordered">
												<thead>
													<tr>
														<th class="span4" style="width: 328px;">Product Name</th>
														<th class="span3" style="width: 210px;">UOM</th>
														<th class="span3" style="width: 210px;">Batch No.</th>
														<th class="span3" style="width: 150px;">Qty in
															System.</th>
														<th class="span3" style="width: 150px;">Actual
															Physical Qty</th>
														<th class="span3" style="width: 310px;">Reason</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: items">
													<tr>
														<td class="span3"><span data-bind='text: productName'></span>
														</td>
														<td class="span2"><span data-bind='text: uomId'></span>
														</td>
														<td class="span2"><span data-bind='text:batchNo'></span>
														</td>
														<td class="span2"><span data-bind='text: qtyInSystem'></span>
														</td>
														<td class="span2"><span data-bind='text: qtyFound'></span>
														</td>
														<td class="span2"><span data-bind='text:reason '></span>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid">
										<div class="span12">
											<form:form name="processCartItemForm"
												id="processCartItemForm" commandName="processCartItem"
												method="post" action="${processstockAdjuctment}">
												<input type="hidden" id=AdjustedStock name="AdjustedStock"
													value="" data-bind='value: lastSavedJson' />
												<input type="hidden" value="true" name="subval">
												<a
													href="<portlet:renderURL><portlet:param name="myaction" value="showStocks" /></portlet:renderURL>"
													class="btn left-align" tabindex="7">Cancel</a>
												<button class="btn btn-success right-align" type="button"
													data-bind="click: submitOrderCon" id="submitUpdateCon"
													tabindex="8">Adjust Stock</button>
												<input type="hidden" data-bind="click: submitOrder"
													id="submitOrderSuc">
												<div style="display: none">
													<input id="cartItemSubmit" type="submit" />
												</div>
											</form:form>
										</div>
									</div>

									<script type="text/javascript">
								function isNumberKey(evt) {
									var charCode = (evt.which) ? evt.which : evt.keyCode;
										if (charCode == 0||charCode == 8 || charCode == 9 || charCode == 37 || charCode == 38 || charCode == 39 || charCode == 40|| charCode == 46) // back space, tab, delete, enter
										return true;
									else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
									return true;
								}
								
								//Vinoth Edited for Assembla Ticket issue:- 1123 Fixes
								function submitOrderCancel(){
							    	$("#Confirmation").modal('hide');
							    }
							    function submitOrderCheck(){
							    	var isync=document.getElementById("isync");
							    	var icheck=document.getElementById("icheck");
							    	//alert('Coming....first..'+isync+'Second..'+icheck);
							    	if(isync.checked==true && icheck.checked==true){
							    		$("#Confirmation").modal('hide');
							    		$("#AdjustingStock").modal('show');
							    		$("#submitOrderSuc").click();
							    		}else{
							    			document.getElementById("error").innerHTML="Please select BOTH options OR Press Cancel";
							    		}
							    }
								$("#productName").change(function() {
									
									var id = $(this).val();
									if(id >0){
										$("#uomId").empty();
										$("#batchNo").empty();
										$("#qtyInSystem").val('');
										$("#reason").empty();
										$(".loadingImage2").show();
										$("#productName").disabled=true;
										$('.loadingImage2').animate({ opacity: 1 }, 500, function() {
											var urlproddetail = '${ProductDetail}';
											$.ajax({
												type: 'GET',
												url: urlproddetail,
												data: {
													'service': 'ProductDetail',
													'productId': id,
													'targetPartyId': ${targetPartyId}
												},
												async: false,
												success: function(data) {
													$("#productName").disabled=false;
													$(".loadingImage2").hide();
													var principal = data.productList;
													for (var i = 0; i < principal.length; i++) {
														$("#principalName").val(principal[i].principalName);
														$("#principalPartyId").val(principal[i].principalPartyId);
														$("#division").val(principal[i].division);
													}
													
													var uom = data.uomList;
													if( uom.length>0){
													for (var i = 0; i < uom.length; i++){
														if(uom[i].uomIdTo=="" ||uom[i].uomIdTo=="null" || uom[i].uomIdTo==null ){
															$("#uomId").append('<option>' + uom[i].uomId + '</option>');
														}else{
															$("#uomId").append('<option>' + uom[i].uomIdTo + '</option>');
														}
														
													}
												}else{
													$("#commonPopup").modal('show');
													$("#idCommonHead").text("Please Check...");
													$("#idCommonBody").text("UoM is Not Avalible");
												}
													var urlbachlist = '${BatchList}';
												$.ajax({
													type: 'GET',
												        url: urlbachlist,
												        data: {
												            'service': 'BatchList',
												            'targetPartyId':${targetPartyId},
															'productId':  $("#productName option:selected").val()
												        },
												        async: false,
												        success: function(data) {
												        	
												        	var batchList = data.productBatchDetails;
												        	
															for (var i = 0; i < batchList.length; i++) {
																$("#batchNo").append('<option>' + batchList[i].serialNumber + '</option>');
															}
															if(batchList.length>0)
																{
												        	$("#qtyInSystem").val(batchList[0].availableToPromiseTotal+batchList[0].freeQuantity);
												        	$("#inventoryItemId").val(batchList[0].inventoryItemId);
												        	var urlreasonlist = '${ReasonList}';
												        	$.ajax({
																type: 'GET',
														        url: urlreasonlist,
														        data: {
														            'service': 'ReasonList',
														            'targetPartyId':${targetPartyId}
																	
														        },
														        async: false,
														        success: function(data) {
														        	
														        	var reson = data.stockVarianceReason;
														        	
																	for (var i = 0; i < reson.length; i++) {
																		$("#reason").append("<option value='"+reson[i].varianceReasonId+"'>" + reson[i].description + "</option>");
																	}
												        	
														        }
												        	});
												        	$("#reasonVal").val($("#reason option:selected").val());
												            $("#batchNo").change(function(){
													        	
																	 var selIndex=$('option:selected',$(this)).index();  
																	 var totalQty =batchList[selIndex].availableToPromiseTotal+batchList[selIndex].freeQuantity;
																		$("#qtyInSystem").val(totalQty);
																		$("#inventoryItemId").val(batchList[selIndex].inventoryItemId);
																        });
																}else{
																$("#qtyFound").val('');
																$("#uomId").empty();
																$("#inventoryItemId").val('');
																$("#commonPopup").modal('show');
																$("#idCommonHead").text("Please Check...");
																$("#idCommonBody").text("NO BATCH NUMBERS AVAILBALE.");
																$("#productName").select2('data', null);
																$("#productName").val('');
															}
															  $("#reason").change(function(){
																	$("#reasonVal").val($('option:selected',$(this)).val());
													        });
												        }
													}); 
												},
												error: function() {
													$(".loadingImage2").hide();
													$("#productName").disabled=false;
													$("#productListError").modal('show');
													$('#productListError .btn').focus();
												}
											});
										});
									}
								});
								
								/* knockout Bindings */
								
								var id = 0;
								var name = "";
								var uom = "";
								var qty = 0;
								var principalName = "";
								var principalId = "";
								var division = "";
								var amount = "";
								var	reasonVal="";
								var qtyInSystem=0;
								var qtyFound =0;
								var reason ="";
								var batchNo ="";
								var inventoryItemId ="";
								
								var ProductItem = function() {
								    var self = this;
									self.productId = ko.observable(id);
									self.productName = ko.observable(name);
									self.uomId = ko.observable(uom);
									self.quantity = ko.observable(qty);
									self.principalName = ko.observable(principalName);
									self.principalPartyId = ko.observable(principalId);
									self.division = ko.observable(division);
									self.amount = ko.observable(amount);
									self .qtyInSystem= ko.observable(qtyInSystem);
									self .qtyFound= ko.observable(qtyFound);
									self .reason= ko.observable(reason);
									self .batchNo= ko.observable(batchNo);
									self .reasonVal= ko.observable(reasonVal);
									self.inventoryItemId=ko.observable(inventoryItemId);
								};

								var Product = function() {
									var self = this;
									self.items = ko.observableArray();	//Put one line in by default
									
									self.addItem = function() {
										var pName = $("#productName  option:selected").text();
										var uId = $("#uomId option:selected").text();
										var qntyFound = $("#qtyFound").val();
										var batchNumber = $("#batchNo option:selected").text();
										var qntyInSystem=$("#qtyInSystem").val();
										var inventorynItemId=$("#inventoryItemId").val();
										//dataTodisplay = JSON.stringify(dataTodisplay);
										var inventorycheck = true;								        
								        $.each(self.items(),function(){
								        	var invid = this.inventoryItemId();
								        	if(invid == inventorynItemId)
											{
												//alert('Duplicate entry');
												inventorycheck = false;
											}
								        })
										if(pName != "" && uId != "" && batchNumber != "" && inventorycheck == true && (qntyFound != qntyInSystem) && (qntyFound==0 || qntyFound>0)  && qntyFound!="" && (qntyFound % 1 == 0) && (/^[a-zA-Z0-9- ]*$/.test(qntyFound) == true)) {
											proCount++;
											id = $("#productName  option:selected").val();
											name = pName;
											uom = uId;
											principalName = $("#principalName").val();
											principalId = $("#principalPartyId").val();
											division = $("#division").val();
											amount = $("#amount").val();
											
											qtyInSystem=qntyInSystem;
											qtyFound=qntyFound;
											batchNo=batchNumber;
											reasonVal=$("#reasonVal").val();
											reason=$("#reason option:selected").text();
											inventoryItemId=inventorynItemId;
											self.items.push(new ProductItem());
											//clear the field value
											$("#uomId").empty();
											$("#batchNo").empty();
											$("#reason").empty();
											$("#qtyInSystem").val('');
											$("#qtyFound").val('');
											$("#principalName").val('');
											$("#inventoryItemId").val('');
											
											$("#principalPartyId").val('');
											$("#division").val('');
											$("#amount").val('');
											$("#productName").select2("val", "0");
											$("#productName").select2("focus");
										} else {
											if(qntyFound == qntyInSystem)
											{
												$("#addQuantityError").modal('show');
												$('#addQuantityError .btn').focus();
											}
											else if(inventorycheck == false)
											{
												$("#addInventoryError").modal('show');
												$('#addInventoryError .btn').focus();
											}
											else
											{
												$("#addCartError").modal('show');
												$('#addCartError .btn').focus();
											}
										}
									};

								    self.lastSavedJson = ko.observable("");
								    //Vinoth K S Edited Regarding 1123 Issue Fixes
								    self.submitOrderCon=function()
								    {
								    	if(proCount==0)
								    		{
								    		//alert("First Check:-"+proCount);
								    		$("#addCartErrorCh").modal('show');
								    		}
								    	else
								    		{
								    		//alert(proCount);
								    		$("#Confirmation").modal('show');
								    		}
								    	
								    };
								    
								    //Vinoth Edited for fixing issue 1123
								    								    
									self.submitOrder = function() {
										
											var dataToSave = $.map(self.items(), function(line) {
								        	var targetPartyId= ${targetPartyId};
								            return line.qtyFound() ? {
								                adjustmentQty: getQtyDiff(line.qtyFound(),line.qtyInSystem()),
								                comments: username,
								                //comments: 'update thru json',
								                partyId: convertToString(targetPartyId),
								                inventoryDate: convertToString(Date.now()),
								                reason : line.reasonVal(),
								                inventoryItemId :line.inventoryItemId()
								            } : undefined;
								        });
											
								        self.lastSavedJson(JSON.stringify(dataToSave));

								        if(dataToSave != null && dataToSave != "") { 
								        	
								        	$("#submitUpdateCon").disabled=true;
								        	$("#changing").modal('show');
								        	
								        	$("#processCartItemForm").ajaxSubmit({
								                url : '${processstockAdjuctment}',
								                type : 'POST',
								                success : function(data){  
								                	$("#changing").modal('hide');
								                	$("#AdjustingStock").modal('hide');
								                	$("#SuccessProduct").modal('show');
								                	$("#submitUpdateCon").disabled=false;
								                	
								                	
								                },
								                error : function()
								                {
								                	alert("Error");
								                	$("#purchaseItemError").modal('show');
													$('#purchaseItemError .btn').focus();
								                }
								            });
											} else {
											$("#purchaseItemError").modal('show');
											$('#purchaseItemError .btn').focus();
										};
											
									};
								};

								ko.applyBindings(new Product());
								/* knockout ends here */
							</script>
								</div>
							</div>
						</div>
					</div>

					<!-- Modal's -->
					<div id="addCartError" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color: black;">Add Items</h4>
						</div>
						<div class="modal-body">
							<h5>All field's are mandatory</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>

					<div id="addQuantityError" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color: black;">Add Items</h4>
						</div>
						<div class="modal-body">
							<h5>Nothing to Adjust..</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>


					<div id="addInventoryError" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color: black;">Add Items</h4>
						</div>
						<div class="modal-body">
							<h5>Duplicate Entry not permitted..</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>

					<div id="changing" class="modal hide fade">
						<div class="modal-header">
							<span>Adjusting Stock </span>
						</div>
						<div class="modal-body" style="float: center;">
							<img src="<%=request.getContextPath()%>/img/loading.gif" />
							<!-- <div class="loading">
									<span>Editing </span>
								</div> -->
						</div>
						<div class="modal-footer"></div>
					</div>

					<div id="addCartErrorCh" class="modal hide fade">
						<div class="modal-header">
							<h4 style="color: black;">Add Items</h4>
						</div>
						<div class="modal-body">
							<h5>Add product's in Cart</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>

					<div id="productListError" class="modal hide fade">
						<div class="modal-header">
							<h4>Product</h4>
						</div>
						<div class="modal-body">
							<h5>Product's not available</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>
					<div id="commonPopup" class="modal hide fade">
						<div class="modal-header">
							<h4 id="idCommonHead"></h4>
						</div>
						<div class="modal-body">
							<h5 id="idCommonBody">Product's not available</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>
					<div id="SuccessProduct" class="modal fade" data-keyboard="false"
						data-backdrop="static">
						<div class="modal-header">
							<Span align="center">Stock Adjustment</Span>
						</div>
						<div class="modal-body">
							<h5>Stock Adjusted Sucessfully</h5>
						</div>
						<div class="modal-footer">
							<a
								href="<portlet:renderURL><portlet:param name="myaction" value="showStocks" /></portlet:renderURL>"
								class="btn">Ok</a>
						</div>
					</div>

					<!-- Confirmation Modal Box -->
					<div id="Confirmation" class="modal fade" data-keyboard="false"
						data-backdrop="static">
						<div class="modal-header">
							<Span align="center">Stock Adjustment Confirmation</Span>
						</div>
						<div class="modal-body">
							<table>
								<form>
									<tr>
										<td><input type="checkbox" name="isync" id="isync">
											I have synced all the tablet devices successfully</td>
									</tr>
									<tr>
										<td></td>
									</tr>
									<tr>
										<td><input type="checkbox" name="icheck" id="icheck">
											I have counted and verified the physical quantity I am
											entering in the "Actual Physical Quantity" Field</td>
									</tr>
								</form>
								<tr>
									<td></td>
								</tr>
								<span style="color: red" id='error'></span>
							</table>
						</div>
						<div class="modal-footer">
							<input type="button" name="submitOrderCheck"
								onClick="submitOrderCheck()" value="Ok"> <input
								type="button" name="submitOrderCancel"
								onClick="submitOrderCancel()" value="Cancel">
						</div>
					</div>

					<!-- alternate confirmation Box -->

					<div id="AdjustingStock" class="modal fade" data-keyboard="false"
						data-backdrop="static">
						<div class="modal-header">
							<Span align="center">Stock Adjustment</Span>
						</div>
						<div class="modal-body">
							<h5>Stock Adjusting...</h5>
						</div>
						<div class="modal-footer">
							<!-- <input type="button" name="submitOrderCheck" onClick="submitOrderfinalCheck()" value="Ok"> <input type="button" name="submitOrderCancel" onClick="submitOrderCancel()" value="Cancel"> -->
						</div>
					</div>
					<div id="purchaseItemError" class="modal hide fade">
						<div class="modal-header">
							<h4>Purchase Cart</h4>
						</div>
						<div class="modal-body">
							<h5>Add product's in Cart</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>
					<div id="AdjsuConfirmation" class="modal hide fade">
						<div class="modal-header">
							<h4>Stock Adjustment</h4>
						</div>
						<div class="modal-body">
							<h5>Have You Synced All the tablet Devices Sucessfully?</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
						</div>
					</div>
				</div>
	<script type="text/javascript">
		function dataFocus()
		{
			$("#productName").select2("data", { id: 0, text: ''});
			$("#productName").select2("focus");
			$("#productName").select2("val", "0");
			$("#productName").select2("focus");
		}
		function getQtyDiff(qty,qtyInSystem)
		{
			var amt = parseInt(qty)-parseInt(qtyInSystem);
			return amt.toString();
		}
		function convertToString(date)
		{
			return date.toString();
		}
		function dismissModal(countVal) {
			$('#purchaseOrderPrintModal'+countVal).modal('hide');
			showTheModal(countVal-1);
		}
	</script>
			</div>
		</div>
	</div>
</body>
</html>