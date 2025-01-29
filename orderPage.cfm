</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfparam name="url.addressId" default="">
            <cfparam name="url.productId" default="">
            <div class="container-fluid ">
                <cfset cartData = application.myCartObj.viewCartData()>
                <div class="header d-flex text-align-center">
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
                    <div class="input-group mt-2 ms-5 ">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#(structKeyExists(url, 'searchTerm') ? url.searchTerm : '')#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>

                    <cfif session.isAuthenticated EQ true>
                        <div><a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#cartData.recordCount#>&##xf07a;</i></a></div>
                    <cfelse>
                         <div><i class="fa-solid fa-cart-shopping me-2 mt-2 p-2" style="color: ##fff"></i></div>
                    </cfif>

                    <a href="userProfile.cfm" class="profileButton"><div class="profile d-flex me-5 mt-1 text-light p-2">
                        <div class="me-1 ">Profile</div>
                        <i class="fa-regular fa-user mt-1"></i>
                    </div></a>
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
                <div class="orderSummary">
                    <h5 class="ms-5 ps-5 mt-3 text-light p-2">ORDER SUMMARY</h5>
                    <div class="addressOrder">
                        <cfset viewUserAddress = application.myCartObj.fetchUserAddress(addressId = URL.addressId)>
                        <div class="addressAddSection d-flex-column mt-2 ">
                            <div class="fs-6 ms-4 text-success">SELECTED ADDRESS</div>
                            <div class="d-flex ms-4">#viewUserAddress.fldFirstName#  #viewUserAddress.fldLastName#  </div>
                            <div class="d-flex ms-4">#viewUserAddress.fldAdressLine1# , #viewUserAddress.fldAdressLine2# ,
                            #viewUserAddress.fldCity# , #viewUserAddress.fldState#</div>
                            <div class="d-flex ms-4">#viewUserAddress.fldPincode# #viewUserAddress.fldPhoneNumber#</div>
                        </div>
                    </div>
                    <div class="productOrder d-flex-column ">
                        <cfif #URL.productId# NEQ "">
                            <cfset cartData = application.myCartObj.viewProduct(productId = URL.productId)>
                        <cfelse>
                            <cfset cartData = application.myCartObj.viewCartData()>
                        </cfif>
                        <div class="fs-6 text-success orderedProductName ms-4 mt-4">PRODUCT DETAILS</div>
                        <cfloop query="#cartData#">
                            <div class="cartItem d-flex">
                                <div class="d-flex-column mt-3">
                                    <div class="d-flex orderListing justify-content-space-between">
                                        <cfif len(trim(URL.productId))>
                                            <img src="assets/#cartData.imageFileName#" alt="img" class="productBoxImage1"> 
                                        <cfelse>
                                            <img src="assets/#cartData.fldImageFileName#" alt="img" class="productBoxImage1"> 
                                        </cfif>
                                    <div class="productBasedDetails"><div class="ms-5 font-weight-bold h6 d-flex orderedProductName">#cartData.fldProductName#</div>
                                    <div class="quantityBlock ms-5">
                                        <button class="decrement me-2" onClick="decrementQuantity(event)">-</button>
                                        <cfif len(trim(URL.productId))>
                                            <span class="quantityNumber">1</span>  
                                        <cfelse>
                                            <span class="quantityNumber">#cartData.fldQuantity#</span> 
                                        </cfif>
                                        <button class="increment ms-2" onClick="incrementQuantity(event)">+</button>
                                    </div>
                                    <div class="d-flex-column productMainDetails">
                                        <div class="productPrice ms-3">Unit Price:$#cartData.fldPrice#</div>
                                        <div class="productTax ms-3">Actual Price:$#cartData.fldPrice#</div>
                                        <div class="productActualPrice ms-3">Product Tax:#cartData.fldTax#%</div>
                                        <div class="totalPrice ms-3 text-success">Total Price:$#cartData.fldPrice#</div>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                        <button type="submit" class="orderPlacingBtn ">PLACE ORDER</button>
                    </div>  
                </div>
            </div>
        </cfoutput>
    </body>
</html>