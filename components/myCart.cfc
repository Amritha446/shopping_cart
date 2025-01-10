<cfcomponent>
    <cffunction name = "validateLogIn" access = "public" returnType = "boolean">
        <cfargument name="userName">
        <cfargument name="userPassword">
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
        <cfargument  name="firstName">
        <cfargument  name="lastName">
        <cfargument  name="mail">
        <cfargument  name="phone">
        <cfargument  name="password">
        <cfargument  name="confirmPassword">
        <cfset saltString = generateSecretKey(("AES"),128)>
        <cfset saltedPassword = #arguments.password# & local.saltString.fldUserSaltString>
        <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
        
    </cffunction>

    <cffunction  name="logout" access="remote" return="void">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <cffunction name = "addCategory" access="public" returnType = "string">
        <cfargument  name="categoryName">
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
            <!---<cfreturn "Inserted successfully">
            <cfelse>
                 <cfquery name = "updateCategory">
                    UPDATE 
                        shoppingcart.tblcategory
                    SET
                        fldActive = 1
                    WHERE
                        fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
                </cfquery> 
            </cfif>--->
        <cfelse>
            <cfreturn "Category should be unique">
        </cfif>
    </cffunction>

    <cffunction name = "viewCategoryData" access="public" returnType = "query">
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
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">
                AND fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">
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
            <!---<cfreturn "Inserted successfully">
            <cfelse>
                 <cfquery name = "updateCategory">
                    UPDATE 
                        shoppingcart.tblcategory
                    SET
                        fldActive = 1
                    WHERE
                        fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
                </cfquery> 
            </cfif>--->
        <cfelse>
            <cfreturn "Subcatagory should be unique">
        </cfif>
    </cffunction>

    <cffunction name = "viewSubCategoryData" access="public" returnType = "query">
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
</cfcomponent>