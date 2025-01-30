<cfcomponent>
    <cffunction name = "validateLogIn" access = "public" returnType = "boolean">
        <cfargument name = "userName" required = "true" type = "string">
        <cfargument name = "userPassword" required = "true" type = "string">
        <cfset saltString = generateSecretKey(("AES"),128)> 
        <!---<cfset var emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
         <cfif (NOT REFind(emailRegex, arguments.userName)) OR (len(trim(arguments.userName)) LT 10)>
            <cfreturn false>
        <cfelseif arguments.userPassword EQ "">
            <cfreturn false>
        <cfelse>  --->
            <cfquery name = "local.saltString" datasource = "#application.datasource#">
                SELECT 
                    fldUserSaltString 
                FROM 
                    shoppingcart.tbluser
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
            </cfquery>
            <cfset saltedPassword = #arguments.userName# & local.saltString.fldUserSaltString>
            <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
            <cfquery name = "local.queryCheck" datasource = "#application.datasource#">
                SELECT fldUser_Id,
                    fldEmail,
                    fldPhone,
                    fldRoleId
                FROM 
                    shoppingcart.tbluser 
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                    AND fldHashedPassword = <cfqueryparam value="#local.encrypted_pass#" cfsqltype="varchar">
            </cfquery>
            <cfif local.queryCheck.recordCount >
                <cfset session.isAuthenticated = true>
                <cfset session.userId = local.queryCheck.fldUser_Id>
                <cfset session.roleId = local.queryCheck.fldRoleId>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        <!--- </cfif> --->
    </cffunction>

    <cffunction name = "signUp" access = "public" returnType = "boolean">
        <cfargument  name = "firstName" required = "true" type = "string">
        <cfargument  name = "lastName" required = "true" type = "string">
        <cfargument  name = "mail" required = "true" type = "string">
        <cfargument  name = "phone" required = "true" type = "string">
        <cfargument  name = "password" required = "true" type = "string">

        <cfif arguments.firstName EQ "">
            <cfreturn false>
        <cfelseif arguments.lastName EQ "">
            <cfreturn false>
        <cfelseif NOT isValidEmail("email",arguments.mail)>
            <!--- <cfthrow message="Invalid email address format." /> --->
            <cfreturn false>
        <cfelseif len(trim(arguments.phone)) LT 10>
            <!--- <cfthrow message="Invalid phone number." /> --->
            <cfreturn false>
        <cfelseif arguments.password EQ "">
            <cfreturn false>
        <cfelse>
            <cfset saltString = generateSecretKey(("AES"),128)>
            <cfset saltedPassword = #arguments.password# & #saltString#>
            <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
            <cfquery name= "local.queryCheck" datasource = "#application.datasource#">
                SELECT 
                    fldUser_Id,
                    fldEmail,
                    fldPhone
                FROM 
                    shoppingcart.tbluser
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.mail#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            </cfquery>
            <cfif local.queryCheck.recordCount EQ 0>
                <cfquery name = "insertUser" datasource = "#application.datasource#">
                    INSERT INTO shoppingcart.tbluser (
                        fldFirstName, 
                        fldLastName, 
                        fldEmail, 
                        fldPhone, 
                        fldRoleId, 
                        fldHashedPassword, 
                        fldUserSaltString        
                    ) VALUES (
                        <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.mail#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">,
                        2,
                        <cfqueryparam value="#local.encrypted_pass #" cfsqltype="varchar">,
                        <cfqueryparam value="#saltString#" cfsqltype="varchar">
                    )
                </cfquery>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        </cfif>
    </cffunction> 

    <cffunction  name="logout" access="remote" returnType="void">
        <cfset structClear(session)>
    </cffunction>

    <cffunction name = "addCategory" access="public" returnType = "string">
        <cfargument  name = "categoryName" required = "true" type = "string">
        <cfif arguments.categoryName EQ "">
            <cfreturn "Category name should be filled.">
        <cfelse>
            <cfquery name = "local.checkCategory" datasource = "#application.datasource#">
                SELECT 
                    fldCategoryName    
                FROM 
                    shoppingcart.tblcategory
                WHERE 
                    fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
                    AND fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                    AND fldActive = 1
            </cfquery>
            <cfif local.checkCategory.recordCount EQ 0> 
                <cfquery name = "local.addCategory" datasource = "#application.datasource#">
                    INSERT INTO shoppingcart.tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                        )
                    VALUES(
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#session.userId#" cfsqltype="varchar">
                    )
                </cfquery>
                <cfreturn "">
            <cfelse>
                <cfreturn "Category should be unique">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name = "viewCategoryData" access = "public" returnType = "query" returnFormat = "json">
        <cfquery name = "local.viewCategory" datasource = "#application.datasource#">
            SELECT fldCategory_Id,
                fldCategoryName
            FROM 
                shoppingcart.tblcategory
            WHERE 
                fldActive = 1
        </cfquery>
        <cfreturn local.viewCategory>
    </cffunction>

    <cffunction name = "viewEachCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfif len(trim(arguments.categoryId)) EQ 0>
            <cfreturn "Invalid Category id.Can't fetch category name.">
        <cfelse>
            <cfquery name = "local.viewData" datasource = "#application.datasource#">
                SELECT
                    fldCategoryName
                FROM
                    shoppingcart.tblcategory
                WHERE
                    fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn local.viewData.fldCategoryName>
        </cfif>
    </cffunction>

    <cffunction name = "updateCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfargument  name = "categoryName" required = "true" type = "string">
        <cfif (len(trim(arguments.categoryId)) EQ 0) AND (arguments.categoryName EQ "")>
            <cfreturn "Category updation failed">
        <cfelse>
            <cfquery name = "local.updateCategory" datasource = "#application.datasource#">
                UPDATE
                    shoppingcart.tblcategory
                SET
                    fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                WHERE
                    fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn "Updated successfully">
        </cfif>
    </cffunction>

    <cffunction name = "delCategory" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfif len(trim(arguments.categoryId)) EQ 0>
            <cfreturn "Category deactivation failed">
        <cfelse>
            <cfset removedTime = "#Now()#">
            <cfquery name = "local.removeCategory" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblcategory
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                WHERE
                    fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn void>
        </cfif>
    </cffunction>

    <cffunction name = "addSubCategory" access = "public" returnType = "string">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfargument  name = "subCategoryName" required = "true" type = "string">
        <cfif (len(trim(arguments.categoryId)) EQ 0) AND (arguments.subCategoryName EQ "")>
            <cfreturn "Failed to add sub-category">
        <cfelse>
            <cfquery name = "local.checkSubCategory" datasource = "#application.datasource#">
                SELECT 
                    fldSubCategoryName   
                FROM 
                    shoppingcart.tblsubcategory
                WHERE 
                    fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="varchar">
                    AND fldActive = 1
            </cfquery>
            <cfif local.checkSubCategory.recordCount EQ 0> 
                <cfquery name = "local.addSubCategory" datasource = "#application.datasource#">
                    INSERT INTO shoppingcart.tblsubcategory(
                        fldCategoryId,
                        fldSubCategoryName,
                        fldCreatedBy
                        )
                    VALUES(
                        <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    )
                </cfquery>
                <cfreturn "Subcategory addedd successfully">
            <cfelse>
                <cfreturn "Subcategory should be unique">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name = "viewSubCategoryData" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfif len(trim(arguments.categoryId)) EQ 0>
            <cfset resultQuery = queryNew("Invalid attempt")>
            <cfset queryAddRow(resultQuery)>
            <cfreturn resultQuery>
        <cfelse>
            <cfquery name = "local.viewSubCategory" datasource = "#application.datasource#">
                SELECT fldSubCategory_Id,
                    fldSubCategoryName
                FROM 
                    shoppingcart.tblsubcategory
                WHERE 
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfreturn local.viewSubCategory>
        </cfif>
    </cffunction>

    <cffunction name = "viewEachSubCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfif len(trim(arguments.subCategoryId)) EQ 0>
            <cfreturn "Invalid attempt">
        <cfelse>
            <cfquery name = "local.viewData" datasource = "#application.datasource#">
                SELECT
                    fldSubCategoryName
                FROM
                    shoppingcart.tblsubcategory
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn viewData.fldSubCategoryName>
        </cfif>
    </cffunction>

    <cffunction name = "delSubCategory" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfif len(trim(arguments.subCategoryId)) EQ 0>
            <cfreturn void>
        <cfelse>
            <cfset removedTime = "#Now()#">
            <cfquery name = "local.removeSubCategory" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblsubcategory
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn void>
        </cfif>
    </cffunction>

    <cffunction name="updateSubCategory" access="remote" returnType="string" returnFormat="json">
        <cfargument name = "subCategoryName" required = "true" type = "string">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfif (len(trim(arguments.subCategoryId)) EQ 0) AND (arguments.subCategoryName EQ "")>
            <cfreturn "Invalid Updation attempt">
        <cfelse>
            <cfquery name = "local.updateSubCategory" datasource = "#application.datasource#">
                UPDATE
                    shoppingcart.tblsubcategory
                SET
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">,
                    fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="varchar">
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn "Sub-Category updated successfully!">
        </cfif>
    </cffunction>
    
    <cffunction name = "viewBrands" access = "remote" returnType = "query">
        <cfquery name = "local.viewProductBrands" datasource = "#application.datasource#">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                shoppingcart.tblbrands
        </cfquery>
        <cfreturn local.viewProductBrands>
    </cffunction>

    <cffunction  name="createProduct" access="remote" returnType="string" returnFormat = "json">
        <cfargument  name = "categoryId" required = "true" type = "numeric">
        <cfargument  name = "subCategoryId" required = "true" type = "numeric">
        <cfargument  name = "productName" required = "true" type = "string">
        <cfargument  name = "productBrand" required = "true" type = "numeric" default = "0">
        <cfargument  name = "productPrice" required = "true" type = "numeric">
        <cfargument  name = "productDescrptn" required = "true" type = "string">
        <cfargument  name = "productImg" required = "true" type = "string">
        <cfargument  name = "productTax" required = "true" type = "numeric"> 
        
        <cfif len(trim(arguments.categoryId)) EQ 0>
            <cfreturn "Invalid Category id">
        <cfelseif len(trim(arguments.subCategoryId)) EQ 0>
            <cfreturn "Invalid Sub-category id">
        <cfelseif arguments.productName EQ "">
            <cfreturn "Invalid Product name">
        <cfelseif len(trim(arguments.productBrand)) EQ 0>
            <cfreturn "Invalid Brand">
        <cfelseif arguments.productPrice NEQ int(arguments.productPrice)>
            <cfreturn "Invalid Price">
        <cfelseif arguments.productDescrptn EQ "">
            <cfreturn "Invalid Product Description">
        <cfelseif arguments.productImg EQ "">
            <cfreturn "Invalid image selection">
        <cfelseif arguments.productTax NEQ int(arguments.productTax)>
            <cfreturn "Invalid Tax">
        <cfelse>
            <cfquery name="local.checkProduct" datasource = "#application.datasource#">
                SELECT 
                    fldProduct_Id,
                    fldProductName
                FROM 
                    shoppingcart.tblproduct
                WHERE
                    fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">
                        AND fldActive = 1
            </cfquery>

            <cfif local.checkProduct.recordCount EQ 0>
                <cfquery name="local.dataAdd" result = "keyValue" datasource = "#application.datasource#">
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
                        <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.productBrandId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.productDescrptn#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.productPrice#" cfsqltype="decimal">,
                        <cfqueryparam value="#arguments.productTax#" cfsqltype="decimal">,
                        #session.userId#
                    )
                </cfquery>
    
                <cfset local.path = expandPath("./assets")>
                <cffile  action="uploadall" destination="#local.path#" nameConflict="makeUnique" result="uploadImg">
            
                <cfquery name = "local.prdctImg" datasource = "#application.datasource#">
                    INSERT INTO shoppingcart.tblproductimages (
                        fldProductId, 
                        fldImageFileName, 
                        fldDefaultImage, 
                        fldCreatedBy
                    )
                    VALUES 
                        <cfloop array="#uploadImg#" item="item" index="i"> 
                            (
                                <cfqueryparam value = '#keyValue.generatedKey#' cfsqltype = "integer" >,
                                <cfqueryparam value = '#item.serverFile#' cfsqltype = "varchar" >,
                                <cfif i EQ 1>
                                    <cfqueryparam value = 1 cfsqltype = "integer">,
                                <cfelse>
                                    <cfqueryparam value = 0 cfsqltype = "integer">,
                                </cfif>
                                <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
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
        </cfif>
    </cffunction>

    <cffunction name = "viewProduct" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "subCategoryId" default = 0 required = "false" type = "integer">
        <cfargument name = "productId" default = "" required = "false" type = "string">
        <cfargument name = "sort" type = "numeric" required = "false" default = 0>
        <cfargument name = "min" type = "numeric" required = "false" default = 0>
        <cfargument name = "max" type = "numeric" required = "false" default = 0>
        <cfargument name = "minRange" type = "numeric" required = "false" default = 0>
        <cfargument name = "maxRange" type = "numeric" required = "false" default = 0>
        <cfargument name = "random" type = "numeric" required = "false" default = 0>
        <cfargument name = "searchTerm" type = "string" required = "false" default = "">
        <!--- <cfif (len(trim(arguments.subCategoryId)) EQ 0) AND (len(trim(arguments.productId)) EQ 0)>
            <cfset resultQuery = queryNew("Error occured!")>
            <cfset queryAddRow(resultQuery)>
            <cfreturn resultQuery>
        <cfelse> --->
            <cfquery name="local.viewProductDetails" datasource = "#application.datasource#">
                SELECT 
                    p.fldProduct_Id, 
                    p.fldSubCategoryId, 
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
                    p.fldActive = 1
                    <cfif arguments.random EQ 0>
                        AND i.fldDefaultImage = 1
                    <cfelse>
                        AND i.fldActive = 1
                    </cfif>
                    <cfif arguments.subCategoryId NEQ 0> 
                        AND p.fldSubCategoryid = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                    </cfif>
                    <cfif len(trim(arguments.productId)) AND isNumeric(arguments.productId)> 
                        AND p.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype = "integer">
                    </cfif>
                    <cfif arguments.max NEQ 0 AND arguments.min NEQ 0> 
                        AND p.fldPrice >= <cfqueryparam value = "#arguments.min#" cfsqltype = "integer"> 
                            AND p.fldPrice <= <cfqueryparam value = "#arguments.max#" cfsqltype = "integer">
                    </cfif>
                    <cfif arguments.maxRange NEQ 0 AND arguments.minRange NEQ 0> 
                        AND p.fldPrice >= <cfqueryparam value = "#arguments.minRange#" cfsqltype = "integer">       
                            AND p.fldPrice <= <cfqueryparam value = "#arguments.maxRange#" cfsqltype = "integer">
                    </cfif>
                    <cfif len(trim(arguments.searchTerm))> 
                        AND (p.fldProductName LIKE <cfqueryparam value = "%#arguments.searchTerm#%" cfsqltype = "varchar">
                        OR p.fldDescription LIKE <cfqueryparam value = "%#arguments.searchTerm#%" cfsqltype = "varchar">)
                    </cfif>
                ORDER BY 
                    <cfif arguments.sort EQ 2>
                        p.fldPrice ASC
                    <cfelseif arguments.sort EQ 1>
                        p.fldPrice DESC
                    <cfelse>
                        p.fldProduct_Id
                    </cfif>
                    ,i.fldDefaultImage DESC,
                    i.fldProductImages_Id ASC
            </cfquery>
            <cfreturn local.viewProductDetails>
        <!--- </cfif> --->
    </cffunction>

    <cffunction name = "subCategoryFetching" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "true">
        <cfquery name = "local.checkProduct" datasource = "#application.datasource#">
            SELECT 
                fldCategoryId,
                fldSubCategoryName
            FROM 
                shoppingcart.tblsubcategory
            WHERE 
                fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
            <cfreturn local.checkProduct>
    </cffunction>

    <cffunction name="categoryFetching" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "categoryId" type = "string" required = "true">
        <cfquery name = "local.checkProduct" datasource = "#application.datasource#">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM 
                shoppingcart.tblcategory
            WHERE 
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
            </cfquery>
            <cfreturn local.checkProduct>
    </cffunction>

    <cffunction name = "editProduct" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfargument name = "productName" required = "true" type = "string">
        <cfargument name = "productBrand" required = "true" default = "0" type = "numeric">
        <cfargument name = "productPrice" required = "true" type = "numeric">
        <cfargument name = "productDescrptn" required = "true" type = "string">
        <cfargument name = "productImg" required = "true" type = "string">
        <cfargument name = "productTax" required = "true" type = "numeric">
        
        <cfif len(trim(arguments.productId)) EQ 0>
            <cfreturn "Invalid Category id">
        <cfelseif len(trim(arguments.categoryId)) EQ 0>
            <cfreturn "Invalid Category id">
        <cfelseif len(trim(arguments.subCategoryId)) EQ 0>
            <cfreturn "Invalid Sub-category id">
        <cfelseif arguments.productName EQ "">
            <cfreturn "Invalid Product name">
        <cfelseif len(trim(arguments.productBrand)) EQ 0>
            <cfreturn "Invalid Brand">
        <cfelseif arguments.productPrice NEQ int(arguments.productPrice)>
            <cfreturn "Invalid Price">
        <cfelseif arguments.productDescrptn EQ "">
            <cfreturn "Invalid Product Description">
        <cfelseif arguments.productImg EQ "">
            <cfreturn "Invalid image selection">
        <cfelseif arguments.productTax NEQ int(arguments.productTax)>
            <cfreturn "Invalid Tax">
        <cfelse>
            <cfset local.path = expandPath("./assets")>
            <cffile  action="uploadall" destination="#local.path#" nameConflict="makeUnique" result="uploadImg">

            <cfquery name="local.checkProduct" datasource = "#application.datasource#">
                SELECT 
                    fldProduct_Id,
                    fldProductName 
                FROM 
                    shoppingcart.tblproduct
                WHERE 
                    fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
        
            <cfif local.checkProduct.recordCount GT 0>
                <cfquery name="local.updateProduct" datasource = "#application.datasource#">
                    UPDATE 
                        shoppingcart.tblproduct
                    SET 
                        fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype = "integer">,
                        fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype = "varchar">,
                        fldBrandId = <cfqueryparam value="#arguments.productBrandId#" cfsqltype = "integer">,
                        fldDescription = <cfqueryparam value="#arguments.productDescrptn#" cfsqltype = "varchar">,
                        fldPrice = <cfqueryparam value="#arguments.productPrice#" cfsqltype = "decimal">,
                        fldTax = <cfqueryparam value="#arguments.productTax#" cfsqltype = "decimal">,
                        fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype = "integer">
                    WHERE 
                        fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfquery>
                <cfloop array="#uploadImg#" item="item" index="i">
                    <cfquery name="local.insertProductImage" datasource = "#application.datasource#">
                        INSERT INTO shoppingcart.tblproductimages (
                            fldProductId, 
                            fldImageFileName, 
                            fldDefaultImage, 
                            fldDeactivatedBy
                        )
                        VALUES (
                            <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                            <cfqueryparam value = "#item.serverFile#" cfsqltype = "varchar">,
                            0,
                            <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                        )
                    </cfquery>
                </cfloop>
                <cfreturn "">
            <cfelse>
                <cfreturn "Product does not exist or is inactive.">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name = "delProduct" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfif len(trim(arguments.productId)) EQ 0>
            
        <cfelse>
            <cfset removedTime = "#Now()#">
            <cfquery name = "local.removeProduct" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblproduct
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype = "integer">
                WHERE
                    fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype = "integer">
            </cfquery>
            <cfreturn void>
        </cfif>
    </cffunction>

    <cffunction name = "getProductImages" returnType = "array" access = "remote" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfif len(trim(arguments.productId)) EQ 0>
            <cfreturn "Can't load images">
        <cfelse>
            <cfquery name="local.getImages" datasource = "#application.datasource#">
                SELECT 
                    fldProductImages_Id,
                    fldImageFileName,
                    fldDefaultImage,
                    fldProductId
                FROM 
                    shoppingcart.tblproductimages
                WHERE 
                    fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
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
        </cfif>
    </cffunction>

    <cffunction name = "setDefaultImage" access = "remote" returntype = "string">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name =  "imageId" required = "true" type = "numeric">
        <cfif (len(trim(arguments.productId)) EQ 0) AND (len(trim(arguments.imageId)) EQ 0)>
            <cfreturn "Can't set the selected image as default.">
        <cfelse>
            <!--- Set all other images for this product to non-default --->
            <cfquery name = "local.imageSetDefault" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblproductimages
                SET 
                    fldDefaultImage = 0
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
            </cfquery>

            <!--- Set the selected image as the default --->
            <cfquery name="local.defaultImageSet" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblproductimages
                SET 
                    fldDefaultImage = 1
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldProductImages_Id = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "integer">
            </cfquery>
            <cfreturn "Default image updated.">
        </cfif>
    </cffunction>

    <cffunction name = "deleteImage" access = "remote" returntype = "string">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name = "imageId" required = "true" type = "numeric">
        <cfif (len(trim(arguments.productId)) EQ 0) AND (len(trim(arguments.imageId)) EQ 0)>
            <cfreturn "Can't set the selected image as default.">
        <cfelse>
            <cfquery name = "local.deleteImage" datasource = "#application.datasource#">
                UPDATE 
                    shoppingcart.tblproductimages
                SET
                    fldActive = 0,
                    fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype="integer">
                WHERE
                    fldProductImages_Id = <cfqueryparam value = "#arguments.imageId#" cfsqltype="integer">
                    AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
            </cfquery>
            <cfreturn "">
        </cfif>
    </cffunction>

    <cffunction name="addToCart" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "string">
        <cfargument name = "quantity" required = "false" type = "numeric" default=1> 
        <cfquery name = "local.selectCartItem" datasource = "#application.datasource#">
            SELECT 
                fldUserId,
                fldProductId,
                fldQuantity
            FROM
                shoppingcart.tblcart
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="varchar">
        </cfquery>

        <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
            <cfif local.selectCartItem.recordCount EQ 0>
                <cfquery name="local.addProductToCart" datasource = "#application.datasource#">
                    INSERT INTO shoppingcart.tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity
                        ) 
                    VALUES (
                        <cfqueryparam value = "#session.userId#" cfsqltype="varchar">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype="varchar">,
                        1
                    )
                </cfquery>
            <cfelse>
                <cfquery name="local.updateProductToCart" datasource = "#application.datasource#">
                    UPDATE
                        shoppingcart.tblcart
                    SET
                       fldQuantity = <cfqueryparam value="#arguments.quantity#" cfsqltype="varchar">
                    WHERE 
                        fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
                        AND  fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="varchar">
                </cfquery>
            </cfif>
            <cfreturn "Product Added Successfully">
        <cfelse>
            <cflocation url="logIn.cfm?productId=#arguments.productId#" addToken = "false">
        </cfif>
    </cffunction>

    <cffunction name = "viewCartData" access = "remote" returnType = "query" returnFormat = "json">
        <cfquery name = "local.viewCart" datasource = "#application.datasource#">
            SELECT 
                c.fldCart_Id,
                c.fldQuantity,
                p.fldProduct_Id,
                p.fldProductName,
                p.fldDescription,
                p.fldPrice,
                p.fldTax,
                pi.fldDefaultImage,
                pi.fldImageFileName
            FROM 
                shoppingcart.tblcart c
            LEFT JOIN 
                shoppingcart.tblproduct p 
                ON c.fldProductId = p.fldProduct_Id
            LEFT JOIN 
                shoppingcart.tblproductimages pi 
                ON p.fldProduct_Id = pi.fldProductId
            WHERE 
                c.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "varchar">
                AND  pi.fldDefaultImage = 1
        </cfquery>
        <cfreturn local.viewCart>
    </cffunction>

    <cffunction name ="removeCartProduct" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument name = "cartId" required = "true" type = "numeric">
        <cfquery name = "local.removeCartData" datasource = "#application.datasource#">
            DELETE
                FROM shoppingcart.tblcart 
            WHERE
                fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
        </cfquery>
        <cfreturn void>
    </cffunction>

    <cffunction  name = "userDetailsFetching" access = "remote" returnType = "query" returnFormat = "json">
        <cfquery name = "local.userDetails" datasource = "#application.datasource#">
            SELECT 
                fldFirstName,
                fldLastName,
                fldEmail,
                fldPhone
            FROM 
                shoppingcart.tbluser 
            WHERE 
                fldUser_Id = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
        </cfquery>
        <cfreturn local.userDetails>
    </cffunction>

    <cffunction name = "userDetailsUpdating" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument  name = "userFirstName" required = "true" type = "string">
        <cfargument  name = "userLastName" required = "true" type = "string">
        <cfargument  name = "userEmail" required = "true" type = "string">
        <cfargument  name = "userPhoneNumber" required = "true" type = "string">
        
        <cfquery name="local.userDetailsUpdate" datasource = "#application.datasource#">
            UPDATE
                shoppingcart.tbluser 
            SET 
                fldFirstName = <cfqueryparam value = "#arguments.userFirstName#" cfsqltype = "varchar">,
                fldLastName = <cfqueryparam value = "#arguments.userLastName#" cfsqltype = "varchar">,
                fldEmail = <cfqueryparam value = "#arguments.userEmail#" cfsqltype = "varchar">,
                fldPhone = <cfqueryparam value = "#arguments.userPhoneNumber#" cfsqltype = "varchar">
            WHERE 
                fldUser_Id = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
        </cfquery>
        <cfreturn "Updated User details successfully">
    </cffunction>

    <cffunction  name="addUserAddress" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument  name = "userFirstName" required = "true" type = "string">
        <cfargument  name = "userLastName" required = "true" type = "string">
        <cfargument  name = "addressLine1" required = "true" type = "string">
        <cfargument  name = "addressLine2" required = "true" type = "string">
        <cfargument  name = "userCity" required = "true" type = "string">
        <cfargument  name = "userState" required = "true" type = "string">
        <cfargument  name = "userPincode" required = "true" type = "string">
        <cfargument  name = "userPhoneNumber" required = "true" type = "string">

        <cfquery name = "addAddress" datasource = "#application.datasource#">
            INSERT INTO shoppingcart.tbladdress(
                fldUserId,
                fldFirstName,
                fldLastName,
                fldAdressLine1,
                fldAdressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
                ) 
            VALUES (
                <cfqueryparam value="#session.userId#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userFirstName#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userLastName#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.addressLine1#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.addressLine2#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userCity#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userState#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userPincode#" cfsqltype="varchar">,
                <cfqueryparam value="#arguments.userPhoneNumber#" cfsqltype="varchar">
                );

        </cfquery>
        <cfreturn "Address addedd successfully.">
    </cffunction>

    <cffunction  name = "fetchUserAddress" access = "public" returnType = "query">
        <cfargument name = "addressId" required = "false" type = "string" default="">
        <cfquery name = "local.addressFetching" datasource = "#application.datasource#">
            SELECT
                fldAddress_Id,
                fldFirstName,
                fldLastName,
                fldAdressLine1,
                fldAdressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
            FROM 
                shoppingcart.tbladdress
            WHERE
                fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
                AND fldActive = 1
                <cfif arguments.addressId NEQ "">
                    AND fldAddress_Id = <cfqueryparam value="#arguments.addressId#" cfsqltype="varchar">
                </cfif>
        </cfquery>
        <cfreturn local.addressFetching>
    </cffunction>

    <cffunction name = "removeUserAddress" access = "remote" returnType = "void" returnFormat = "json">
        <cfargument  name = "addressId" required = "true" type = "numeric">
        <cfquery name = "removeAddress" datasource = "#application.datasource#">
            UPDATE 
                shoppingcart.tbladdress
            SET 
                fldActive = 0
            WHERE 
                fldAddress_Id = <cfqueryparam value = "#arguments.addressId#" cfsqltype="integer">
        </cfquery>
        <cfreturn void>
    </cffunction>

    <cffunction name = "vieworderPayment" access = "remote" returnType = "query" returnFormat="json">
    <cfargument name = "addressId" required = "true" type = "string">
    <cfargument name = "totalPrice" required = "true" type = "numeric">
    <cfargument name = "totalTax" required = "true" type = "numeric">
    <cfargument name = "productId" required = "false" type = "string" default = "">
    <cfargument name = "cardNumber" required = "true" type = "numeric">
    <cfargument name = "cvv" required = "true" type = "numeric">
    
    <cfset paymentNumber = 1111111>
    <cfset paymentCvv = 101>

    <cfif (arguments.cardNumber EQ paymentNumber) AND (arguments.cardNumber EQ paymentCvv)>
        
        <cfquery name="orderDetailsInserting">
            INSERT INTO shoppingcart.tblorder(
                fldUserId,
                fldAddressId,
                fldTotalPrice,
                fldTotalTax
            )
            VALUES(
                <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">,
                <cfqueryparam value="#arguments.totalPrice#" cfsqltype="decimal">,
                <cfqueryparam value="#arguments.totalTax#" cfsqltype="decimal">
            )
        </cfquery>
        
        <cfset orderId = orderDetailsInserting.Identity>
        
        <cfif len(arguments.productId) GT 0>
            <cfquery name="orderItemInserting">
                INSERT INTO shoppingcart.tblorderitems (
                    fldOrderId,
                    fldProductId,
                    fldQuantity,
                    fldUnitPrice,
                    fldUnitTax
                )
                VALUES (
                    <cfqueryparam value="#orderId#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                    <cfqueryparam value="1" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.totalPrice#" cfsqltype="decimal">,
                    <cfqueryparam value="#arguments.totalTax#" cfsqltype="decimal">
                )
            </cfquery>
        <cfelse>
            <cfquery name="getCartData" datasource="#application.datasource#">
                SELECT 
                    c.fldCart_Id,
                    c.fldQuantity,
                    p.fldProduct_Id,
                    p.fldPrice,
                    p.fldTax
                FROM 
                    shoppingcart.tblcart c
                LEFT JOIN 
                    shoppingcart.tblproduct p 
                    ON c.fldProductId = p.fldProduct_Id
                WHERE 
                    c.fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="varchar">
            </cfquery>
            
            <cfloop query="getCartData">
                <cfquery name="orderItemInserting">
                    INSERT INTO shoppingcart.tblorderitems (
                        fldOrderId,
                        fldProductId,
                        fldQuantity,
                        fldUnitPrice,
                        fldUnitTax
                    )
                    VALUES (
                        <cfqueryparam value="#orderId#" cfsqltype="varchar">,
                        <cfqueryparam value="#getCartData.fldProduct_Id#" cfsqltype="integer">,
                        <cfqueryparam value="#getCartData.fldQuantity#" cfsqltype="integer">,
                        <cfqueryparam value="#getCartData.fldPrice#" cfsqltype="decimal">,
                        <cfqueryparam value="#getCartData.fldTax#" cfsqltype="decimal">
                    )
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
</cffunction>

</cfcomponent>