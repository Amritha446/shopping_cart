
    </head>
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
                <cfset variables.categoryId = URL.categoryId> 
                <cfset variables.subCategoryId = URL.subCategoryId>
                <div class="mainSection mb-5 mt-5">
                    <div class="modal-content">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading" class = "ms-5 mt-4">PRODUCT LIST</h5>
                            <button type="submit" class="addSubCategoryBtn ms-4 mb-3 mt-4" onClick="createNewProduct()"
                                id="createNewProductBtn">
                                Add
                            </button>
                        </div>
                        <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = url.subCategoryId)>
                        <cfloop query = "#viewProduct#">
                            <div class = "contentBox h-50 d-flex mb-3 bg-success"> 
                                <div class = "d-flex flex-column productData col-5">
                                    <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                    <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                    <div class="ms-4 small">#viewProduct.fldPrice#</div>
                                </div>
                                
                                <div>
                                    <button type="submit" class="imgBtn ms-2 mt-2" data-bs-toggle="modal" data-bs-target="##imgDetails"
                                     value = "#viewProduct.fldProduct_Id#" onClick="loadProductImages()">
                                        <img src="assets/product_Images/#viewProduct.imageFileName#" alt="img" class = "pe-none prdctImg">
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
                     
                            <button type="button" class="btn-close ms-auto p-3" data-bs-dismiss="modal" aria-label="Close"></button>
                    
                            <div class = "d-flex flex-column"> 
                                <div class="imageShow" id="imageShow">
                                    <div id="carouselExampleIndicators" class="carousel slide">
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

                <div class="modal fade" id="editImageDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content d-flex justify-content-center align-items-center ms-5">
                        <div id="selectedImagesList" class="mt-1 ms-5"></div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="editProductDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content d-flex justify-content-center align-items-center ms-5">
                            <form method="post" name="form" enctype="multipart/form-data" id="createProductData">
                                <input type = "hidden" value="" name="productId" id="productId">
                                <div class="headEdit mt-1 ms-5">
                                    <div class="headEditText" id="heading"></div>
                                </div>
                                <div class="textHead ms-5">
                                    PRODUCT DETAILS
                                </div><hr class="horizontalLine1 mt-1">                                                
                                
                                <div class="d-flex ms-4" id = "multiSelect">
                                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                                    <div class="textHead col-3">Category Name:</div>
                                    <select id="categoryIdProduct" name="categoryIdProduct" class="categoryInbox ms-3 mt-1" >
                                        <cfloop query = #viewCategory#>
                                            <option value="#viewCategory.fldCategory_Id#">#viewCategory.fldCategoryName#</option>
                                        </cfloop>
                                    </select>
                                    <div class="error text-danger ms-3" id="categoryError"></div>
                                </div>
                    
                                <div class="d-flex mt-3 ms-4" id="multiSelect">
                                    <cfset viewSubCategory = application.myCartObj.viewSubCategoryData(categoryId = URL.categoryId)>
                                    <div class="textHead col-3">Sub-Category Name:</div>
                                    
                                    <select id="subCategoryIdProduct" name="subCategoryIdProduct" class="categoryInbox ms-3 mt-1">
                                        <cfif viewSubCategory["message"] EQ "Success">
                                            <cfloop array="#viewSubCategory['data']#" index="subCategory">
                                                <option value="#subCategory['fldSubCategory_Id']#">#subCategory['fldSubCategoryName']#</option>
                                            </cfloop>
                                        <cfelse>
                                            <option value="">Error: #viewSubCategory['message']#</option>
                                        </cfif>
                                    </select>
                                    
                                    <div class="error text-danger ms-3" id="subCategoryError"></div>
                                </div>


                                <div class="d-flex flex-column mt-3 ms-4">
                                    <div class="d-flex">
                                        <div class="textHead col-3">Product Name:</div>
                                        <input type="text" name="productName" class="editBtn2 ms-3" id="productName" maxlength="100">
                                    </div>
                                    <div class="error text-danger ms-3" id="productNameError"></div>
                                </div>

                                <div class="d-flex mt-3 ms-4">
                                    <div class="textHead col-3">Product Brand:</div>
                                    <select id="productBrand" name="productBrand" class="categoryInbox ms-3">
                                        <cfset brandName = application.myCartObjAdmin.viewBrands()>
                                        <cfloop query = #brandName#>
                                            <option value="#brandName.fldBrand_Id#">#brandName.fldBrandName#</option>
                                        </cfloop> 
                                    </select>
                                    <div class="error text-danger ms-3" id="brandError"></div>
                                </div>

                                <div class="d-flex flex-column mt-3 ms-4">
                                    <div class="d-flex">
                                        <div class="textHead col-3">Product Description:</div>
                                        <input type="text" name="productDescrptn" class="editBtn2 ms-3" id="productDescrptn" maxlength="300">
                                    </div>
                                    <div class="error text-danger ms-3" id="descriptionError"></div>
                                </div>

                                <div class="d-flex flex-column mt-3 ms-4">
                                    <div class="d-flex">
                                        <div class="textHead col-3">Product Price:</div>
                                        <input type="number" name="productPrice" class="editBtn2 ms-3" id="productPrice">
                                    </div>
                                    <div class="error text-danger ms-3" id="priceError"></div>
                                </div>

                                <div class="d-flex flex-column mt-3 ms-4">
                                    <div class="d-flex">
                                        <div class="textHead col-3">Product Tax:</div>
                                        <input type="number" name="productTax" class="editBtn2 ms-3" id="productTax" maxlength="100">
                                    </div>
                                    <div class="error text-danger ms-3" id="taxError"></div>
                                </div>

                                <div class="d-flex mt-3 ms-4">
                                    <div class="d-flex flex-column">
                                        <div class="textHead col-7">Upload Product Image</div>
                                        <input type="file" class="editBtn1 ms-4 mt-1" name="productImg" id="productImg" multiple>
                                        <div class="error text-danger ms-3" id="imgError"></div>
                                    </div>
                                </div>

                                <button type="button" class="editImageFile mt-3 mb-5 ms-5" id="viewSelectedImgBtn" name="submit" onClick="viewSelectedImages(event)" data-bs-toggle="modal" data-bs-target="##editImageDetails">VIEW SELECTED IMAGES</button>

                                <div class="ms-5"><button type="submit" value="submit" class="btn mt-3 mb-5 ms-5" name="submit" onClick="return validation()" >SUBMIT</button></div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <cfif structKeyExists(form,"submit") AND form.productId == "">
                <cfset resultProduct=application.myCartObjAdmin.createProduct(
                    categoryId = form.categoryIdProduct,
                    subCategoryId = form.subCategoryIdProduct,
                    productName = form.productName,
                    productBrand = form.productBrand,
                    productPrice = form.productPrice,
                    productDescrptn = form.productDescrptn,
                    productImg = form.productImg,
                    productTax = form.productTax
                )>
                <cfif len(trim(resultProduct)) EQ 0>
                    <cflocation  url="productPage.cfm?categoryId=#variables.categoryId#&subCategoryId=#variables.subCategoryId#">
                <cfelse>
                    #resultProduct#
                </cfif>
            </cfif>  

            <cfif structKeyExists(form,"submit") AND form.productId != "">
                <cfset resultProduct=application.myCartObjAdmin.editProduct(categoryId = form.categoryIdProduct,
                subCategoryId = form.subCategoryIdProduct,
                productId = form.productId,
                productName = form.productName,
                productBrand = form.productBrand,
                productPrice = form.productPrice,
                productDescrptn = form.productDescrptn,
                productImg = form.productImg,
                productTax = form.productTax)>
                <cfif len(trim(resultProduct)) EQ 0>
                    <cflocation  url="productPage.cfm?categoryId=#variables.categoryId#&subCategoryId=#variables.subCategoryId#">
                <cfelse>
                    #resultProduct#
                </cfif>
            </cfif> 
        </cfoutput>    
    </body>
</html>
