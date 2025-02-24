</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfparam name="url.random" default=0>
            <cfif isValid("integer", url.productId)>
                <cfset productId = url.productId>
            <cfelse>
                <cfset productId = application.myCartObj.decryptUrl(encryptedData = url.productId)>
            </cfif>
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
                                                <cfif subCategory["fldCategoryId"] EQ viewCategory.fldCategory_Id>
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
                
                <cfset viewProduct = application.myCartObj.viewProduct(productId = productId,
                                                                          random = url.random)>
                <cfif len(trim(url.searchTerm)) NEQ 0>
                    <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                </cfif>
                <cfset subCategories = application.myCartObj.viewSubCategoryData(categoryId = viewCategory.fldCategory_Id)>
                
                <div class="d-flex productSection">
                    <div class="product-container d-flex">
                        <div class="d-flex-column">
                            <div class="mainImage-container">
                                <img src="assets/#viewProduct.imageFileName#" alt="Main Product Image" id="mainImage">
                            </div>

                            <div class="thumbnails p-2 ms-4">
                                <cfloop query="#viewProduct#">
                                    <img class="thumbnail" src="assets/#viewProduct.imageFileName#" alt="Thumbnail Image" onclick="changeMainImage(this)">
                                </cfloop>
                            </div>
                            <div class="d-flex ms-4">
                                <form method="POST" name="formBuyNow">
                                    <cfif structKeyExists(session, "isAuthenticated")>
                                        <button type="button" class="buyProduct"  data-bs-toggle="modal" data-bs-target="##buyNow" id="buyNowBtn" name="buyNowBtn">BUY NOW</button>
                                    <cfelse>
                                        <button type="submit" class="buyProduct"  data-bs-toggle="modal" data-bs-target="##buyNow" id="buyNowBtn" name="buyNowBtn">BUY NOW</button>
                                        <input type="hidden" value = "#productId#" name="addToCartHidden">
                                        <input type="hidden" name="cartToken" id="cartToken" value = 1>
                                    </cfif>
                                </form>

                                <form method="POST" name="form">
                                    <button type="submit" class="addToCart" >ADD TO CART</button>
                                    <input type="hidden" value = "#productId#" name="addToCartHidden">
                                    <input type="hidden" name="cartToken" id="cartToken" value = 1>
                                </form>
                            </div>
                        </div>   
                    </div>

                    <cfif structKeyExists(form, "buyNowBtn") AND structKeyExists(session, "isAuthenticated") EQ FALSE>
                        <cfset viewcart = application.myCartObj.addToCart(productId = form.addToCartHidden,
                                                                         cartToken = form.cartToken)>
                        <cfif viewcart == true >
                            <cflocation  url="cartPage.cfm">
                        <cfelse>
                            <cflocation url="logIn.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = productId))#&cartToken=1" addToken = "false">
                        </cfif>
                    </cfif>

                    <cfif structKeyExists(form, "addToCartHidden")>
                        <cfset viewcart = application.myCartObj.addToCart(productId = form.addToCartHidden,
                                                                         cartToken = form.cartToken)>
                        <cfif viewcart == true >
                            <cflocation  url="cartPage.cfm">
                        <cfelse>
                            <cflocation url="logIn.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = productId))#&cartToken=1" addToken = "false">
                        </cfif>
                    </cfif>
                    
                    <div class="d-flex-column productDetails">
                        <cfset subCategoryFetching = application.myCartObj.subCategoryFetching(subCategoryId = #viewProduct.fldSubCategoryId#)>
                        <cfset categoryFetching = application.myCartObj.categoryFetching(categoryId = #subCategoryFetching.fldCategoryId#)>
                        <div class="productPath p-1 ">
                            <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                            ><a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = categoryFetching.fldCategory_Id))#" class="navBarButton ms-2">#categoryFetching.fldCategoryName#</a>
                            ><a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewProduct.fldSubCategoryId))#" class="navBarButton ms-2">#subCategoryFetching.fldSubCategoryName#</a>
                            ><a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = productId))#" class="navBarButton ms-2">#viewProduct.fldBrandName#</a>
                        </div>
                        <div class="productName">#viewProduct.fldProductName#</div>
                        <div class="productBrandName">#viewProduct.fldBrandName#</div>
                        <div class="productDescription">About Product:#viewProduct.fldDescription#</div>
                        <div class="productPrice">Product Price:#viewProduct.fldPrice#</div>
                        <div class="productDescription">Product Tax:#viewProduct.fldTax#%</div>
                    </div>
                </div>
                <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                    <div class="modal fade" id="buyNow" tabindex="-1">
                        <div class="modal-dialog custom-modal-width">
                            <div class="modal-content d-flex justify-content-center align-items-center">
                                <div class="buyModal">
                                    <div class="text-success ms-5 mt-1 fw-bold">SELECT ADDRESS</div>
                                    <cfset viewUserAddress = application.myCartObj.fetchUserAddress()>
                                    <form action="orderPage.cfm" method="get">
                                        <cfloop query="#viewUserAddress#">
                                            <div class="addressAddSection d-flex ms-4 mt-2">
                                                <div class="d-flex-column">
                                                    <input type="radio" name="addressId" value="#viewUserAddress.fldAddress_Id#" class="address-radio" required>
                                                    <div class="d-flex ms-4">#viewUserAddress.fldFirstName# #viewUserAddress.fldLastName#</div>
                                                    <div class="d-flex ms-4">#viewUserAddress.fldAdressLine1# , #viewUserAddress.fldAdressLine2# , #viewUserAddress.fldCity# , #viewUserAddress.fldState#</div>
                                                    <div class="d-flex ms-4">#viewUserAddress.fldPincode# #viewUserAddress.fldPhoneNumber#</div>
                                                </div>
                                            </div>
                                        </cfloop>
                                        <input type="hidden" name="productId" value="#productId#">
                                        <div class="d-flex">
                                            <button type="submit" id="userPaymentBtn" class="userAddressBtn1">PAYMENT</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfif>

                <div class="modal fade" id="editUserAddress" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content d-flex justify-content-center align-items-center">
                            <div class="d-flex ">
                                <div class="d-flex-column ">
                                    <div class="textHead">FIRST NAME:</div>
                                    <input type="text" name="addressFirstName" class="ms-1" id="addressFirstName">
                                </div>
                                <div class="d-flex-column">
                                    <div class="textHead">LAST NAME:</div>
                                    <input type="text" name="addressLastName" class="ms-1" id="addressLastName" >
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex-column ">
                                    <div class="textHead">ADDRESS LINE 1:</div>
                                    <input type="text" name="addressLine1" class="ms-1" id="addressLine1">
                                </div>
                                <div class="d-flex-column">
                                    <div class="textHead">ADDRESS LINE 2:</div>
                                    <input type="text" name="addressLine2" class="ms-1" id="addressLine2">
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex-column ">
                                    <div class="textHead">CITY:</div>
                                    <input type="text" name="userCity" class="ms-1" id="userCity">
                                </div>
                                <div class="d-flex-column">
                                    <div class="textHead">STATE:</div>
                                    <input type="text" name="userState" class="ms-1" id="userState" >
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex-column ">
                                    <div class="textHead">PINCODE:</div>
                                    <input type="text" name="userPincode" class="ms-1" id="userPincode">
                                </div>
                                <div class="d-flex-column">
                                    <div class="textHead">PHONE NO:</div>
                                    <input type="text" name="userPhoneNumber" class="ms-1" id="userPhoneNumber" >
                                </div>
                            </div>
                            <button type="submit" value="submit" class="btn mt-3 mb-5 ms-3" name="submit" onClick="editUserAddress()">SUBMIT</button>
                        </div>
                    </div>
                </div>
            </cfoutput>