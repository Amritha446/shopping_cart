<cfcomponent>
    <cfset this.name = 'shoppingCart'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout=createTimespan(0, 2, 0, 0)>
    
    <cffunction name = "onApplicationStart" access = "public" returnType = "boolean">
        <cfset application.key = generateSecretKey("AES")>
        <cfset application.myCartObj = createObject("component", "components.myCart")>
        <cfset application.datasource = "shoppingCart">
        <cfreturn true>
    </cffunction>

    <cffunction  name = "onRequest" returnType = "void">
        <cfargument  name = "requestPage" required="true">
        <cfinclude template = "commonLink.cfm">
        <cfinclude  template = "#arguments.requestPage#">
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean">

        <cfargument  name = "requestPage" required = "true"> 

        <cfif structKeyExists(URL,"reload") AND URL.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>

        <cfset local.publicPages = ["/Amritha_CF/testTask/myCart/shopping_cart/Components/myCart.cfc",
            "/Amritha_CF/testTask/myCart/shopping_cart/login.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/signUp.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/homePage.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/categoryBasedProduct.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/productDetails.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/filterProduct.cfm"]>
        <cfset local.adminPages = ["/Amritha_CF/testTask/myCart/shopping_cart/cartDashboard.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/addCategory.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/productPage.cfm",
            "/Amritha_CF/testTask/myCart/shopping_cart/subCategory.cfm"]>
        
        <cfif ArrayContains(local.adminPages,arguments.requestPage)>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cfif session.roleId EQ 1>
                    <cfreturn true> 
                <cfelse>
                    <cflocation url = "/Amritha_CF/testTask/myCart/shopping_cart/homePage.cfm">
                </cfif>
            <cfelse>
                <cflocation url = "/Amritha_CF/testTask/myCart/shopping_cart/homePage.cfm">
           </cfif>
        <cfelseif ArrayContains(["/Amritha_CF/testTask/myCart/shopping_cart/logIn.cfm","/Amritha_CF/testTask/myCart/shopping_cart/signUp.cfm"],arguments.requestPage)>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cflocation url ="/Amritha_CF/testTask/myCart/shopping_cart/homePage.cfm">
            </cfif>
        <cfelseif ArrayContains(local.publicPages,arguments.requestPage)>
            <cfreturn true>
        <cfelse>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cfreturn true>
            <cfelse>
                <cflocation url ="/Amritha_CF/testTask/myCart/shopping_cart/logIn.cfm">  
            </cfif> 
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction name="onError" access="public" returnType="void">
        <cfargument name="exception" required="true" type="any">
        <cfargument name="eventName" required="true" type="string">

        <cfset location("./error.cfm?message=" & urlEncodedFormat(arguments.exception.message))>
    </cffunction>
    
</cfcomponent>