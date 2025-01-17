    
    
    </head>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">MyCart</div>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex ms-5">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1 pe-none ms-5" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                
                <div class="navBar">
                    <cfset viewCategory = application.myCartObj.viewCategoryData()>
                    <cfloop query="#viewCategory#">
                        <!--- <div class = "categoryDisplay ms-5 d-flex">
                            #viewCategory.fldCategoryName#
                        </div> --->
                        <div class="categoryDisplay ms-5 me-5 d-flex">
                            <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#" id="categoryNameNavBar">
                                #viewCategory.fldCategoryName#
                            </div>
                            <div class="subcategoryList" id="subcategoryList_#viewCategory.fldCategory_Id#" ></div>
                        </div>
                    </cfloop>
                </div>

                <div class="homeImg">
                    <img src="assets1/home.jpeg" alt="img" class="homeImg">
                </div>

                <div class="productListing d-flex-column">
                    <h6 class="mt-3 ms-3">RANDOM PRODUCTS</h6>
                    <cfset viewProduct = application.myCartObj.viewProduct()>

                    <div class="productContainer">
                        <cfloop query="viewProduct">
                        
                            <!--- Start a new row every 6 items --->
                            <cfif (currentRow mod 6) EQ 1>
                                <!--- Close the previous row if it's not the first row --->
                                <cfif currentRow GT 1>
                                    </div> <!-- Close previous row -->
                                </cfif>
                                <div class="productRow d-flex"> <!-- Start a new row -->
                            </cfif>
                            
                            <div class="productBox d-flex-column">
                                <img src="assets/#viewProduct.imageFileName#" alt="img" class="productBoxImage">
                                <div class="ms-4 font-weight-bold h5">#viewProduct.fldProductName#</div>
                                <div class="ms-4 h6 ">#viewProduct.fldBrandName#</div>
                                <div class="ms-4 small">$#viewProduct.fldPrice#</div>
                            </div>
                            
                            <!--- Track the row number by incrementing the currentRow counter --->
                            <cfset currentRow = currentRow + 1>
                        </cfloop>

                    <!--- Close the last row after the loop ends --->
                        <cfif currentRow GT 1>
                            </div> <!-- Close the last row -->
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
