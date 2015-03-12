jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "formatted-num-pre": function ( a ) {
a = (a==="-") ? 0 : a.replace( /[^\d\-\.]/g, "" );
        var b=a.split("-");
        a = b[1];
    	return a;
    },
 
    "formatted-num-asc": function ( a, b ) {
        return a - b;
    },
 
    "formatted-num-desc": function ( a, b ) {
        return b - a;
    }
} );

jQuery('.typeahead').typeahead();
var targetparty;
var fromParty;
var invoices;
var invoicedetail;
$(document).ready(function() {
	$("#error").hide();
	document.getElementById('suppName').style.visibility = "hidden";
	document.getElementById("outStanding").style.visibility="hidden";
	document.getElementById('pendPay').style.visibility = "hidden";
	document.getElementById('enPayDet').style.visibility = "hidden";
	document.getElementById('cnBut').style.visibility = "hidden";
	document.getElementById("headerCheckBoxid").checked = false;
	targetparty = $("#targetPartyId").val();
	// for page loading error

	invoices = $("#invoices").dataTable({
		//"aoColumns": [null,null,null,null, {"sType": "currency"}, {"sType": "currency"}, {"sType": "currency"}],
		"sDom": '<"top">rt<"bottom"flp><"clear">',
		"bInfo" : false,
		"fnDrawCallback": function(oSettings) {
			if ($('#example tr').length < 11) {
				$('.dataTables_paginate').hide();
			}
		},
//		$(window).height() - 385
		"sScrollY": 250,
		'iDisplayLength': 500,
		"scrollCollapse": true,
        "paging":false,
        "bFilter": false,
   "aoColumns": [null,{sClass: "alignLeft" },{ "iDataSort": 7 },{"iDataSort": 7 },{ "sType": "formatted-num",sClass: "alignRight" },{ "sType": "formatted-num",sClass: "alignRight" },{ "sType": "formatted-num",sClass: "alignRight" }, {"bVisible": false}]

	});
	
	invoices.fnSort( [ [7,'asc'] ] );
	invoicedetail = $("#invoicedetail").dataTable({
		"sDom": '<"top">rt<"bottom"flp><"clear">',
		"bInfo" : false,
		"fnDrawCallback": function(oSettings) {
			if ($('#example tr').length < 11) { 
				$('.dataTables_paginate').hide();
			}
		},
		
		"sScrollY": "200px",
		"bAutoWidth":false, 
		'iDisplayLength': 500,
		"scrollCollapse": true,
        "paging":false,
        "aaSorting": [[0,'desc']]
	});

	var urlretailser = $("#idhiddenRetailerNameSearch").val();
	$.ajax({
	    type: 'GET',
	    url: urlretailser,
	    async: false,
	    cache:false,
	    dataType:"json",
	    data : {
			'service' : 'RetailerNameSearch',
			'targetPartyId': targetparty
		},
		success: function(data) {
			var supplierList = data.partyList;
			var companyName =[];
			for(var i =0 ;i<supplierList.length;i++) {
				var retailer = {};
				if(supplierList[i].companyName != null) retailer["label"] = supplierList[i].companyName;
				if(supplierList[i].companyName != null) retailer["value"] = supplierList[i].companyName;
				if(supplierList[i].partyIdTo != null) retailer["customerPartyId"] = supplierList[i].partyIdTo;
				companyName.push(retailer);
			}
			jQuery('#customer_Name').autocomplete({ source: companyName, maxRows: 3,
				select: function( event, ui ) {
					 $("#customer_Name" ).val( ui.item.value );
					 $("#customerPartyId" ).val( ui.item.customerPartyId );
					 
					 searchSupp();
					 $("#enAmnt" ).val( "" );
					 $("#totBalAmntDisplay" ).text( "0.00" );
					 $("#totBalAmnt" ).val( "0.00" );
					 $("#paymentRef").val( "" );
					 var date = new Date();
						var currentDate = date.getDate();
						var currentMonth = date.getMonth() + 1;
						var currentYear = date.getFullYear();
						jQuery("#expectedDeliveryDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
//						jQuery("#paymentDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
     				 invoices.fnSort( [ [7,'asc'] ] );
					 return false;
				}
			});
		},
		error: function(data) {
	    	$(".loadingImage3").hide();
	    	alert("Fetching Error....");
	    }
	});
	
	var urlpaymethod = $("#idhiddenpaymentMethodTypes").val();
	$.ajax({
	    type: 'GET',
	    url: urlpaymethod,
	    async: false,
	    cache:false,
	    dataType:"json",
	    data : {
			'service' : 'paymentMethodTypes'
		},
		success: function(data) {
			$(".loadingImage3").hide();
			var paymentMethodTypes = data.paymentMethodTypes;
			for(var i =0 ;i<paymentMethodTypes.length;i++) {
				//companyName.push(retailer);
				$("#payMethod").append('<option value=' + paymentMethodTypes[i].paymentMethodTypeId + '>' + paymentMethodTypes[i].description + '</option>');
			}
		},
		error: function(data) {
	    	$(".loadingImage3").hide();
	    	alert("Fetching Error.... ");
	    }
	});
	
	
		
	
	
});
function selectCheck()
{
	if ($("#headerCheckBoxid:checked").val() == "on")
	{
		checked = true;
	}
	else
	{
		checked = false;
	}
	for (var i = 0; i < document.getElementsByName("selectToPay").length; i++) 
	{
		document.getElementsByName("selectToPay")[i].checked = checked;
		
	}
	checkToProceed();
	
}

var balance;
var selectedAmount;
var checkboxes;
var checkedBoxAll;
function checkToProceed()
{
	balance = 0;
	selectedAmount = [];
	checkedBoxAll = [];
	checkboxes = document.getElementsByName("selectToPay");
	/*var  = document.getElementsByName('categoryLi');*/
	var vals = "";
	
	for (var i=0;i<checkboxes.length;i++) {
		if (checkboxes[i].checked) 
		{
			selectedAmount.push($("#invPBal_"+checkboxes[i].id+"-").text());
			balance += parseFloat($("#invPBal_"+checkboxes[i].id+"-").text());
			//alert("data :: "+$("#invNo_"+checkboxes[i].id).text());
			checkedBoxAll.push(checkboxes[i].id);
			
		}
	}
	$("#totBalAmnt").val(parseFloat(balance).toFixed(2));
	$("#totBalAmntDisplay").text(formatCurrencyAmount(balance));
	if(checkHeaderCheckBox())
	{
	document.getElementById("headerCheckBoxid").checked = true;
	}
else{
	document.getElementById("headerCheckBoxid").checked = false;
}
}
var enAmnt;
function checkChangedEnAmnt()

{
	enAmnt = $("#enAmnt").val();
	
	var chVals = enAmnt.match(/\./g);
	if(chVals == "" || chVals == null)
	{
		chVals = 0;
	}
	else
	{
		chVals = enAmnt.match(/\./g).length;
	}
	
	if (1 < chVals) 
	{
//		clearAll()
		$("#confirmationModalForerrorInAmount").modal('show');
	}
	else
	{
		if(enAmnt > balance)
		{
			//confirmationModalForamnttoPayExceeed
			$('#confirmationModalForamnttoPayExceeed').modal('show');
			//alert("Please Enter Amount Less than or equal to Total Invoice Amount..");
			$("#enAmnt").val('');
			$("#enAmnt").focus();
		}
	}
}
var avAmt=0;
var remAmt;
var invDetail={};
//var invDetail;
//alert("invDetail :: "+JSON.stringify(invDetail));
//var singleRecord;
function calculateTotal()
{
	//var invDetail;
	var paymentRef= $("#paymentRef").val();
	if($("#totBalAmnt").val() > 0)
	{
		var enAmnt = $("#enAmnt").val();
		var chVals = enAmnt.match(/\./g);
		//alert(chVals);
		if(chVals == "" || chVals == null)
		{
			chVals = 0;
		}
		else
		{
			chVals = enAmnt.match(/\./g).length;
		}
		if (1 < chVals) 
		{
//			clearAll();
			  $("#confirmationModalForerrorInAmount").modal('show');
		}
		else if (paymentRef.match(/[^a-zA-Z0-9 ]/g))
		{
//			clearAll();
			$("#confirmationModalForerrorInRef").modal('show');
		}
		else if(enAmnt > balance)
         {
                 $('#confirmationModalForamnttoPayExceeed').modal('show');
         }
		else
		{
		if(enAmnt == "" || enAmnt == null || enAmnt==0)
		{
//			clearAll();
			$("#confirmationModalForamntnotNull").modal('show');
			
		}
		else
		{
//			var invDetail={};
			avAmnt = balance;
			var appliedAmnt;
			if(enAmnt <= avAmnt && enAmnt > 0)
			{
				var singleRecord = [];
				for(var j=0;j<checkedBoxAll.length;j++)
				{
					if(enAmnt>0){
						remAmt = parseFloat(enAmnt)-parseFloat(selectedAmount[j]) ;
					}
					if(remAmt>0){
						enAmnt = remAmt;
						appliedAmnt=parseFloat(selectedAmount[j]);
					}else{
						appliedAmnt=enAmnt;
						enAmnt = 0;
					}
					singleRecord.push({ "refernceNumber":$("#invRfNo_"+checkedBoxAll[j]).text(),"invoiceId" :$("#invNo_"+checkedBoxAll[j]).text(),"invoiceAmount":$("#invAmt_"+checkedBoxAll[j]+"-").text(),"invoiceBalance":$("#invPBal_"+checkedBoxAll[j]+"-").text(),"appliedAmt":appliedAmnt});
					
				}
				invDetail["invoices"]=singleRecord;
			}
			invoicedetail.fnClearTable();
			for(var k=0;k<invDetail.invoices.length;k++)
			{
				invoicedetail.fnAddData([invDetail.invoices[k].refernceNumber+'<span style="display:none">'+invDetail.invoices[k].invoiceId+'<span>',formatCurrencyAmount(invDetail.invoices[k].invoiceAmount),formatCurrencyAmount(invDetail.invoices[k].invoiceBalance),formatCurrencyAmount(invDetail.invoices[k].appliedAmt)]);
			}
			$('.dataTables_scrollHeadInner').css('width','100%');
			$('.dataTable').css('width','100%');
			
			$('#confirmationModalForUpdate').modal('show');
		}
		}
	}
	else
	{
		$('#confirmationModalForselectInvoice').modal('show');
	}
}

var payDetail;
var invDetai;

function postToServer()
{
	
	$('#confirmationModalForUpdate').modal('hide');
	$('#confirmationModalForSaving').modal('show');
	//
	payDetail ={};
	invDetai = [];
	for(var l=0;l<invDetail.invoices.length;l++)
	{
		var invoiceId = invDetail.invoices[l].invoiceId;
		var invoiceAmount = parseFloat(invDetail.invoices[l].invoiceAmount).toFixed(2);
		var invoiceBalance =parseFloat( invDetail.invoices[l].invoiceBalance).toFixed(2);
		var appliedAmt = parseFloat(invDetail.invoices[l].appliedAmt).toFixed(2);
		var payMethod = $("#payMethod option:selected" ).val();
		var paymentRef = $("#paymentRef").val();
		
		var olDate = $("#expectedDeliveryDate").val();
		var p = olDate.split(/\D/g);
		var effDate = [p[2],p[1],p[0] ].join("-");
//		var paymentDateSplitedArr=$("#paymentDate").val().split(/\D/g);
//		var paymentDate=[paymentDateSplitedArr[2],paymentDateSplitedArr[1],paymentDateSplitedArr[0] ].join("-");
		if(appliedAmt >0)
			{
				invDetai.push({"invoiceId":invoiceId,"invoiceAmount":formatCurrencyAmountPost(invoiceAmount),"amountToBePaid":formatCurrencyAmountPost(invoiceBalance),"amountApplied":formatCurrencyAmountPost(appliedAmt),"partyIdFrom":targetparty,"partyIdTo":fromParty,"roleTypeIdTo":"BILL_FROM_VENDOR", "paymentTypeId": "VENDOR_PAYMENT","effectiveDate":effDate,"paymentMethod":payMethod,"refNumber":paymentRef});
			}
	}
	payDetail["payments"]=invDetai;
	
	var urlprospay = $("#idhiddenPostingPayment").val();
	$.ajax({
		type : 'POST',
		url : urlprospay,
		async : false,
		cache:false,
		data : {
			'service' : 'PostingPayment',
			'invPost':JSON.stringify(payDetail)
		},
		success : function(data) {
			//{"responseMessage":"success","serviceStatus":0}
			if(data.responseMessage == "success")
			{
					clearAll();
					loadInvoiceList();
					$('#confirmationModalForSaving').modal('hide');
					$('#confirmationModalForSaved').modal('show');
			}
			else
			{
				$('#confirmationModalForSaving').modal('hide');
				$('#confirmationModalForFailed').modal('show');
				
			}
		}
	});
}

function reload()
{
	window.location.reload(true);
}

function searchSupp()
{
	document.getElementById("headerCheckBoxid").checked = false;
	$("#LoadingImage").show();
	var urlretaildetser = $("#idhiddenRetailerDetailsSearch").val();
	$.ajax({
		type : 'GET',
		url : urlretaildetser,
		async : false,
		data : {
			'service' : 'RetailerDetailsSearch',
			'retailerName' : $("#customer_Name" ).val(),
			'partyIdTo': $("#customerPartyId").val(),
			'targetPartyId' : targetparty
		},
		cache:false,
		success : function(data) {
			var retailerdata = data.partyList;
			for ( var i = 0; i < retailerdata.length; i++) {
				var address = retailerdata[i].address1+retailerdata[i].address2;
				var mobileNo = retailerdata[i].mobileNumber;
				var city = "";
				if (retailerdata[i].city != null) {
					alert("city" + city);
					city = retailerdata[i].city;
				}
				var postalCode = "";
				if (retailerdata[i].postalCode != null) {
					postalCode = retailerdata[i].postalCode;
				}
				if (city != "" && postalCode != "") {
					var address3 = city + "," + postalCode;
				} else {
					var address3 = city + postalCode;
				}
				if (address3 != "") {
					$("#lbladdress3").text(address3);
				}
				if (retailerdata[i].address1 != null) {
					$("#lblSuDe").text(retailerdata[i].address1);
				}
				if(retailerdata[i].address2 != null){
				$("#lbladdress2").text(retailerdata[i].address2);
				}
				else{
					$("#lbladdress2").text("");
				}
				if(mobileNo != null){
				$("#lblSuDeMob").text(mobileNo.replace(","," , "));
					}
				else{
					$("#lblSuDeMob").text("");
				}
				if(retailerdata[i].tin != null){
					$("#lblTinId").text(retailerdata[i].tin);
				}
			else{
				$("#lblTinId").text("");
			}
			
				fromParty = retailerdata[i].partyIdTo;
			}
		},
		error: function(data) {
	    	alert("Server Not Responding check your internet connection....");
	    }
	});
	
	$("#partyIdFrom").val(fromParty);
	invoices.fnClearTable();

	loadInvoiceList();
	
	document.getElementById('suppName').style.visibility = "visible";
	document.getElementById('outStanding').style.visibility = "visible";
	document.getElementById('pendPay').style.visibility = "visible";
	document.getElementById('enPayDet').style.visibility = "visible";
	document.getElementById('cnBut').style.visibility = "visible";
	$("#lblAdd").text($("#customer_Name" ).val());
}

function loadInvoiceList()
{
	invoices.fnClearTable();
	var urlinvlist = $("#idhiddeninvoiceList").val();
	$.ajax({
		type: 'GET',
		url: urlinvlist,
		async: false,
		cache:false,
		data: {
			'service': 'invoiceList',
			'fromPartyId':fromParty,
			'targetPartyId':targetparty,
			'createdDateAfter':'2014-04-01'
		},
		success: function(data) {
			$("#LoadingImage").hide();
			var invoiceList=data.invoiceList;
			//alert("Value :: "+JSON.stringify(categoryList));
			var totOutBalance =0;
			for(var i=0;i<invoiceList.length;i++)
			{
				
				var formdate = new Date(invoiceList[i].invoiceDate);
				var newDate = ("0" + formdate.getDate()).slice(-2)+"-"+("0" + (formdate.getMonth() + 1)).slice(-2)+"-"+formdate.getFullYear();
				var hiddenDate =("0" + formdate.getFullYear())+("0" + (formdate.getMonth() + 1)).slice(-2)+("0" + formdate.getDate()).slice(-2);
				var amountPaid = invoiceList[i].amountPaid;
				if(amountPaid == null || amountPaid == "")
				{
					amountPaid = 0;
				}
				var duedate = invoiceList[i].dueDate;
				if(duedate == null || duedate == "")
				{
					duedate = "N/A";
				}
				else
				{
					var ddate = new Date(invoiceList[i].dueDate);
					duedate = ("0" + ddate.getDate()).slice(-2)+"-"+("0" + (ddate.getMonth() + 1)).slice(-2)+"-"+ddate.getFullYear();
				}
				totOutBalance += parseFloat(invoiceList[i].totalAmount).toFixed(2)-parseFloat(amountPaid).toFixed(2);
				if(parseFloat(parseFloat(invoiceList[i].totalAmount).toFixed(2)-parseFloat(amountPaid).toFixed(2)).toFixed(2)>0.00){
				invoices.fnAddData(['<input type="checkbox" name="selectToPay" id="'+i+'" class="selectToPay" onchange="checkToProceed()">','<span style="text-align:left" id="invRfNo_'+i+'">'+invoiceList[i].referenceNumber+'</span><span class="table-td-gap-m" id="invNo_'+i+'" style="display:none">'+invoiceList[i].invoiceId+'</span>','<span id="invDate_'+i+'">'+newDate+'</span>','<span class="table-td-gap2" id="invDueDate_'+i+'">'+duedate+'</span>','<span id="invAmt_'+i+'-">'+parseFloat(invoiceList[i].totalAmount).toFixed(2)+'</span>','<span id="invPAmt_'+i+'-">'+parseFloat(amountPaid).toFixed(2)+'</span>','<span id="invPBal_'+i+'-">'+parseFloat(parseFloat(invoiceList[i].totalAmount).toFixed(2)-parseFloat(amountPaid).toFixed(2)).toFixed(2)+'</span>','<span>'+hiddenDate+'</span>']);
				}
			}
			$("#outStandingAmt").text(formatCurrencyAmount(totOutBalance));
		},
		error: function() {
			alert("Invoice Not Loading.....");
		}
	});
	invoices.fnSort( [ [7,'asc'] ] );
//	$('.dataTables_scrollBody').css('line-height','20px');
	//$('.').css('line-height','20px');
	
}

function clearAll()
{
	payDetail={};
	invDetai=[];
	document.getElementById("headerCheckBoxid").checked = false;
	$("#enAmnt" ).val( "" );
	 $("#totBalAmntDisplay" ).text( "0.00" );
	 $("#totBalAmnt" ).val( "0.00" );
	 $("#paymentRef").val( "" );
	 var date = new Date();
		var currentDate = date.getDate();
		var currentMonth = date.getMonth() + 1;
		var currentYear = date.getFullYear();
		jQuery("#expectedDeliveryDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
//		jQuery("#paymentDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
	 selectCheck();
	$('#confirmationModalForUpdate').modal('hide');
	$('#confirmationModalForCancel').modal('hide');
	$('#confirmationModalForSaved').modal('hide');
	
//	invoices.fnClearTable();
//	loadInvoiceList();
//	invoiceDetail.fnClearTable();

}
function formatCurrencyAmountPost(value) {
	   var curr = accounting.formatNumber(value, 2, "", ".");
	   return curr;
	}
function formatCurrencyAmount(value) {
	   var curr = accounting.formatNumber(value, 2, ",", ".");
	   return curr;
	}


function checkAlphanumeric()
{
	var envalue = $("#paymentRef").val();
	if(alphanumeric(envalue)==false)
	{
		//$("#hint").show();
		$("#error").show();
	}
	else
	{
		$("#error").hide();
	}
}

function alphanumeric(inputtxt)
{
 var letterNumber = /^[0-9a-zA-Z]+$/;
 if(inputtxt.match(letterNumber)) 
  {
   return true;
  }
else
  { 
   return false; 
  }
  }

function CancelInvoicemodal()
{
	$('#confirmationModalForCancel').modal('show');
}

function checkHeaderCheckBox()
{
	$("#enAmnt").val("");
	$("#paymentRef").val( "" );
	 var date = new Date();
		var currentDate = date.getDate();
		var currentMonth = date.getMonth() + 1;
		var currentYear = date.getFullYear();
		jQuery("#expectedDeliveryDate").val(currentDate + '-'+ currentMonth + '-'	+ currentYear );
	length=document.getElementsByName("selectToPay").length;	
	for (var i = 0; i <length; i++) 
	{
		if(!document.getElementsByName("selectToPay")[i].checked)
			{
			return false;
			}
	}
	return true
}