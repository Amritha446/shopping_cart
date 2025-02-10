<!--- <html>
    <head>
        <title>signUp page</title>
        <cfinclude template="commonLink.cfm">
    </head> --->
    <body>
        <cfoutput>
            
            <div class="container-fluid">
                <div class="header d-flex">
                    <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                <cfset categoryId = URL.categoryId> 
                <cfset subCategoryId = URL.subCategoryId>
            
                <div class="mainSection mb-5 mt-5">
                    <div class="modal-content">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading" class = "ms-5 mt-4">PRODUCT LIST</h5>
                            <button type="submit" class="addSubCategoryBtn ms-4 mb-3 mt-4" onClick="createNewProduct()"
                                id="createNewProductBtn">Add</button> <!---  id="addProductBtn" ---> 
                        </div>
                        <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = url.subCategoryId)>
                        <cfloop query = "#viewProduct#">
                            <div class = "contentBox h-50 d-flex mb-3 bg-success"> 
                                <div class = "d-flex-column productData">
                                    <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                    <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                    <div class="ms-4 small">#viewProduct.fldPrice#</div>
                                </div>
                                
                                <div>
                                    <button type="submit" class="imgBtn ms-2 mt-2" data-bs-toggle="modal" data-bs-target="##imgDetails"
                                     value = "#viewProduct.fldProduct_Id#" onClick="loadProductImages()">
                                        <img src="assets/#viewProduct.imageFileName#" alt="img" class = "pe-none prdctImg">
                                    </butoon>
                                </div>
                                <div class = " p-1">
                                    <button type="submit" class="dltProductButton ms-5 mt-3" id="dltProductBtn" value = "#viewProduct.fldProduct_Id#" onClick="deleteProduct(event)">
                                        <i class="fa-regular fa-trash-can pe-none"></i>
                                    </button>
                                </div>
                                <div class = " p-1">
                                    <button type="submit" class="editProductButton ms-3 mt-3" data-bs-toggle="modal" data-bs-target="##editProductDetails" 
                                        id="editProductBtn" value = "#viewProduct.fldProduct_Id#" onClick = "editProductDetailsButton(event)">
                                        <i class="fa-solid fa-angle-right pe-none"></i>
                                    </button>
                                </div>
                            </div>
                        </cfloop>   
                    </div>
                </div>

                <div class="modal fade" id="imgDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class = "imgBox d-flex-column"> 
                                <div class="imageShow" id="imageShow">
                                    <div id="carouselExampleIndicators" class="carousel slide" >
                                        <div class="carousel-inner" id="carouselImages">

                                        </div>
                                        <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Previous</span>
                                        </button>
                                        <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Next</span>
                                        </button>
                                    </div> 
                                </div> 
                                
                            </div>
                            
                        </div>
                    </div>
                </div>
                
                <div class="modal fade" id="editProductDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content d-flex justify-content-center align-items-center">
                            <form method="post" name="form" enctype="multipart/form-data" id="createProductData">
                                <input type = "hidden" value="" name="productId" id="productId">
                                <div class="headEdit mt-1 ">
                                    <div class="headEditText" id="heading"></div>
                                </div>
                                <div class="textHead">
                                    PRODUCT DETAILS
                                </div><hr class="horizontalLine1 mt-1">                                                
                                
                                <div class="d-flex-column" id = "multiSelect">
                                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                                    <div class="textHead ">Category Name:</div>
                                    <select id="categoryIdProduct" name="categoryIdProduct" class="ms-3" >
                                        <cfloop query = #viewCategory#>
                                            <option value="#viewCategory.fldCategory_Id#">#viewCategory.fldCategoryName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger ms-3" id="categoryError"></div>
                                </div>

                                <div class="d-flex-column" id = "multiSelect">
                                    <cfset viewSubCategory = application.myCartObj.viewSubCategoryData(categoryId = categoryId)>
                                    <div class="textHead ">Sub-Category Name:</div>
                                    <select id="subCategoryIdProduct" name="subCategoryIdProduct" class="ms-3">
                                        <cfloop query = #viewSubCategory#>
                                            <option value="#viewSubCategory.fldSubCategory_Id#">#viewSubCategory.fldSubCategoryName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger ms-3" id="subCategoryError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT NAME</div>
                                    <input type="text" name="productName" class="editBtn2 ms-3" id="productName">
                                    <div class="error text-danger ms-3" id="productNameError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT BRAND</div>
                                    <select id="productBrand" name="productBrand" class="ms-3">
                                        <cfset brandName = application.myCartObj.viewBrands()>
                                        <cfloop query = #brandName#>
                                            <option value="#brandName.fldBrand_Id#">#brandName.fldBrandName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger ms-3" id="brandError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT DESCRIPTION</div>
                                    <input type="text" name="productDescrptn" class="editBtn2 ms-3" id="productDescrptn">
                                    <div class="error text-danger ms-3" id="descriptionError"></div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT PRICE</div>
                                    <input type="number" name="productPrice" class="editBtn2 ms-3" id="productPrice">
                                    <div class="error text-danger ms-3" id="priceError"></div>
                                </div>

                                <div class="d-flex ">
                                    <div class="d-flex-column">
                                        <div class="textHead">UPLOAD PRODUCT IMAGE</div>
                                        <input type="file" class="editBtn1 ms-3 " name="productImg" id="productImg" multiple>
                                        <div class="error text-danger ms-3" id="imgError"></div>
                                    </div>
                                </div>

                                <div class="d-flex-column">
                                    <div class="textHead">PRODUCT TAX</div>
                                    <input type="number" name="productTax" class="editBtn2 ms-3" id="productTax">
                                    <div class="error text-danger ms-3" id="taxError"></div>
                                </div>

                                <button type="submit" value="submit" class="btn mt-3 mb-5 ms-5" name="submit" onClick="return validation()" >SUBMIT</button>
                                <button type="button" class="btn2 btn-secondary ms-5" data-bs-dismiss="modal" id="closeBtnId">Close</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <cfif structKeyExists(form,"submit")>
                <cfset resultProduct=application.myCartObj.saveProduct(
                    categoryId = form.categoryIdProduct,
                    subCategoryId = form.subCategoryIdProduct,
                    productId = (len(trim(form.productId)) EQ 0 ? 0 : form.productId),
                    productName = form.productName,
                    productBrandId = form.productBrand,
                    productPrice = form.productPrice,
                    productDescrptn = form.productDescrptn,
                    productImg = form.productImg,
                    productTax = form.productTax
                )>

                <!--- <cfif len(trim(resultProduct)) EQ 0>
                    <cflocation  url="productPage.cfm?categoryId=#categoryId#&subCategoryId=#subCategoryId#">
                <cfelse>
                    #resultProduct#
                </cfif> --->
                <cfif structKeyExists(resultProduct, "success") AND resultProduct.success EQ true>
                    <cflocation url="productPage.cfm?categoryId=#categoryId#&subCategoryId=#subCategoryId#">
                <cfelse>
                    
                </cfif>
            </cfif>  

            <!--- <cfif structKeyExists(form,"submit") AND form.productId != "">
                <cfset resultProduct=application.myCartObj.saveProduct(categoryId = form.categoryIdProduct,
                subCategoryId = form.subCategoryIdProduct,
                productId = form.productId,
                productName = form.productName,
                productBrandId = form.productBrand,
                productPrice = form.productPrice,
                productDescrptn = form.productDescrptn,
                productImg = form.productImg,
                productTax = form.productTax)>
                <!--- <cfif len(trim(resultProduct)) EQ 0>
                    <cflocation  url="productPage.cfm?categoryId=#categoryId#&subCategoryId=#subCategoryId#">
                <cfelse>
                    #resultProduct#
                </cfif> --->
                <cfif structKeyExists(resultProduct, "success") AND resultProduct.success EQ true>
                    <cflocation url="productPage.cfm?categoryId=#categoryId#&subCategoryId=#subCategoryId#">
                <cfelse>
                    <div class="text-danger">Error occured</div>
                </cfif>
            </cfif> --->
        </cfoutput>    
    </body>
</html>