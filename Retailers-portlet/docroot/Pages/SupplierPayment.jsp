<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<portlet:defineObjects />
<portlet:resourceURL var="RetailerNameSearch" id="RetailerNameSearch" />
<portlet:resourceURL var="RetailerDetailsSearch" id="RetailerDetailsSearch" />
<portlet:resourceURL var="invoiceList" id="invoiceList" />
<portlet:resourceURL var="paymentMethodTypes" id="paymentMethodTypes" />
<portlet:resourceURL var="PostingPayment" id="PostingPayment" />
<html>
<head>
<title>Supplier Order</title>
<style type="text/css">
.changecolor {
	background: none repeat scroll 0 0 #F26C4F;
}

#hint{
		cursor:pointer;
	}
	.tooltip{
		margin:8px;
		padding:8px;
		border:1px solid blue;
		background-color:yellow;
		position: absolute;
		z-index: 2;
	}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/SupplierPayment.js?<%=System.currentTimeMillis()%>"></script>
<script  type="text/javascript" >
function isNumberKey(evt) {
	   var charCode = (evt.which) ? evt.which : evt.keyCode;
	   if(charCode == 46 && $("#enAmnt").val().indexOf(".")<0)
	   {
	   return true;		   
	   } 
// 	   || charCode == 37
	   if (charCode == 0 || charCode == 8  ) // back space, tab, delete, enter
	   {
	   return true;
	   }
	   else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
	   return true;
	   
	}
function isValKey(evt) {
	   var charCode = (evt.which) ? evt.which : evt.keyCode;
	   return false;
// 	   if (charCode == 0 || charCode == 8 || charCode == 9) // back space, tab, delete, enter
// 	   return true;
// 	   else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
// 	   return true;
	}
</script>
</head>
<body>
<input type="hidden" id="targetPartyId" value="${targetPartyId}">
<input type="hidden" id="customerPartyId">
	<div class="container">

		<div class="content">
			<div class="span11" id="section">
				<div class="tab_salesorder">
					<ul id="myTab" class="nav nav-tabs">
						<li class="active"><a
							href="<portlet:renderURL><portlet:param name="myaction" value="SalesOrderRules" /></portlet:renderURL>">
								Supplier Payment</a></li>
					</ul>
				</div>
				<div class="div-total">

					<table class="table-search" colspan="2">

						<tr class="td-body" colspan="2">
							<th colspan="2">&nbsp;&nbsp;Search Supplier Name</th>
						</tr>
						<tr colspan="2">
							<td style="width: 22px;"><input type="text"
								id="customer_Name" style="margin: 12px;"></td>
							 <td><img style="display: none" id="LoadingImage" src="<%=request.getContextPath()%>/img/ajax.gif" /></td> 
						</tr>
					</table>
					<div class="div-address">
					<table class="table-address" id="suppName">
						<tr>
							<td class="table-search-td">
								<table class="table-add">
									<tr>
										<th colspan="3"><label class="lable-address" id="lblAdd"></label>
										<input type="hidden" id="idhiddenRetailerNameSearch" value="<%=RetailerNameSearch%>">
										<input type="hidden" id="idhiddenRetailerDetailsSearch" value="<%=RetailerDetailsSearch%>">
										<input type="hidden" id="idhiddeninvoiceList" value="<%=invoiceList%>">
										<input type="hidden" id="idhiddenpaymentMethodTypes" value="<%=paymentMethodTypes%>">
										<input type="hidden" id="idhiddenPostingPayment" value="<%=PostingPayment%>">
										</th>
									</tr>
									<tr>
										<td style=" width:38%;">
											<table   class="table-add">
												<tr>
													<td><label class="lable-font1"> Address </label></td>
													<td><span class="lable-address1" id="lblSuDe">
													</span></td>
												</tr>
												<tr>
													<td></td>
													<td><span class="lable-address1" id="lbladdress2">
													</span></td>
												</tr>
												<tr>
													<td></td>
													<td><span class="lable-address1" id="lbladdress3">
													</span></td>
												</tr>
											</table>
										</td>
										<td>
											<table class=" table-mob">
												<tr>
													<td class="td-mob"><label class="lable-font1"> Mobile
															Number</label></td>
													<td><span class="lable-address1" id="lblSuDeMob"></span>
													</td>
												</tr>
												<tr>
													<td></td>
													<td><span class="lable-address1" id="lblSuDeMob">
													 </span>
													</td>
												</tr>
												<tr>
													<td style="padding-left: 20px;"><label class="lable-font1">TIN Number</label></td>
													<td><span class="lable-address1" id="lblTinId"></span>
														<span id="partyIdFrom" style="visibility: hidden;"></span>
													</td>
												</tr>
											</table>
										</td>

									</tr>
								</table> 
								</td>
								</tr>
					</table>
				 </div>
				 	<div class=" div-out">
					<table class=" table-out" id="outStanding">
					<tr class="table-tr-backg">
					<th class="table-tr-backg">
					<label class="table-th-col" >
					Outstanding Amount</label>
							</th>
					</tr>
					<tr>
					<td>
					<label	class="lable-amount">&#8377; <span
									id="outStandingAmt"></span></label>
					</td>
					</tr>
					</table>
					</div>
					<div class="div-first-table" id="pendPay">
						<table style="width: 98%; margin-left: 0px;">
							<tr class="table-tr-backg">
								<th class="table-th-col" colspan=7;>&nbsp;&nbsp;Pending
									Payments</th>
							</tr>
						</table>
							<table class="div-table table-striped" style="width: 800px;line-height: 20px " id="invoices">
							<thead>
							<tr class="td-body1" >
							<th colspan=8; class="tableth-width">
							<input type="checkbox" onclick="selectCheck()" class="selectToPay" id="headerCheckBoxid" ></th>
								<th class="table-pending-bord" style="text-align: center">&nbsp;Invoice No.</th>
								<th class="table-pending-bord2">&nbsp;Invoice Date</th>
								<th class="table-pending-bord1">&nbsp;Amount Due On</th>
								<th class="table-pending-bord3" style="text-align: center">&nbsp;Amount (&#8377;)</th>	
								<th class="table-pending-bord4" style="text-align: center">&nbsp;Paid (&#8377;)</th>
								<th class="table-pending-bord3" style="text-align: center">&nbsp;Balance (&#8377;)</th>
								 <th class="table-pending-bord3">&nbsp;Hidden (&#8377;)</th>
							</tr>
							</thead>
							<tbody style="text-align: center;">
							</tbody>
						</table>
					</div>
					<div class="div-order" id="enPayDet" style="margin-left: 2px;">
						<table class="div-table-order" colspan=2;>
							<tr class="table-tr-backg" colspan=2;>
								<th class="table-th-col" colspan=3;>&nbsp;&nbsp;Enter
									Payment Details</th>
							</tr>
							<tr class="tr-pending-body" colspan=2;>

								<td class="table-amt">Total Amount</td>
								
								<td class="totamt">&#8377; <span id="totBalAmntDisplay">0.00</span> <input type="hidden" id="totBalAmnt"></td>
							</tr>
							<tr class="tr-pending-body" colspan=2;>
								<td  class="td-gap">Amount to Pay</td>
						
								<td><input type="text" class="input-small" id="enAmnt" title="Enter Amount to Pay numbers Only"
									style="border: 1px solid #f8bc7e; width: 120px;" onkeypress="return isNumberKey(event)"></td>
							</tr>
							<tr class="tr-pending-body" colspan=2;>
								<td class="td-gap">Effective Date</td>
								
								<td><input type="text" class="input-small" id="expectedDeliveryDate" onkeypress="return isValKey(event)"
									style="border: 1px solid #f8bc7e; width: 120px;">
									<script type="text/javascript">
										jQuery("#expectedDeliveryDate")
												.datepicker({
												});
										var date = new Date();
										var currentDate = date.getDate();
										var currentMonth = date.getMonth() + 1;
										var currentYear = date.getFullYear();
										jQuery("#expectedDeliveryDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
									</script>
									</td>
							</tr>
							<tr class="tr-pending-body">

								<td  class="td-gap">Payment Type</td>
							
								<td>
								<select class="selectpicker select-drop" id="payMethod">
								</select>
								</td>
							</tr>
							<script>
$(function () { $('.tooltip-show').tooltip('show');});
$(function () { $('.tooltip-show').on('show.bs.tooltip', function () {
})});
</script>
							<tr class="tr-pending-body" colspan=2;>
								<td  class="td-gap">Payment Ref. No.
								<i class="icon-question-sign" rel="tooltip" title="Please enter A-Z,a-z,0 to 9 only" id="hint"></i>
								</td>
						
								<td><input type="text" class="input-small" style="border: 1px solid #f8bc7e; width: 120px;" id="paymentRef" onblur="checkAlphanumeric();">
								</td>
							</tr>
						</table>
					</div>
					<table class="table-button" id="cnBut">
						<tr>
							<td class="table-td-but"><a href="javascript:CancelInvoicemodal()" class="btn btn-arning">
									cancel </a></td>
							<td style=" padding-left: 5px;"><a href="javascript:calculateTotal()" class="btn btn-success" id="update"> Make Payment </a></td>

						</tr>
					</table>
				</div>
			</div>


			<div id="confirmationModalForUpdate" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" style="width: 50%">
				<div class="modal-header">
				<h5 class="modal-head-font">Please confirm...</h5>
				</div>
				<div class="modal-body">
				<!-- 	<table class="table table-striped" 
					style="width: 800px; border: 1px solid #cdcdcd; line-height: 35px; margin: 0px;" id="invoicedetail"> -->
					<table class="table table-striped"
						style="width: 100%; border: 1px solid #cdcdcd; line-height: 35px; margin: 0px;" id="invoicedetail">
					
						<thead>
						<tr>
							<th class="th-width">Invoice Id</th>
							<th class="th-width">Amount (&#8377;)</th>
							<th class="th-width">Balance (&#8377;)</th>
							<th class="th-width">Applied (&#8377;)</th>
						</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-warning" data-dismiss="modal">No</a>
					<a href="javascript:postToServer()" autofocus="autofocus" class="btn btn-success">Yes</a> 
				</div>
			</div>
	<div id="confirmationModalForCancel" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static">
				<div class="modal-header">
			<h5>Please confirm...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Do you want to cancel the payment?
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-warning" data-dismiss="modal">No</a>
					<a href="javascript:clearAll()" autofocus="autofocus" class="btn btn-success">Yes</a> 
					
				</div>
			</div>
			<div id="confirmationModalForSaving" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" data-keyboard="false">
				<div class="modal-header">
				<h5 class="modal-head-font">Please wait...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Payment in progress.
				</h3>
				</div>
				<div class="modal-footer">
				</div>
			</div>
			<div id="confirmationModalForSaved" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" >
				<div class="modal-header">
				<h5 class="modal-head-font">Success</h5>
				</div>
				<div class="modal-body">
					<h3>
					Payment Processed successfully.
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			<div id="confirmationModalForFailed" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static">
				<div class="modal-header">
				<h3 class="modal-head-font">Error...</h3>
				</div>
				<div class="modal-body">
					<h3>
					Payment failed.
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			<div id="confirmationModalForamnttoPayExceeed" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" >
				<div class="modal-header">
				<h5 class="modal-head-font">Please check...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Enter the "Amount to Pay" less than "Total Amount".
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			<div id="confirmationModalForamntnotNull" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" >
				<div class="modal-header">
				<h5 class="modal-head-font">Please check...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Amount to pay. Should not be empty or Zero
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			<div id="confirmationModalForselectInvoice" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static">
				<div class="modal-header">
				<h5>Please check...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Please select atleast one invoice.
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			<div id="confirmationModalForerrorInAmount" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" >
				<div class="modal-header">
				<h5>Please check...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Please check "Amount To Pay".
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			
			<div id="confirmationModalForerrorInRef" class="modal hide fade"
				tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
				aria-hidden="true" data-backdrop="static" >
				<div class="modal-header">
				<h5>Please check...</h5>
				</div>
				<div class="modal-body">
					<h3>
					Special Characters are Not allow in "Reference No". like (!,@,#,$,%,&,*,...)
				</h3>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
				</div>
			</div>
			
		</div>
	</div>
</body>
</html>