<cfoutput>
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
</cfoutput>