</head>
    <body>
        <cfoutput>
            <cfset productId = url.productId>
            <cfparam name="url.random" default=0>
            <div class="container-fluid ">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">MyCart</div>
                </div>
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
                
                <cfset viewProduct = application.myCartObj.viewProduct(productId = #url.ProductId#,
                                                                          random = url.random)>
                <div class="d-flex">
                <div class="product-container d-flex">
                    <div class="d-flex-column">
                        <div class="main-image-container">
                            <img src="assets/#viewProduct.imageFileName#" alt="Main Product Image" id="main-image">
                        </div>

                        <div class="thumbnails">
                            <cfloop query="#viewProduct#">
                                <img class="thumbnail" src="assets/#viewProduct.imageFileName#" alt="Thumbnail Image" onclick="changeMainImage(this)">
                            </cfloop>
                        </div>
                        <div class="d-flex">
                            <button type="submit" class="buyProduct">BUY NOW</button>
                            <button type="submit" class="addToCart">ADD TO CART</button>
                        </div>
                    </div>
                    
                </div>
                <div class="d-flex-column productDetails">
                        <div class="productName">#viewProduct.fldProductName#</div>
                        <div class="productBrandName">#viewProduct.fldBrandName#</div>
                        <div class="productDescription">About Product:#viewProduct.fldDescription#</div>
                        <div class="productPrice">#viewProduct.fldPrice#</div>
                </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>