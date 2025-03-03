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
                    
                    <button type="button" class="logOutBtn p-1 col-1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
                        </div>
                    </button>
                </div>
                <cfinclude template = "navbar.cfm">

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
                        <cfset orderedEachItemList = application.myCartObj.fetchOrderDetails(searchId = url.searchId)>
                        <cfif orderedEachItemList.recordCount EQ 0>
                            <h6 class="text-danger ms-5 mt-2">No orders found with #url.searchId#</h6>
                        </cfif>
                    <cfelse>
                        <cfset orderedEachItemList = application.myCartObj.fetchOrderDetails(limit = pageSize, offset = offset)>
                    </cfif>
                    <cfset totalOrders = application.myCartObj.fetchOrderDetails().recordCount>
                    <cfset totalPages = floor(((totalOrders + pageSize) - 1) / pageSize)>
                    
                    <cfloop query="#orderedEachItemList#">
                        <div class="d-flex flex-column mb-3">
                            <div class="d-flex orderListHeading">
                                <div class="">ORDER ID : #orderedEachItemList.fldOrder_Id#</div>
                                <button type="button" class="invoiceDownload" onClick="downloadInvoice(event)" value="#orderedEachItemList.fldOrder_Id#" title="Download Invoice">
                                    <i class="fa-solid fa-download bg-light pe-none"></i> 
                                </button>
                            </div>
                            
                            <div class="orderedItemsBlock d-flex">
                                <div class="productDetails d-flex flex-column col-4">
                                    <cfloop list="#orderedEachItemList.fldQuantity#" item="item" index="index">
                                        <div class="orderedItem">
                                            <img src="assets/#ListGetAt(orderedEachItemList.fldImageFileName,index)#" alt="product_img" class="orderListImage ms-2 me-3">
                                            <div class="d-flex flex-column">
                                                <div>#ListGetAt(orderedEachItemList.fldProductName,index)#</div>
                                                <div class="orderDiv">Quantity: #ListGetAt(orderedEachItemList.fldQuantity,index)#</div>
                                                <div class="orderDiv">Unit Price: #ListGetAt(orderedEachItemList.fldUnitPrice,index)#</div>
                                                <div class="orderDiv">Unit Tax: #ListGetAt(orderedEachItemList.productTax,index)# %</div>
                                            </div>
                                        </div>
                                    </cfloop>
                                </div>

                                <div class="orderDetails d-flex flex-column col-8 ms-4 mt-3">
                                    <cfset originalDate = CreateDateTime(
                                        ListGetAt(orderedEachItemList.formattedDate, 3, '-'),
                                        ListGetAt(orderedEachItemList.formattedDate, 2, '-'),
                                        ListGetAt(orderedEachItemList.formattedDate, 1, '-')
                                    )>
                                    <cfset newDate = DateAdd("d", 7, originalDate)>
                                    <cfset date = dateFormat(newDate,'d-m-Y')>
                                    <div class="d-flex">
                                        <div class="me-5"><div class="orderDiv">Ordered On: #orderedEachItemList.formattedDate#</div>
                                        <div class="orderDiv">Delivery Date: #date#</div></div>
                                        <div class="ms-5"><div class="orderDiv">Contact Details:</div>
                                        <div class="orderDiv">Mob No: #orderedEachItemList.fldPhoneNumber#</div>
                                        <div class="orderDiv">Address: #orderedEachItemList.fldAdressLine1# #orderedEachItemList.fldAdressLine2#</div></div>
                                    </div>
                                </div>
                            </div>
                        </div> 
                    </cfloop>

                    <div class="orderPagination">
                        <cfif (currentPage GT 1) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(currentPage - 1)#" class="paginaionLink">Previous</a>
                        <cfelse>
                            <button class="paginaionLink disabled" >Previous</button>
                        </cfif>

                        <span>Page #currentPage# </span>
                        
                        <cfif (currentPage LT totalPages) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(currentPage + 1)#" class="paginaionLink">Next</a>
                        <cfelse>
                            <button class="paginaionLink disabled" >Next</button>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfoutput>