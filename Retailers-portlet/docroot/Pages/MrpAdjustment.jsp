<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<portlet:defineObjects />
<liferay-theme:defineObjects/>
<portlet:actionURL var="processCart">
	<portlet:param name="myaction" value="processCartItem" />
</portlet:actionURL>
<portlet:resourceURL var ="ProductSearch" id="ProductSearch"/>
<portlet:resourceURL var="ProductDetail" id="ProductDetail"/>
<portlet:resourceURL var="BatchList" id="BatchList"/>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Purchase Order</title>

<%long userId = themeDisplay.getUserId();

User userObj = UserLocalServiceUtil.getUser(userId); 
String screenname = userObj.getScreenName();
String firstname = userObj.getFirstName();
%>
<script type="text/javascript">
		var username = '<%=screenname%>';
		var itemsCount = 0;
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
				$.ajax({
				    type: 'GET',
				    url: '${ProductSearch}',
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
										data-toggle="tab">MRP adjustment</a></li>
								</ul>
							</div>
						</div>
					</div>

					<!-- Status Message to be displayed -->
					<input type="hidden" value="${statusMessage}" id="hiddenmsg" />

					<!-- Content's -->
					<div class="row-fluid">
						<div class="span12">
							<h4>MRP Adjustment</h4>
							<div id="myTabContent" class="tab-content">
								<div class="tab-pane active" id="create_order">
									<div class="row-fluid">
										<div class="span12">
										<div id="minblock">
											<table class="table table-bordered">
												<thead>
													<tr>
														<th class="span4">Product List</th>
														<th class="span3">UOM</th>
														<th class="span3">Batch No.</th>
														<th class="span3">MRP In System</th>
														<th class="span3">New MRP</th>
														<th>Action</th>
														</tr>
												</thead>
												<tbody>
													<tr>
														<td class="span4"><select id="productName"
															tabindex="1" class="no-space selectProduct"
															name="productName" data-placeholder="Select Product" autofocus="autofocus">
														</select>
															<div class="loadingImage"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath() %>/img/ajax.gif" />
															</div></td>
														<td class="span3"><select id="uomId" tabindex="2"
															class="no-space" name="uomId" data-placeholder="Select Uom">
														</select>
															<div class="loadingImage2"
																style="display: none; float: right;">
																<img src="<%=request.getContextPath() %>/img/ajax.gif" />
															</div> <input id="principalName" type="hidden" value="" /> <input
															id="principalPartyId" type="hidden" value="" /> <input
															id="division" type="hidden" value="" /> <input
															id="amount" type="hidden" value="" /></td>

														<td class="span3"><select id="batchNo" tabindex="2"
															class="no-space" name="batchNo">
														</select></td>
														<!-- Price -->
														<td class="span2"><input class="input-small"
															type="text" id="spriceSystem" disabled /> <input
															id="inventoryItemId" type="hidden" value="" /></td>
														<td class="span2"><input class="input-small"
															type="text" id="spriceFound" tabindex="4" /></td>
													<!-- Vinoth Edit Finish -->
														<td class="span2"><a class="btn" id="addrow"
															tabindex="6" href="#" data-bind="click: $root.addItem" ><i
																class="icon-plus icon-black"></i>Add</a></td>
													</tr>
												</tbody>
											</table>
											</div>
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
														<th class="span3" style="width: 150px;">MRP in System.</th>
														<th class="span3" style="width: 150px;">New MRP</th>
<!-- 														<th class="span3" style="width: 310px;">Reason</th> -->
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
<!-- 														<td class="span2"><span data-bind='text:reason '></span> -->
<!-- 														</td> -->
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="row-fluid">
										<div class="span12">
											<form:form name="processCartItemForm"
												id="processCartItemForm" commandName="processCartItem"
												method="post" action="${processCart}">
												<input type="hidden" id="purchaseItem" name="purchaseItem"
													value="" data-bind='value: lastSavedJson' />
												<a
													href="<portlet:renderURL><portlet:param name="myaction" value="showCreateOrder" /></portlet:renderURL>"
													class="btn left-align" tabindex="7">Cancel</a>
													
												<button class="btn btn-success right-align" type="button"
													data-bind="click: submitOrder" tabindex="8">Adjust MRP</button>
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
							
								$("#productName").change(function() {
									
									var id = $(this).val();
									
									if(id > 0){
										
										$("#uomId").empty();
										$("#batchNo").empty();
										$("#qtyInSystem").val('');
										$(".loadingImage2").show();
										$('.loadingImage2').animate({ opacity: 1 }, 500, function() {
											$.ajax({
												type: 'GET',
												url: '${ProductDetail}',
												data: {
													'service': 'ProductDetail',
													'productId': id,
													'targetPartyId': ${targetPartyId}
												},
												async: false,
												success: function(data) {
													$(".loadingImage2").hide();
													var principal = data.productList;
													for (var i = 0; i < principal.length; i++) {
														$("#principalName").val(principal[i].principalName);
														$("#principalPartyId").val(principal[i].principalPartyId);
														$("#division").val(principal[i].division);
													}
													
													var uom = data.uomList;
													if( uom.length>0)
													{
														for (var i = 0; i < uom.length; i++) 
														{
		 													if(uom[i].uomId=="" || uom[i].uomId=="null" || uom[i].uomId==null)
															{
		 														$("#uomId").append('<option>' + uom[i].uomIdTo + '</option>');
		 													}else{
		 														$("#uomId").append('<option>' + uom[i].uomId + '</option>');
															}
														}
													}
													else
													{
														$("#commonPopup").modal('show');
														$("#idCommonHead").text("Please Check...");
														$("#idCommonBody").text("UoM is Not Avalible");
													}
												   	$.ajax({
														type: 'GET',
												        url: '${BatchList}',
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
															if(batchList.length>=0)
																{
												        	$("#spriceSystem").val(batchList[0].price);
												        	$("#inventoryItemId").val(batchList[0].inventoryItemId);
												        	$("#productId").val(batchList[0].productId);
												        	$("#reason").append("<option value='VAR_STOLEN'>" + 'STOCK STOLEN' + "</option>");
												        	$("#reason").append("<option value='VAR_FOUND'>" + 'STOCK FOUND' + "</option>");
											        		$("#reason").append("<option value='VAR_PILFERAGE'>" + 'PILFERAGE' + "</option>");
											        		$("#reason").append("<option value='VAR_DAMAGED'>" + 'DAMAGE' + "</option>");
											        		$("#reason").append("<option value='VAR_EXPIRED'>" + 'EXPIRED' + "</option>");
												        	// 											        	$("#reason").append('<option>' + 'STOCK STOLEN' + '</option>');
												            $("#batchNo").change(function(){
													        	
																	 var selIndex=$('option:selected',$(this)).index();  
																	 //var totalQty =batchList[selIndex].availableToPromiseTotal+batchList[selIndex].freeQuantity;
																		
																	 var tot=batchList[selIndex].price; 
																	$("#spriceSystem").val(tot);
																	$("#inventoryItemId").val(batchList[selIndex].inventoryItemId);
																	$("#productId").val(batchList[selIndex].productId);
																        });
												            
																}
															else{
																$("#qtyFound").val('');
																$("#uomId").empty();
																$("#inventoryItemId").val('');
																$("#commonPopup").modal('show');
																$("#idCommonHead").text("Please Check...");
																$("#idCommonBody").text("Batch is Not Avalible");
															}
															  $("#reason").change(function(){
																		$("#reasonVal").val($('option:selected',$(this)).val());
													        });
												        }
													}); 
												},
												error: function() {
													$(".loadingImage2").hide();
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
								var qtyInSystem=0;//sprice system
								var qtyFound =0;//sprice found
								var reason ="";
								var batchNo ="";
								var inventoryItemId ="";
								var productId="";
								
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
									self.qtyInSystem= ko.observable($("#spriceSystem").val());
									self.qtyFound= ko.observable(qtyFound);
									self.reason= ko.observable(reason);
									self.batchNo= ko.observable(batchNo);
									self.reasonVal= ko.observable(reasonVal);
									self.inventoryItemId=ko.observable(inventoryItemId);
								};

								var Product = function() {
									var self = this;
									self.items = ko.observableArray();	//Put one line in by default
									
									self.addItem = function() {
										$("#minblock").hide();//Hiding after Click Add Button
										
										var pName = $("#productName  option:selected").text();
										var uId = $("#uomId option:selected").text();
										var qntyFound = $("#spriceFound").val();
										var qtyInSystem = $("#spriceSystem").val();
										var batchNumber = $("#batchNo option:selected").text();
										
										if(pName != "" && uId != "" && qntyFound != qtyInSystem && batchNumber != "" && qntyFound != 0) {
											id = $("#productName  option:selected").val();
											name = pName;
											uom = uId;
											//qty = qnty;
											principalName = $("#principalName").val();
											principalId = $("#principalPartyId").val();
											division = $("#division").val();
											amount = $("#amount").val();
											
											qtyInSystem=$("#spriceSystem").val();
											qtyFound=qntyFound;
											batchNo=batchNumber;
											reasonVal=$("#reasonVal").val();
											reason=$("#reason option:selected").text();
											productId=$("#productId").val();
											inventoryItemId=$("#inventoryItemId").val();
											
											self.items.push(new ProductItem());

											//clear the field value
											$("#uomId").empty();
											$("#batchNo").empty();
											$("#reason").empty();
											$("#qtyInSystem").val('');
											$("#qtyFound").val('');
											$("#principalName").val('');
											$("#inventoryItemId").val('');
											$("#productId").val('');
											$("#principalPartyId").val('');
											$("#division").val('');
											$("#amount").val('');
											$("#productName").select2("val", "0");
											$("#productName").select2("focus");
										}else {
											if(qntyFound == qtyInSystem)
											{
												$("#addQuantityError").modal('show');
												$('#addQuantityError .btn').focus();
											}
											else
											{
												$("#addCartError").modal('show');
												$('#addCartError .btn').focus();
											}
										}
									};

									 self.lastSavedJson = ko.observable("");
										
										self.submitOrder = function() {
											
											$("#submitUpdateCon").disabled=true;
									        $("#changing").modal('show');
											
									        var dataToSave = $.map(self.items(), function(line) {
									        	var targetPartyId= ${targetPartyId};
									            return line.qtyFound() ? {
									            	price: line.qtyFound(),
									                comments: 'update thru json',
									                modifiedByUser: username,
									                partyId: convertToString(targetPartyId),
									                inventoryDate: convertToString(Date.now()),
									                productId:line.productId(),
									                reason : line.reasonVal(),
									                inventoryItemId :line.inventoryItemId(),
									                batch:line.batchNo()
									            } : undefined;
									        });
									        self.lastSavedJson(JSON.stringify({"inventoryItem":dataToSave}));
									        

									        if(dataToSave != null && dataToSave != "") { 
									        	
												$("#cartItemSubmit").click();
												
												$("#changing").modal('hide');
							                	$("#SuccessProduct").modal('show');
												} else {
												$("#changing").modal('hide');
												$("#purchaseItemError").modal('show');
												$('#purchaseItemError .btn').focus();
												
											};
											$("#submitUpdateCon").disabled=false;
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
							<h4>Add Items</h4>
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
							<h4 style="color:black;">Add Items</h4>
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
							<h4 style="color:black;">Add Items</h4>
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
							<span>Adjusting MRP </span>
						</div>
						<div class="modal-body" style="float: center;">
							<img src="<%=request.getContextPath() %>/img/loading.gif" />
								<!-- <div class="loading">
									<span>Editing </span>
								</div> -->
						</div>
						<div class="modal-footer"></div>
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
					<div id="SuccessProduct" class="modal hide fade">
						<div class="modal-header">
							<h4>MRP Adjustment</h4>
						</div>
						<div class="modal-body">
							<h5>MRP Adjusted Sucessfully</h5>
						</div>
						<div class="modal-footer">
							<a class="btn" data-dismiss="modal" aria-hidden="true" onclick="dataFocus()">Ok</a>
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

					<div id="purchaseOrderSuccess" class="modal hide fade">
						<div class="modal-header">
							<h4>Purchase Order</h4>
						</div>
						<div class="modal-body">
							<h5>Your order submitted successfully</h5>
						</div>
						<div class="modal-footer">
							<a class="btn btn-success" data-dismiss="modal"
								aria-hidden="true">Ok</a>
						</div>
					</div>

					<div id="purchaseOrderError" class="modal hide fade">
						<div class="modal-header">
							<h4>Purchase Order</h4>
						</div>
						<div class="modal-body">
							<h5>Your order failed</h5>
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
		// function is used for Generating and Printing Invoice...
		
		function getQtyDiff(qty,qtyInSystem)
		{
			
	var amt=parseInt(qty)-parseInt(qtyInSystem);
	return amt.toString();
		}
		function convertToString(date)
		{
	return date.toString();
		}
		
		function dismissModal(countVal) {
			$('#purchaseOrderPrintModal'+countVal).modal('hide');
			/* var divId = document.getElementById('purchaseOrderPrintModal'+countVal);
			document.removeChild(divId); */
			showTheModal(countVal-1);
		}

	</script>
			</div>
		</div>
	</div>
</body>
</html>