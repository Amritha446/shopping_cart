<html>
    <head>
        <title>signUp page</title>
        <script src = "js/jquery.min.js"></script>
        <script src="js/cartDashboard.js"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" >
        <script src="js/bootstrap.bundle.min.js"></script>
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"/>
    </head>
    <body>
        <cfoutput>
            <cfset categoryId = URL.categoryId> 
            <cfset subCategoryId = URL.subCategoryId>
            
            <div class="container-fluid">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">PRODUCT PAGE</div>
                    <div class="logIn d-flex">
                        <a href="login.cfm" class="link d-flex">
                            <i class="fa-solid fa-right-to-bracket mb-1 mt-1 ms-3" style="color:##fff"></i>
                            <div class="text-white ms-2">LogIn</div>
                        </a>
                    </div>
                </div>
                <div class="mainSection mb-5 mt-5">
                    <div class="modal-content">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading" class = "ms-5 mt-4">PRODUCT LIST</h5>
                            <button type="submit" class="addSubCategoryBtn ms-4 mb-3 mt-4" onClick="createNewProduct()"
                                id="createNewProductBtn">Add</button> <!---  id="addProductBtn" ---> 
                        </div>
                        <cfset objCreate = createObject("component","components.myCart")>
                        <cfset viewProduct = objCreate.viewProduct(subCategoryId = subCategoryId)>
                        <cfloop query = "#viewProduct#">
                            <div class = "contentBox h-50 d-flex mb-3 bg-success">
                                
                                <div class = "d-flex-column productData">
                                    <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                    <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                    <div class="ms-4 small">#viewProduct.fldPrice#</div>
                                </div>
                                
                                <div class="prdctImg">
                                    <img src="assets/#viewProduct.imageFileName#" alt="img" class = "ms-5 mt-e prdctImg">
                                </div>
                                <div class = " p-1">
                                    <button type="submit" class="dltProductButton ms-5 mt-3" id="dltProductBtn" value = "#viewProduct.fldProduct_Id#" onClick="deleteProduct(event)"  >
                                        <i class="fa-regular fa-trash-can pe-none"></i>
                                    </button>
                                    </div>
                                    <div class = " p-1">
                                    <button type="submit" class="editProductButton ms-3 mt-3" data-bs-toggle="modal" data-bs-target="##editProductDetails" 
                                        id="editProductBtn" value = "#viewProduct.fldProduct_Id#" onClick = "editProductDetailsButton(event)">
                                        <i class="fa-solid fa-angle-right"></i>
                                    </button>

                                </div>
                            </div>
                        </cfloop>
                    </div>
                </div>
                <div class="modal fade" id="editProductDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form method="post" name="form" enctype="multipart/form-data" id="createProductData">
                                <input type = "hidden" value="" name="productId" id="productId">
                                <div class="headEdit mt-1 ">
                                    <div class="headEditText" id="heading"></div>
                                </div>
                                <div class="textHead">
                                    PRODUCT DETAILS
                                </div><hr class="horizontalLine1 mt-1">                                                
                                
                                <div class="d-flex-column" id = "multiSelect">
                                    <cfset objCreate = createObject("component","components.myCart")>
                                    <cfset viewCategory = objCreate.viewCategoryData()>
                                    <div class="textHead ">Category Name:</div>
                                    <select id="categoryIdProduct" name="categoryIdProduct" class="ms-3" >
                                        <cfloop query = #viewCategory#>
                                            <option value="#viewCategory.fldCategory_Id#">#viewCategory.fldCategoryName#</option>
                                        </cfloop>
                                    </select>
                                </div>

                                <div class="d-flex-column" id = "multiSelect">
                                    <cfset objCreate = createObject("component","components.myCart")>
                                    <cfset viewSubCategory = objCreate.viewSubCategoryData(categoryId=url.categoryId)>
                                    <div class="textHead ">Sub-Category Name:</div>
                                    <select id="subCategoryIdProduct" name="subCategoryIdProduct" class="ms-3">
                                        <cfloop query = #viewSubCategory#>
                                            <option value="#viewSubCategory.fldSubCategory_Id#">#viewSubCategory.fldSubCategoryName#</option>
                                        </cfloop>
                                    </select>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT NAME</div>
                                    <input type="text" name="productName" class="editBtn2 ms-3" id="productName">
                                    <div class="error text-danger" id="nameError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT BRAND</div>
                                    <select id="productBrand" name="productBrand" class="ms-3">
                                        <cfset obj = createObject("component","components.myCart")>
                                        <cfset brandName = obj.viewBrands()>
                                        <cfloop query = #brandName#>
                                            <option value="#brandName.fldBrand_Id#">#brandName.fldBrandName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger" id="brandError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT DESCRIPTION</div>
                                    <input type="text" name="productDescrptn" class="editBtn2 ms-3" id="productDescrptn">
                                    <div class="error text-danger" id="descriptionError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT PRICE</div>
                                    <input type="number" name="productPrice" class="editBtn2 ms-3" id="productPrice">
                                    <div class="error text-danger" id="priceError"></div>
                                </div>

                                <div class="d-flex ">
                                    <div class="d-flex-column">
                                        <div class="textHead">UPLOAD PRODUCT IMAGE</div>
                                        <input type="file" class="editBtn1 ms-3 " name="productImg" id="productImg" multiple>
                                        <div class="error text-danger" id="imgError"></div>
                                    </div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT TAX</div>
                                    <input type="number" name="productTax" class="editBtn2 ms-3" id="productTax">
                                    <div class="error text-danger" id="taxError"></div>
                                </div>

                                <button type="submit" value="submit" class="btn mt-3 mb-5 ms-5" name="submit" <!--- onClick="return validation()" --->>SUBMIT</button>
                                <button type="button" class="btn2 btn-secondary ms-5" data-bs-dismiss="modal">Close</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <cfif structKeyExists(form,"submit") AND form.productId == "">
                <cfset obj=createObject("component","components.myCart")>
                <cfset resultProduct=obj.createProduct(categoryId = form.categoryIdProduct,
                subCategoryId = form.subCategoryIdProduct,
                productName = form.productName,
                productBrandId = form.productBrand,
                productPrice = form.productPrice,
                productDescrptn = form.productDescrptn,
                productImg = form.productImg,
                productTax = form.productTax)>
                <cflocation url="subCategory.cfm">
            </cfif>  

            <cfif structKeyExists(form,"submit") AND form.productId != "">
                <cfset obj=createObject("component","components.myCart")>
                <cfset resultProduct=obj.EditProduct(categoryId = form.categoryIdProduct,
                subCategoryId = form.subCategoryIdProduct,
                productId = form.productId,
                productName = form.productName,
                productBrandId = form.productBrand,
                productPrice = form.productPrice,
                productDescrptn = form.productDescrptn,
                productImg = form.productImg,
                productTax = form.productTax)>
                <cflocation  url="subCategory.cfm">
            </cfif>
        </cfoutput>    
    </body>
</html>