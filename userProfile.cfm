</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid ">
                <cfset cartData = application.myCartObj.viewCartData()>
                <div class="header d-flex text-align-center">
                    <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
                    <div class="input-group mt-2 ms-5 ">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#(structKeyExists(url, 'searchTerm') ? url.searchTerm : '')#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>

                    <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
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

                <cfinclude template = "navbar.cfm">

                <div class="nameSection justify-content-center text-align-center d-flex">
                    <cfset viewUserDetails = application.myCartObj.userDetailsFetching()>
                    <div class="userImage">
                        <button type="submit" class="profileButton" data-bs-toggle="modal" data-bs-target="##editUserDetails" id="userDetailedBtn" onClick="editUser()">
                            <img src="assets1/user.JPG" alt="img" class="mt-3 userImg pe-none">
                        </button>
                    </div>
                    <div class="userDetails ms-2 mt-3">
                        <div class="text-light"> Hello, #viewUserDetails.fldFirstName# #viewUserDetails.fldLastName#</div>
                        <div class="productPath text-light">Email:#viewUserDetails.fldEmail#</div>
                    </div>
                </div>
                
                <div class="addressSection p-3">
                    <div class="text-light ms-5 mt-1 fw-bold">ADDRESS LIST</div>
                    <cfset viewUserAddress = application.myCartObj.fetchUserAddress()>
                    <cfloop query="#viewUserAddress#">
                        <div class="addressAddSection d-flex ms-4 mt-2 ">
                            <div class="d-flex flex-column">
                                <div class="d-flex ms-4">#viewUserAddress.fldFirstName#  #viewUserAddress.fldLastName#  </div>
                                <div class="d-flex ms-4">#viewUserAddress.fldAdressLine1# , #viewUserAddress.fldAdressLine2# ,
                                #viewUserAddress.fldCity# , #viewUserAddress.fldState#</div>
                                <div class="d-flex ms-4">#viewUserAddress.fldPincode# #viewUserAddress.fldPhoneNumber#</div>
                            </div>
                            <div>
                                <button type="submit" class="adddressRemove" onClick="removeAddress(event)" value="#viewUserAddress.fldAddress_Id#"><i class="fa-regular fa-trash-can pe-none"></i></button>
                            </div>
                        </div>      
                    </cfloop> 
                    <button type="submit" data-bs-toggle="modal" data-bs-target="##editUserAddress" id="userAddressBtn" class="userAddressBtn" >ADD</button>
                </div>

                <div class="modal fade" id="editUserDetails" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content d-flex justify-content-center align-items-center">
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">FIRST NAME:</div>
                                    <input type="text" name="userFirstName" class="ms-1" id="userFirstNameProfile">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">LAST NAME:</div>
                                    <input type="text" name="userLastName" class="ms-1" id="userLastNameProfile">
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">EMAIL:</div>
                                    <input type="text" name="userPhoneNumber" class="ms-1" id="userPhoneNumberProfile">
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">PHONE NO:</div>
                                    <input type="text" name="userEmail" class="ms-1" id="userEmailProfile" >
                                </div>
                            </div>
                            <button type="submit" value="submit" class="btn mt-3 mb-5 ms-3" name="submit" onClick="editUserSubmit()">SUBMIT</button>
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
                                    <div class="error text-danger" id="addressFirstNameError"></div>
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">LAST NAME:</div>
                                    <input type="text" name="addressLastName" class="ms-1" id="addressLastName" >
                                    <div class="error text-danger" id="addressLastNameError"></div>
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">ADDRESS LINE 1:</div>
                                    <input type="text" name="addressLine1" class="ms-1" id="addressLine1">
                                    <div class="error text-danger" id="addressLine1Error"></div>
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">ADDRESS LINE 2:</div>
                                    <input type="text" name="addressLine2" class="ms-1" id="addressLine2">
                                    <div class="error text-danger" id="addressLine2Error"></div>
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">CITY:</div>
                                    <input type="text" name="userCity" class="ms-1" id="userCity">
                                    <div class="error text-danger" id="userCityError"></div>
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">STATE:</div>
                                    <input type="text" name="userState" class="ms-1" id="userState" >
                                    <div class="error text-danger" id="userStateError"></div>
                                </div>
                            </div>
                            <div class="d-flex ">
                                <div class="d-flex flex-column ">
                                    <div class="textHead">PINCODE:</div>
                                    <input type="text" name="userPincode" class="ms-1" id="userPincode">
                                    <div class="error text-danger" id="userPincodeError"></div>
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="textHead">PHONE NO:</div>
                                    <input type="text" name="userPhoneNumber" class="ms-1" id="userPhoneNumber" >
                                    <div class="error text-danger" id="userPhoneNumberError"></div>
                                </div>
                            </div>
                            <button type="submit" value="submit" class="btn mt-3 mb-5 ms-3" name="submit" onClick="editUserAddress()">SUBMIT</button>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>
    