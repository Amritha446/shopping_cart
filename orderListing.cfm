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
                    
                    <cfset variables.pageSize = 5>
                    <cfset variables.currentPage = #url.page#>
                    <cfset variables.offset = (variables.currentPage - 1) * variables.pageSize>

                    <cfif url.searchId NEQ "">
                        <cfset variables.orderedEachItemList = application.myCartObj.fetchOrderDetails(searchId = url.searchId)>
                        <cfif structCount(variables.orderedEachItemList) EQ 0>
                            <h6 class="text-danger mt-2 orderListingError">No orders found with #url.searchId#</h6>
                        </cfif>
                    <cfelse>
                        <cfset variables.orderedEachItemList = application.myCartObj.fetchOrderDetails(limit = variables.pageSize,
                                                                                             offset = variables.offset
                                                                                             )>
                    </cfif>

                    <cfset variables.totalOrder = application.myCartObj.fetchOrderDetails()>
                    <cfset variables.totalOrders = structCount(variables.totalOrder)>
                    <cfset variables.totalPages = floor(((variables.totalOrders + variables.pageSize) - 1) / variables.pageSize)>

                    <cfset orderIds = structKeyList(variables.orderedEachItemList)>
                    <cfloop list="#orderIds#" index="orderId">
                        <cfset order = variables.orderedEachItemList[orderId]>
                        <div class="d-flex flex-column mb-3">
                            <div class="d-flex orderListHeading">
                                <div class="">ORDER ID : #order.orderId#</div>
                                <button type="button" class="invoiceDownload" onClick="downloadInvoice(event)" value="#order.orderId#" title="Download Invoice">
                                    <i class="fa-solid fa-download bg-light pe-none"></i> 
                                </button>
                            </div>

                            <div class="orderedItemsBlock d-flex">
                                <div class="productDetails d-flex flex-column col-4">
                                    <cfloop array="#order.products#" index="product">
                                        <div class="orderedItem ms-5">
                                            <img src="assets/product_Images/#product.imageFileName#" alt="product_img" class="orderListImage ms-2 me-3">
                                            <div class="d-flex ms-5">
                                                <div class="orderDiv1">#product.productName#</div>
                                                <div class="orderDiv">Quantity: #product.quantity#</div>
                                                <div class="orderDiv1">Unit Price: $#product.unitPrice#</div>
                                                <div class="orderDiv ms-3">Unit Tax: #product.tax# %</div>
                                            </div>
                                        </div>
                                    </cfloop>
                                </div>
                            </div>

                            <div class="d-flex orderListHeading">
                                <div class="orderDetails d-flex">
                                    <cfset originalDate =dateTimeFormat(parsedatetime(order.orderDate) , "d-m-Y")>
                                    <cfset newDate = DateAdd("d", 7, originalDate)>
                                    <cfset date = dateFormat(newDate, 'd-m-Y')>

                                    <div class="d-flex contactBlock">
                                        <div class="text-success">Ordered On:<br> #originalDate#</div>
                                        <div class="text-success">Delivery Date:<br> #date#</div>
                                        <div class="text-success">Mob No:<br> #order.address.phoneNumber#</div>
                                        <div class="text-success">Address:<br> #order.address.line1# #order.address.line2#</div>
                                    </div>
                                </div>
                            </div>
                        </div> 
                    </cfloop>

                    <div class="orderPagination">
                        <cfif (variables.currentPage GT 1) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(variables.currentPage - 1)#" class="paginationLink"> Previous </a>
                        <cfelse>
                            <button class="paginationLink disabled" > Previous </button>
                        </cfif>

                        <span class="m-2">Page #variables.currentPage# </span>
                        
                        <cfif (variables.currentPage LT variables.totalPages) AND (url.searchId EQ "")>
                            <a href="orderListing.cfm?searchId=#url.searchId#&page=#(variables.currentPage + 1)#" class="paginationLink"> Next </a>
                        <cfelse>
                            <button class="paginationLink disabled" > Next </button>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfoutput>