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
                        <div><a href="cartPage.cfm"><i class="fa badge fa-lg mt-3" value=#session.cartCount#>&##xf07a;</i></a></div>
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
                <div class="orderHistoryPage d-flex flex-column">
                    <div class = "successMsg ">PAYMENT SUCCESSFULL!</div>
                    <div class="d-flex">
                        <form action = "homePage.cfm">
                            <button type = "submit" class = "placeOrder">Go Back Shopping</button>
                        </form>
                        <form action = "orderListing.cfm">
                            <button type = "submit" class = "placeOrder" >View Order History</button>
                        </form>
                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>
