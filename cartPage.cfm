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
                                <a href="categoryBasedProduct.cfm?categoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = viewCategory.fldCategory_Id))#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                                <div class="subCategoryMenu">
                                    <cfset subCategories = application.myCartObj.viewSubCategoryData(categoryId = viewCategory.fldCategory_Id)>
                                    <cfloop query="#subCategories#">
                                        <a href="filterProduct.cfm?subCategoryId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = subCategories.fldSubCategory_Id))#" class="subcategory-item">
                                            #subCategories.fldSubCategoryName#
                                        </a>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </cfloop>
                </div>
                <div class="d-flex">
                    <cfset cartData = application.myCartObj.viewCartData()>
                    <input type = "hidden" id="cartIdFetch" value="#cartData.fldCart_Id#">
                    <div class="cartContainer d-flex-column">
                        <cfloop query="#cartData#">
                            <div class="cartItem d-flex-column ms-5" >
                                <div class="d-flex-column productBox1">
                                    <img src="assets/#cartData.fldImageFileName#" alt="img" class="productBoxImage"> 
                                    <div class="ms-4 font-weight-bold h5">#cartData.fldProductName#</div>
                                    <div class="quantityBlock ms-5">
                                        <button class="decrement me-2" value="#cartData.fldProduct_Id#" onClick="decrementQuantity(event)">-</button>
                                        <span class="quantityNumber">#cartData.fldQuantity#</span>
                                        <button class="increment ms-2" value="#cartData.fldProduct_Id#" onClick="incrementQuantity(event)">+</button>
                                    </div>

                                    <div class="d-flex">
                                        <button type="submit" class="buyProduct" value="#cartData.fldCart_Id#" onClick="removeCartProduct(event)">REMOVE</button>
                                        <a href="productDetails.cfm?productId=#urlEncodedFormat(application.myCartObj.encryptUrl(plainData = cartData.fldProduct_Id))#&random=1" class="imageLink">
                                            <button type="submit" class="buyProduct">VIEW</button>
                                        </a>
                                    </div>
                                    
                                </div>
                                <div class="d-flex-column productMainDetails">
                                    <div class="productPrice ms-3" id="orderedProductPriceId">Unit Price:$#cartData.fldPrice#</div>
                                    <div class="productTax ms-3" id="orderedProductTaxId">Actual Price:$#cartData.fldPrice#</div>
                                    <div class="productActualPrice ms-3" id="orderedProductActualId">Product Tax:#cartData.fldTax#%</div>
                                    <div class="totalPrice ms-3 text-success" id="orderedProductTotalId">Total Price:$#cartData.fldPrice#</div>
                                </div>

                            </div>
                        </cfloop>  
                    </div>
                    <div class="priceDetails">
                        <h6 class="text-success ms-5">Buy Together</h6>
                        <div class="priceDetailsHeading ms-3">Total Price:</div>
                        <button type="button" class="placeOrder" data-bs-toggle="modal" data-bs-target="##cartItems" id="cartOrderBtn"> ORDER </button> 
                    </div>
                </div>
                <div class="modal fade" id="cartItems" tabindex="-1">
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