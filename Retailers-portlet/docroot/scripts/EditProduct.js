var itemsCount = 0;
var proCount=0;
var globalproduct;
var productslist = new Array();
var uomslist = new Array();
var compuomlist;

jQuery(document).ready(function() {

	$("#productName").val('');

	/*******Partha Edited hear for Product Name Auto Complete*********/
var prodserurl = $("#idhiddenProductSearch").val();
	$.ajax({
		type: 'GET',
		url: prodserurl,
		async: false,
		cache: false,
		data: {
			'service': 'ProductSearch',
			'targetPartyId': partyId
		},
		success: function(data) {

			products = data.productList;
			$.each(products, function(i, product)
					{
				productslist.push({
					"label" : product.productName,
					"value" : product.productName,
					"id" : product.productId
				});
					});
			$("#loadingImage").hide();
		}
	});

	var cusurl = $("#idhiddenCustomerDetails").val();
	$.ajax({
		type: 'GET',
		url: cusurl,
		async: false,
		cache:false,
		data: {
			'service': 'CustomerDetails',
			'retailerPartyId':partyId
		},
		success: function(data) {
			$(".loadingImage").hide();
			var customerDetail=data.customerDetail;
			$("#partyRoleTypeId").val(customerDetail.partyTypeId);
		},
		error: function() {
			$("#ConnectionCheck").modal('show');
		}
	});




	//UOM Pair List
	
	$.ajax({
		type: 'GET',
		url: "/Retailers-portlet/json/uom.json",
		async: false,
		cache: false,
		success: function(data) {
			compuomlist = data;
		}
	});

	//	GetUOMlist
	var uomurl = $("#idhiddenGetUOMlist").val();
	$.ajax({
		type: 'GET',
		url: uomurl,
		data: {
			'service': 'GetUOMlist',
			'targetPartyId': partyId
		},
		async: false,
		cache: false,
		success: function(data) {
			uoms = data.uomList;
			//alert(JSON.stringify(data));
			$.each(uoms, function(i, uom)
					{

				uomslist.push({
					"label" : uom.uomId,
					"value" : uom.uomId,
					"id" : uom.uomId
				});
					});
			$("#loadingImage").hide();
		}
	});


	$("#productName").autocomplete({
		source: productslist,
		minLength:3,
		autofocus:true,
		select : function(event, ui)
		{
			$('#productName').val(ui.item.label);
			$('#hdnProductId').val(ui.item.id);
			loadProductDetails(ui.item.id);
			//return false;
		},
		change : function(event, ui)
		{
			if (ui.item == null || ui.item == undefined)
			{
				$("#productName").val("");
			} else
			{
				//$('#productName').val(ui.item.label);
				//loadProductDetails(ui.item.id);
			}
		}
	});


	$("#uomchange").autocomplete({
		source: function (request, response) {
			var term = $.ui.autocomplete.escapeRegex(request.term)
			, startsWithMatcher = new RegExp("^" + term, "i")
			, startsWith = $.grep(uomslist, function(value) 
					{return startsWithMatcher.test(value.label || value.value || value); })
					, containsMatcher = new RegExp(term, "i")
			, contains = $.grep(uomslist, function (value) {
				return $.inArray(value, startsWith) < 0 && 
				containsMatcher.test(value.label || value.value || value);
			});

			response(startsWith.concat(contains));
		},
		//source : uomslist,
		minLength:2,
		autofocus:true,
		select : function(event, ui)
		{

			var uomval = "PACK";
			for(var i=0 ; i < compuomlist.length; i++ )
			{
				if(ui.item.label==compuomlist[i].label)
				{
					//alert(JSON.stringify(compuomlist[i].value));
					var uomval = compuomlist[i].value.split("'")[1];
					i=compuomlist.length;
				}
			}
			//alert(JSON.stringify(uomval));

			if(uomval==null)
			{
				//uomval = "PACK";
			}

			//changeUOM(ui.item.value);

			$('#hdnuomchange').val(uomval);
			$('#uomchange').val(ui.item.label);

			//alert("Sell Uom"+$('#uomchange').val());
			//alert("Buy Uom"+$('#hduomchange').val());
			return false;
		},
		change : function(event, ui)
		{
			if (ui.item == null || ui.item == undefined)
			{
				//$("#uomchange").val("");
			}
		}
	});


	$("#uomchange").blur(function()
			{
		var uomlist = uomslist;
		var uomcheck = false;
		for(var i=0 ; i < uomlist.length ; i++ )
		{
			if($('#uomchange').val()==uomlist[i].label)
			{
				uomcheck = true;
				i=uomlist.length;
			}
		}
		var uom = globaldata.productList;
		if($('#uomchange').val()!= '' && uomcheck == true)
		{
			var resultMap = [];
			var resultList = {};
			$("#packchange").prop('readonly', false);	

			uomc = 1;
			$(".editproduct1").show();
			//$(".editproduct2").show();

			/*if($('#uomchange').val()=="PACK")
							{	
								$("#packchange").val("1'S");
							}*/

			if($('#uomchange').val()=="PACK")
			{	
				$("#packchange").val("1'S");
				$("#packchange").prop('readonly', true);
			}

			var pack = $("#packchange").val().split( "'" );
			var pack1;

			if(packsize > pack[0] & pack[0]== 1 ){
				cpack1 = 1;
			}else if(packsize < pack[0] & packsize== 1){
				cpack1 = 2;
			}else{
				cpack1 = null;
			}
			if (packsize!=1){
				pack1 = packsize;
			}else{
				pack1 = 1;
			}
			if(uom[0].quantitySellUomId == $("#uomchange").val())
			{
				uomc = 0;
				//$(".editproduct1").hide();
				//$(".editproduct2").hide();
			}
			if(packc == 1)
			{
				uomTo = $("#uomchange").val();
				uomFo = $("#hdnuomchange").val();
				conTo = pack[0];
				//$(".editproduct1").show();
				//$(".editproduct1").show();
			}else{
				uomTo = $("#uomchange").val();
				uomFo = $("#hdnuomchange").val();
				conTo = packsize;
				//$("#packchange").val(packsize+"'S");
			}
			//alert(uomTo+","+uomFo+","+pack[0]+","+cpack1);
			packval=conTo;
			displaytable(uomTo,uomFo,conTo,cpack1);

		}
		else
		{
			//$("#packchange").val('1');
			//$('#uomchange').val(uom[0].quantitySellUomId);
			$("#erroruom").modal('show');
		}

			});

	$("#packchange").blur(function()
			{
		//alert("packchange");

		var pack = $("#packchange").val().split( "'" );	
		var uom = globaldata.productList;
		if(pack[0] >= 1)
		{
			pack[0]=parseInt(pack[0]);

			$("#packchange").val(pack[0]+"'S");

			packc = 1;
			data =globaldata.uomList;
			$(".editproduct1").show();


			if(packsize > pack[0] & pack[0]== 1 )
			{
				cpack1 = 1;
			}
			else if(pack[0] > 1 & packsize== 1)
			{
				cpack1 = 2;
			}
			else
			{
				cpack1 = null;
			}
			if(packsize == pack[0])
			{
				packc = 0;
				//$(".editproduct1").hide();
			}
			if(uomc==0)
			{
				uomTo = uom[0].quantitySellUomId;
				uomFo = uom[0].quantityBuyUomId;
				conTo = pack[0];
				//$("#uomchange").val(uomTo);
			}
			else
			{
				uomTo = $("#uomchange").val();
				uomFo = $("#hdnuomchange").val();
				conTo = pack[0];
				//$(".editproduct1").show();
			}
			//alert(uomTo+","+uomFo+","+pack[0]+","+cpack1);

			packval=pack[0];

			displaytable(uomTo,uomFo,pack[0],cpack1);

		}
		else
		{
			//$("#packchange").val('1');
			$("#errorpack").modal('show');
			//$("#packchange").val(packsize+"'S");
		}
			});

	$("#submitUpdateCon").click(function()
			{
		if(uomc == 0 & packc==0 )
		{
			$("#changeError").modal('show');
		}
		else
		{
			$("#Confirmation").modal('show');
		}

			}); 

	$("#submitcancel").click(function()
			{
		//$("#productName").val('0');
		loadProductDetails('');
		$(".editproduct").hide();
		$(".editproduct1").hide();

			}); 

});
function isNumberKey(evt) {
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	if (charCode == 0||charCode == 8 || charCode == 9 || charCode == 37 || charCode == 38 || charCode == 39 || charCode == 40|| charCode == 46) // back space, tab, delete, enter
		return true;
	else if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
	return true;
}

function submitUpdateCancel()
{
	$("#Confirmation").modal('hide');
}
function submitUpdateCheck()
{
	var isync=document.getElementById("isync");
	if(isync.checked==true)
	{ 
		$("#Confirmation").modal('hide');
		submitUpdate();
	}
	else
	{
		document.getElementById("error").innerHTML="Please select any options or Press Cancel";
	} 
}


function displaytable(uomlow,uomhigh,pack,cpack1)
{
	pack = packval;

	var resultMap = [];
	var resultList = {};
	$("#editproduct2").show();
	if(uomlow==uomhigh)
	{
		uomhigh = "PACK";
		for(var i=0 ; i < compuomlist.length; i++ )
		{
			if(uomlow==compuomlist[i].label)
			{
				uomhigh = compuomlist[i].value.split("'")[1];
				i=compuomlist.length;
			}
		}
	}
	if(pack>1)
	{
		$("#cuomId").text(uomlow.toLowerCase()+", "+uomhigh.toLowerCase());
		$("#cconversionId").text("1 "+uomhigh.toLowerCase());
		$("#cconversionId1").text(" is ");
		$("#cconversionId2").text(pack+" "+uomlow.toLowerCase());
		$("#cpackId").text(pack+"'S");
	}
	else
	{
		$("#cuomId").text(uomlow.toLowerCase());
		$("#cconversionId").text("1 "+uomlow.toLowerCase());
		$("#cconversionId1").text("");
		$("#cconversionId2").text("");
		$("#cpackId").text(pack+"'S");
	};	

	var uom = globaldata.productList;
	var batchList = globalstock;
	var stockprice = globaldata.productPriceList;

	if(packsize != pack && uom[0].quantitySellUomId != uomlow) {
		document.getElementById('cuomId').style.color = '#FF0000';
		document.getElementById('cpackId').style.color = '#FF0000';
		document.getElementById('cconversionId').style.color = '#FF0000';
		document.getElementById('cconversionId1').style.color = '#FF0000';
		document.getElementById('cconversionId2').style.color = '#FF0000';
	}else if(packsize != pack) {
		document.getElementById('cuomId').style.color = '#4C4C4C';
		document.getElementById('cpackId').style.color = '#FF0000';
		document.getElementById('cconversionId').style.color = '#FF0000';
		document.getElementById('cconversionId1').style.color = '#FF0000';
		document.getElementById('cconversionId2').style.color = '#FF0000';

	}else if(uom[0].quantitySellUomId != uomlow) {
		document.getElementById('cuomId').style.color = '#FF0000';
		document.getElementById('cpackId').style.color = '#4C4C4C';
		document.getElementById('cconversionId').style.color = '#FF0000';
		document.getElementById('cconversionId1').style.color = '#FF0000';
		document.getElementById('cconversionId2').style.color = '#FF0000';
	}else {
		document.getElementById('cuomId').style.color = '#4C4C4C';
		document.getElementById('cpackId').style.color = '#4C4C4C';
		document.getElementById('cconversionId').style.color = '#4C4C4C';
		document.getElementById('cconversionId1').style.color = '#4C4C4C';
		document.getElementById('cconversionId2').style.color = '#4C4C4C';
	}


	if(batchList.length!= 0)
	{
		$("#batchhead").empty();
		$("#batchProduct").empty();
		$("#batchhead").append('<tr>');
		$("#batchhead").append('<th class = "fnt7" style="width: 10%;">Batch No.</th>');
		$("#batchhead").append('<th class = "fnt7" style="width: 12%;">Stock('+uom[0].quantitySellUomId+')</th>');
		$("#batchhead").append('<th id = "content" class = "fnt7" style="width: 12%; background-color:#f5b994;" >Stock(<span id = "Nstock" class ="fnt9" style="font-size:10pt;">'+uomlow+'</span>)</th>');/////
		$("#batchhead").append('<th class = "fnt7" style="width: 12%;" >Price/ <span style="text-transform:capitalize;">'+uom[0].quantitySellUomId.toLowerCase()+'</span></th>');
		if(pack>1)
		{
			$("#batchhead").append('<th id = "content" class = "fnt7" style="width: 12%; background-color:#f5b994;" >Price/ <span id = "Nuom1" class ="fnt9" style="text-transform:capitalize; font-size:10pt;">'+uomlow.toLowerCase()+'</span></th>');////
		}
		else
		{
			$("#batchhead").append('<th id = "content" class = "fnt7" style="width: 12%; background-color:#f5b994;" >Price/ <span id = "Nuom1" class ="fnt9" style="text-transform:capitalize; font-size:10pt">'+uomlow.toLowerCase()+'</span></th>');////
		}
		$("#batchhead").append('<th class = "fnt7" style="width: 12%;">Price/ <span style="text-transform:capitalize;">'+uom[0].quantityBuyUomId.toLowerCase()+'</span> </th>');
		if(pack>1)
		{
			$("#batchhead").append('<th id = "content" class = "fnt7" style="width: 12%; background-color:#f5b994;" >Price/ <span id = "Nuom2" class ="fnt9" style="text-transform:capitalize; font-size:10pt">'+uomhigh.toLowerCase()+'</span></th>');////
		}
		else
		{
			$("#batchhead").append('<th id = "content" class = "fnt7" style="width: 12%; background-color:#f5b994;" >Price/ <span id = "Nuom2" class ="fnt9" style="text-transform:capitalize; font-size:10pt">'+uomlow.toLowerCase()+'</span></th>');////
		}
		$("#batchhead").append('<th style="width: 24%;"></th></tr>');

		for (var i = 0; i < batchList.length; i++) 
		{
			var header = {};
			var purchasePrice = 0;
			for(var j = 0; j < stockprice.length; j++)
			{
				if(stockprice[j].productPricePurposeId == "COMPONENT_PRICE" && stockprice[j].serialNumber == batchList[i].serialNumber )
				{
					purchasePrice = stockprice[j].price;
					j = stockprice.length;
				}
			}
			unitprice = batchList[i].price/packsize;
			unitprice = unitprice.toFixed(2);
			nunitprice = batchList[i].price/pack;
			nunitprice = nunitprice.toFixed(2);
			if(cpack1 == 1){
				var nstock = batchList[i].availableToPromiseTotal/packsize;
			}else if(cpack1 == 2)
			{
				var nstock = batchList[i].availableToPromiseTotal*pack;
			}else{
				var nstock = batchList[i].availableToPromiseTotal;
			}
			$("#batchProduct").append('<tr>');
			$("#batchProduct").append('<td class = "fnt8">' + batchList[i].serialNumber + '</td>');
			$("#batchProduct").append('<td class = "fnt8">' + batchList[i].availableToPromiseTotal + '</td>');
			if(cpack1 != null){
				//alert(isfloat(nstock));
				//alert(parseInt(nstock));
				if(isfloat(nstock))
				{
					$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;"><span class = "fnt13">' + parseInt(nstock, 10)+'('+nstock.toFixed(2) + ')</span></td>');
					$("#stockerror").show();
				}
				else
				{
					$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;"><span class = "fnt5">' + nstock + '</span></td>');
				}


			}else{
				$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;">' + nstock + '</td>');
			}
			$("#batchProduct").append('<td class = "fnt8">' + unitprice + '</td>');

			if(unitprice != nunitprice){
				$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;"><span class = "fnt5">' + nunitprice + '</span></td>');
				//$("#cuomId").style.color='#FF0000';
				//$("#cpackId").style.color='#FF0000';
				//$("#cconversionId").style.color='#FF0000';
			}else{
				$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;">' + nunitprice + '</td>');
			}

			$("#batchProduct").append('<td class = "fnt8">' + batchList[i].price.toFixed(2) + '</td>');
			$("#batchProduct").append('<td class = "fnt8" style=" background-color:#ffdec9;" >' + batchList[i].price.toFixed(2) + '</td>');
			$("#batchProduct").append('<td></td></tr>');

			header["batch"] = batchList[i].serialNumber;
			header["inventoryId"] = batchList[i].inventoryItemId;
			header["stock"] = parseInt(nstock);
			header["sellPrice"] = batchList[i].price;
			header["purchasePrice"] = purchasePrice;
			var dateval = batchList[i].expireDate.split("-");
			var exDate = dateval[2]+"-"+dateval[1]+"-"+dateval[0];
			header["expiryDate"] = exDate; 
			resultMap.push(header);
			var data = JSON.stringify(resultMap);
		};
	}
	else
	{
		$("#batchProduct").empty();
	}

	if(batchList.length!= 0)
	{
		if(packsize != pack && uom[0].quantitySellUomId != uomlow) {
			document.getElementById('Nstock').style.color = '#FF0000';
			document.getElementById('Nuom1').style.color = '#FF0000';
			document.getElementById('Nuom2').style.color = '#FF0000';

		}else if(packsize != pack) {
			document.getElementById('Nstock').style.color = '#4C4C4C';
			document.getElementById('Nuom1').style.color = '#4C4C4C';
			document.getElementById('Nuom2').style.color = '#4C4C4C';

		}else if(uom[0].quantitySellUomId != uomlow) {
			document.getElementById('Nstock').style.color = '#FF0000';
			document.getElementById('Nuom1').style.color = '#FF0000';
			document.getElementById('Nuom2').style.color = '#FF0000';

		}else {
			document.getElementById('Nstock').style.color = '#4C4C4C';
			document.getElementById('Nuom1').style.color = '#4C4C4C';
			document.getElementById('Nuom2').style.color = '#4C4C4C';
		}
	}	
	resultList["partyId"] = partyId;
	resultList["facilityId"] = globaldata.productList[0].facilityId;
	/*resultList["partyRoleTypeId"] = globaldata.productRoleList[0].roleTypeId;*/ //Vinoth Modified for Edit Product Change
	resultList["partyRoleTypeId"] = $("#partyRoleTypeId").val();

	resultList["productStoreId"] = globaldata.productTaxList[0].productStoreId;
	if(globaldata.productPriceList.length!= 0)
	{
		resultList["productStoreGroupId"] = globaldata.productPriceList[0].productStoreGroupId;	
	}else{
		resultList["productStoreGroupId"] = globaldata.productTaxList[0].productStoreId; 
	}
	resultList["manufacturerPartyId"] = globaldata.productList[0].manufacturerPartyId;
	resultList["dataSourceId"] = globaldata.productList[0].dataSourceId;
	if(globaldata.productList[0].externalId != null)
	{
		resultList["externalId"] = globaldata.productList[0].externalId;	
	}else{
		resultList["externalId"] = "empty"; 
	}
	resultList["productId"] = globaldata.productList[0].productId; /*Edited by vinoth for Changed Create Product Service*/
	resultList["productName"] = globaldata.productList[0].productName;
	if(pack>1)
	{
		resultList["sellUom"] = uomlow;
		resultList["stockUom"] = uomlow;
		resultList["buyUom"] = uomhigh;
	}else{
		resultList["sellUom"] = uomlow;
		resultList["stockUom"] = uomlow;
		resultList["buyUom"] = uomlow;
	}
	resultList["conversionFactor"] = pack;
	var MRP = 0;
	for(var j = 0; j < stockprice.length; j++)
	{
		if(stockprice[j].productPricePurposeId == "MRP")
		{
			MRP = stockprice[j].price;
			j = stockprice.length;
		}
	}
	resultList["mrp"] = MRP;

	if(globaldata.productList[0].genericName!=null)
	{
		resultList["genericName"] = globaldata.productList[0].genericName;
	}else{
		resultList["genericName"] = 0;
	}
	if(globaldata.productList[0].minimumStock!=null)
	{
		resultList["minStock"] = globaldata.productList[0].minimumStock;
	}else{
		resultList["minStock"] = 0;
	}
	if(globaldata.productList[0].reorderQuantity!=null)
	{
		resultList["reorderLevel"] = globaldata.productList[0].reorderQuantity;
	}else{
		resultList["reorderLevel"] = 0;
	}
	if(globaldata.productList[0].maximumStock!=null)
	{
		resultList["maxStock"] = globaldata.productList[0].maximumStock;
	}else{
		resultList["maxStock"] = 0;
	}
	if(globaldata.productTaxList[0].taxPercentage!=null)
	{
		resultList["taxPercentage"] = globaldata.productTaxList[0].taxPercentage;
	}else{
		resultList["taxPercentage"] = 0;
	}
	resultList["newStock"] = resultMap;
	resultList["oldStock"] = resultMap1;/*Edited by vinoth for Changed Create Product Service*/

	//vinoth /*var data = JSON.stringify(resultList);*/
	
	finalresult = resultList;
}

function emptyProductDetails()
{
	$("#uomId").empty();
	$("#batchNo").empty();
	$("#qtyInSystem").val('');
	uomc = 0;
	packc = 0;
	cpack1 = 0;
	result = {};
	finalresult = [];
	resultMap1 = [];
	removebatch = [];
	resultRemove = [];
	$("#uomchange").val('');
	$("#packchange").val('');
	$("#reason").empty();
	$("#batchProduct").empty();
	$("#batchhead").empty();
}

function loadProductDetails(productId)
{
	var id = productId;
	$("#uomId").empty();
	$("#batchNo").empty();
	$("#qtyInSystem").val('');

	uomc = 0;
	packc = 0;
	cpack1 = 0;

	result = {};
	finalresult = [];
	resultMap1 = [];
	removebatch = [];
	resultRemove = [];

	$("#uomchange").val('');
	$("#packchange").val('');
	$("#reason").empty();
	$(".loadingImage2").show();
	$("#batchProduct").empty();
	$("#batchhead").empty();
	$(".editproduct").show();
	$(".editproduct1").hide();
	$("#editproduct2").hide();
	$("#stockerror").hide();

	$("#productName").disabled=true;
	$('.loadingImage2').animate({ opacity: 1}, 500, function() {
		var urlproddel = $("#idhiddenProductDetail").val();
		$.ajax({
			type: 'GET',
			cache: false,
			url: urlproddel,
			data: {
				'service': 'ProductDetail',
				'productId': id,
				'targetPartyId': partyId
			},
			async: false,
			success: function(data) {
				$("#productName").disabled=false;
				$(".loadingImage2").hide();
				//var principal = data.productList;

				var uom = data.productList;
				var tax = data.productTaxList;
				globaldata = data;
				//globaldata = uom;

				if(uom[0].quantityIncluded>1)
				{
					$("#uomId").text(uom[0].quantitySellUomId.toLowerCase()+", "+uom[0].quantityBuyUomId.toLowerCase());
					$("#conversionId").text("1 "+uom[0].quantityBuyUomId.toLowerCase());
					$("#conversionId1").text(" is ");
					$("#conversionId2").text(uom[0].quantityIncluded+" "+uom[0].quantitySellUomId.toLowerCase());

					//$("#cuomId").text(uom[0].quantitySellUomId.toLowerCase()+", "+uom[0].quantityBuyUomId.toLowerCase());
					//$("#cconversionId").text("1 "+uom[0].quantityBuyUomId.toLowerCase()+" is "+uom[0].quantityIncluded+" "+uom[0].quantitySellUomId.toLowerCase());

					$("#packId").text(uom[0].quantityIncluded+"'S");
					//$("#cpackId").text(uom[0].quantityIncluded+"'S");
					packsize = uom[0].quantityIncluded;
				}
				else
				{
					$("#uomId").text(uom[0].quantityBuyUomId.toLowerCase());
					$("#conversionId").text("1 "+uom[0].quantityBuyUomId.toLowerCase());
					$("#conversionId1").text('');
					$("#conversionId2").text('');

					$("#cuomId").text(uom[0].quantityBuyUomId.toLowerCase());
					$("#cconversionId").text("1 "+uom[0].quantityBuyUomId.toLowerCase());

					$("#packId").text("1'S");
					$("#cpackId").text("1'S");

					packsize = 1;
				};	

				$("#vatId").text(tax[0].taxPercentage+"%");
				$("#cvatId").text(uom[0].VAT+"%");

			},
			error: function() {
				$(".loadingImage2").hide();
				$("#productName").disabled=false;
				$("#productListError").modal('show');
				$('#productListError .btn').focus();
			}
		});

		var batchurl = $("#idhiddenBatchList").val();
		$.ajax({
			type: 'GET',
			cache: false,
			url: batchurl,
			data: {
				'service': 'BatchList',
				'targetPartyId':partyId,
				'productId':  id
			},
			async: false,
			success: function(data) {
				var batchList = data.productBatchDetails;
				globalstock = batchList;
				var resultList1 = {};
				var removebatch = [];
				data = globaldata;
				stockprice = data.productPriceList;
				var uom = data.productList;
				uomd = globaldata.uomList;
				if(batchList.length!=0)
				{
					$("#batchhead").append('<tr>');
					$("#batchhead").append('<th class = "fnt7" style="width: 20%;">Batch No.</th>');
					$("#batchhead").append('<th class = "fnt7" style="width: 20%;">Stock(<span style="text-transform:uppercase;">'+uom[0].quantitySellUomId+'</span>)</th>');
					$("#batchhead").append('<th class = "fnt7" style="width: 20%;">Price/ <span style="text-transform:capitalize;">'+uom[0].quantitySellUomId.toLowerCase()+'</span></th>');
					$("#batchhead").append('<th class = "fnt7" style="width: 20%;">Price/ <span style="text-transform:capitalize;">'+uom[0].quantityBuyUomId.toLowerCase()+'</span></th>');
					$("#batchhead").append('<th style="width: 20%"></th></tr>');


					for (var i = 0; i < batchList.length; i++) {

						var header = {};
						var header1 = {};

						unitprice = batchList[i].price/packsize;
						unitprice = unitprice.toFixed(2);

						var purchasePrice = 0;
						for(var j=0; j < stockprice.length; j++)
						{
							if(stockprice[j].productPricePurposeId == "COMPONENT_PRICE" && stockprice[j].serialNumber == batchList[i].serialNumber )
							{
								purchasePrice = stockprice[j].price;  
								j = stockprice.length;
							}
						}

						$("#batchProduct").append('<tr>');
						$("#batchProduct").append('<td class = "fnt8">' + batchList[i].serialNumber + '</td>');
						$("#batchProduct").append('<td class = "fnt8">' + batchList[i].availableToPromiseTotal + '</td>');
						$("#batchProduct").append('<td class = "fnt8">' + unitprice + '</td>');
						$("#batchProduct").append('<td class = "fnt8">' + batchList[i].price.toFixed(2) + '</td>');
						$("#batchProduct").append('<td></td></tr>');

						header["batch"] = batchList[i].serialNumber;
						header["inventoryId"] = batchList[i].inventoryItemId;
						header["stock"] = batchList[i].availableToPromiseTotal;
						header["sellPrice"] = batchList[i].price;
						header["purchasePrice"] = purchasePrice;

						var dateval = batchList[i].expireDate.split("-");
						var exDate = dateval[2]+"-"+dateval[1]+"-"+dateval[0];
						header["expiryDate"] = exDate;

						resultMap1.push(header);

						var today = new Date();
						var dd = today.getDate();
						var mm = today.getMonth()+1; 
						var yyyy = today.getFullYear();
						var nowdate = yyyy+'-'+mm+'-'+dd;

						header1["partyId"] = partyId;
						header1["inventoryItemId"] = batchList[i].inventoryItemId;
						header1["adjustmentQty"] = "-"+batchList[i].availableToPromiseTotal;
						header1["comments"] = "Product Deleted";
						header1["reason"] = "VAR_DAMAGED";
						header1["inventoryDate"] = nowdate;

						removebatch.push(header1);
						/*var result = {};
						result["stockAdjustmentDetails"] = removebatch;
						var data1 = JSON.stringify(result);*///Vinoth Modified
						resultRemove = removebatch;
					};
				}
				else
				{
					$("#batchProduct").empty();
					$("#batchhead").append('<tr><th>No batch available</th></tr>');
				}
			},
			error: function() {
				$(".loadingImage2").hide();
				$("#batchProduct").empty();
			}
		}); 

	});

}
/***************************************************/
/***************************************************/

function isfloat(num) {
	return +num === num && (!isFinite(num) || !!(num % 1));
}

function reloadproduct() {
	productslist = new Array();
	var prodserurl = $("#idhiddenProductSearch").val();
	$.ajax({
		type: 'GET',
		url: prodserurl,
		async: false,
		cache: false,
		data: {
			'service': 'ProductSearch',
			'targetPartyId': partyId
		},
		success: function(data) {

			products = data.productList;
			$.each(products, function(i, product)
					{
				productslist.push({
					"label" : product.productName,
					"value" : product.productName,
					"id" : product.productId
				});
					});
			$("#loadingImage").hide();
		}
	});

	$("#productName").autocomplete({
		source: productslist,
		minLength:3,
		autofocus:true,
		select : function(event, ui)
		{
			$('#productName').val(ui.item.label);
			$('#hdnProductId').val(ui.item.id);
			loadProductDetails(ui.item.id);
			//return false;
		},
		change : function(event, ui)
		{
			if (ui.item == null || ui.item == undefined)
			{
				$("#productName").val("");
			} else
			{
				//$('#productName').val(ui.item.label);
				//loadProductDetails(ui.item.id);
			}
		}
	});


}

function submitUpdate() {
	var targetPartyId= partyId;
	var batchList = globalstock;

	finalresult,
	finalresult["stockAdjustmentDetails"]=resultRemove;
	var productId = globaldata.productList[0].productId;
	var roletypeid = globaldata.productRoleList[0].roleTypeId;
	$("#submitUpdateCon").disabled=true;
	$("#changing").modal('show');
	var prodnewurl = $("#idhiddenProductNew").val();
	$.ajax({
		type: 'POST',  //IT is acually a POST service
		url: prodnewurl,
		data: {
			'service': 'ProductNew',
			'productId': productId,
			'targetPartyId': partyId,
			'newproduct':JSON.stringify(finalresult)
		},
		async: false,
		cache: false,
		success: function(data) {
			var newp = data;

			var status = "failure";
			if(newp.responseMessage){
				status=newp.responseMessage;
			}
			if(newp.result){
				status=newp.result;
			}
			if(status=="success")
			{
				$("#productName").val('');
				emptyProductDetails();
				$(".editproduct").hide();
				$(".editproduct1").hide();
				reloadproduct();
				$("#changing").modal('hide');
				$("#SuccessProduct").modal('show');
				$("#submitUpdateCon").disabled=false;

			}else{
				$("#changing").modal('hide');
				$("#editerror").modal('show');
				$("#submitUpdateCon").disabled=false;
			}
		},
		error: function() {

		}
	});
}