<cfcomponent>

    <cffunction name = "encryptUrl" access = "public" returnType = "string">
        <cfargument name = "plainData" type = "string" required = "true">
        <cfreturn encrypt(arguments.plainData,application.key,"AES","BASE64")>
    </cffunction>

    <cffunction name = "decryptUrl" access = "public" returnType = "string">
        <cfargument name = "encryptedData" type = "string" required = "true">
        <cfreturn decrypt(arguments.encryptedData,application.key,"AES","BASE64")>
    </cffunction>

    <cffunction name = "validateLogIn" access = "public" returnType = "boolean">
        <cfargument name = "userName" required = "true" type = "string">
        <cfargument name = "userPassword" required = "true" type = "string">
        <cfset saltString = generateSecretKey(("AES"),128)> 
        <cfif NOT isValid("email",arguments.userName) AND len(trim(arguments.userName)) LT 10>
            <cfreturn false>
        <cfelseif len(trim(arguments.userPassword)) EQ 0>
            <cfreturn false>
        <cfelse>  
            <cfquery name = "local.saltString" datasource = "#application.datasource#">
                SELECT 
                    fldUserSaltString 
                FROM 
                    tbluser
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
            </cfquery>
            <cfset saltedPassword = arguments.userPassword & local.saltString.fldUserSaltString>
            <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
            <cfquery name = "local.queryCheck" datasource = "#application.datasource#">
                SELECT fldUser_Id,
                    fldFirstName,
                    fldLastName,
                    fldEmail,
                    fldPhone,
                    fldRoleId
                FROM 
                    tbluser 
                WHERE 
                    fldHashedPassword = <cfqueryparam value="#local.encrypted_pass#" cfsqltype="varchar">
                    AND (fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                        OR fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">)           
            </cfquery>
            <cfif local.queryCheck.recordCount >
                <cfset session.isAuthenticated = true>
                <cfset session.userId = local.queryCheck.fldUser_Id>
                <cfset session.roleId = local.queryCheck.fldRoleId>
                <cfset session.userName = local.queryCheck.fldFirstName & local.queryCheck.fldLastName>
                <cfset session.mail = local.queryCheck.fldEmail>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="signUp" access="remote" returnType="struct" returnFormat = "json">
        <cfargument name="firstName" required="true" type="string">
        <cfargument name="lastName" required="true" type="string">
        <cfargument name="mail" required="true" type="string">
        <cfargument name="phone" required="true" type="string">
        <cfargument name="password" required="true" type="string">

        <cfset var errorMessages = structNew()>
        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset errorMessages["firstName"] = "First name is required.">
        </cfif>
        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset errorMessages["lastName"] = "Last name is required.">
        </cfif>
        <cfif NOT isValid("email", arguments.mail)>
            <cfset errorMessages["mail"] = "Invalid email address.">
        </cfif>
        <cfif (len(trim(arguments.phone)) EQ 0) AND (val(arguments.phone) EQ false)>
            <cfset errorMessages["phone"] = "Invalid Number.">
        </cfif>
        <cfif len(trim(arguments.password)) EQ 0>
            <cfset errorMessages["password"] = "Password is required.">
        </cfif>
        <cfif structCount(errorMessages) GT 0>
            <cfreturn errorMessages>
        <cfelse>
            <cfset saltString = generateSecretKey("AES", 128)>
            <cfset saltedPassword = arguments.password & saltString>
            <cfset local.encrypted_pass = Hash(saltedPassword, "SHA-256")>

            <cfquery name="local.queryCheck" datasource="#application.datasource#">
                SELECT 
                    fldUser_Id,
                    fldEmail,
                    fldPhone
                FROM 
                    tbluser
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.mail#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            </cfquery>

            <cfif local.queryCheck.recordCount EQ 0>
                <cfquery name="insertUser" datasource="#application.datasource#">
                    INSERT INTO tbluser (
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
                        <cfqueryparam value="#local.encrypted_pass#" cfsqltype="varchar">,
                        <cfqueryparam value="#saltString#" cfsqltype="varchar">
                    )
                </cfquery>
                <cfreturn { "success": true ,"message": "Registered successfully"}>
            <cfelse>
                <cfreturn { "success": false, "message": "Email or phone number already exists." }>
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="logout" access="remote" returnType="void">
        <cfset structClear(session)>
    </cffunction>

    <cffunction name="saveCategory" access="remote" returnType="string" returnFormat = "json">
        <cfargument name="operation" required="true" type="string">
        <cfargument name="categoryName" required="true" type="string">
        <cfargument name="categoryId" required="false" type="numeric" default=0>
        <cfif len(trim(arguments.categoryName)) EQ 0>
            <cfreturn "Category name should be filled.">
        </cfif>
        <cfif NOT reFind("^[a-zA-Z]+$", arguments.categoryName)>
            <cfreturn "Category name should contain only alphabets and should not be empty.">
        </cfif>
        <cfquery name="local.checkCategory" datasource="#application.datasource#">
            SELECT 
                fldCategoryName    
            FROM 
                tblcategory
            WHERE 
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                AND fldActive = 1
                <cfif arguments.operation EQ "update">
                    AND fldCategory_Id != <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
        </cfquery>

        <cfif local.checkCategory.recordCount EQ 0>
            <cfif arguments.operation EQ "add">
                <cfquery name="local.addCategory" datasource="#application.datasource#">
                    INSERT INTO tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                    )
                    VALUES(
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    )
                </cfquery>
                <cfreturn "Category added successfully.">
            <cfelseif arguments.operation EQ "update">
                <cfquery name="local.updateCategory" datasource="#application.datasource#">
                    UPDATE
                        tblcategory
                    SET
                        fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                    WHERE
                        fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfquery>
                <cfreturn "Category updated successfully.">
            </cfif>
        <cfelse>
            <cfreturn "Category name should be unique.">
        </cfif>
    </cffunction>

    <cffunction name = "viewCategoryData" access = "public" returnType = "query" returnFormat = "json">
        <cfquery name = "local.viewCategory" datasource = "#application.datasource#">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM 
                tblcategory
            WHERE 
                fldActive = 1
        </cfquery>
        <cfreturn local.viewCategory>
    </cffunction>

    <cffunction name = "saveSubCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "operation" required = "true" type = "string">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfargument name = "subCategoryName" required = "true" type = "string">
        <cfargument name = "subCategoryId" required = "false" type = "numeric" default = 0>
        
        <cfif len(trim(arguments.subCategoryName)) EQ 0>
            <cfreturn "Failed to add or update sub-category: Name cannot be empty">
        </cfif>
        <cfif NOT reFind("^[a-zA-Z]+$", arguments.subCategoryName)>
            <cfreturn "sub category name should contain only alphabets and should not be empty.">
        </cfif>
        <cfquery name = "local.checkSubCategory" datasource = "#application.datasource#">
            SELECT 
                fldSubCategoryName   
            FROM 
                tblsubcategory
            WHERE 
                fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="varchar">
                AND fldActive = 1
                <cfif arguments.operation EQ "update">
                    AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                    AND fldSubCategory_Id <> <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                <cfelse>
                    AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
        </cfquery>

        <cfif local.checkSubCategory.recordCount EQ 0>
            <cfif arguments.operation EQ "add">
                <cfquery name = "local.addSubCategory" datasource = "#application.datasource#">
                    INSERT INTO tblsubcategory(
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
                <cfreturn "Subcategory added successfully">
            <cfelseif arguments.operation EQ "update">
                <cfquery name = "local.updateSubCategory" datasource = "#application.datasource#">
                    UPDATE
                        tblsubcategory
                    SET
                        fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">,
                        fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="varchar">
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                </cfquery>
                <cfreturn "Sub-category updated successfully!">
            </cfif>
        <cfelse>
            <cfreturn "Sub-category should be unique">
        </cfif>
    </cffunction>

    <cffunction name="viewSubCategoryData" access="remote" returnType="struct" returnFormat="json">
        <cfargument name="categoryId" required="true" type="numeric">
        <cfset var result = structNew()>
        <cfif isValid("integer",arguments.categoryId) EQ false>
            <cfset result["message"] = "Invalid attempt - categoryId is required">
            <cfset result["data"] = []>
            <cfreturn result>
        <cfelse>
            <cfquery name="local.viewSubCategory" datasource="#application.datasource#">
                SELECT 
                    fldSubCategory_Id,
                    fldSubCategoryName,
                    fldCategoryId
                FROM 
                    tblsubcategory
                WHERE 
                    fldActive = 1
                    <cfif arguments.categoryId NEQ 0>
                        AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                    </cfif>
            </cfquery>
            <cfset result["message"] = "Success">
            <cfset result["data"] = arrayNew(1)>
            <cfloop query="local.viewSubCategory">
                <cfset arrayAppend(result["data"], {
                    "fldSubCategory_Id" = local.viewSubCategory.fldSubCategory_Id,
                    "fldSubCategoryName" = local.viewSubCategory.fldSubCategoryName,
                    "fldCategoryId" = local.viewSubCategory.fldCategoryId
                })>
            </cfloop>
            <cfreturn result>
        </cfif>
    </cffunction>

    <cffunction name = "viewBrands" access = "remote" returnType = "query">
        <cfquery name = "local.viewProductBrands" datasource = "#application.datasource#">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                tblbrands
        </cfquery>
        <cfreturn local.viewProductBrands>
    </cffunction>

    <cffunction name="createProduct" access="remote" returnType="string" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfargument name = "productName" required = "true" type = "string">
        <cfargument name = "productBrand" required = "true" type = "numeric" default = "0">
        <cfargument name = "productPrice" required = "true" type = "numeric">
        <cfargument name = "productDescrptn" required = "true" type = "string">
        <cfargument name = "productImg" required = "true" type = "string">
        <cfargument name = "productTax" required = "true" type = "numeric"> 
        
        <cfset var errorMessages = structNew()>
        <cfif val(arguments.categoryId) EQ false>
            <cfset errorMessages["categoryId"] = "Invalid category id.">
        </cfif>
        <cfif val(arguments.subCategoryId) EQ false>
            <cfset errorMessages["subCategoryId"] = "Invalid sub-category id.">
        </cfif>
        <cfif len(trim(arguments.productName)) EQ 0>
            <cfset errorMessages["productName"] = "Invalid product name.">
        </cfif>
        <cfif len(trim(arguments.productBrand)) EQ 0>
            <cfset errorMessages["productBrand"] = "Invalid brand.">
        </cfif>
        <cfif arguments.productPrice NEQ int(arguments.productPrice)>
            <cfset errorMessages["productPrice"] = "Invalid product price.">
        </cfif>
        <cfif len(trim(arguments.productDescrptn)) EQ 0>
            <cfset errorMessages["productDescrptn"] = "Invalid product descrptn.">
        </cfif>
        <cfif (len(trim(arguments.productImg)) EQ 0)>
            <cfset errorMessages["productImg"] = "Invalid Image selection.">
        </cfif>
        <cfif arguments.productTax NEQ int(arguments.productTax)>
            <cfset errorMessages["productTax"] = "Invalid product tax.">
        </cfif>
        <cfif structCount(errorMessages) GT 0>
            <cfreturn errorMessages>
        <cfelse>
            <cfquery name="local.checkProduct" datasource = "#application.datasource#">
                SELECT 
                    fldProduct_Id,
                    fldProductName
                FROM 
                    tblproduct
                WHERE
                    fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">
                        AND fldActive = 1
            </cfquery>

            <cfif local.checkProduct.recordCount EQ 0>
                <cfquery name="local.dataAdd" result = "keyValue" datasource = "#application.datasource#">
                    INSERT INTO 
                        tblproduct(
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
                        <cfqueryparam value="#session.userId#" cfsqltype = "integer">
                    )
                </cfquery>
    
                <cfset local.path = expandPath("./assets")>
                <cffile action="uploadall" destination="#local.path#" nameConflict="makeUnique" result="uploadImg">
            
                <cfquery name = "local.prdctImg" datasource = "#application.datasource#">
                    INSERT INTO tblproductimages (
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
        <cfargument name="limit" type="numeric" required="false" default="5">  
        <cfargument name="offset" type="numeric" required="false" default="0">
        <cfargument name="randomProducts" type="boolean" required="false" default="false">
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
                tblproduct p
            INNER JOIN tblbrands b ON b.fldBrand_Id = p.fldBrandId
            INNER JOIN tblproductimages i ON i.fldProductId = p.fldProduct_Id
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
                <cfelseif arguments.randomProducts EQ true>
                    RAND()
                <cfelse>
                    p.fldProduct_Id
                </cfif>,
                i.fldDefaultImage DESC,
                i.fldProductImages_Id ASC
                LIMIT <cfqueryparam value="#arguments.offset#" cfsqltype="integer">,
                <cfqueryparam value="#arguments.limit#" cfsqltype="integer">    
        </cfquery>
        <cfreturn local.viewProductDetails>
    </cffunction>

    <cffunction name = "subCategoryFetching" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "true">
        <cfquery name = "local.checkProduct" datasource = "#application.datasource#">
            SELECT 
                fldCategoryId,
                fldSubCategoryName
            FROM 
                tblsubcategory
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
                tblcategory
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
        <cfelseif len(trim(arguments.productName)) EQ 0>
            <cfreturn "Invalid Product name">
        <cfelseif len(trim(arguments.productBrand)) EQ 0>
            <cfreturn "Invalid Brand">
        <cfelseif arguments.productPrice NEQ int(arguments.productPrice)>
            <cfreturn "Invalid Price">
        <cfelseif len(trim(arguments.productDescrptn)) EQ 0>
            <cfreturn "Invalid Product Description">
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
                    tblproduct
                WHERE 
                    fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
        
            <cfif local.checkProduct.recordCount GT 0>
                <cfquery name="local.updateProduct" datasource = "#application.datasource#">
                    UPDATE 
                        tblproduct
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
                        INSERT INTO tblproductimages (
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
                    tblproductimages
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
            <!--- Set all other images to non-default --->
            <cfquery name = "local.imageSetDefault" datasource = "#application.datasource#">
                UPDATE 
                    tblproductimages
                SET 
                    fldDefaultImage = 0
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
            </cfquery>

            <!--- Set the selected image as default --->
            <cfquery name="local.defaultImageSet" datasource = "#application.datasource#">
                UPDATE 
                    tblproductimages
                SET 
                    fldDefaultImage = 1
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldProductImages_Id = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "integer">
            </cfquery>
            <cfreturn "Default image updated.">
        </cfif>
    </cffunction>

    <cffunction name = "deleteImage" access = "remote" returntype = "string" returnFormat="json">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name = "imageId" required = "true" type = "numeric">
        <cfif (len(trim(arguments.productId)) EQ 0) AND (len(trim(arguments.imageId)) EQ 0)>
            <cfreturn "Can't set the selected image as default.">
        <cfelse>
            <cfquery name = "local.deleteImage" datasource = "#application.datasource#">
                UPDATE 
                    tblproductimages
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

    <cffunction name = "addToCart" access = "remote" returnType = "boolean" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "numeric" default = 0>
        <cfargument name = "quantity" required = "false" type = "numeric" default = 1>
        <cfargument name = "cartToken" required = "false" type = "numeric" default = 0>  
        <cftry>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                
                <cfquery name = "local.selectCartItem" datasource = "#application.datasource#">
                    SELECT 
                        fldUserId,
                        fldProductId,
                        fldQuantity
                    FROM
                        tblcart
                    WHERE
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
                        AND fldUserId = <cfqueryparam value ="#session.userId#" cfsqltype="integer">
                </cfquery>

                <cfif (local.selectCartItem.recordCount EQ 0) AND (len(trim(arguments.productId)) NEQ 0)>
                    <cfquery name="local.addProductToCart" datasource = "#application.datasource#">
                        INSERT INTO tblcart(
                            fldUserId,
                            fldProductId,
                            fldQuantity
                            ) 
                        VALUES (
                            <cfqueryparam value = "#session.userId#" cfsqltype="integer">,
                            <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">,
                            1
                        )
                    </cfquery>
                <cfelseif (arguments.quantity EQ 1) AND (arguments.cartToken EQ 1)>
                    <cfquery name="local.updateProductToCart" datasource = "#application.datasource#">
                        UPDATE
                            tblcart
                        SET
                            fldQuantity = "#local.selectCartItem.fldQuantity#" + 1
                        WHERE 
                            fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                            AND fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                    </cfquery>
                <cfelse>
                    <cfquery name="local.updateProductToCart" datasource = "#application.datasource#">
                        UPDATE
                            tblcart
                        SET
                            fldQuantity = <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                        WHERE 
                            fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                            AND  fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                    </cfquery>
                </cfif>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        <cfcatch type="any">
            <cfreturn false>
        </cfcatch>
        </cftry>
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
                tblcart c
            INNER JOIN tblproduct p ON p.fldProduct_Id = c.fldProductId
            INNER JOIN tblproductimages pi ON pi.fldProductId = p.fldProduct_Id
            WHERE 
                c.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                AND  pi.fldDefaultImage = 1
                AND p.fldActive = 1
        </cfquery>
        <cfreturn local.viewCart>
    </cffunction>

    <cffunction name ="removeCartProduct" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "cartId" required = "true" type = "numeric">
        <cftry>
            <cfif trim(len(arguments.cartId)) EQ 0>
                <cfreturn "select Product to remove">
            <cfelse>
                <cfquery name = "local.removeCartData" datasource = "#application.datasource#">
                    DELETE
                        FROM tblcart 
                    WHERE
                        fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
                </cfquery>
                <cfreturn "Product removed">
            </cfif>
        <cfcatch type="any">
            <cfreturn "An error occurred: #cfcatch.message#">
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "userDetailsFetching" access = "remote" returnType = "query" returnFormat = "json">
        <cfquery name = "local.userDetails" datasource = "#application.datasource#">
            SELECT 
                fldFirstName,
                fldLastName,
                fldEmail,
                fldPhone
            FROM 
                tbluser 
            WHERE 
                fldUser_Id = <cfqueryparam value="#session.userId#" cfsqltype="integer">
        </cfquery>
        <cfreturn local.userDetails>
    </cffunction>

    <cffunction name = "userDetailsUpdating" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "userFirstName" required = "true" type = "string">
        <cfargument name = "userLastName" required = "true" type = "string">
        <cfargument name = "userEmail" required = "true" type = "string">
        <cfargument name = "userPhoneNumber" required = "true" type = "string">
        <cftry>
            <cfif len(trim(arguments.userFirstName)) EQ 0>
                <cfreturn "Enter User First Name">
            <cfelseif len(trim(arguments.userLastName)) EQ 0>
                <cfreturn "Enter User Last Name">
            <cfelseif len(trim(arguments.userEmail)) EQ 0>
                <cfreturn "Enter Mail Id">
            <cfelseif len(trim(arguments.userPhoneNumber)) LT 10>
                <cfreturn "Enter PhoneNumber">
            <cfelse>
                <cfquery name="local.queryCheck" datasource="#application.datasource#">
                    SELECT 
                        fldUser_Id
                    FROM 
                        tbluser
                    WHERE 
                        (fldEmail = <cfqueryparam value="#arguments.userEmail#" cfsqltype="varchar">
                        OR fldPhone = <cfqueryparam value="#arguments.userPhoneNumber#" cfsqltype="varchar">)
                        AND fldUser_Id != <cfqueryparam value="#session.userId#" cfsqltype="varchar">
                </cfquery>
                <cfif local.queryCheck.recordCount EQ 0>
                    <cfquery name="local.userDetailsUpdate" datasource = "#application.datasource#">
                        UPDATE
                            tbluser 
                        SET 
                            fldFirstName = <cfqueryparam value = "#arguments.userFirstName#" cfsqltype = "varchar">,
                            fldLastName = <cfqueryparam value = "#arguments.userLastName#" cfsqltype = "varchar">,
                            fldEmail = <cfqueryparam value = "#arguments.userEmail#" cfsqltype = "varchar">,
                            fldPhone = <cfqueryparam value = "#arguments.userPhoneNumber#" cfsqltype = "varchar">
                        WHERE 
                            fldUser_Id = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    </cfquery>
                    <cfreturn "Updated User details successfully">
                <cfelse>
                    <cfreturn "Email and Phone should be unique">
                </cfif>
            </cfif>
        <cfcatch type="any">
            <cfreturn "An error occurred: #cfcatch.message#">
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addUserAddress" access = "remote" returnType = "struct" returnFormat = "json">
        <cfargument name = "userFirstName" required = "true" type = "string">
        <cfargument name = "userLastName" required = "true" type = "string">
        <cfargument name = "addressLine1" required = "true" type = "string">
        <cfargument name = "addressLine2" required = "true" type = "string">
        <cfargument name = "userCity" required = "true" type = "string">
        <cfargument name = "userState" required = "true" type = "string">
        <cfargument name = "userPincode" required = "true" type = "string">
        <cfargument name = "userPhoneNumber" required = "true" type = "string">

        <cfset var errorMessages = structNew()>
        <cftry>
            <cfif len(trim(arguments.userFirstName)) EQ 0>
                <cfset errorMessages["userFirstName"] ="Enter User First Name">
            </cfif>
            <cfif len(trim(arguments.userLastName)) EQ 0>
                <cfset errorMessages["userLastName"] ="Enter User Last Name">
            </cfif>
            <cfif len(trim(arguments.addressLine1)) EQ 0>
                <cfset errorMessages["addressLine1"] ="Enter User Address Line 1">
            </cfif>
            <cfif len(trim(arguments.addressLine2)) EQ 0>
                <cfset errorMessages["addressLine2"] ="Enter User Address Line 2">
            </cfif>
            <cfif len(trim(arguments.userCity)) EQ 0>
                <cfset errorMessages["userCity"] ="Enter City">
            </cfif>
            <cfif len(trim(arguments.userState)) EQ 0>
                <cfset errorMessages["userState"] ="Enter State">
            </cfif>
            <cfif len(trim(arguments.userPincode)) EQ 0>
                <cfset errorMessages["userPincode"] ="Enter Pincode">
            </cfif>
            <cfif len(trim(arguments.userPhoneNumber)) LT 10>
                <cfset errorMessages["userPhoneNumber"] ="Enter PhoneNumber">
            </cfif>
            <cfif structCount(errorMessages) GT 0>
                <cfreturn errorMessages>
            <cfelse>
                <cfquery name = "addAddress" datasource = "#application.datasource#">
                    INSERT INTO tbladdress(
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
                        <cfqueryparam value="#session.userId#" cfsqltype="integer">,
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
                <cfreturn { "success": true ,"message": "Registered successfully"}>
            </cfif>
        <cfcatch type="any">
            <cfreturn { "success": false, "message": "An unexpected error occurred: #cfcatch.message#" }>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "fetchUserAddress" access = "public" returnType = "query">
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
                tbladdress
            WHERE
                fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                AND fldActive = 1
                <cfif val(arguments.addressId) NEQ false>
                    AND fldAddress_Id = <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfreturn local.addressFetching>
    </cffunction>

    <cffunction name = "removeUserAddress" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "addressId" required = "true" type = "numeric">
        <cftry>
            <cfif val(arguments.addressId) EQ false>
                <cfreturn "select address to remove">
            <cfelse>
                <cfquery name = "removeAddress" datasource = "#application.datasource#">
                    UPDATE 
                        tbladdress
                    SET 
                        fldActive = 0
                    WHERE 
                        fldAddress_Id = <cfqueryparam value = "#arguments.addressId#" cfsqltype="integer">
                </cfquery>
                <cfreturn "">
            </cfif>
        <cfcatch type="any">
            <cfreturn "An error occurred: #cfcatch.message#">
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addOrderPayment" access="remote" returnType="string" returnFormat="json">
        <cfargument name="addressId" required="true" type="numeric">
        <cfargument name="totalPrice" required="true" type="numeric">
        <cfargument name="totalTax" required="true" type="numeric">
        <cfargument name="productId" required="false" type="numeric" default="0">
        <cfargument name="cardNumber" required="true" type="numeric">
        <cfargument name="cvv" required="true" type="numeric">
        <cfargument name="unitPrice" required="true" type="numeric">
        <cfargument name="unitTax" required="true" type="numeric">
        
        <cftry>
            <cfif trim(len(arguments.addressId)) EQ 0>
                <cfreturn "select address">
            <cfelseif trim(len(arguments.totalPrice)) EQ 0>
                <cfreturn "select Product">
            <cfelseif trim(len(arguments.totalTax)) EQ 0>
                <cfreturn "select Product">
            <cfelseif trim(len(arguments.cardNumber)) EQ 0>
                <cfreturn "Enter card details">
            <cfelseif trim(len(arguments.cvv)) EQ 0>
                <cfreturn "Enter card details">
            <cfelse>
                <cfif (arguments.cardNumber EQ 4321) AND (arguments.cvv EQ 434)>
                    <cfstoredproc procedure="sp_AddOrderPayment" datasource="#application.datasource#">
                        <cfprocparam type="in" value="#session.userId#" cfsqltype="integer">
                        <cfprocparam type="in" value="#arguments.addressId#" cfsqltype="integer">
                        <cfprocparam type="in" value="#arguments.totalPrice#" cfsqltype="decimal">
                        <cfprocparam type="in" value="#arguments.totalTax#" cfsqltype="decimal">
                        <cfprocparam type="in" value="#arguments.productId#" cfsqltype="integer">
                        <cfprocparam type="in" value="#arguments.unitPrice#" cfsqltype="decimal">
                        <cfprocparam type="in" value="#arguments.unitTax#" cfsqltype="decimal">
                        <cfprocparam type="out" variable="v_OrderId" cfsqltype="varchar">
                    </cfstoredproc>
                    <cfset orderId = v_OrderId>
                    
                    <cfset orderDetails = fetchOrderDetails(orderId = orderId)>

                    <cfset productDetailsHTML = "<ul>" />
                    
                    <cfloop query="#orderDetails#">
                        <cfset productDetailsHTML = productDetailsHTML & "<li>#fldProductName# (Qty: #fldQuantity#) - $ #fldUnitPrice#</li>" />
                    </cfloop>
                    
                    <cfset productDetailsHTML = productDetailsHTML & "</ul>" />
                    <cfmail to="#session.mail#"
                            from="myCart@myCart.com" 
                            subject="Order Confirmation"
                            type="html">
                        <p>Hi #session.userName#</p>
                        <p>Thank you for your purchase!</p>
                        <p>Your order details are as follows:</p>
                        #productDetailsHTML#
                    </cfmail>

                    <cfset result = "Order placed successfully.">
                <cfelse>
                    <cfset result = "Invalid card details">
                </cfif>
            </cfif>
        <cfcatch type="any">
            <cfset result = "#cfcatch.message#">
        </cfcatch>
        </cftry>
        <cfreturn result>
    </cffunction>

    <cffunction  name="fetchOrderDetails" access="public" returnType = "query">
        <cfargument name = "orderId" required = "false" type = "string" default="">
        <cfargument name = "orderIdList" required = "false" type = "string" default="">
        <cfargument name = "searchId" required = "false" type = "string" default="">
        <cfargument name="limit" required="false" type="numeric" default="5">
        <cfargument name="offset" required="false" type="numeric" default="0">

        
        <cfquery name = "orderHistoryData" datasource = "#application.datasource#">
            SELECT 
                o.fldOrder_Id,
                o.fldTotalPrice,
                o.fldTotalTax,
                DATE_FORMAT(o.fldOrderDate,'%d-%m-%Y') AS formattedDate,
                oi.fldQuantity,
                oi.fldUnitPrice,
                a.fldFirstName AS addressFirstName,
                a.fldLastName AS addressLastName,
                a.fldAdressLine1,
                a.fldAdressLine2,
                a.fldCity,
                a.fldState,
                a.fldPincode,
                a.fldPhoneNumber,
                p.fldProductName,
                p.fldTax AS productTax,
                pi.fldImageFileName
            FROM 
                tblorder o
            INNER JOIN tblorderitems oi ON oi.fldOrderId = o.fldOrder_Id
            INNER JOIN tbladdress a ON a.fldAddress_Id = o.fldAdressId
            INNER JOIN tblproduct p ON p.fldProduct_Id = oi.fldProductId
            INNER JOIN tblproductimages pi ON pi.fldProductId = p.fldProduct_Id AND pi.fldDefaultImage = 1
            WHERE
                o.fldUserId = <cfqueryparam value="#session.UserId#" cfsqltype = "integer">
                <cfif trim(len(arguments.orderId))>
                    AND fldOrder_Id = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar">
                </cfif>
                <cfif trim(len(arguments.searchId))>
                    AND fldOrder_Id LIKE <cfqueryparam value = "%#arguments.searchId#%" cfsqltype = "varchar">
                </cfif>
                <cfif trim(len(arguments.orderIdList))>
                    AND fldOrder_Id = <cfqueryparam value = "#arguments.orderIdList#" cfsqltype = "varchar">
                </cfif>
            ORDER BY 
                o.fldOrderDate DESC
                LIMIT <cfqueryparam value="#arguments.offset#" cfsqltype="numeric">,
                <cfqueryparam value="#arguments.limit#" cfsqltype="numeric">
        </cfquery>
        <cfreturn orderHistoryData>
    </cffunction>

    <cffunction name="downloadOrderData" access="remote" returnType = "query" returnFormat="json">
        <cfargument name = "orderId" required = "true" type = "string" default="">
        <cfset orderHistoryData = fetchOrderDetails(orderId)>
        <cfdocument format="pdf" filename="../assets1/createdPdf.pdf" overwrite="yes">
            <cfoutput>
                <h3>Invoice for Order : #orderHistoryData.fldOrder_Id#</h3>
                <p>Order Date: #orderHistoryData.formattedDate#</p>
                <p>Total Price: $#orderHistoryData.fldTotalPrice#</p>
                <p>Shipping Address: #orderHistoryData.addressFirstName# #orderHistoryData.addressLastName#</p>
                <p>Shipping Address: #orderHistoryData.fldAdressLine1#, #orderHistoryData.fldCity#, #orderHistoryData.fldState# #orderHistoryData.fldPincode#</p>
                <p>Phone: #orderHistoryData.fldPhoneNumber#</p>
                
                <h2>Ordered Items:</h2>
                <table border="1" cellpadding="5" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Unit Price ($)</th>
                            <th>Product Tax (%)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop query="#orderHistoryData#">
                            <tr>
                                <td>#orderHistoryData.fldProductName#</td>
                                <td>#orderHistoryData.fldQuantity#</td>
                                <td>$#orderHistoryData.fldUnitPrice#</td>
                                <td>#orderHistoryData.productTax#%</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </cfoutput>
        </cfdocument>
        <cfabort>
    </cffunction>

    <cffunction name="delItem" access="remote" returnType="string" returnFormat="json">
        <cfargument name="itemType" required="true" type="string">
        <cfargument name="itemId" required="true" type="numeric">
        <cftry>
            <cfif arguments.itemType EQ "category">
                <cfquery name="local.deactivateCategory" datasource="#application.datasource#">
                    UPDATE 
                        tblcategory c
                    LEFT JOIN tblsubcategory s ON s.fldCategoryId = c.fldCategory_Id
                    LEFT JOIN tblproduct p ON p.fldSubCategoryid = s.fldSubCategory_Id
                    LEFT JOIN tblproductimages pi ON pi.fldProductId = p.fldProduct_Id
                    SET 
                        c.fldActive = 0, 
                        c.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        s.fldActive = 0,
                        s.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        p.fldActive = 0,
                        p.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    WHERE 
                        c.fldCategory_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>
                
                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE 
                        FROM tblproductimages pi
                    LEFT JOIN tblproduct p ON pi.fldProductId = p.fldProduct_Id
                    LEFT JOIN tblsubcategory s ON p.fldSubCategoryid = s.fldSubCategory_Id
                    WHERE 
                        s.fldCategoryId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND pi.fldDefaultImage = 0
                </cfquery>
                
            <cfelseif arguments.itemType EQ "subcategory">
                <cfquery name="local.deactivateSubCategory" datasource="#application.datasource#">
                    UPDATE 
                        tblsubcategory s
                    LEFT JOIN tblproduct p ON p.fldSubCategoryid = s.fldSubCategory_Id
                    LEFT JOIN tblproductimages pi ON pi.fldProductId = p.fldProduct_Id
                    SET 
                        s.fldActive = 0, 
                        s.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        p.fldActive = 0,
                        p.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                        
                    WHERE 
                        s.fldSubCategory_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>

                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE
                        FROM tblproductimages pi
                    LEFT JOIN tblproduct p ON pi.fldProductId = p.fldProduct_Id
                    WHERE 
                        p.fldSubCategoryid = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND pi.fldDefaultImage = 0
                </cfquery>
                
            <cfelseif arguments.itemType EQ "product">
                <cfquery name="local.deactivateProduct" datasource="#application.datasource#">
                    UPDATE 
                        tblproduct p
                    LEFT JOIN tblproductimages pi ON pi.fldProductId = p.fldProduct_Id
                    SET 
                        p.fldActive = 0,
                        p.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    WHERE 
                        p.fldProduct_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>

                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE
                        FROM tblproductimages pi
                    WHERE 
                        pi.fldProductId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND pi.fldDefaultImage = 0
                </cfquery>
            </cfif>

            <cfreturn "#arguments.itemType# deactivated successfully and product images hard deleted.">
        
        <cfcatch>
            <cfreturn "Error occurred during #arguments.itemType# deactivation: #cfcatch.message#">
        </cfcatch>
    </cftry>
    </cffunction>

</cfcomponent>