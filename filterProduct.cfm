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
                <cfset subCategoryId = url.subCategoryId>
                <cfparam name="url.sort" default=0>
                <cfparam name="url.minRange" default="0">
                <cfparam name="url.maxRange" default="0">
                <cfparam name="url.filterDataMin" default="0">
                <cfparam name="url.filterDataMax" default="0">

                <div class="navBar">
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfloop query="#viewCategory#">
                        <div class="categoryDisplay ms-5 me-5 d-flex">
                            <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#" id="categoryNameNavBar">
                                <a href="categoryBasedProduct.cfm?categoryId=#viewCategory.fldCategory_Id#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                            </div>
                            <div class="subCategoryMenu" id="subCategoryMenu-#viewCategory.fldCategory_Id#" 
                                data-category-id="#viewCategory.fldCategory_Id#">
                                <cfset subCategories = application.myCartObj.viewSubCategoryData(viewCategory.fldCategory_Id)>
                                <cfloop query="#subCategories#">
                                    <div class="subcategory-item" data-subcategory-id="#fldSubCategory_Id#">
                                        #fldSubCategoryName#
                                    </div>
                                </cfloop>
                            </div>
                        </div>
                    </cfloop>
                </div>

                <div class="productListingBasedCategory"> 
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfloop query="#viewCategory#">
                        <cfset viewData = application.myCartObj.viewSubCategoryData(categoryId = #viewCategory.fldCategory_Id#)>
                        <cfloop query="#viewData#">
                            <cfif viewData.fldSubCategory_Id EQ subCategoryId>
                                <h5 class="navBarButton ms-2">#viewData.fldSubCategoryName#</h5>
                                
                                <div class="filterProduct d-flex">
                                    <div class="filterLink ms-2">
                                        <a href="filterProduct.cfm?subCategoryId=#viewData.fldSubCategory_Id#&sort=1" class="navBarButton">Price High To Low</a>
                                        <a href="filterProduct.cfm?subCategoryId=#viewData.fldSubCategory_Id#&sort=2" class="ms-3 navBarButton">Price Low To High </a>
                                    </div>
                                    <div class="d-flex">
                                        <button type="submit" class="filterButton" data-bs-toggle="modal" data-bs-target="##filterProduct" >Filter <i class="fa-solid fa-filter"></i></button>
                                    </div>
                                </div>

                                <div class="modal fade" id="filterProduct" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="get" name="form" action="filterProduct.cfm?subCategoryId=#subCategoryId#">
                                                <div class="d-flex-column ms-2 mt-2 p-2">
                                                    <label for="selectedValue">Select min value:</label>
                                                    <select name="minRange" id="selectedValueMin" class="mb-1">
                                                        <option value="0" default>0</option>
                                                        <option value="1000">1000</option>
                                                        <option value="5000">5000</option>
                                                        <option value="10000">10000</option>
                                                        <option value="15000">15000</option>
                                                    </select>
                                                    <label for="selectedValue">Select max value:</label>
                                                    <select name="maxRange" id="selectedValueMax" class="mt-1 mb-2">
                                                        <option value="0" default>0</option>
                                                        <option value="1000">1000</option>
                                                        <option value="5000">5000</option>
                                                        <option value="10000">10000</option>
                                                        <option value="15000">15000</option>
                                                        <option value="20000">20000</option>
                                                    </select>
                                                    <input type="number" name="filterDataMin" placeholder="Min" class="ms-2">
                                                    <div class="ms-5 filterText"> To </div>
                                                    <input type="number" name="filterDataMax" placeholder="Max" class="ms-2">
                                                    
                                                    <input type="hidden" name="minRange" id="minRange">
                                                    <input type="hidden" name="maxRange" id="maxRange">
                                                    <input type="hidden" name="subCategoryId" id="subC" value="#subCategoryId#">
                                                    <button type="submit" class="mt-2 ">Submit</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <cfif structKeyExists(form, "maxRange")>
                                    <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = subCategoryId,
                                                                                    min = url.minRange,
                                                                                    max = url.maxRange,
                                                                                    minRange = url.filterDataMin,
                                                                                    maxRange = url.filterDataMin)>
                                <cfelse>
                                    <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = #viewData.fldSubCategory_Id#,
                                                                                    sort = url.sort)>
                                </cfif>

                                <div class="productContainer mt-2">
                                    <cfset currentRow = 1>
                                    <cfloop query="viewProduct">
                                        <cfif (currentRow mod 6) EQ 1>
                                            <cfif currentRow GT 1>
                                                </div>
                                            </cfif>
                                            <div class="productRow d-flex">
                                        </cfif>
                                        <div class="productBox d-flex-column">
                                            <a href="productDetails.cfm?productId=#viewProduct.fldProduct_Id#" class="imageLink"><img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                            <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                            <div class="ms-4 h6">#viewProduct.fldBrandName#</div>
                                            <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                        </div>
                                        <cfset currentRow = currentRow + 1>
                                    </cfloop>
                                </div>

                            </cfif>
                        </cfloop>
                    </cfloop>
                </div>
            </div>
        </cfoutput>
    </body>
</html>