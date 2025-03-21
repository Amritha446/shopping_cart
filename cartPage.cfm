
</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid mb-3">
                
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

                    <a href="userProfile.cfm" class="profileButton"><div class="profile d-flex me-5 mt-1 text-light p-2">
                        <div class="me-1 ">Profile</div>
                        <i class="fa-regular fa-user mt-1"></i>
                    </div></a>
                    <a href="orderListing.cfm" class="imageLink text-light me-3 mt-2 p-1">Orders</a>
                    <button type="button" class="logOutBtn p-1 col-1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
                        </div>
                    </button>
                </div>
                <cfinclude template = "navbar.cfm">
                <div class="d-flex">
                    <cfset variables.cartData = application.myCartObj.viewCartData()>
                    <cfif variables.cartData.recordCount EQ 0>
                        <h5 class="text-success ms-5 mt-5">Cart is empty!</h5>
                    </cfif>
                    <input type = "hidden" id="cartIdFetch" value="#variables.cartData.fldCart_Id#">
                    <div class="cartContainer d-flex flex-column">
                        <cfloop query="#variables.cartData#">
                            <div class="cartItem d-flex " >
                                <div class="d-flex flex-column productBox1">
                                    <img src="assets/product_Images/#variables.cartData.fldImageFileName#" alt="img" class="productBoxImage"> 
                                    <div class="ms-4 font-weight-bold h5 ">#variables.cartData.fldProductName#</div>
                                    <div class="quantityBlock ms-4">
                                        <button class="decrement me-2" value="#variables.cartData.fldProduct_Id#" onClick="decrementQuantity(event)">-</button>
                                        <span class="quantityNumber">#variables.cartData.fldQuantity#</span>
                                        <button class="increment ms-2" value="#variables.cartData.fldProduct_Id#" onClick="incrementQuantity(event)">+</button>
                                        <input type="hidden" id="hiddenQuantityUpdate" value = 1>
                                    </div>

                                    <div class="d-flex">
                                        <button type="submit" class="buyProduct" value="#variables.cartData.fldCart_Id#" onClick="removeCartProduct(event)">REMOVE</button>
                                        <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = variables.cartData.fldProduct_Id))#&productImages=1" class="imageLink">
                                            <button type="submit" class="buyProduct">VIEW</button>
                                        </a>
                                    </div>
                                    
                                </div>
                                <div class="d-flex flex-column productMainDetails">
                                    <div class="productPrice ms-3" id="orderedProductPriceId">Unit Price:$#variables.cartData.fldPrice#</div>
                                    <div class="productTax ms-3" id="orderedProductTaxId">Actual Price:$#variables.cartData.fldPrice#</div>
                                    <div class="productActualPrice ms-3" id="orderedProductActualId">Product Tax:#variables.cartData.fldTax#%</div>
                                    <div class="totalPrice ms-3 text-success" id="orderedProductTotalId">Total Price:$#variables.cartData.fldPrice#</div>
                                </div>

                            </div>
                        </cfloop>  
                    </div>
                    <div class="priceDetails">
                        <h6 class="text-success ms-5 ps-4">Buy Together</h6>
                        <div class="priceDetailsHeading ms-5 text-success">Total Price:</div>
                        <button type="button" class="placeOrder" data-bs-toggle="modal" data-bs-target="##cartItems" id="cartOrderBtn"> ORDER </button> 
                    </div>
                </div>
                <div class="modal fade" id="cartItems" tabindex="-1">
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
                                    <div class="d-flex">
                                        <button type="submit" id="userPaymentBtn" class="userAddressBtn1">PAYMENT</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

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
            </div>    
        </cfoutput>
        <cfinclude template = "commonFooter.cfm">