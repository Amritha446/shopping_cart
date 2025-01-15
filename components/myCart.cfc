<cfcomponent>
    <cffunction name = "validateLogIn" access = "public" returnType = "boolean">
        <cfargument name="userName" required="true">
        <cfargument name="userPassword" required="true">
       <!---  <cfset saltString = generateSecretKey(("AES"),128)> --->
        
        <cfquery name = local.saltString>
            SELECT 
                fldUserSaltString 
            FROM 
                shoppingcart.tbluser
            WHERE 
                fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
                OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset saltedPassword = #arguments.userName# & local.saltString.fldUserSaltString>
        <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
        <cfquery name = local.queryCheck>
            SELECT fldUser_Id,
                fldEmail,
                fldPhone,
                fldRoleId
            FROM 
                shoppingcart.tbluser 
            WHERE 
                fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
                OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
                AND fldHashedPassword = <cfqueryparam value="#local.encrypted_pass#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif local.queryCheck.recordCount >
            <cfset session.isAuthenticated = true>
            <cfset session.userId = local.queryCheck.fldUser_Id>
            <cfset session.roleId = local.queryCheck.fldRoleId>
            
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction name = "signUp" access = "public" returnType = "boolean">
        <cfargument  name="firstName" required="true">
        <cfargument  name="lastName" required="true">
        <cfargument  name="mail" required="true">
        <cfargument  name="phone" required="true">
        <cfargument  name="password" required="true">
        <cfargument  name="confirmPassword" required="true">
        <cfset saltString = generateSecretKey(("AES"),128)>
        <cfset saltedPassword = #arguments.password# & local.saltString.fldUserSaltString>
        <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
        
    </cffunction>

    <cffunction  name="logout" access="remote" return="void">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <cffunction name = "addCategory" access="public" returnType = "string">
        <cfargument  name="categoryName" required="true">
        <cfquery name = "local.checkCategory">
            SELECT 
                fldCategoryName    
            FROM 
                shoppingcart.tblcategory
            WHERE 
                fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
                AND fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
                AND fldActive = 1
        </cfquery>
        <cfif local.checkCategory.recordCount EQ 0> 
            <cfquery name = "local.addCategory">
                INSERT INTO shoppingcart.tblcategory(
                    fldCategoryName,
                    fldCreatedBy
                    )
                VALUES(
                    <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
            <cfreturn "Category addedd successfully">
        <cfelse>
            <cfreturn "Category should be unique">
        </cfif>
    </cffunction>

    <cffunction name = "viewCategoryData" access="public" returnType = "query" returnFormat = "json">
        <cfquery name = "viewCategory">
            SELECT fldCategory_Id,
                fldCategoryName
            FROM 
                shoppingcart.tblcategory
            WHERE 
                fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
                AND fldActive = 1
        </cfquery>
        <cfreturn viewCategory>
    </cffunction>

    <cffunction name = "viewEachCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name="categoryId">
        <cfquery name = "viewData">
            SELECT
                fldCategoryName
            FROM
                shoppingcart.tblcategory
            WHERE
                fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn viewData.fldCategoryName>
    </cffunction>

    <cffunction name = "updateCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name="categoryId">
        <cfargument  name="categoryName">
        <cfquery name = "updateCategory">
            UPDATE
                shoppingcart.tblcategory
            SET
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
            WHERE
                fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn "Updated successfully">
    </cffunction>

    <cffunction name = "delCategory" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name="categoryId">
        <cfset removedTime = "#Now()#">
        <cfquery name = "removeCategory">
            UPDATE 
                shoppingcart.tblcategory
            SET
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
            WHERE
                fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction name = "addSubCategory" access="public" returnType = "string">
        <cfargument name = "categoryId">
        <cfargument  name="subCategoryName">
        <cfquery name = "local.checkSubCategory">
            SELECT 
                fldSubCategoryName   
            FROM 
                shoppingcart.tblsubcategory
            WHERE 
                fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">
                AND fldActive = 1
        </cfquery>
        <cfif local.checkSubCategory.recordCount EQ 0> 
            <cfquery name = "local.addSubCategory">
                INSERT INTO shoppingcart.tblsubcategory(
                    fldCategoryId,
                    fldSubCategoryName,
                    fldCreatedBy
                    )
                VALUES(
                    <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
            <cfreturn "Subcategory addedd successfully">
        <cfelse>
            <cfreturn "Subcategory should be unique">
        </cfif>
    </cffunction>

    <cffunction name = "viewSubCategoryData" access="remote" returnType = "query" returnFormat = "json">
        <cfargument name = "categoryId">
        <cfquery name = "viewSubCategory">
            SELECT fldSubCategory_Id,
                fldSubCategoryName
            FROM 
                shoppingcart.tblsubcategory
            WHERE 
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">
                AND fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
                AND fldActive = 1
        </cfquery>
        <cfreturn viewSubCategory>
    </cffunction>

    <cffunction name = "viewEachSubCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name="subCategoryId">
        <cfquery name = "local.viewData">
            SELECT
                fldSubCategoryName
            FROM
                shoppingcart.tblsubcategory
            WHERE
                fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn viewData.fldSubCategoryName>
    </cffunction>

    <cffunction name = "delSubCategory" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name="subCategoryId">
        <cfset removedTime = "#Now()#">
        <cfquery name = "local.removeSubCategory">
            UPDATE 
                shoppingcart.tblsubcategory
            SET
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction name="updateSubCategory" access="remote" returnType="string" returnFormat="json">
        <cfargument name="subCategoryName">
        <cfargument name="subCategoryId">
        <cfargument name="categoryId">

        <cfquery name = "local.updateSubCategory">
            UPDATE
                shoppingcart.tblsubcategory
            SET
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">,
                fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">
            WHERE
                fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfreturn "Sub-Category updated successfully!">
    </cffunction>
    
    <cffunction name = "viewBrands" access = "remote" returnType = "query">
        <cfquery name = "viewProductBrands">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                shoppingcart.tblbrands
        </cfquery>
        <cfreturn viewProductBrands>
    </cffunction>

    <cffunction  name="createProduct" access="remote" returnType="string" returnFormat = "json">
        <cfargument  name="categoryId">
        <cfargument  name="subCategoryId">
        <cfargument  name="productName">
        <cfargument  name="productBrand">
        <cfargument  name="productPrice">
        <cfargument  name="productDescrptn">
        <cfargument  name="productImg">
        <cfargument  name="productTax"> 

        <cfquery name="local.checkProduct">
            SELECT 
                fldProduct_Id,
                fldProductName
            FROM 
                shoppingcart.tblproduct
            WHERE
                fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">
                    AND fldActive = 1
        </cfquery>

        <cfif local.checkProduct.recordCount EQ 0>
            <cfquery name="local.dataAdd" result = "keyValue">
                INSERT INTO 
                    shoppingcart.tblproduct(
                        fldSubCategoryId,
                        fldProductName,
                        fldBrandId,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy
                    ) 
                VALUES(
                    <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.productBrandId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.productDescrptn#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.productPrice#" cfsqltype="cf_sql_decimal">,
                    <cfqueryparam value="#arguments.productTax#" cfsqltype="cf_sql_decimal">,
                    #session.userId#
                )
            </cfquery>
 
            <cfset local.path = expandPath("./assets")>
            <cffile  action="uploadall" destination="#local.path#" nameConflict="makeUnique" result="uploadImg">
          
            <cfquery name = "local.prdctImg">
                INSERT INTO shoppingcart.tblproductimages (
                    fldProductId, 
                    fldImageFileName, 
                    fldDefaultImage, 
                    fldCreatedBy
                )
                VALUES 
                    <cfloop array="#uploadImg#" item="item" index="i"> 
                        (
                            <cfqueryparam value = '#keyValue.generatedKey#' cfsqltype = "cf_sql_integer" >,
                            <cfqueryparam value = '#item.serverFile#' cfsqltype = "cf_sql_varchar" >,
                            <cfif i EQ 1>
                                <cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >,
                            <cfelse>
                                <cfqueryparam value = 0 cfsqltype = "cf_sql_integer" >,
                            </cfif>
                            <cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                        )
                        <cfif i NEQ arrayLen(uploadImg)>
                            ,
                        </cfif>
                    </cfloop>
                
            </cfquery>
            <cfreturn "">
        <cfelse>
            <cfreturn "Product should be unique">
        </cfif>
    </cffunction>

    <cffunction name = "viewProduct" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "subCategoryId">
        <cfargument name="productId" required="false" default="">
        <cfquery name="local.viewProductDetails">
            SELECT 
                p.fldProduct_Id, 
                p.fldSubCategoryid, 
                p.fldProductName, 
                b.fldBrandName,
                p.fldDescription, 
                p.fldPrice, 
                p.fldTax, 
                b.fldBrand_Id,
                i.fldProductImages_Id AS imageId,
                i.fldImageFileName AS imageFileName
            FROM 
                shoppingcart.tblproduct p
            LEFT JOIN 
                shoppingcart.tblbrands b ON p.fldBrandId = b.fldBrand_Id
            LEFT JOIN 
                shoppingcart.tblproductimages i ON p.fldProduct_Id = i.fldProductId 
            WHERE
                p.fldSubCategoryid = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">
                AND p.fldActive = 1
                <cfif len(trim(arguments.productId))> 
                    AND p.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
                </cfif> 
                AND i.fldDefaultImage = 1
            ORDER BY 
                p.fldProduct_Id;
        </cfquery>
        <cfreturn local.viewProductDetails>
    </cffunction>

    <cffunction name="editProduct" access="remote" returnType="string" returnFormat="json">
        <cfargument name="productId">
        <cfargument name="subCategoryId">
        <cfargument name="productName">
        <cfargument name="productBrand">
        <cfargument name="productPrice">
        <cfargument name="productDescrptn">
        <cfargument name="productImg">
        <cfargument name="productTax">
        
        <cfset local.path = expandPath("./assets")>
        <cffile  action="uploadall" destination="#local.path#" nameConflict="makeUnique" result="uploadImg">

        <cfquery name="local.checkProduct">
            SELECT 
                fldProduct_Id,
                fldProductName 
            FROM 
                shoppingcart.tblproduct
            WHERE 
                fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
                AND fldActive = 1
        </cfquery>
    
        <cfif local.checkProduct.recordCount GT 0>
            <cfquery name="local.updateProduct">
                UPDATE 
                    shoppingcart.tblproduct
                SET 
                    fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">,
                    fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">,
                    fldBrandId = <cfqueryparam value="#arguments.productBrandId#" cfsqltype="cf_sql_integer">,
                    fldDescription = <cfqueryparam value="#arguments.productDescrptn#" cfsqltype="cf_sql_varchar">,
                    fldPrice = <cfqueryparam value="#arguments.productPrice#" cfsqltype="cf_sql_decimal">,
                    fldTax = <cfqueryparam value="#arguments.productTax#" cfsqltype="cf_sql_decimal">,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                WHERE 
                    fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfloop array="#uploadImg#" item="item" index="i">
                <cfquery name="insertProductImage">
                    INSERT INTO shoppingcart.tblproductimages (
                        fldProductId, 
                        fldImageFileName, 
                        fldDefaultImage, 
                        fldDeactivatedBy
                    )
                    VALUES (
                        <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#item.serverFile#" cfsqltype="cf_sql_varchar">,
                        0,
                        <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
            </cfloop>
            <cfreturn "Product updated successfully.">
        <cfelse>
            <cfreturn "Product does not exist or is inactive.">
        </cfif>
    </cffunction>

    <cffunction name = "delProduct" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name="productId">
        <cfset removedTime = "#Now()#">
        <cfquery name = "local.removeProduct">
            UPDATE 
                shoppingcart.tblproduct
            SET
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
            WHERE
                fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction name="getProductImages" returnType="array" access="remote" returnFormat="json">
        <cfargument name="productId" >
        <cfquery name="local.getImages" >
            SELECT 
                fldProductImages_Id,
                fldImageFileName,
                fldDefaultImage,
                fldProductId
            FROM 
                shoppingcart.tblproductimages
            WHERE 
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
                AND fldActive = 1
        </cfquery>

        <cfset var images = []>
        <cfloop query="local.getImages">
            <cfset arrayAppend(images, {
                "fldProductImages_Id" = getImages.fldProductImages_Id,
                "fldImageFileName" = getImages.fldImageFileName,
                "fldDefaultImage" = getImages.fldDefaultImage,
                "fldProductId" = getImages.fldProductId
            })>
        </cfloop>
        <cfreturn images>
    </cffunction>

    <cffunction name="setDefaultImage" access="remote" returntype="void">
        <cfargument name="productId" >
        <cfargument name="imageId" >

        <!--- Set all other images for this product to non-default --->
        <cfquery name="local.imageSetDefault">
            UPDATE 
                shoppingcart.tblproductimages
            SET 
                fldDefaultImage = 0
            WHERE 
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- Set the selected image as the default --->
        <cfquery name="local.defaultImageSet">
            UPDATE 
                shoppingcart.tblproductimages
            SET 
                fldDefaultImage = 1
            WHERE 
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
                AND fldProductImages_Id = <cfqueryparam value="#arguments.imageId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction name="deleteImage" access="remote" returntype="void">
        <cfargument name="productId">
        <cfargument name="imageId">

        <cfquery name="local.deleteImage">
            UPDATE 
                shoppingcart.tblproductimages
            SET
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
            WHERE
                fldProductImages_Id = <cfqueryparam value="#arguments.imageId#" cfsqltype="cf_sql_integer">
                AND fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
        </cfquery>

    </cffunction>
</cfcomponent>