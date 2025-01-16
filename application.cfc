<cfcomponent>
    <cfset this.name = 'shoppingCart'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout=createTimespan(0, 2, 0, 0)>
    <cfset this.datasource = "shoppingCart">
    
    <cffunction name = "onApplicationStart" access="public" returnType="boolean">
        <cfset application.myCartObj = createObject("component", "components.myCart")>
        <cfreturn true>
    </cffunction>

    <!--- <cffunction name="onRequestStart" returnType="void">
        <cfargument  name="requestPage" required="true"> 
        <cfset local.excludePages = ["/Amritha_CF/testTask/myCart/shopping_cart/login.cfm","/Amritha_CF/testTask/myCart/shopping_cart/signUp.cfm"]>
        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">
        <cfelseif structKeyExists(session, "isAuthenticated")>
            <cfif session.roleId EQ 1>
                <cfinclude  template="#arguments.requestPage#">  
            <cfelse>
                <cfinclude  template="home.cfm">
            </cfif>
        <cfelse>
            <cfinclude  template="login.cfm">
        </cfif>
    </cffunction> --->
    <cffunction  name="onRequest" returnType="void">
        <cfargument  name="requestPage">
        <cfinclude template="commonLink.cfm">
        <cfinclude  template="#arguments.requestPage#">
    </cffunction>

</cfcomponent>