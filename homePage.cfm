    
    
    </head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
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

                    <cfif structKeyExists(session, "isAuthenticated") AND session.roleId EQ 1>
                        <a href = "cartDashboard.cfm" class = "imageLink text-light mt-2 p-1">Admin</a>
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
                
                <div class="navBar">
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfset allSubCategories = application.myCartObj.viewSubCategoryData(categoryId = 0)>
                    <cfif viewCategory.recordCount GT 0>
                        <cfloop query="#viewCategory#">
                            <div class="categoryDisplay ms-5 me-5 d-flex">
                                <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#">
                                    <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewCategory.fldCategory_Id))#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                                    <div class="subCategoryMenu">
                                        <cfloop query="#allSubCategories#">
                                            <cfif allSubCategories.fldCategoryId EQ viewCategory.fldCategory_Id>
                                                <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = allSubCategories.fldSubCategory_Id))#" class="subcategoryItem">
                                                    #allSubCategories.fldSubCategoryName#
                                                </a>
                                            </cfif>
                                        </cfloop>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    <cfelse>
                        <div class="errorMessage">
                            Error:#viewCategory.messsage#
                        </div>
                    </cfif>
                </div>

                <div id="homeCarousel" class="carousel slide">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="0" class="active" aria-current="true"></button>
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="2"></button>
                    </div>
                    <div class="carouselMainBox">
                        <div class="carousel-item active">
                            <img src="assets1/home.jpeg" class="d-block w-100" alt="Image 1">
                        </div>
                        <div class="carousel-item">
                            <img src="assets1/form2.jpg" class="d-block w-100" alt="Image 2">
                        </div>
                        <div class="carousel-item">
                            <img src="assets1/home1.jpg" class="d-block w-100" alt="Image 3">
                        </div>
                    </div>

                    <button class="carousel-control-prev" type="button" data-bs-target="##homeCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="##homeCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
                <div class="productListing d-flex-column">
                    <h6 class="mt-3 ms-3">RANDOM PRODUCTS</h6>
                    <cfif url.searchTerm NEQ "">
                        <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                    <cfelse>
                        <cfset viewProduct = application.myCartObj.viewProduct()>
                    </cfif>
                    <cfif viewProduct.recordCount GT 0>
                        <div class="productContainer">
                            <cfloop query="viewProduct"> 
                                <cfif currentRow LTE 5>
                                    <cfif (currentRow mod 5) EQ 1>
                                        <cfif currentRow GT 1>
                                            </div>
                                        </cfif>
                                        <div class="productRow d-flex"> 
                                    </cfif>
                                    
                                    <div class="productBox d-flex-column">
                                        <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewProduct.fldProduct_Id))#&random=1" class="imageLink">
                                            <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                            <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                            <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                            <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                        </a>
                                    </div>
                                </cfif>

                                <!-- hidden products -->
                                <cfif currentRow GT 5>
                                    <div class="productBox d-flex-column hiddenProduct">
                                        <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewProduct.fldProduct_Id))#&random=1" class="imageLink">
                                            <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                            <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                            <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                            <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                        </a>
                                    </div>
                                </cfif>
                                <cfset currentRow = currentRow + 1>
                            </cfloop>
                            <cfif currentRow GT 5>
                                <button type="button" class="viewMoreButton" onclick="toggleProducts()">View More</button>
                            </cfif>
                        </div> 
                    <cfelse>
                        <h6 class="mt-3 ms-3 text-danger">NO RESULT'S FOUND WITH #url.searchTerm#..</h6>
                    </cfif>
                </div>

                <div class="footerSection d-flex">
                    <div class="footerHeading ms-5 mt-4">
                        <a href="cartDashboard.cfm" class="footerHeading">BECOME A SELLER</a>
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
