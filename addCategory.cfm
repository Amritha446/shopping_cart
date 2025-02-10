<!--- <html>
    <head>
        <title>Add Catgory</title>
        <cfinclude template="commonLink.cfm">    --->
    </head>
    <body>
        <cfoutput>
            <div class = "container" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <div class="mainHeading ">
                        <h5 class = "ms-5 mt-3">ADD CATEGORY</h5>
                    </div>
                </div>
                <div class="mainContent">
                    <form method="post" name="form" enctype="multipart/form-data" id="createCategory">
                        <div class="addBox d-flex-column h-50">
                            <div class="d-flex">
                                <div class="text-secondary mt-4 ms-5"> Enter Category Name: </div>
                                <input type="text" name="categoryName" class="inputs ms-5" id="categoryNameAdd">
                            </div>
                            <div class="d-flex">
                                <button type="submit" name="submit" class="btn mt-3 ms-5" onClick="addCategoryFormSubmit()">ADD</button>
                                <a href = "cartDashboard.cfm" class = "imageLink">
                                    <button type="button" name="submit1" class="btn mt-3 ms-5">Close</button>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <!--- <cfif structKeyExists(form,"submit") >
                <cfset objCreate = createObject("component","components.myCart")>
                <cfset result = application.myCartObj.addCategory(categoryName = form.categoryName)>
                <cfif result EQ "">
                    <cflocation url="cartDashBoard.cfm">
                <cfelse>
                    #result#
                </cfif>--->
        </cfoutput>
    </body>
</html>