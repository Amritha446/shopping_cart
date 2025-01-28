</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfset productId = url.productId>
            <cfparam name="url.random" default=0>
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    <cfset cartData = application.myCartObj.viewCartData()>
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
                    <div class="input-group mt-2 ms-5 ">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#(structKeyExists(url, 'searchTerm') ? url.searchTerm : '')#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>
                    <div>
                        <a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#cartData.recordCount#>&##xf07a;</i></a>
                    </div>
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
                
                <cfset viewProduct = application.myCartObj.viewProduct(productId = #url.ProductId#,
                                                                          random = url.random)>
                <cfif url.searchTerm NEQ "">
                    <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                </cfif>
                <cfset subCategories = application.myCartObj.viewSubCategoryData(categoryId = viewCategory.fldCategory_Id)>
                
                <div class="d-flex productSection">
                    <div class="product-container d-flex">
                        <div class="d-flex-column">
                            <div class="main-image-container">
                                <img src="assets/#viewProduct.imageFileName#" alt="Main Product Image" id="main-image">
                            </div>

                            <div class="thumbnails p-2 ms-4">
                                <cfloop query="#viewProduct#">
                                    <img class="thumbnail" src="assets/#viewProduct.imageFileName#" alt="Thumbnail Image" onclick="changeMainImage(this)">
                                </cfloop>
                            </div>
                            <div class="d-flex ms-4">
                                <button type="submit" class="buyProduct">BUY NOW</button>
                                <button type="submit" class="addToCart" value=#url.productId# onClick="addProductToCart(event)" >ADD TO CART</button>
                            </div>
                        </div>   
                    </div>
                    
                    
                    <div class="d-flex-column productDetails">
                    <cfset subCategoryFetching = application.myCartObj.subCategoryFetching(subCategoryId = #viewProduct.fldSubCategoryId#)>
                    <cfset categoryFetching = application.myCartObj.categoryFetching(categoryId = #subCategoryFetching.fldCategoryId#)>
                        <div class="productPath p-1 ">
                            <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                            ><a href="categoryBasedProduct.cfm?categoryId=#categoryFetching.fldCategory_Id#" class="navBarButton ms-2">#categoryFetching.fldCategoryName#</a>
                            ><a href="filterProduct.cfm?subCategoryId=#viewProduct.fldSubCategoryId#" class="navBarButton ms-2">#subCategoryFetching.fldSubCategoryName#</a>
                            ><a href="productDetails.cfm?productId=#productId#" class="navBarButton ms-2">#viewProduct.fldBrandName#</a>
                        </div>
                        <div class="productName">#viewProduct.fldProductName#</div>
                        <div class="productBrandName">#viewProduct.fldBrandName#</div>
                        <div class="productDescription">About Product:#viewProduct.fldDescription#</div>
                        <div class="productPrice">Product Price:#viewProduct.fldPrice#</div>
                        <div class="productDescription">Product Tax:#viewProduct.fldTax#%</div>
                    </div>
                </div>
                
                <div class="footerSection d-flex mt-5">
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