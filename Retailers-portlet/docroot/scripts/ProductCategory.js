
function change() {
	$("#schedul1").find("input,button,textarea").attr("disabled", false);
	$("#schedul1 tr").removeClass("nonhighlight");
	$("#schedul1 tr").addClass("highlight");
}
function change1() {
	//$('input:checkbox').removeAttr('checked');
	$("#schedul1").find("input,button,textarea").attr("disabled", true);
	$("#schedul1 tr").removeClass("highlight");
	$("#schedul1 tr").addClass("nonhighlight");
}

function cancelScreen()
{
	$('#cancelPopup').modal('show');
}
$( document ).ready(function() {
	
	jQuery("#product_name").select2({
		placeholder: "Search Product",
		allowClear: true,
		minimumInputLength: 3				
	}); 
	$(".select2-container .select2-choice").css("width","200px");
	$(".select2-container .select2-choice").css("margin-top","10px");
	$("#product_name").select2("focus");
	$('.select2-choice').attr('tabindex', '-1');
	var schedule = $("#schedule").dataTable({
		"sDom": '<"top">rt<"bottom"flp><"clear">',
		"bInfo" : false,
		"fnDrawCallback": function(oSettings) {
			if ($('#example tr').length < 11) {
				$('.dataTables_paginate').hide();
			}
		}
	});
	
	$("#radio_1").prop("checked",true);//initial disabling
	$("#radio").prop("checked",false);//vinoth modified
	
	
	var productslist;
	var targetPartyId = $("#targetPartyId").val();
	/* Product List */ 
	var urlprodser = $("#idhiddenProductSearch").val();
	$.ajax({
		type: 'GET',
		url: urlprodser,
		async: false,
		data: {
			'service': 'ProductSearch',
			'targetPartyId':targetPartyId 
		},
		success: function(data) {
			productslist = data.productList;
			$("#product_name").append('<option value="0"></option>');
			for (var i = 0; i < productslist.length; i++) {
				$("#product_name").append('<option value=' + productslist[i].productId + '>' + productslist[i].productName + '</option>');
			}

		},
		error: function() {
			alert("ProductList Loading Error.....");
		}
	});

	function toTitleCase(str) {
		return str.replace(/(?:^|\s)\w/g, function(match) {
			return match.toUpperCase();
		});
	}
	/*Load Check Boxes*/
	var prodCate = $("#idhiddenProductCategories").val();
	$.ajax({
		type: 'GET',
		url: prodCate,
		async: false,
		data: {
			'service': 'ProductCategories',
			'categoryType':'PHARMA_CATEGORY' 
		},
		success: function(data) {
			$(".loadingImage").hide();
			var categoryList=data.productCategories;

			for(var i=0;i<categoryList.length;i++)
			{
				schedule.fnAddData(['<input type="checkbox" name="categoryLi" value="'+categoryList[i].productCategoryId+'" id="'+categoryList[i].productCategoryId+'" />'+categoryList[i].productCategoryId]);
			}
		},
		error: function() {
			alert("JsonLoading.....");
		}
	});
	
	change1();//inital disabling

});
var jsonfull;
function showValue()
{
	if($("#product_name option:selected").val() == null || $("#product_name option:selected").val() == "" || $("#product_name option:selected").val() == undefined)
		{
			//alert("Please Select Product....");
			$('#emptyProductmessage').modal('show');
		}
	else
		{
	if ($("#radio").prop("checked")) {
		// do something
		var checkboxes = document.getElementsByName('categoryLi');
		//if(checkboxes)
		var vals = "";
		var jsonArr = [];

		var prdId=$("#product_name option:selected").val();
		
		for (var i=0, n=checkboxes.length;i<n;i++) {
			if (checkboxes[i].checked) 
			{

				jsonArr.push(checkboxes[i].value);

			}
		}
		jsonfull = {productId:prdId,categoryIds:jsonArr};

		if(jsonArr =="" || jsonArr == null)
		{

			$('#failuremessage').modal('show');

		}
		else
		{

			//alert("coming sucess...");
			$('#successmessage').modal('show');

		}

	}
		
	else
	{
		var checkboxes = document.getElementsByName('categoryLi');
		var vals = "";
		var jsonArr = [];
		var prdId=$("#product_name option:selected").val();
		jsonfull = {productId:prdId,categoryIds:jsonArr};
		//alert("esle coming....");
		$('#successmessage').modal('show');
	}
		}

}

function reload()
{
	window.location.reload(true);
}

function saveConfirm()
{
	/*Send To Server*/
	$('#successmessage').modal('hide');
	$('#assignPop').modal('show');
	var urlprodCatePo = $("#idhiddenproductCategoryPost").val();
	$.ajax({
		type: 'GET',
		url: urlprodCatePo,
		async: false,
		data:{
			'service':'productCategoryPost',
			'savedJson':JSON.stringify(jsonfull)
		},
		success: function(data) {
			if(data.responseMessage=="success")
				{
					$('#assignPop').modal('hide');
					$('#storeSuccessmessage').modal('show');
				}
			else
				{
					$('#assignPop').modal('hide');
					$('#storeErrormessage').modal('show');
				}
		},
		error: function() {
			$('#assignPop').modal('hide');
			$('#storeErrormessage').modal('show');
		}
	});
}

function cancelConfirm ()
{
	window.location.reload(true);
}
function loadProductList()
{
	/*alert("Function Loading...");*/
	var prdId=$("#product_name option:selected").val();
	var urlprodCatemem = $("#idhiddenproductCategoryMembers").val();
	$.ajax({
		type: 'GET',
		url: urlprodCatemem,
		async: false,
		data:{
			'service':'productCategoryMembers',
			'productId':prdId
		},
		success: function(data) {
			$('input:checkbox').removeAttr('checked');
			var productList=data.productCategoryMembers;

			if(productList == null || productList == "")
			{
				$('input:radio[name=group1]')[1].checked = true;
				change1();
			}
			else
			{
				//alert("coming....");
				for(var i=0;i<productList.length;i++)
				{
					$("#"+productList[i].productCategoryId).prop("checked", true);
					/*$('input:checkbox[id="'+productList[i].productCategoryId+'"]').attr('checked','checked');*/
				}
				$('input:radio[name=group1]')[0].checked = true;
				change();
				//$('input:checkbox').removeAttr('checked');
			}

		},
		error: function() {
			alert("Json Not Loading.....");
		}
	});
}