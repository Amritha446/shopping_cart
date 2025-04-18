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
                        <div><a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#session.cartCount#>&##xf07a;</i></a></div>
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
                <cfinclude template = "navbar.cfm">

                <div class="productListingBasedCategory">
                    <cfset variables.categoryId = application.myCartObj.decryptUrl(encryptedData = URL.categoryId)>
                    <cfset variables.viewCategory = application.myCartObj.viewCategoryData()>

                    <cfloop query="#variables.viewCategory#">
                        <cfif variables.viewCategory.fldCategory_Id EQ variables.categoryId>
                            <cfset variables.viewSubCategory = application.myCartObj.viewSubCategoryData(categoryId = variables.viewCategory.fldCategory_Id)>

                            <cfif variables.viewSubCategory["message"] EQ "Success">
                                <div class="productPath">
                                    <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                                    > <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = categoryId))#" class="navBarButton ms-2">#variables.viewCategory.fldCategoryName#</a>
                                </div>

                                <cfloop array="#variables.viewSubCategory['data']#" index="subCategory">
                                    <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategory['fldSubCategory_Id']))#" class="navBarButton ms-2">
                                        <h5 class = "ms-2">#subCategory['fldSubCategoryName']#</h5>
                                    </a>
    
                                    <cfset variables.viewProduct = application.myCartObj.viewProduct(subCategoryId = subCategory['fldSubCategory_Id'],
                                                                                            limit = 5,
                                                                                            searchTerm=url.searchTerm)>
                                    <div class="productContainer ms-3">
                                        <cfloop query="variables.viewProduct">
                                            <div class="productBox d-flex flex-column">
                                                <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.viewProduct.fldProduct_Id))#&productImages=1" class="imageLink">
                                                    <img src="assets/product_Images/#variables.viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                                    <div class="ms-4 font-weight-bold h5">#variables.viewProduct.fldProductName#</div>
                                                    <div class="ms-4 h6 ">#variables.viewProduct.fldBrandName#</div>
                                                    <div class="ms-4 small">$#variables.viewProduct.fldPrice#</div>
                                                </a>
                                            </div>
                                        </cfloop>
                                    </div>
                                </cfloop>
                            <cfelse>
                                <div class="errorMessage">
                                    Error: #variables.viewSubCategory['message']#
                                </div>
                            </cfif>
                        </cfif>
                    </cfloop>
                </div>
            </cfoutput>
        <cfinclude template = "commonFooter.cfm">


