<cffunction name="addOrUpdateSubCategory" access="remote" returnType="string" returnFormat="json">
    <cfargument name="categoryId" required="true">
    <cfargument name="subCategoryName" required="true">
    <cfargument name="subCategoryId" required="false"> <!-- Optional if editing a subcategory -->

    <!--- Check if categoryId is a number (meaning it's an existing category) or a string (new category) --->
    <cfif IsNumeric(arguments.categoryId)>
        <!--- If the category ID is numeric, check if the category exists --->
        <cfquery name="checkCategoryExistence">
            SELECT fldCategory_Id
            FROM shoppingcart.tblcategory
            WHERE fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif checkCategoryExistence.recordCount EQ 0>
            <cfreturn "Category does not exist! Please select a valid category.">
        </cfif>

        <!--- If category exists, add the subcategory to the existing category --->
        <cfquery name="addSubCategoryToExistingCategory">
            INSERT INTO shoppingcart.tblsubcategory (fldSubCategoryName, fldCategory_Id)
            VALUES (<cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">)
        </cfquery>
        <cfreturn "Subcategory added to the existing category successfully!">

    <cfelse>
        <!--- If the categoryId is a string, assume it's a new category --->
        <cfquery name="createNewCategory">
            INSERT INTO shoppingcart.tblcategory (fldCategoryName)
            VALUES (<cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">)
        </cfquery>

        <!--- Get the new category ID after insert --->
        <cfset newCategoryId = createNewCategory.generatedKey>

        <!--- Add the subcategory to the newly created category --->
        <cfquery name="addSubCategoryToNewCategory">
            INSERT INTO shoppingcart.tblsubcategory (fldSubCategoryName, fldCategory_Id)
            VALUES (<cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#newCategoryId#" cfsqltype="cf_sql_integer">)
        </cfquery>
        <cfreturn "New Category and Subcategory created successfully!">
    </cfif>
</cffunction>
