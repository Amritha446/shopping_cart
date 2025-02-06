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
                    <div class="profile d-flex me-5 mt-1 text-light p-2">
                        <div class="me-1 ">Profile</div>
                        <i class="fa-regular fa-user mt-1"></i>
                    </div>
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

                            <div class="productPath">
                                <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                                ><a href="categoryBasedProduct.cfm?categoryId=#categoryId#" class="navBarButton ms-2">#viewCategory.fldCategoryName#</a>
                            </div>

                            <cfloop query="#viewData#">
                                <a href="filterProduct.cfm?subCategoryId=#viewData.fldSubCategory_Id#" class="navBarButton ms-2"><h5>#viewData.fldSubCategoryName#</h5></a>
                                <cfset viewProduct = application.myCartObj.viewProduct(subCategoryId = #viewData.fldSubCategory_Id#)>
                                <cfif url.searchTerm NEQ "">
                                    <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                                </cfif>
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
                                            <a href="productDetails.cfm?productId=#viewProduct.fldProduct_Id#&random=1" class="imageLink">
                                            <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                            <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                            <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                            <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                        </a>
                                        </div>
                                        <cfset currentRow = currentRow + 1>
                                    </cfloop>
                                </div>
                            </cfloop>
                        </cfif>
                    </cfloop>
                </div>
                <div class="footerSection D-FLEX">
                    <div class="footerHeading ms-5 mt-4">
                        <a href="logIn.cfm" class="footerHeading">BECOME A SELLER</a>
                    </div>
                    <div class="footerHeading ms-5 mt-4">
                        ADVERTISE
                    </div>
                    <div class="footerHeading ms-5 mt-4">
                        GIFT CARD
                    </div>
                    <div class="footerHeading ms-5 mt-4">
                        HELP CENTER
                    </div>
                    <div class="footerHeading ms-5 mt-4">
                       <img src="assets1/6.PNG" class="ms-5" alt="img">
                    </div>
                </div>
                <div class="footer d-flex">
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> ABOUT</div>
                        <div class="footerContent mb-3">CONTACT US</div>
                        <div class="footerContent mb-3">ABOUT US</div>
                        <div class="footerContent mb-3"> CAREERS</div>
                        <div class="footerContent mb-3">FLIPKART STORIES</div>
                        <div class="footerContent mb-3">PRESS</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> GROUP COMPANIES</div>
                        <div class="footerContent mb-3">MYNTRAA</div>
                        <div class="footerContent mb-3">SHOPSY</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> CONSUMER POLICY</div>
                        <div class="footerContent mb-3">CONTACT US</div>
                        <div class="footerContent mb-3">ABOUT US</div>
                        <div class="footerContent mb-3"> CAREERS</div>
                        <div class="footerContent mb-3">FLIPKART STORIES</div>
                        <div class="footerContent mb-3">PRESS</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> HELP</div>
                        <div class="footerContent mb-3">PAYMENTS</div>
                        <div class="footerContent mb-3">SHIPPING</div>
                        <div class="footerContent mb-3">CANCELLATION</div>
                        <div class="footerContent mb-3">RETURNS</div>
                        <div class="footerContent mb-3">FAQ</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3">SOCIAL</div>
                        <div class="footerContent mb-3">CONTACT US</div>
                        <div class="footerContent mb-3">ABOUT US</div>
                        <div class="footerContent mb-3"> CAREERS</div>
                        <div class="footerContent mb-3">FLIPKART STORIES</div>
                        <div class="footerContent mb-3">PRESS</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> OTHER APPS</div>
                        <div class="footerContent mb-3">FLIPKART</div>
                        <div class="footerContent mb-3">AMAZON</div>
                        <div class="footerContent mb-3">MYNTRAA</div>
                        <div class="footerContent mb-3">SHOPSY</div>
                    </div>
                    <div class="d-flex-column footerBlock mt-3 ms-5 me-3">
                        <div class="footerHeading mb-3"> POLICY DETAILS</div>
                        <div class="footerContent mb-3">CONTACT US</div>
                        <div class="footerContent mb-3">ABOUT US</div>
                        <div class="footerContent mb-3"> CAREERS</div>
                        <div class="footerContent mb-3">FLIPKART STORIES</div>
                        <div class="footerContent mb-3">PRESS</div>
                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>