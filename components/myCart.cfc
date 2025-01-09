<cfcomponent>
    <cffunction name = "validateLogIn" access = "public" returnType = "boolean">
        <cfargument name="userName">
        <cfargument name="userPassword">
       <!---  <cfset saltString = generateSecretKey(("AES"),128)> --->
        
        <cfquery name = local.saltString>
            SELECT fldUserSaltString 
            FROM shoppingcart.tbluser
            WHERE fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
            OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset saltedPassword = #arguments.userName# & local.saltString.fldUserSaltString>
        <cfset local.encrypted_pass = Hash(#saltedPassword#, 'SHA-256')/>
        <cfquery name = local.queryCheck>
            SELECT fldUser_Id,
                fldEmail,
                fldPhone,
                fldRoleId
            FROM shoppingcart.tbluser 
            WHERE fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
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

    <cffunction name = "addCategory" access="public" returnType = "query">
    </cffunction>

</cfcomponent>