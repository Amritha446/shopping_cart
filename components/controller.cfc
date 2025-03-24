<cfcomponent>
    <cffunction name="savedCategory" access="remote" returnType="string" returnFormat = "json" >
        <cfargument name="operation" required="true" type="string">
        <cfargument name="categoryName" required="true" type="string">
        <cfargument name="categoryId" required="false" type="numeric" default=0>
        <cfif len(trim(arguments.categoryName)) EQ 0>
            <cfreturn "Category name should be filled.">
        </cfif>
        <cfif NOT reFind("^[a-zA-Z]+$", arguments.categoryName)>
            <cfreturn "Category name should contain only alphabets and should not be empty.">
        </cfif>
        <cfset local.categorySub = application.myCartObjAdmin.saveCategory(operation = arguments.operation,
                                                                        categoryName = arguments.categoryName,
                                                                        categoryId = arguments.categoryId)>
        <cfreturn local.categorySub>
    </cffunction>
</cfcomponent>