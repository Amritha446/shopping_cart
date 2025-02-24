</head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <cfparam name="url.searchId" default="">
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 me-5">MyCart</div></a>
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
                    <cfparam name="url.searchId" default="">
                    <cfparam name="url.page" default="1">
                    
                    <cfset pageSize = 5>
                    <cfset currentPage = #url.page#>
                    <cfset offset = (currentPage - 1) * pageSize>

                    <cfif url.searchId NEQ "">
                        <cfset orderedItemList = application.myCartObj.fetchOrderDetails(searchId = url.searchId)>
                    <cfelse>
                        <cfset orderedItemList = application.myCartObj.fetchOrderDetails(limit = pageSize, offset = offset)>
                    </cfif>

                    <cfset totalOrders = application.myCartObj.fetchOrderDetails().recordCount>
                    <cfset totalPages = floor(((totalOrders + pageSize) - 1) / pageSize)>

                    <cfset lastOrderId = "">
                    <cfset orderDetails = {}>

                    <cfloop query="#orderedItemList#">
                        <cfset orderDetails[orderedItemList.fldOrder_Id] = application.myCartObj.fetchOrderDetails(orderIdList = orderedItemList.fldOrder_Id)>
                    </cfloop>

                    <cfloop query = "#orderedItemList#">
                        <cfif orderedItemList.fldOrder_Id NEQ lastOrderId>
                            <div class="d-flex-column mb-3">
                                <cfset lastOrderId = orderedItemList.fldOrder_Id>
                                <cfset orderedEachItemList = orderDetails[orderedItemList.fldOrder_Id]>
                                <div class="d-flex orderListHeading">
                                    <div class="orderDiv">ORDER ID : #orderedEachItemList.fldOrder_Id#</div>
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
                                            <div class="orderDiv">Quantity : #orderedEachItemList.fldQuantity#</div>
                                            <div class="orderDiv">Unit Price : #orderedEachItemList.fldUnitPrice#</div>
                                            <div class="orderDiv">Unit Tax : #orderedEachItemList.productTax# % </div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-2">
                                            <div class="orderDiv">Ordered On:</div>
                                            <div class="orderDiv">#orderedEachItemList.formattedDate#</div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-3">
                                            <div class="orderDiv">Contact Details:</div>
                                            <div class="orderDiv">Mob No: #orderedEachItemList.fldPhoneNumber#</div>
                                            <div class="orderDiv">Address: #orderedItemList.fldAdressLine1# #orderedEachItemList.fldAdressLine2#</div>
                                        </div> 
                                        <div class="d-flex-column ms-4 col-2">
                                            <div class="orderDiv">Delivery date:</div>
                                            <div class="orderDiv">#date#</div>
                                        </div> 
                                    </div>
                                </cfloop>
                            </div>
                        </cfif>
                    </cfloop>
                    <div class="orderPagination">
                        <cfif (currentPage GT 1) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(currentPage - 1)#" class="paginaionLink">Previous</a>
                        <cfelse>
                            <span class="paginaionLink disabled">Previous</span>
                        </cfif>

                        <span>Page #currentPage# </span>
                        
                        <cfif (currentPage LT totalPages) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(currentPage + 1)#" class="paginaionLink">Next</a>
                        <cfelse>
                            <span class="paginaionLink disabled">Next</span>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfoutput>