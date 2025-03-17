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
                <cfset session.cartCount = viewCartData().recordCount>
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
        <cfif (len(trim(arguments.phone)) EQ 0) AND (val(arguments.phone) EQ 0)>
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

    <cffunction name = "viewCategoryData" access = "public" returnType = "query" returnFormat = "json">
        <cfargument name = "categoryId" required = "false" type = "numeric" default=0>
        <cfquery name = "local.viewCategory" datasource = "#application.datasource#">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM 
                tblcategory
            WHERE 
                fldActive = 1
                <cfif arguments.categoryId NEQ 0>
                    AND fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfreturn local.viewCategory>
    </cffunction>

    <cffunction name="viewSubCategoryData" access="remote" returnType="struct" returnFormat="json">
        <cfargument name="categoryId" required="false" type="numeric" default=0>
        <cfargument name = "subCategoryId" type = "numeric" required = "false" default=0>
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
                    <cfif arguments.subCategoryId NEQ 0>
                        AND fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
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

    <cffunction name = "viewProduct" access = "remote" returnType = "query" returnFormat = "json">
        <cfargument name = "subCategoryId" default = 0 required = "false" type = "integer">
        <cfargument name = "productId" default = "" required = "false" type = "string">
        <cfargument name = "sort" type = "numeric" required = "false" default = 1>
        <cfargument name = "min" type = "numeric" required = "false" default = 0>
        <cfargument name = "max" type = "numeric" required = "false" default = 0>
        <cfargument name = "minRange" type = "numeric" required = "false" default = 0>
        <cfargument name = "maxRange" type = "numeric" required = "false" default = 0>
        <cfargument name = "random" type = "numeric" required = "false" default = 0>
        <cfargument name = "searchTerm" type = "string" required = "false" default = "">
        <cfargument name="limit" type="numeric" required="false" default=0>  
        <cfargument name="offset" type="numeric" required="false" default="0">
        <cfargument name="randomProducts" type="boolean" required="false" default="false">
        <cfquery name="local.viewProductDetails" datasource = "#application.datasource#">
            SELECT 
                P.fldProduct_Id, 
                P.fldSubCategoryId, 
                P.fldProductName, 
                B.fldBrandName,
                P.fldDescription, 
                P.fldPrice, 
                P.fldTax, 
                B.fldBrand_Id,
                PI.fldProductImages_Id AS imageId,
                PI.fldImageFileName AS imageFileName
            FROM 
                tblproduct P
                INNER JOIN tblbrands B ON B.fldBrand_Id = P.fldBrandId
                INNER JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
            WHERE
                P.fldActive = 1
                <cfif arguments.random EQ 0>
                    AND PI.fldDefaultImage = 1
                <cfelse>
                    AND PI.fldActive = 1
                </cfif>
                <cfif arguments.subCategoryId NEQ 0> 
                    AND P.fldSubCategoryid = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                </cfif>
                <cfif len(trim(arguments.productId)) AND isNumeric(arguments.productId)> 
                    AND P.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype = "integer">
                </cfif>
                <cfif arguments.max NEQ 0 AND arguments.min NEQ 0> 
                    AND P.fldPrice >= <cfqueryparam value = "#arguments.min#" cfsqltype = "integer"> 
                        AND P.fldPrice <= <cfqueryparam value = "#arguments.max#" cfsqltype = "integer">
                </cfif>
                <cfif arguments.maxRange NEQ 0 AND arguments.minRange NEQ 0> 
                    AND P.fldPrice >= <cfqueryparam value = "#arguments.minRange#" cfsqltype = "integer">       
                        AND P.fldPrice <= <cfqueryparam value = "#arguments.maxRange#" cfsqltype = "integer">
                </cfif>
                <cfif len(trim(arguments.searchTerm))> 
                    AND (P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchTerm#%" cfsqltype = "varchar">
                    OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchTerm#%" cfsqltype = "varchar">)
                </cfif>
            ORDER BY 
                <cfif arguments.randomProducts>
                    RAND()
                <cfelseif arguments.sort EQ 1>
                    P.fldPrice DESC
                <cfelseif arguments.sort EQ 2>
                    P.fldPrice ASC
                <cfelse>
                    P.fldProduct_Id
                </cfif>,
                PI.fldDefaultImage DESC,
                PI.fldProductImages_Id ASC
                <cfif arguments.limit NEQ 0>
                    LIMIT <cfqueryparam value="#arguments.offset#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.limit#" cfsqltype="integer">
                </cfif>      
        </cfquery>
        <cfreturn local.viewProductDetails>
    </cffunction>

    

    <cffunction name = "addToCart" access = "remote" returnType = "boolean" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name = "quantity" required = "false" type = "numeric" default = 1>
        <cfargument name = "cartToken" required = "false" type = "numeric" default = 0>  
        <cftry>
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
                <cfset session.cartCount = session.cartCount + 1>
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
                        AND fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                </cfquery>
            </cfif>
            <cfreturn true>
        <cfcatch type="any">
            <cfreturn false>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "viewCartData" access = "remote" returnType = "query" returnFormat = "json">
        <cfquery name = "local.viewCart" datasource = "#application.datasource#">
            SELECT 
                C.fldCart_Id,
                C.fldQuantity,
                P.fldProduct_Id,
                P.fldProductName,
                P.fldDescription,
                P.fldPrice,
                P.fldTax,
                PI.fldDefaultImage,
                PI.fldImageFileName
            FROM 
                tblcart C
                INNER JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
                INNER JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
            WHERE 
                C.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                AND PI.fldDefaultImage = 1
                AND P.fldActive = 1
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
                <cfset session.cartCount = session.cartCount - 1>
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
            <cfelseif val(arguments.userPhoneNumber) EQ 0>
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
            <cfif len(trim(arguments.userPhoneNumber)) LT 10 AND VAL(arguments.userPhoneNumber) EQ 0>
                <cfset errorMessages["userPhoneNumber"] ="Enter PhoneNumber">
            </cfif>
            <cfif structCount(errorMessages) GT 0>
                <cfreturn errorMessages>
            <cfelse>
                <cfquery name = "local.addAddress" datasource = "#application.datasource#">
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
                <cfif val(arguments.addressId) NEQ 0>
                    AND fldAddress_Id = <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfreturn local.addressFetching>
    </cffunction>

    <cffunction name = "removeUserAddress" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "addressId" required = "true" type = "numeric">
        <cftry>
            <cfif val(arguments.addressId) EQ 0>
                <cfreturn "select address to remove">
            <cfelse>
                <cfquery name = "local.removeAddress" datasource = "#application.datasource#">
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

    <cffunction name = "addOrderPayment" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "addressId" required = "true" type = "numeric">
        <cfargument name = "totalPrice" required = "true" type = "numeric">
        <cfargument name = "totalTax" required = "true" type =  "numeric">
        <cfargument name = "productId" required = "false" type = "numeric" default = "0">
        <cfargument name = "cardNumber" required = "true" type = "numeric">
        <cfargument name = "cvv" required="true" type = "numeric">
        <cfargument name = "unitPrice" required = "true" type = "numeric">
        <cfargument name = "unitTax" required = "true" type = "numeric">
        
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
                        <cfprocparam type="out" variable="Error" cfsqltype="varchar">
                    </cfstoredproc>
                    <cfset local.orderId = v_OrderId>
                    <cfset local.error = Error>
                    <cfif local.error EQ 'Error occured'>
                        <cfreturn local.error>
                    </cfif>
                    <cfset local.orderDetails = fetchOrderDetails(orderId = local.orderId)>

                    <cfset local.productDetailsHTML = "<ul>"/>

                    <cfloop collection = "#local.orderDetails#" item = "orderId">
                        <cfset local.order = local.orderDetails[orderId]>
                        <cfloop array = "#local.order.products#" index = "product">
                            <cfset local.productDetailsHTML = local.productDetailsHTML & "<li>#product.productName# (Qty: #product.quantity#) - $ #product.unitPrice#</li>" />
                        </cfloop>
                    </cfloop>

                    <cfset local.productDetailsHTML = local.productDetailsHTML & "</ul>" />

                    <cfmail to="#session.mail#"
                            from="myCart@myCart.com" 
                            subject="Order Confirmation"
                            type="html">
                        <p>Hi #session.userName#,</p>
                        <p>Thank you for your purchase!</p>
                        <p>Your order details are as follows:</p>
                        #local.productDetailsHTML#
                    </cfmail>

                    <cfset session.cartCount = viewCartData().recordCount>
                    <cfset local.result = "Order placed successfully.">
                <cfelse>
                    <cfset local.result = "Invalid card details">
                </cfif>
            </cfif>
        <cfcatch type="any">
            <cfset local.result = "#cfcatch.message#">
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchOrderDetails" access="public" returnType="struct">
        <cfargument name="orderId" required="false" type="string" default="">
        <cfargument name="searchId" required="false" type="string" default="">
        <cfargument name="limit" required="false" type="numeric" default="0">
        <cfargument name="offset" required="false" type="numeric" default="0">

        <cfset local.orderDetails = structNew()>
        <cftry>
            <cfquery name="local.orderHistoryData" datasource="#application.datasource#">
                SELECT 
                    O.fldOrder_Id,
                    O.fldTotalPrice,
                    O.fldTotalTax,
                    O.fldOrderDate,
                    OI.fldQuantity,
                    OI.fldUnitPrice,
                    A.fldFirstName AS addressFirstName,
                    A.fldLastName AS addressLastName,
                    A.fldAdressLine1,
                    A.fldAdressLine2,
                    A.fldCity,
                    A.fldState,
                    A.fldPincode,
                    A.fldPhoneNumber,
                    P.fldProductName,
                    P.fldTax AS productTax,
                    PI.fldImageFileName
                FROM
                    tblorder O
                    INNER JOIN tblorderitems OI ON OI.fldOrderId = O.fldOrder_Id
                    INNER JOIN tbladdress A ON A.fldAddress_Id = O.fldAdressId
                    INNER JOIN tblproduct P ON P.fldProduct_Id = OI.fldProductId
                    INNER JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND PI.fldDefaultImage = 1
                WHERE
                    O.fldUserId = <cfqueryparam value="#session.UserId#" cfsqltype="integer">
                    <cfif trim(len(arguments.orderId))>
                        AND fldOrder_Id = <cfqueryparam value="#arguments.orderId#" cfsqltype="varchar">
                    </cfif>
                    <cfif trim(len(arguments.searchId))>
                        AND fldOrder_Id LIKE <cfqueryparam value="%#arguments.searchId#%" cfsqltype="varchar">
                    </cfif>
                ORDER BY O.fldOrderDate DESC
                <cfif arguments.limit NEQ 0>
                    LIMIT <cfqueryparam value="#arguments.offset#" cfsqltype="numeric">,
                    <cfqueryparam value="#arguments.limit#" cfsqltype="numeric">
                </cfif>
            </cfquery>

            <cfloop query="local.orderHistoryData">
                <cfif NOT structKeyExists(orderDetails, fldOrder_Id)>
                    <cfset orderDetails[fldOrder_Id] = structNew()>
                    <cfset orderDetails[fldOrder_Id].orderId = fldOrder_Id>
                    <cfset orderDetails[fldOrder_Id].totalPrice = fldTotalPrice>
                    <cfset orderDetails[fldOrder_Id].totalTax = fldTotalTax>
                    <cfset orderDetails[fldOrder_Id].orderDate = fldOrderDate>

                    <cfset orderDetails[fldOrder_Id].address = structNew()>
                    <cfset orderDetails[fldOrder_Id].address.firstName = addressFirstName>
                    <cfset orderDetails[fldOrder_Id].address.lastName = addressLastName>
                    <cfset orderDetails[fldOrder_Id].address.line1 = fldAdressLine1>
                    <cfset orderDetails[fldOrder_Id].address.line2 = fldAdressLine2>
                    <cfset orderDetails[fldOrder_Id].address.city = fldCity>
                    <cfset orderDetails[fldOrder_Id].address.state = fldState>
                    <cfset orderDetails[fldOrder_Id].address.pincode = fldPincode>
                    <cfset orderDetails[fldOrder_Id].address.phoneNumber = fldPhoneNumber>

                    <cfset orderDetails[fldOrder_Id].products = arrayNew(1)>
                </cfif>

                <cfset arrayAppend(orderDetails[fldOrder_Id].products, {
                    productName = fldProductName,
                    quantity = fldQuantity,
                    unitPrice = fldUnitPrice,
                    tax = productTax,
                    imageFileName = fldImageFileName
                })>
            </cfloop>
        <cfcatch type="any">
            <cfset local.result = "#cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn local.orderDetails>
    </cffunction>

    <cffunction name="downloadOrderData" access="remote" returnType="query" returnFormat="json">
        <cfargument name = "orderId" required = "true" type = "string">
        <cfset local.order = fetchOrderDetails(orderId = arguments.orderId)[arguments.orderId]>

        <cfif arrayLen(local.order.products) GT 0>
            <cfdocument format="pdf" filename="../assets1/createdPdf.pdf" overwrite="yes">
                <cfoutput>
                    <h3>Invoice for Order: #local.order.orderId#</h3>
                    <p>Order Date: #local.order.orderDate#</p>
                    <p>Total Price: $#local.order.totalPrice#</p>

                    <p>Shipping Address: #local.order.address.firstName# #local.order.address.lastName#</p>
                    <p>Shipping Address: #local.order.address.line1#, #local.order.address.city#, #local.order.address.state# #local.order.address.pincode#</p>
                    <p>Phone: #local.order.address.phoneNumber#</p>

                    <h2>Ordered Items:</h2>
                    <table border="2" cellpadding="5" cellspacing="1">
                        <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Quantity</th>
                                <th>Unit Price ($)</th>
                                <th>Product Tax (%)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#local.order.products#" index="product">
                                <tr>
                                    <td>#product.productName#</td>
                                    <td>#product.quantity#</td>
                                    <td>$#product.unitPrice#</td>
                                    <td>#product.tax#%</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </cfoutput>
            </cfdocument>
        <cfelse>
            <cfthrow message="Order not found or invalid OrderId.">
        </cfif>
        <cfabort>
    </cffunction>

</cfcomponent>