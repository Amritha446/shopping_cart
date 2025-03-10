<cfcomponent>
    <cfset this.name = 'shoppingCart'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout=createTimespan(0, 2, 0, 0)>
    
    <cffunction name = "onApplicationStart" access = "public" returnType = "boolean">
        <cfset application.key = "1e0Js/hDrE8mllZflN+WkQ==">
        <cfset application.myCartObj = createObject("component", "components.myCart")>
        <cfset application.datasource = "shoppingCart">
        <cfreturn true>
    </cffunction>

    <cffunction name = "onRequest" returnType = "void">
        <cfargument name = "requestPage" required="true">
        <cfinclude template = "commonLink.cfm">
        <cfinclude template = "#arguments.requestPage#">
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean">

        <cfargument name = "requestPage" required = "true"> 

        <cfif structKeyExists(URL,"reload") AND URL.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>

        <cfset local.publicPages = ["/Components/myCart.cfc",
                                "/login.cfm",
                                "/signUp.cfm",
                                "/homePage.cfm",
                                "/categoryBasedProduct.cfm",
                                "/productDetails.cfm",
                                "/filterProduct.cfm"]>
        <cfset local.adminPages = ["/cartDashboard.cfm",
                                "/addCategory.cfm",
                                "/productPage.cfm",
                                "/subCategory.cfm"]>
        
        <cfif ArrayContains(local.adminPages,arguments.requestPage)>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cfif session.roleId EQ 1>
                    <cfreturn true> 
                <cfelse>
                    <cflocation url = "/homePage.cfm">
                </cfif>
            <cfelse>
                <cflocation url = "/homePage.cfm">
           </cfif>
        <cfelseif ArrayContains(["/logIn.cfm","/signUp.cfm"],arguments.requestPage)>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cflocation url ="/homePage.cfm">
            </cfif>
        <cfelseif ArrayContains(local.publicPages,arguments.requestPage)>
            <cfreturn true>
        <cfelse>
            <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true >
                <cfreturn true>
            <cfelse>
                <cflocation url ="/logIn.cfm">  
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