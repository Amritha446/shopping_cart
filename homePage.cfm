    
    
    </head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
                    <div class="input-group mt-2 ms-5 ">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#url.searchTerm#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>
                    <div><i class="fa-solid fa-cart-shopping me-2 mt-2 p-2" style="color: ##fff"></i></div>
                    <div class="profile d-flex me-5 mt-1 text-light p-2">
                        <div class="me-1 ">Profile</div>
                        <i class="fa-regular fa-user mt-1"></i>
                    </div>
                    <button type="button" class="logOutBtn p-1 col-1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
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

                <!--- <div class="homeImg">
                    <img src="assets1/home.jpeg" alt="img" class="homeImg">
                </div> --->

                <div id="homeCarousel" class="carousel slide">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="0" class="active" aria-current="true"></button>
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="##homeCarousel" data-bs-slide-to="2"></button>
                    </div>
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="assets1/home.jpeg" class="d-block w-100" alt="Image 1">
                        </div>
                        <div class="carousel-item">
                            <img src="assets1/home1.jpg" class="d-block w-100" alt="Image 2">
                        </div>
                        <div class="carousel-item">
                            <img src="assets1/form2.jpg" class="d-block w-100" alt="Image 3">
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
                    <cfset viewProduct = application.myCartObj.viewProduct()>
                    <cfif url.searchTerm NEQ "">
                        <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                    </cfif>
                    <cfif viewProduct.recordCount GT 0>
                        <div class="productContainer">
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
                            <cfif currentRow GT 1 >
                                </div>
                            </cfif>  
                        </div> 
                    <cfelse>
                        <h6 class="mt-3 ms-3 text-danger">NO RESULT'S FOUND WITH #URL.SEARCHtERM#..</h6>
                    </cfif>
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
