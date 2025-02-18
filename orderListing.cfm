</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfparam name="url.searchId" default="">
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
                    
                    <button type="button" class="logOutBtn p-1 col-1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
                        </div>
                    </button>

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

                <div class="orderHistory">
                    <div class = "text-success orderedItems">ORDER HISTORY</div>
                    <form method = "GET" action="orderListing.cfm?serachId=#url.searchId#" value="#(structKeyExists(url, 'searchId') ? url.searchId : '')#">
                        <input type="search" name="searchId" placeholder = "Search with Order Id.." class="orderedItemsSearch">
                    </form>
                    <cfif url.searchId NEQ "">
                        <cfset orderedItemList = application.myCartObj.orderHistoryDisplay(searchId = url.searchId)>
                    <cfelse>
                        <cfset orderedItemList = application.myCartObj.orderHistoryDisplay()>
                    </cfif>

                    <cfset lastOrderId = "">
                    <cfloop query = "#orderedItemList#">
                        <cfif orderedItemList.fldOrder_Id NEQ lastOrderId>>
                            <div class="d-flex-column">
                                <cfset lastOrderId = orderedItemList.fldOrder_Id> 
                                <cfset orderedEachItemList = application.myCartObj.orderHistoryDisplay(orderIdList = #orderedItemList.fldOrder_Id#)>
                                <div class="d-flex orderListHeading">
                                    <div class="">ORDER ID : #orderedEachItemList.fldOrder_Id#</div>
                                    <button type="button" class="invoiceDownload" onClick="downloadInvoice(event)" value="#orderedEachItemList.fldOrder_Id#" title="Download Invoice">
                                        <i class="fa-solid fa-download bg-light pe-none"></i> 
                                    </button>
                                </div>
                                <cfloop query="#orderedEachItemList#">
                                    <div class="orderedItemsBlock d-flex">
                                        <img src="assets/#orderedEachItemList.fldImageFileName#" alt="img" class="orderListImage ms-2 me-3">
                                        <cfset originalDate = CreateDateTime(
                                            ListGetAt(orderedEachItemList.formattedDate, 3, '-'), 
                                            ListGetAt(orderedEachItemList.formattedDate, 2, '-'), 
                                            ListGetAt(orderedEachItemList.formattedDate, 1, '-')
                                        )>
                                        <cfset newDate = DateAdd("d", 7, originalDate)>
                                        <cfset date = dateFormat(newDate,'d-m-Y')>
                                        <div class="d-flex-column col-2">
                                            <div>#orderedEachItemList.fldProductName#</div>
                                            <div class="">Quantity : #orderedEachItemList.fldQuantity#</div>
                                            <div class="">Unit Price : #orderedEachItemList.fldUnitPrice#</div>
                                            <div class="">Unit Tax : #orderedEachItemList.productTax# % </div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-2">
                                            <div class="">Ordered On:</div>
                                            <div class="">#orderedEachItemList.formattedDate#</div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-3">
                                            <div class="">Contact Details:</div>
                                            <div class="">Mob No: #orderedEachItemList.fldPhoneNumber#</div>
                                            <div class="">Address: #orderedItemList.fldAdressLine1# #orderedEachItemList.fldAdressLine2#</div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-2">
                                            <div class="">Delivery date:</div>
                                            <div class="">#date#</div>
                                        </div> 
                                    </div>
                                </cfloop>  
                            </div>
                        </cfif>
                    </cfloop>
                </div>
            </div>
        </cfoutput>