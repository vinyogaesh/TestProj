<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<portlet:defineObjects />
<portlet:resourceURL var="ProductSearch" id="ProductSearch"/>
<portlet:resourceURL var="ProductCategories" id="ProductCategories"/>
<portlet:resourceURL var="productCategoryMembers" id="productCategoryMembers"/>
<portlet:resourceURL var="productCategoryPost" id="productCategoryPost"/>
<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="Content-Type">
<title>Product Category</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/scripts/ProductCategory.js?<%=System.currentTimeMillis()%>">
</script>
</head>
<body>
	<div class="container">
		<div class="content">
			<div class="span11" id="section">
				<div class="tab_salesorder">
					<ul id="myTab" class="nav nav-tabs">
						<li class="active"><a
							href="<portlet:renderURL><portlet:param name="myaction" value="viewProductCategory"/></portlet:renderURL>">
								Assign Schedule</a></li>
					</ul>
				</div>
				<table width=100%>
					<tr>
						<td class="main-td-body">

							<table width=100% style="border-bottom: 1px solid #ddd;">
								<tr class="td-body">

									<td>&nbsp;&nbsp;Select Product Name</td>
									<td class="td-border-1">&nbsp;&nbsp;Category</td>
									<td>&nbsp;&nbsp;Schedule</td>
								</tr>
								<tr class="tr-body-bak">
								
								<input name="targetPartyId" id="targetPartyId" type="hidden"
									value="${targetPartyId}" />
									<td class="tr-com-box">
									<div style=" height: 150px; width: 98%">
									<select id="product_name" tabindex="1" class="no-space selectProduct" name="product_name" data-placeholder="Select Product" autofocus="autofocus" width="30px" onchange="loadProductList()">
									</select>
									</div>
									</td>
									<td class="td-radio">
									<div style="margin-top:-65px;margin-left: 10px;">
									<div class="div-pop-wi1">
											<input type="radio" name="group1" id="radio" value="Scheduled" class="css-checkbox"	style="margin-top: 2px;" Onclick="change()" >
											<label for="radio" class="css-label">Scheduled</label> </div>
											<div class="div-pop-wi2" >
											<input id="radio_1" type="radio" id="radio_1" class="css-checkbox"
												name="group1" value="Non-Scheduled" style="margin-top: 2px;" Onclick="change1()" >
											<label for="radio_1" class="css-label">Non-Scheduled</label> 
											<input type="hidden" id="idhiddenProductSearch" name="namehiddenProductSearch" value="<%=ProductSearch%>">
												<input type="hidden" id="idhiddenProductCategories" name="namehiddenProductCategories" value="<%=ProductCategories%>">
												<input type="hidden" id="idhiddenproductCategoryMembers" name="namehiddenproductCategoryMembers" value="<%=productCategoryMembers%>">
												<input type="hidden" id="idhiddenproductCategoryPost" name="namehiddenproductCategoryPost" value="<%=productCategoryPost%>">
											</div>
										</div>
									</td>
									<td style="width: 65%">
									<div  id="schedul1">
										<table class="table-inside" id="schedule" width="200px">
										<thead><tr><th></th>
										</thead>
										<tbody>
										</tbody>
										</table>
										</div>
								</td>
								</tr>
							</table> <br>
							<table>
								<tr>
									<td style="width: 88%"></td>
									<td style="width: 7%"><a href="javascript:cancelScreen()" class="btn btn-warning">Cancel</a></td>
									<td><a href="javascript:showValue()" class="btn btn-success btn-lg">Assign</a></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>
	<div id="successmessage" class="modal hide fade" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  data-backdrop="static" data-keyboard="false" style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/success_icon.png"   height="30" width="30"/> Confirmation</h4>
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Do You Want to Save ?</font> <br><br>
			 
			<a href="#" class="btn btn-warning" data-dismiss="modal">No</a>
			<a href="javascript:saveConfirm()" class="btn btn-success" >Yes</a>
			</div>
		</div>
		
		<div id="failuremessage" class="modal hide fade" tabindex="-1" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/error_icon.png" height="30" width="30"/> Error
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Select any Category!</font> <br><br>
			<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
			</div>
		</div>
		
		<div id="emptyProductmessage" class="modal hide fade" tabindex="-1" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/error_icon.png" height="30" width="30"/> Product Not Selected
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Please select any Product!</font> <br><br>
			<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
			</div>
		</div>
		<div id="storeErrormessage" class="modal hide fade" tabindex="-1" data-backdrop="static" data-keyboard="false"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/error_icon.png" height="30" width="30"/> Error
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Category Not Assigning Please Try Later!</font> <br><br>
			<a href="#" class="btn btn-success" data-dismiss="modal">Close</a>
			</div>
		</div>
		
		<div id="storeSuccessmessage" class="modal hide fade" tabindex="-1" data-backdrop="static" data-keyboard="false"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/success_icon.png" height="30" width="30"/> Success
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Category Assigned Successfully.</font> <br><br>
			<a href="javascript:reload()" class="btn btn-success">Close</a>
			</div>
		</div>
		
		<div id="assignPop" class="modal hide fade" tabindex="-1" data-backdrop="static" data-keyboard="false"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"  style=" height: 150px;width: 350px;" >
			<div class="modal-header">
				<h4><img src="<%=request.getContextPath() %>/img/confirm_icon.png" height="30" width="30"/> Assigning Category
			</div>
			<div class="modal-body">
			<font style="color: #B74934;font-size: 14px;font-family:Arial; text-align:center;">  
				Category Assigning Please Wait a Moment...</font> <br><br>
			</div>
		</div>
	<div id="cancelPopup" class="modal hide fade" tabindex="-1" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="height: 167px;width: 400px;"  >
		<div class="modal-header">
			<h4><img src="<%=request.getContextPath() %>/img/confirm_icon.png"   height="30" width="30"/> Confirmation </h4>
		</div>
		<div class="modal-body">
			<h4>Do You Want To Cancel?</h4>
			<br><br>
			
			<a href="#" class="btn btn-warning" data-dismiss="modal">No</a>
			<a href="javascript:cancelConfirm()" class="btn btn-success">Yes</a> 
		</div>
	</div>
</body>
</html>