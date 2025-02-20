

</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
                    <div class="input-group mt-2 ms-5 ">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#(structKeyExists(url, 'searchTerm') ? url.searchTerm : '')#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>
                    <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                        <cfset cartData = application.myCartObj.viewCartData()>
                        <div><a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#cartData.recordCount#>&##xf07a;</i></a></div>
                    <cfelse>
                         <div><i class="fa-solid fa-cart-shopping me-2 mt-2 p-2" style="color: ##fff"></i></div>
                    </cfif>
                    <a href="userProfile.cfm" class="profileButton">
                        <div class="profile d-flex me-5 mt-1 text-light p-2">
                            <div class="me-1 ">Profile</div>
                            <i class="fa-regular fa-user mt-1"></i>
                        </div>
                    </a>
                    <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                        <button type="button" class="logOutBtn p-1 col-1">
                            <div class="signUp d-flex">
                                <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
                            </div>
                        </button>
                    <cfelse>
                        <div class="logInBtn d-flex">
                            <a href="logIn.cfm" class="signUp d-flex">
                                <i class="fa-solid fa-right-to-bracket mb-1 mt-1 " style="color:##fff"></i><div class="text-white ">LogIn</div>
                            </a>
                        </div>
                    </cfif>
                </div>
                <cfset subCategoryId = application.myCartObj.decryptUrl(encryptedData =url.subCategoryId)>
                <cfparam name="url.sort" default=0>
                <cfparam name="url.min" default=0>
                <cfparam name="url.max" default=0>
                <cfparam name="url.minRange" default=0>
                <cfparam name="url.maxRange" default=0>

                <div class="navBar">
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfset allSubCategories = application.myCartObj.viewSubCategoryData(categoryId = 0)>
                    <cfif viewCategory.recordCount GT 0>
                        <cfloop query="#viewCategory#">
                            <div class="categoryDisplay ms-5 me-5 d-flex">
                                <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#">
                                    <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewCategory.fldCategory_Id))#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                                    <div class="subCategoryMenu">
                                        <cfif allSubCategories["message"] EQ "Success">
                                            <cfloop array="#allSubCategories['data']#" index="subCategory">
                                                <cfif subCategory['fldCategoryId'] EQ viewCategory.fldCategory_Id>
                                                    <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#" class="subcategoryItem">
                                                        #subCategory['fldSubCategoryName']#
                                                    </a>
                                                </cfif>
                                            </cfloop>
                                        <cfelse>
                                            <div class="errorMessage">
                                                Error: #allSubCategories["message"]#
                                            </div>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    <cfelse>
                        <div class="errorMessage">
                            Error: #viewCategory.message#
                        </div>
                    </cfif>
                </div>

                <div class="productListingBasedCategory"> 
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfif viewCategory.recordCount GT 0>
                        <cfset subCategoryData = structNew()>
                        <cfloop query="#viewCategory#">
                            <cfset subCategoryData[viewCategory.fldCategory_Id] = application.myCartObj.viewSubCategoryData(categoryId = viewCategory.fldCategory_Id)>
                        </cfloop>

                        <cfloop query="#viewCategory#">
                            <cfset currentCategoryId = viewCategory.fldCategory_Id>
                            <cfset viewSubCategory = subCategoryData[currentCategoryId]>

                            <cfif viewSubCategory["message"] EQ "Success">
                                <cfloop array="#viewSubCategory['data']#" index="subCategory">
                                    <cfif subCategory['fldSubCategory_Id'] EQ subCategoryId>
                                        <div class="productPath ms-3 p-2">
                                            <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                                            > <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewCategory.fldCategory_Id))#" class="navBarButton ms-2">#viewCategory.fldCategoryName#</a>
                                            > <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#" class="navBarButton ms-2">#subCategory['fldSubCategoryName']#</a>
                                        </div>

                                        <h5 class="navBarButton ms-5 mt-2">#subCategory['fldSubCategoryName']#</h5>
                                        <div class="filterProduct d-flex ms-5">
                                            <div class="filterLink ms-2">
                                                <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#&sort=1" class="navBarButton">Price High To Low</a>
                                                <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#&sort=2" class="ms-3 navBarButton">Price Low To High</a>
                                            </div>
                                            <div class="d-flex">
                                                <button type="submit" class="filterButton" data-bs-toggle="modal" data-bs-target="##filterProduct">Filter <i class="fa-solid fa-filter"></i></button>
                                            </div>
                                        </div>
                                        <div class="fade modal" id="filterProduct" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form method="post" name="form" action="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#">
                                                        <div class="d-flex-column ms-2 mt-2 p-2">
                                                            <label for="selectedValue" class="ms-1 mt-2 mb-2">Price Range:</label>
                                                            <div class="d-flex">
                                                                <input type="number" name="minRange" placeholder="Min" class="ms-2" value="0">
                                                                <div class="ms-4 me-2 filterText"> To </div>
                                                                <input type="number" name="maxRange" placeholder="Max" class="ms-2" value="0">
                                                            </div>
                                                            <div class="mt-3">
                                                                <label for="selectedValue">Min value:</label>
                                                                <select name="min" id="selectedValueMin" class="mb-1 ">
                                                                    <option value="0" default>0</option>
                                                                    <option value="5000">5000</option>
                                                                    <option value="15000">15000</option>
                                                                    <option value="35000">35000</option>
                                                                    <option value="50000">50000</option>
                                                                </select>
                                                                <label for="selectedValue" class="ms-3">Max value:</label>
                                                                <select name="max" id="selectedValueMax" class="mt-1 mb-2">
                                                                    <option value="0" default>0</option>
                                                                    <option value="10000">10000</option>
                                                                    <option value="20000">20000</option>
                                                                    <option value="40000">40000</option>
                                                                    <option value="80000">80000</option>
                                                                    <option value="150000">150000</option>
                                                                </select>
                                                                <button type="submit" class=" selectBtn" name="filterSubmit">Submit</button>
                                                            </div>
                                                            
                                                            <input type="hidden" name="subCategoryId" id="subC" value="#subCategory['fldSubCategory_Id']#">
                                                            
                                                        </div>
                                                    </form>
                                                </div>  
                                            </div>
                                        </div>
                                        
                                        <cfset limit = 5>
                                        <cfset offset = 0>

                                        <cfif structKeyExists(form, "viewMoreClicked")>
                                            <cfset offset = form.offset + limit>
                                        <cfelse>
                                            <cfset offset = 0>
                                        </cfif>
                                        <cfif structKeyExists(form, "filterSubmit")> 
                                            <cfset viewProductCount = application.myCartObj.viewProduct(subCategoryId = subCategoryId,
                                                                                                        limit = 100)>
                                            <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = subCategoryId, 
                                                                                                    min = form.min, 
                                                                                                    max = form.max, 
                                                                                                    minRange = form.minRange, 
                                                                                                    maxRange = form.maxRange,
                                                                                                    limit = limit,
                                                                                                    offset = offset)>                                                           
                                        <cfelse>
                                            <cfset viewProductCount = application.myCartObj.viewProduct(subCategoryId = subCategoryId,
                                                                                                 limit = 100)>
                                            <cfset viewProduct = application.myCartObj.viewProduct( subCategoryId = subCategory['fldSubCategory_Id'],
                                                                                                limit = limit,
                                                                                                offset = offset,
                                                                                                sort = url.sort
                                                                                                )>
                                        </cfif>
                                        <cfif url.searchTerm NEQ "">
                                            <cfset viewProduct = application.myCartObj.viewProduct(searchTerm = url.searchTerm)>
                                        </cfif>
                                        
                                        <div id="productContainer" class="productContainer mt-2 ms-5">
                                            <cfloop query="viewProduct">
                                                <div class="productBox d-flex-column" id="product_#viewProduct.currentRow#">
                                                    <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewProduct.fldProduct_Id))#&random=1" class="imageLink">
                                                        <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                                        <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                                        <div class="ms-4 h6">#viewProduct.fldBrandName#</div>
                                                        <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                                    </a>
                                                </div>
                                            </cfloop>         
                                        </div>
                                        <button type="button" id="viewMoreBtn" class="selectBtn" onClick = "loadMoreProducts('#subcategoryId#')">View</button>

                                    </cfif>
                                </cfloop>
                            <cfelse>
                                <div class="errorMessage">
                                    Error: #viewSubCategory['message']#
                                </div>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        <div class="errorMessage">
                            No categories available.
                        </div>
                    </cfif>
                </div>
            </div>
        </cfoutput>