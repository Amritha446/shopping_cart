
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
                        <div><a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#session.cartCount#>&##xf07a;</i></a></div>
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
                <cfinclude template = "navbar.cfm">

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

                    <!--- <button class="carousel-control-prev" type="button" data-bs-target="##homeCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="##homeCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button> --->
                </div>

                <div class="productListing d-flex flex-column">
                    <h6 class="mt-3 ms-3">RANDOM PRODUCTS</h6>
                    <cfif url.searchTerm NEQ "">
                        <cfset viewProductCount = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                        <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm,
                                                                                limit = viewProductCount.recordCount)>                                                       
                    <cfelse>
                        <cfset viewProduct = application.myCartObj.viewProduct(randomProducts = true,
                                                                                limit = 10)>                 
                    </cfif>
                    <cfif viewProduct.recordCount GT 0>
                        <div class="productContainer">
                            <cfloop query="viewProduct"> 
                                <div class="productBox d-flex flex-column">
                                    <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewProduct.fldProduct_Id))#&random=1" class="imageLink">
                                        <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                        <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                        <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                        <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                                    </a>
                                </div>
                            </cfloop>
                        </div>  
                    <cfelse>
                        <h6 class="mt-3 ms-3 text-danger">NO RESULT'S FOUND WITH #url.searchTerm#..</h6>
                    </cfif>
                </div>
            </cfoutput>
            <cfinclude template = "commonFooter.cfm">