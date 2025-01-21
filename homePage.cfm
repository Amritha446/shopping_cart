    
    
    </head>
    <body>
        <cfoutput>
            <cfparam name="url.searchTerm" default="">
            <div class="container-fluid ">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2 col-6 ">MyCart</div>
                    <div class="input-group mt-2 ms-5">
                        <form action="homePage.cfm?searchTerm=#url.searchTerm#" method="get">
                            <input class="form-control border rounded-pill" type="search" name="searchTerm" value="#url.searchTerm#" id="example-search-input" placeholder="Serach..">
                        </form>
                    </div>
                </div>
                <button type="button" class="btn1">
                    <div class="signUp d-flex">
                        <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                    </div>
                </button>
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

                <div class="homeImg">
                    <img src="assets1/home.jpeg" alt="img" class="homeImg">
                </div>

                <div class="productListing d-flex-column">
                    <h6 class="mt-3 ms-3">RANDOM PRODUCTS</h6>
                    <cfset viewProduct = application.myCartObj.viewProduct(searchTerm=url.searchTerm)>
                    <div class="productContainer">
                        <cfloop query="viewProduct">
                            <cfif (currentRow mod 6) EQ 1>
                                <cfif currentRow GT 1>
                                    </div>
                                </cfif>
                                <div class="productRow d-flex"> 
                            </cfif>
                            
                            <div class="productBox d-flex-column">
                                <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                            </div>
                            <cfset currentRow = currentRow + 1>
                        </cfloop>
                        <cfif currentRow GT 1 >
                            </div>
                        </cfif>  
                    </div> 
                </div>

                <div class="footerSection">
                </div>
                <div class="footer d-flex">
                    <div class="d-flex-column footerHeading mt-3">
                        Customer Service
                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>
