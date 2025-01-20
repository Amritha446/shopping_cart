<cfcomponent>
    <cfset this.name = 'shoppingCart'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout=createTimespan(0, 2, 0, 0)>
    <cfset this.datasource = "shoppingCart">
    
    <cffunction name = "onApplicationStart" access="public" returnType="boolean">
        <cfset application.myCartObj = createObject("component", "components.myCart")>

        <cfreturn true>
    </cffunction>

    <cffunction  name="onRequest" returnType="void">
        <cfargument  name="requestPage" required="true">
        <cfinclude template="commonLink.cfm">
        <cfinclude  template="#arguments.requestPage#">
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean">

        <cfargument  name="requestPage" required="true"> 
        <cfset onApplicationStart()>
        <cfset local.excludePages = ["/Amritha_CF/testTask/myCart/shopping_cart/login.cfm","/Amritha_CF/testTask/myCart/shopping_cart/signUp.cfm","/Amritha_CF/testTask/myCart/shopping_cart/homePage.cfm","/Amritha_CF/testTask/myCart/shopping_cart/categoryBasedProduct.cfm"]>
        <cfset local.adminPages = ["/Amritha_CF/testTask/myCart/shopping_cart/cartDashboard.cfm","/Amritha_CF/testTask/myCart/shopping_cart/addCategory.cfm",
        "/Amritha_CF/testTask/myCart/shopping_cart/productPage.cfm","/Amritha_CF/testTask/myCart/shopping_cart/subCategory.cfm"]>
        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfreturn true>
        <cfelseif structKeyExists(session, "isAuthenticated")>
            <cfif session.roleId EQ 1>
                <cfreturn true> 
            <cfelse>
                <cfif ArrayContains(local.adminPages,arguments.requestPage)>
                    <cflocation  url="homePage.cfm">
                <cfelse>
                    <cfreturn true>
                </cfif>
            </cfif>
        <cfelse>
            <cfif ArrayContains(local.excludePages,arguments.requestPage)>
                <cfreturn true>
            <cfelse>
                <cflocation  url="logIn.cfm">
            </cfif> 
        </cfif>
    </cffunction>
    
</cfcomponent>