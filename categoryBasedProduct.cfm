</head>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">MyCart</div>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex ms-5">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1 pe-none ms-5" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                <div class="navBar">
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfloop query="#viewCategory#">
                        <div class="categoryDisplay ms-5 me-5 d-flex">
                            <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#">
                                <a href="categoryBasedProduct.cfm?categoryId=#viewCategory.fldCategory_Id#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                                <div class="subCategoryMenu">
                                    <cfset subCategories = application.myCartObj.viewSubCategoryData(categoryId = viewCategory.fldCategory_Id)>
                                    <cfloop query="#subCategories#">
                                        <a href="filterProduct.cfm?subCategoryId=#subCategories.fldSubCategory_Id#" class="subcategory-item">
                                            #subCategories.fldSubCategoryName#
                                        </a>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </cfloop>
                </div>

                <div class="productListingBasedCategory">
                    <cfset categoryId = url.categoryId>
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfloop query="#viewCategory#">
                        <cfif viewCategory.fldCategory_Id EQ categoryId>
                            <cfset viewData = application.myCartObj.viewSubCategoryData(categoryId = #viewCategory.fldCategory_Id#)>
                            <cfloop query="#viewData#">
                                <a href="filterProduct.cfm?subCategoryId=#viewData.fldSubCategory_Id#" class="navBarButton ms-2"><h5>#viewData.fldSubCategoryName#</h5></a>
                                <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = #viewData.fldSubCategory_Id#)>
                                <div class="productContainer">
                                    <cfset currentRow = 1>
                                    <cfloop query="viewProduct">
                                        <cfif (currentRow mod 6) EQ 1>
                                            <cfif currentRow GT 1>
                                                </div> 
                                            </cfif>
                                            <div class="productRow d-flex">
                                        </cfif>
                                        <div class="productBox d-flex-column">
                                            <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                            <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                            <div class="ms-4 h6">#viewProduct.fldBrandName#</div>
                                            <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                        </div>
                                        <cfset currentRow = currentRow + 1>
                                    </cfloop>
                                </div>
                            </cfloop>
                        </cfif>
                    </cfloop>
                </div>
            </div>
        </cfoutput>
    </body>
</html>