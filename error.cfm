    </head>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
                    
                    <div class="ms-5"><i class="fa-solid fa-cart-shopping me-2 mt-2 p-2" style="color: ##fff"></i></div>

                    <a href="userProfile.cfm" class="profileButton">
                        <div class="profile d-flex me-5 mt-1 text-light p-2">
                            <div class="me-1 ">Profile</div>
                            <i class="fa-regular fa-user mt-1"></i>
                        </div>
                    </a>

                    <div class="logInBtn d-flex">
                        <a href="logIn.cfm" class="imageLink d-flex ms-5 text-light mt-3">
                            Home
                        </a>
                    </div>
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
                <div class="d-flex flex-column align-items-center justify-content-center p-5">
                    <img src="./assets1/error.jpg" alt="errorImg" class="">
                    <div class="d-flex align-items-center justify-content-center text-danger mt-3 fs-5"><i class="fa-regular fa-face-frown me-1"></i> Something went wrong!Try again later.</div>
                    <a href = "homePage.cfm" class="imageLink d-flex align-items-center justify-content-center mt-3">Go back to Home Page</a>
                </div>
        </cfoutput>
    </body>
</html>
