/**
 * @author vinoth
 */
var gList = [];
var table;
var start  = 0;
var limit = 5;
var editFlag;
var edList = [];

$(document).ready(function() {
	$("#idTxtAlternateGrp").on("keypress", function (e) {
	    return e.which !== 32;
	});
	table =$('#alternateTable').dataTable({
		"bFilter" : false,               
		"bLengthChange": false,
		"bPaginate": false,
		"bInfo": true,
		"bJQueryUI" : true,
		'iDisplayLength': -1,
		"bSort" : false
	});
	
	editFlag = false;
	$('#alternateTable tbody').on( 'click', 'tr', function () {
		if ( $(this).hasClass('selected') ) {
			$(this).removeClass('selected');
		}
		else {
			$('#alternateTable tr.selected').removeClass('selected');
			$(this).addClass('selected');
		}
		var sData = table.fnGetData( this );
		updateProducts(sData);
	} );
	/*$('#alternateTable tbody').on( 'click', 'button', function () {
		var sData = table.fnGetData( this );
		alert(sData);
		//updateProducts(aPos);
		
    } );*/
	
	initPageAction();
	initProductNameSearch();
	initAutoCompleteHighlight();
	$("#idButAdd").bind('click',addPartList);
	$("#idButSubmit").bind('click',generateJsonResources);
	//$("#addMoreProduct").bind('click',updateProducts);
	
	loadAlternateProducts(start,limit);//	getLoyaltyList(start,limit);
	var orIdVal = $("#idorderIdListValue").val();
	$("#dataInfo").text("Showing "+(parseInt(start+1))+" to "+ limit +" of "+ orIdVal);
	if(orIdVal > start && 2 > start){
		$(".prev").addClass("disabled");
		$('#prevbut').attr('disabled', true);
		/*$(".next").addClass("disabled");
		$('#nextbut').attr('disabled', true);*/
	}else{
		$(".prev").removeClass("disabled");
		$('#prevbut').attr('disabled', false);
		$(".next").removeClass("disabled");
		$('#nextbut').attr('disabled', false);
	}

	$("#nextbut").click(function(){
		//start = start+limit;
		if(start+limit >= start){
			start = start+limit;
		}
		if(orIdVal >=start){
			table.fnClearTable();
			$("#dataInfo").text("Showing "+(parseInt(start+1))+" to "+ (parseInt(start+1)+parseInt(limit)-1) +" of "+orIdVal);
			if(start <= orIdVal){
				$(".next").removeClass("disabled");
				$('#nextbut').attr('disabled', false);
			}else{
				$(".next").addClass("disabled");
				$('#nextbut').attr('disabled', true);
			}
			if(start < limit){
				$(".prev").addClass("disabled");
				$('#prevbut').attr('disabled', true);
			}else{
				$(".prev").removeClass("disabled");
				$('#prevbut').attr('disabled', false);
			}
			loadAlternateProducts(start,limit);//getLoyaltyList(start,limit);
		}else{
			$(".next").addClass("disabled");
			$('#nextbut').attr('disabled', true);
			start = start-limit;
		}

	});
	$("#prevbut").click(function(){
		if(start >= limit){
			$(".prev").removeClass("disabled");
			$('#prevbut').attr('disabled', false);
			$(".next").removeClass("disabled");
			$('#nextbut').attr('disabled', false);
			table.fnClearTable();
			start = start-limit;
			$("#dataInfo").text("Showing "+(parseInt(start+1))+" to "+ (parseInt(start+1)+parseInt(limit)-1) +" of "+ orIdVal);
			loadAlternateProducts(start,limit);//getLoyaltyList(start,limit);
			if(start <= 1){
				$(".prev").addClass("disabled");
				$('#prevbut').attr('disabled', true);
			}
		}else{
			$(".prev").addClass("disabled");
			$('#prevbut').attr('disabled', true);
			$(".next").removeClass("disabled");
			$('#nextbut').attr('disabled', false);
		}
    });
	

	/**
	 * Add New Group
	 */

	$("#idbutAddGrp").click(function(){
		editFlag = false;
		$("#idTxtAlternateGrp").prop("disabled",false);
		$("#idTxtAlternateGrp").val("");
		gList = [];
		deleteAllRows();
		$("#addNewCategory").modal('show');
	});
	
	/**
	 * Search Button
	 */

	$("#idButSearch").click(function(){
		var textVal = $("#searchMethodsBox").val();
		if(textVal.trim() == "" || textVal.trim() == null || $("#searchMethods option:selected").val() == ""){
			$("#commonModal").modal('show');
			$("#commonModalHead").text("Please check...");
			$("#commonModalBody").html("<h5>Search Field should not be empty.</h5>");
		}else{
			searchAlternateProductsList(0,limit);
		}
	});
	 
	/**
	 * Empty Group
	 */
	
	$("#idButRemoveAll").click(function(){
		editFlag = true;
		gList = [];
		deleteAllRows();
	});
});


/**
 * Update List Based on Search
 */
function searchAlternateProductsList(start,limit){
	var grpSelName = "";
	var partSelName = "";
	var partSelNo = "";
	//alert($("#searchMethods option:selected").val() +" :: "+$("#searchMethodsBox").val());
	if($("#searchMethods option:selected").val() == "category"){
		grpSelName = $("#searchMethodsBox").val();
		partSelName = "";
		partSelNo = "";
	}else if($("#searchMethods option:selected").val() == "partName"){
		partSelName = $("#searchMethodsBox").val();
		grpSelName = "";
		partSelNo = "";
	}else if($("#searchMethods option:selected").val() =="partNumber"){
		partSelNo = $("#searchMethodsBox").val();
		grpSelName = "";
		partSelName = "";
	}else{
		
	}
	
	table.fnClearTable();
	loadAlternateProducts(start,limit,grpSelName,partSelName,partSelNo);
}

/**
 * updating Products
 */
function updateProducts(el){
	editFlag = true;
	var newList = [];
	var mvalue = JSON.parse(decodeURIComponent($("#"+el[0]).val()));
	var mValLen = $("#tarneal_subList_length_"+el[0]).val();
	newList.push(mvalue);
	for(var m=1;m<mValLen;m++){
		newList.push(JSON.parse(decodeURIComponent($("#tarneal_"+el[0]+"_"+m).val())));
	}
	gList = [];
	edList = [];
	deleteAllRows();
	var rows = "";
	for(var l=0;l<newList.length;l++){
		//alert(JSON.stringify(newList[l]));
		gList.push({
			prdId:newList[l].productId,
	        partNo: newList[l].partNumber,
	        partName: newList[l].partName,
	        fromDate:newList[l].fromDate
	    });
		edList.push({
			prdId:newList[l].productId,
	        partNo: newList[l].partNumber,
	        partName: newList[l].partName,
	        fromDate:newList[l].fromDate
	    });
    rows = "<tr><td></td><td><div class='expand' onmouseover='popupShow(this)' rel='popover'><input type='hidden' id='popOver_Man_"+l+"' value='"+newList[l].manufacturerName+"'/><input type='hidden' id='popOver_uom_"+l+"' value='"+newList[l].uomId+"'/></div><div class='col-md-3 col-lg-3 padding0'>"+newList[l].partNumber+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'></div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
		//rows = "<tr><td></td><td><a class='expand popper pull-left' data-toggle='popover' data-trigger='hover' onclick='popupShow(this)'></a><div class='popper-content hide'><ul class='addtnInfo'><li><div class='left'>Manufacturer:</div><div class='right discV'>"+newList[l].partNumber+"</div></li><li><div class='left'>UOM:</div><div class='right discV'>"+newList[l].partName+"</div></li></ul></div><div class='col-md-3 col-lg-3 padding0'>"+newList[l].partNumber+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+newList[l].partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
		$( rows ).appendTo( "#itemList tbody" );
	}
	
	$("#idTxtAlternateGrp").val(el[0]);
	$("#idTxtAlternateGrp").prop("disabled", true);
	$("#addNewCategory").modal('show');
}

/**
 * Load Alternate Products
 */
function loadAlternateProducts(start,limit,grpSelName,partSelName,partSelNo){
	if(grpSelName == undefined){
		grpSelName = "";
	}
	if(partSelName == undefined){
		partSelName = "";
	}
	if(partSelNo == undefined){
		partSelNo = "";
	}
	
	
	var idHdnGetAllAlternateRegReq = $("#idHdnGetAllAlternateRegReq").val();
	$("#loadingAnimation").modal('show');
	$.ajax({
		type: 'GET',
		url: idHdnGetAllAlternateRegReq,
		async:false,
		cache:false,
		data: {
			'productStoreGroupId':$("#idHdnProductStoreGroupId").val(),
			'startIndex':start,
			'limit':limit,
			'grpSelName':grpSelName,
			'partSelName':partSelName,
			'partSelNo':partSelNo
		},success: function(data) {
			$("#loadingAnimation").modal('hide');
			var alternateProductList = data.groupList;
			var alternateProductDetail = data.groupDetail;
			var alternateProductDetailTotalSize = alternateProductList.length;
			var alternateProductDetailSize = alternateProductDetailTotalSize;
			var incNo;
			if(alternateProductDetailTotalSize > 5 && start < 5){
				incNo = parseInt(alternateProductDetailTotalSize-limit);
				alternateProductDetailSize = alternateProductDetailTotalSize - incNo;
			}else if(start > 4){
				incNo = parseInt(alternateProductDetailTotalSize-limit);
				alternateProductDetailSize = alternateProductDetailTotalSize;
			}
			
			$("#idorderIdListValue").val(alternateProductDetailTotalSize);
			var vin=1;
			for (var i=start;i <alternateProductDetailSize;i++){
				if(alternateProductList[i].reason !=undefined && alternateProductDetail[alternateProductList[i].reason].length > 0){
					var a = table.fnAddData([alternateProductList[i].reason,"<input type='hidden' id='tarneal_subList_length_"+alternateProductList[i].reason+"' value='"+alternateProductDetail[alternateProductList[i].reason].length+"' /><input type='hidden' id='"+alternateProductList[i].reason+"' value='"+encodeURIComponent(JSON.stringify(alternateProductDetail[alternateProductList[i].reason][0]))+"' />","<div class='expand' onmouseover='popupShowMain(this)' rel='popover'><input type='hidden' id='popOver_Main_Man_"+vin+"' value='"+alternateProductDetail[alternateProductList[i].reason][0].manufacturerName+"'/><input type='hidden' id='popOver_Main_uom_"+vin+"' value='"+alternateProductDetail[alternateProductList[i].reason][0].uomId+"'/></div>"+alternateProductDetail[alternateProductList[i].reason][0].partNumber,alternateProductDetail[alternateProductList[i].reason][0].fromDate]);
					var nTr = table.fnSettings().aoData[ a[0] ].nTr;
					nTr.className = "parentRow";
					vin++;
					if(alternateProductDetail[alternateProductList[i].reason] != undefined){
						for(var j=1;j < alternateProductDetail[alternateProductList[i].reason].length;j++){
							if(alternateProductDetail[alternateProductList[i].reason][j] != undefined){
								table.fnAddData(['',"<input type='hidden' id='tarneal_"+alternateProductList[i].reason+"_"+j+"' value='"+encodeURIComponent(JSON.stringify(alternateProductDetail[alternateProductList[i].reason][j]))+"' />","<div class='expand' onmouseover='popupShowMain(this)' rel='popover'><input type='hidden' id='popOver_Main_Man_"+vin+"' value='"+alternateProductDetail[alternateProductList[i].reason][j].manufacturerName+"'/><input type='hidden' id='popOver_Main_uom_"+vin+"' value='"+alternateProductDetail[alternateProductList[i].reason][j].uomId+"'/></div>"+alternateProductDetail[alternateProductList[i].reason][j].partNumber,alternateProductDetail[alternateProductList[i].reason][j].fromDate]);
							}
						vin++;
						}
					}
				}
			}
		},error: function() {
			$("#commonModal").modal('show');
			$("#modalHead").text("Please check...>");
			$("#modalBody").html("<h5>Server unavalible.</h5>");
		}
	});
}

/**
 * Remove Row From Table
 */

function findAndRemove(array, property, value) {
	   $.each(array, function(index, result) {
	      if(result[property] == value) {
	          //Remove from array
	          array.splice(index, 1);
	      }    
	   });
	}

/**
 * Delete Index Based Rows
 * @param r
 */
function deleteRow(r) {
    var i = r.parentNode.parentNode.parentNode.rowIndex;
    //alert(i);
    document.getElementById("itemList").deleteRow(i);
    gList.splice(parseInt(i-3), 1);
}

/**
 * Generate JSON Resources
 */

function generateJsonResources(){
	var grpName = $("#idTxtAlternateGrp").val();
	grpName = grpName.trim();
	var loggedUser = $("#idHdnCreatedUser").val();
	if(grpName.length <= 0){
		$("#commonModal").modal('show');
		$("#commonModalHead").text('Please Check...');
		$("#commonModalBody").text('Group Name Should not be empty!');
	}else if(gList.length <= 0 && editFlag == false){
		$("#commonModal").modal('show');
		$("#commonModalHead").text('Please Check...');
		$("#commonModalBody").text('Please add atleast one product in to the given Group!');
	}else{
		var newListInsert = []
		var prdStrId = $("#idHdnProductStoreGroupId").val();
		if(editFlag){
			$("#addNewCategory").modal('hide');
			$("#waitModal").modal('show');
			postDataServer(JSON.stringify(edList),JSON.stringify(gList),prdStrId,grpName,editFlag);
		}else{
			$("#addNewCategory").modal('hide');
			$("#waitModal").modal('show');		
			postDataServer(JSON.stringify(edList),JSON.stringify(gList),prdStrId,grpName,editFlag);
		}
	}
}

/**
 * Clear All Data
 */
function clearAll(){
	$("#idTxtAlternateGrp").prop("disabled",false);
	$("#idTxtAlternateGrp").val("");
	gList = [];
	table.fnClearTable();
	loadAlternateProducts(start,limit);
}

/**
 * delete all records from table
 */

function deleteAllRows(){
	var rows = document.getElementById("itemList").getElementsByTagName("tr").length;
	if(rows > 3){ 
		for(var l=4;l<=rows;l++){
		    document.getElementById("itemList").deleteRow(3);
		}
	}
}

/**
 * Post to Server
 */

function postDataServer(oldList,newList,prdStrId,grpName,editFlag){
	var idHdnActionPostUrl = $("#idHdnActionPostUrl").val();
	$.ajax({
		type:'POST',
		url:idHdnActionPostUrl,
		async:false,
		cache:false,
		data:{
			'oldList':oldList,
			'newList':newList,
			'prdStrGrpId':prdStrId,
			'grpName':grpName,
			'editFlag':editFlag
		},success: function(data) {
			if(data.responseMessage == "success"){
				$("#waitModal").modal('hide');
				$("#commonModal").modal('show');
				$("#commonModalHead").text("Sucess");
				$("#commonModalBody").text("Alternate Product Created Sucessfully!");
				clearAll();
			}else{
				$("#waitModal").modal('hide');
				$("#commonModal").modal('show');
				$("#commonModalHead").text("Please check...");
				$("#commonModalBody").text("Alternate Product is Not Updating please try again.");
			}
		},error: function() {
		$("#waitModal").modal('hide');
		$("#commonModal").modal('show');
		$("#commonModalHead").text("Please check...");
		$("#commonModalBody").text("Alternate Product is Not Updating please try again.");
		}
	});
}

/**
 * Add Product in List
 */
function addPartList(){
	var grpname = $("#idTxtAlternateGrp").val();
	var pNo = $("#idHdnPartNo").val();
	var pName = $("#idHdnPartName").val();
	var prId = $("#idHdnPrdId").val();
	var manufac = $("#idHdnmanufac").val();
	var uom = $("#idHdnuom").val();
	if(grpname.trim() === ""){
		$("#commonModal").modal('show');
		$("#commonModalHead").text('Please Check...');
		$("#commonModalBody").text('Group Name Should not be empty!');
	}else if(pNo.trim() != "" || pName.trim() != "" ){
		if(gList.length > 0){
			//alert(checkSamePart(pNo));
			if(checkSamePart(pNo)){
				gList.push({
					prdId:prId,
			        partNo: pNo.trim(),
			        partName: pName.trim(),
			        manufacturerName : manufac.trim(),
			        uomId:uom.trim()
			    });
				var rows = "";
				$.each(gList, function(l){
					rows = "<tr><td></td><td><div class='expand' onmouseover='popupShow(this)' rel='popover'><input type='hidden' id='popOver_Man_"+l+"' value='"+this.manufacturerName+"'/><input type='hidden' id='popOver_uom_"+l+"' value='"+this.uomId+"'/></div><div class='col-md-3 col-lg-3 padding0'>"+this.partNo+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+this.partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
					//rows = "<tr><td></td><td><a class='expand popper pull-left' data-toggle='popover' data-trigger='hover'></a><div class='popper-content hide'><ul class='addtnInfo'><li><div class='left'>Manufacturer:</div><div class='right discV'>"+this.partNo+"</div></li><li><div class='left'>UOM:</div><div class='right discV'>"+this.partName+"</div></li></ul></div><div class='col-md-3 col-lg-3 padding0'>"+this.partNo+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+this.partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
				});
				$( rows ).appendTo( "#itemList tbody" );
				$("#idHdnPartNo").val('');
				$("#idHdnPartName").val('');
				$("#idHdnmanufac").val('');
				$("#idHdnuom").val('');
				$("#idPartNo").val('');
			}else{
				//alert(JSON.stringify(gList));
				$("#commonModal").modal('show');
				$("#commonModalHead").text('Please Check...');
				$("#commonModalBody").text('Part No already exist in given group!');
			}
		}else{
			gList.push({
				prdId:prId,
		        partNo: pNo,
		        partName: pName,
		        manufacturerName : manufac.trim(),
		        uomId:uom.trim()
		    });
			var rows = "";
			$.each(gList, function(l){
				rows = "<tr><td></td><td><div class='expand' onmouseover='popupShow(this)' rel='popover'><input type='hidden' id='popOver_Man_"+l+"' value='"+this.manufacturerName+"'/><input type='hidden' id='popOver_uom_"+l+"' value='"+this.uomId+"'/></div><div class='col-md-3 col-lg-3 padding0'>"+this.partNo+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+this.partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
				//rows = "<tr><td></td><td><div class='expand'><span onclick='popupShow(this)' rel='popover'></span><input type='hidden' id='popOver_Man_"+l+"' value='"+newList[l].manufacturerName+"'/><input type='hidden' id='popOver_uom_"+l+"' value='"+newList[l].uomId+"'/></div><div class='col-md-3 col-lg-3 padding0'>"+newList[l].partNumber+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+newList[l].partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
			    //rows = "<tr><td></td><td><a class='expand popper pull-left' data-toggle='popover' data-trigger='hover'></a><div class='popper-content hide'><ul class='addtnInfo'><li><div class='left'>Manufacturer:</div><div class='right discV'>"+this.partNo+"</div></li><li><div class='left'>UOM:</div><div class='right discV'>"+this.partName+"</div></li></ul></div><div class='col-md-3 col-lg-3 padding0'>"+this.partNo+"</div><div class='col-md-8 col-lg-8 padding0'><div class='pull-left'>"+this.partName+"</div><span class='glyphicon glyphicon-remove-sign pull-right' id='idButRemove' onclick='deleteRow(this)'></span></div></td></tr>";
			});
			$( rows ).appendTo( "#itemList tbody" );
			$("#idHdnPartNo").val('');
			$("#idHdnPartName").val('');
			$("#idHdnmanufac").val('');
			$("#idHdnuom").val('');
			$("#idPartNo").val('');
		}
	}else{
		$("#commonModal").modal('show');
		$("#commonModalHead").text('Please Check...');
		$("#commonModalBody").text('Part No or Part Name Should not be empty!');
	}
}

/**
 * Check Same Part No or Not
 * @param pNo
 * @returns {Boolean}
 */
function checkSamePart(pNo){
	//gList.partNo != pNo
	var flag;
	//alert("gList.length :: "+gList.length);
	for(var i=0;i<gList.length;i++){
		//alert("gList[i].partNo.trim() === pNo.trim() && flag " +gList[i].partNo.trim() +" :: "+pNo.trim()+" :: " +flag);
		if(gList[i].partNo.trim() === pNo.trim()){
			flag = false;
			break;
		}else{
			flag = true;
		}
	}
	return flag;
}


/**
 * Product Name Search
 * @param $scope
 */
function initProductNameSearch(){
 	$('#idPartNo').autocomplete({ source: function( request, response ) {
 		$("#idProductLoadingImage").show();
 		 var urlprodser = $("#hdnProductSearch").val();
 		$.ajax({
 			type: 'GET',
 			url: urlprodser,
 			async: false,
 			cache:false,
 			data: {
 				'partNo':$("#idPartNo").val(),
 				'partyTypeId':$("#idHdnPartyTypeId").val(),
 				'productStoreGroupId':$("#idHdnProductStoreGroupId").val(),
 				'limit':10
 			},
 			success: function(data) {
 				var products = data.productList;
 				var autoProducts = new Array();
 				$.each(products, function(i, product)
 				{
 					/*autoProducts["label"] = products[i].productName;
 					autoProducts["value"] = products[i].productName;
 					*/autoProducts.push({
 						"label" : products[i].productName,
 						"value" : products[i].productName,
 						"prdId" : products[i].productId,
 						"prdNo" : products[i].productName,
 						"prdName" :products[i].description,
 						"manufacturer":products[i].manufacturerName,
 						"uom":products[i].uomId
 					});
 				});
 				$("#idProductLoadingImage").hide();
 				$(".search-box").prop('readonly', false);
 				response(autoProducts);
 			}
 		});
 	},minLength: 3,delay: 500,autoFocus:true,select : function(event, ui)
 		{
 			$('#idPartNo').val(ui.item.label);
 			$('#hdnProductId').val(ui.item.prdId);
 			$('#idHdnPartNo').val(ui.item.prdNo);  
 			$('#idHdnPartName').val(ui.item.prdName);
 			$('#idHdnPrdId').val(ui.item.prdId);
 			$('#idHdnmanufac').val(ui.item.manufacturer);
 			$('#idHdnuom').val(ui.item.uom);
 			//productSelect(ui.item.prdId);
 			return false;
 		}
 	});
}

/**
 * Page Initiation Action
 */
function initPageAction(){
	var urlPartyDeail = $("#idhiddenPartyDetails").val();
	$.ajax({
		type: 'GET',
		url: urlPartyDeail,
		async:false,
		cache:false,
		success: function(data) {
			/*alert(JSON.stringify(data));*/
			$("#idHdnPartyTypeId").val(data.customerDetail.partyTypeId);
			$("#idHdnProductStoreGroupId").val(data.customerDetail.productStoreGroupId);
		},
		error : function(data){
			$("#alertModal").modal('show');
			$("#spanHeader").html("Failure");
			$("#divMessage").html(data.status);
		}
	});
}


/**
 * Popup Show Function
 */

function popupShow(evl){
	var i = evl.parentNode.parentNode.rowIndex;
    $(evl).popover({
        html: true,
        animation: false,
        content: "<label>Manufacturer:</label>"+"<span>"+$("#popOver_Man_"+parseInt(i-3)).val()+"</span>"+"<div class='linetop'></div>"+"<label class='float:left;'>UOM:</label>"+"<span>"+$("#popOver_uom_"+parseInt(i-3)).val()+"</span>",
        placement: "right",
        trigger: "hover"
    });
}


function popupShowMain(evl){
	var i = evl.parentNode.parentNode.rowIndex;
    $(evl).popover({
        html: true,
        animation: false,
        content: "<label>Manufacturer:</label>"+"<span>"+$("#popOver_Main_Man_"+parseInt(i)).val()+"</span>"+"<div class='linetop'></div>"+"<label class='float:left;'>UOM:</label>"+"<span>"+$("#popOver_Main_uom_"+parseInt(i)).val()+"</span>",
        placement: "right",
        trigger: "hover"
    });
}

/*function popupShowMainSub(evl){
	var i = evl.parentNode.parentNode.rowIndex;
    $(evl).popover({
        html: true,
        animation: false,
        content: "Manufacturer:"+$("#popOver_Main_Man_"+parseInt(i)).val()+" UOM:"+$("#popOver_Main_uom_"+parseInt(i)).val(),
        placement: "right",
        trigger: "hover"
    });
}*/

/**
 * Initializes highlight option for auto complete search texts
 */
function initAutoCompleteHighlight(){
	String.prototype.replaceAt = function(index, char)
	{
		return this.substr(0, index) + "<span style='font-weight:bold;color:Red;'>" + char + "</span>";
	};

	$.ui.autocomplete.prototype._renderItem = function(ul, item)
	{
		this.term = this.term.toLowerCase();
		var resultStr = item.label.toLowerCase();
		var tmp = item.label;
		var t = "";
		while (resultStr.indexOf(this.term) != -1)
		{
			var index = resultStr.indexOf(this.term);
			t = t + tmp.replaceAt(index, tmp.slice(index, index + this.term.length));
			resultStr = resultStr.substr(index + this.term.length);
			tmp = tmp.substr(index + this.term.length);
		}
		return $("<li></li>").data("item.autocomplete", item).append("<a>" + t + tmp + "</a>").appendTo(ul);

	};
}