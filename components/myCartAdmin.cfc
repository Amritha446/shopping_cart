<cfcomponent>
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

    <cffunction name = "saveSubCategory" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "operation" required = "true" type = "string">
        <cfargument name = "categoryId" required = "true" type = "numeric">
        <cfargument name = "subCategoryName" required = "true" type = "string">
        <cfargument name = "subCategoryId" required = "false" type = "numeric" default = 0>
        
        <cfif len(trim(arguments.subCategoryName)) EQ 0>
            <cfreturn "Failed to add or update sub-category: Name cannot be empty">
        </cfif>
        <cfif NOT reFind("^[a-zA-Z]+$", arguments.subCategoryName)>
            <cfreturn "sub category name should contain only alphabets.">
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
        <cfargument name = "productBrand" required = "true" type = "numeric" default="0">
        <cfargument name = "productPrice" required = "true" type = "numeric">
        <cfargument name = "productDescrptn" required = "true" type = "string">
        <cfargument name = "productImg" required = "true" type = "string">
        <cfargument name = "productTax" required = "true" type = "numeric"> 
        
        <cfset var errorMessages = structNew()>
        <cfif val(arguments.categoryId) EQ 0>
            <cfset errorMessages["categoryId"] = "Invalid category id.">
        </cfif>
        <cfif val(arguments.subCategoryId) EQ 0>
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
                        <cfqueryparam value="#arguments.productBrand#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.productDescrptn#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.productPrice#" cfsqltype="decimal">,
                        <cfqueryparam value="#arguments.productTax#" cfsqltype="decimal">,
                        <cfqueryparam value="#session.userId#" cfsqltype = "integer">
                    )
                </cfquery>
    
                <cfset local.path = expandPath("./assets/product_Images")>
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

    <cffunction name = "editProduct" access = "public" returnType = "string">
        <cfargument name = "productId" required = "true" type = "numeric">
        <cfargument name = "subCategoryId" required = "true" type = "numeric">
        <cfargument name = "productName" required = "true" type = "string">
        <cfargument name = "productBrand" required = "true" type = "numeric" default="0">
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
            <cfset local.path = expandPath("./assets/product_Images")>
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
                        fldBrandId = <cfqueryparam value="#arguments.productBrand#" cfsqltype = "integer">,
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

    <cffunction name = "delItem" access = "remote" returnType = "string" returnFormat = "json">
        <cfargument name = "itemType" required = "true" type = "string">
        <cfargument name = "itemId" required = "true" type = "numeric">
        <cftry>
            <cfif arguments.itemType EQ "category">

                <cfquery name="local.getImages" datasource="#application.datasource#">
                    SELECT 
                        PI.fldImageFileName
                    FROM 
                        tblproductimages PI
                        LEFT JOIN tblproduct P ON P.fldProduct_Id = PI.fldProductId
                        LEFT JOIN tblsubcategory S ON S.fldSubCategory_Id = P.fldSubCategoryid
                    WHERE S.fldCategoryId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                    AND PI.fldDefaultImage = 0
                </cfquery>

                <cfquery name="local.deactivateCategory" datasource="#application.datasource#">
                    UPDATE 
                        tblcategory C
                        LEFT JOIN tblsubcategory S ON S.fldCategoryId = C.fldCategory_Id
                        LEFT JOIN tblproduct P ON P.fldSubCategoryid = S.fldSubCategory_Id
                    SET 
                        C.fldActive = 0, 
                        C.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        S.fldActive = 0,
                        S.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        P.fldActive = 0,
                        P.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    WHERE 
                        C.fldCategory_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>
                
                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE 
                        FROM tblproductimages PI
                        LEFT JOIN tblproduct P ON P.fldProduct_Id = PI.fldProductId
                        LEFT JOIN tblsubcategory S ON S.fldSubCategory_Id = P.fldSubCategoryid
                    WHERE 
                        S.fldCategoryId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND PI.fldDefaultImage = 0
                </cfquery>

                <cfloop query="local.getImages">
                    <cffile action="delete" file="#expandPath('/assets/product_Images/' & local.getImages.fldImageFileName)#">
                </cfloop>
                
            <cfelseif arguments.itemType EQ "subcategory">
                <cfquery name="local.getImages" datasource="#application.datasource#">
                    SELECT 
                        PI.fldImageFileName
                    FROM 
                        tblproductimages PI
                        LEFT JOIN tblproduct P ON P.fldProduct_Id = PI.fldProductId
                    WHERE P.fldSubCategoryid = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                    AND PI.fldDefaultImage = 0
                </cfquery>

                <cfquery name="local.deactivateSubCategory" datasource="#application.datasource#">
                    UPDATE 
                        tblsubcategory S
                        LEFT JOIN tblproduct P ON P.fldSubCategoryid = S.fldSubCategory_Id
                    SET 
                        S.fldActive = 0, 
                        S.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">,
                        P.fldActive = 0,
                        P.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                        
                    WHERE 
                        S.fldSubCategory_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>

                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE
                        FROM tblproductimages PI
                        LEFT JOIN tblproduct P ON P.fldProduct_Id = PI.fldProductId
                    WHERE 
                        P.fldSubCategoryid = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND PI.fldDefaultImage = 0
                </cfquery>

                <cfloop query="local.getImages">
                    <cffile action="delete" file="#expandPath('/assets/product_Images/' & local.getImages.fldImageFileName)#">
                </cfloop>
                
            <cfelseif arguments.itemType EQ "product">
                <cfquery name="local.getImages" datasource="#application.datasource#">
                    SELECT 
                        PI.fldImageFileName
                    FROM 
                        tblproductimages PI
                    WHERE PI.fldProductId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                    AND PI.fldDefaultImage = 0
                </cfquery>

                <cfquery name="local.deactivateProduct" datasource="#application.datasource#">
                    UPDATE 
                        tblproduct P
                    SET 
                        P.fldActive = 0,
                        P.fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
                    WHERE 
                        P.fldProduct_Id = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                </cfquery>

                <cfquery name="local.deleteProductImages" datasource="#application.datasource#">
                    DELETE
                        FROM tblproductimages PI
                    WHERE 
                        PI.fldProductId = <cfqueryparam value="#arguments.itemId#" cfsqltype="integer">
                        AND PI.fldDefaultImage = 0
                </cfquery>

                <cfloop query="local.getImages">
                    <cffile action="delete" file="#expandPath('/assets/product_Images/' & local.getImages.fldImageFileName)#">
                </cfloop>
            </cfif>

            <cfreturn "#arguments.itemType# deactivated successfully and product images hard deleted.">
        
        <cfcatch>
            <cfreturn "Error occurred during #arguments.itemType# deactivation: #cfcatch.message#">
        </cfcatch>
    </cftry>
    </cffunction>
    
</cfcomponent>