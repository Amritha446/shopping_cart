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
                        <div class="categoryDisplay ms-5 me-5 d-flex">
                            <div class="categoryNameNavBar p-1" data-category-id="#viewCategory.fldCategory_Id#" id="categoryNameNavBar">
                                <a href="categoryBasedProduct.cfm?categoryId=#viewCategory.fldCategory_Id#" class="navBarButton">#viewCategory.fldCategoryName#</a>
                            </div>
                            <div class="subCategoryMenu" id="subCategoryMenu-#viewCategory.fldCategory_Id#" 
                                data-category-id="#viewCategory.fldCategory_Id#">
                                <cfset subCategories = application.myCartObj.viewSubCategoryData(viewCategory.fldCategory_Id)>
                                <cfloop query="#subCategories#">
                                    <div class="subcategory-item" data-subcategory-id="#fldSubCategory_Id#">
                                        #fldSubCategoryName#
                                    </div>
                                </cfloop>
                            </div>
                        </div>
                    </cfloop>
                </div>
                
                <div class="mainContentProduct d-flex">
                </div>

            </div>
        </cfoutput>
    </body>
</html>