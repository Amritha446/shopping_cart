</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfparam name="url.productImages" default=0>
            <cfif isValid("integer", url.productId)>
                <cfset variables.productId = url.productId>
            <cfelse>
                <cfset variables.productId = application.myCartObj.decryptUrl(encryptedData = url.productId)>
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
                
                <cfif len(trim(url.searchTerm)) NEQ 0>
                    <cfset variables.viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                <cfelse>
                    <cfset variables.viewProduct = application.myCartObj.viewProduct(productId = variables.productId,
                                                                          productImages = url.productImages)>
                </cfif>
                
                <div class="d-flex productSection">
                    <div class="product-container d-flex">
                        <div class="d-flex flex-column">
                            <div class="mainImage-container">
                                <img src="assets/product_Images/#variables.viewProduct.imageFileName#" alt="Main Product Image" id="mainImage">
                            </div>

                            <div class="thumbnails p-2 ms-4">
                                <cfloop query="#variables.viewProduct#">
                                    <img class="thumbnail" src="assets/product_Images/#variables.viewProduct.imageFileName#" alt="Thumbnail Image" onclick="changeMainImage(this)">
                                </cfloop>
                            </div>
                            <div class="d-flex ms-4">
                                <form method="POST" name="formBuyNow">
                                    <cfif structKeyExists(session, "isAuthenticated")>
                                        <button type="button" class="buyProduct"  data-bs-toggle="modal" data-bs-target="##buyNow" id="buyNowBtn" name="buyNowBtn">BUY NOW</button>
                                    <cfelse>
                                        <button type="submit" class="buyProduct"  data-bs-toggle="modal" data-bs-target="##buyNow" id="buyNowBtn" name="buyNowBtn">BUY NOW</button>
                                        <input type="hidden" value = "#variables.productId#" name="addToCartHidden">
                                        <input type="hidden" name="cartToken" id="cartToken" value = 1>
                                    </cfif>
                                </form>

                                <form method="POST" name="form">
                                    <button type="submit" class="addToCart" >ADD TO CART</button>
                                    <input type="hidden" value = "#variables.productId#" name="addToCartHidden">
                                    <input type="hidden" name="cartToken" id="cartToken" value = 1>
                                </form>
                            </div>
                        </div>   
                    </div>

                    <cfif structKeyExists(form, "buyNowBtn") >
                        <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                            <cfset variables.viewcart = application.myCartObj.addToCart(productId = form.addToCartHidden,
                                                                            cartToken = form.cartToken)>
                            <cflocation  url="cartPage.cfm">
                        <cfelse>
                            <cflocation url="logIn.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.productId))#&cartToken=1" addToken = "false">
                        </cfif>
                    </cfif>

                    <cfif structKeyExists(form, "addToCartHidden")>
                        <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                            <cfset variables.viewcart = application.myCartObj.addToCart(productId = form.addToCartHidden,
                                                                            cartToken = form.cartToken)>
                            <cflocation url="cartPage.cfm">
                        <cfelse>
                            <cflocation url="logIn.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.productId))#&cartToken=1" addToken = "false">
                        </cfif>
                    </cfif>
                    
                    <div class="d-flex flex-column productDetails">
                        <cfset variables.subCategoryFetching = application.myCartObj.viewSubCategoryData(subCategoryId = #variables.viewProduct.fldSubCategoryId#)>
                        <cfset variables.categoryData = {}>

                        <cfloop array="#variables.subCategoryFetching['data']#" index="subCategoryData">
                            <cfset categoryFetching = application.myCartObj.viewCategoryData(categoryId = #subCategoryData["fldCategoryId"]#)>
                            <cfset variables.categoryData[subCategoryData["fldCategoryId"]] = categoryFetching>
                        </cfloop>

                        <cfloop array="#variables.subCategoryFetching['data']#" index="subCategoryData">
                            <div class="productPath p-1 ">
                                <a href="homePage.cfm" class="navBarButton ms-2">home</a>
                                > 
                                <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.categoryData[subCategoryData['fldCategoryId']].fldCategory_Id))#" class="navBarButton ms-2">
                                    #variables.categoryData[subCategoryData['fldCategoryId']].fldCategoryName#
                                </a>
                                > 
                                <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.viewProduct.fldSubCategoryId))#" class="navBarButton ms-2">#subCategoryData["fldSubCategoryName"]#</a>
                                > 
                                <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.productId))#" class="navBarButton ms-2">#variables.viewProduct.fldBrandName#</a>
                            </div>
                        </cfloop>
                        
                        <div class="productName">#variables.viewProduct.fldProductName#</div>
                        <div class="productBrandName">#variables.viewProduct.fldBrandName#</div>
                        <div class="productDescription">About Product:#variables.viewProduct.fldDescription#</div>
                        <div class="productPrice">Product Price:#variables.viewProduct.fldPrice#</div>
                        <div class="productDescription">Product Tax:#variables.viewProduct.fldTax#%</div>
                    </div>
                </div>
                <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                    <div class="modal fade" id="buyNow" tabindex="-1">
                        <div class="modal-dialog custom-modal-width">
                            <div class="modal-content d-flex justify-content-center align-items-center">
                                <div class="buyModal">
                                    <div class="text-success ms-5 mt-1 fw-bold">SELECT ADDRESS</div>
                                    <cfset variables.viewUserAddress = application.myCartObj.fetchUserAddress()>
                                    <form action="orderPage.cfm" method="get">
                                        <cfloop query="#variables.viewUserAddress#">
                                            <div class="addressAddSection d-flex ms-4 mt-2">
                                                <div class="d-flex flex-column">
                                                    <input type="radio" name="addressId" value="#variables.viewUserAddress.fldAddress_Id#" class="address-radio" required>
                                                    <div class="d-flex ms-4">#variables.viewUserAddress.fldFirstName# #variables.viewUserAddress.fldLastName#</div>
                                                    <div class="d-flex ms-4">#variables.viewUserAddress.fldAdressLine1# , #variables.viewUserAddress.fldAdressLine2# , #variables.viewUserAddress.fldCity# , #variables.viewUserAddress.fldState#</div>
                                                    <div class="d-flex ms-4">#variables.viewUserAddress.fldPincode# #variables.viewUserAddress.fldPhoneNumber#</div>
                                                </div>
                                            </div>
                                        </cfloop>
                                        <input type="hidden" name="productId" value="#variables.productId#">
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
                                <div class="d-flex flex-column ">
                                    <div class="textHead">FIRST NAME:</div>
                                    <input type="text" name="addressFirstName" class="ms-1" id="addressFirstName">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">LAST NAME:</div>
                                    <input type="text" name="addressLastName" class="ms-1" id="addressLastName" >
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">ADDRESS LINE 1:</div>
                                    <input type="text" name="addressLine1" class="ms-1" id="addressLine1">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">ADDRESS LINE 2:</div>
                                    <input type="text" name="addressLine2" class="ms-1" id="addressLine2">
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">CITY:</div>
                                    <input type="text" name="userCity" class="ms-1" id="userCity">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">STATE:</div>
                                    <input type="text" name="userState" class="ms-1" id="userState" >
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">PINCODE:</div>
                                    <input type="text" name="userPincode" class="ms-1" id="userPincode">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">PHONE NO:</div>
                                    <input type="text" name="userPhoneNumber" class="ms-1" id="userPhoneNumber" >
                                </div>
                            </div>
                            <button type="submit" value="submit" class="btn mt-3 mb-5 ms-3" name="submit" onClick="editUserAddress()">SUBMIT</button>
                        </div>
                    </div>
                </div>
            </cfoutput>
            <cfinclude template = "commonFooter.cfm">