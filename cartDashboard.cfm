<!--- <html>
    <head>
        <title>Admin-dashboard</title>
        <cfinclude template="commonLink.cfm">   
    </head>  --->
    <body>
        <cfoutput>
            <div class = "container-fluid" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <div class="mainHeading ">
                        <h5 class = "ms-5 mt-3">MyCart</h5>
                    </div>
                </div>
                <div class = "mainContent d-flex justify-content-center align-items-center h-50" id = "content">
                    <input type="hidden" value="" name = "categoryId1" id = "categoryId1">
                    <div class="d-flex-column">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading">Catagory List</h5>
                            <form action = "addCategory.cfm">
                                <button type="submit" class="addCategoryBtn ms-4 mb-3" id="addCategoryBtn">Add</button>
                            </form>
                        </div>

                        <cfset objCreate = createObject("component","components.myCart")>
                        <cfset viewCategory = application.myCartObj.viewCategoryData()>

                        <cfloop query = "#viewCategory#">
                            <div class = "contentBox d-flex mb-3">
                                <div class = "col-5 categoryName" id="categoryName">
                                    #viewCategory.fldCategoryName#
                                </div>
                                <div class="p-1 ">
                                    <button type="button" class="edtButton" data-bs-toggle="modal" data-bs-target="##editContact" 
                                    id="editb" value="#viewCategory.fldCategory_Id#" onClick = "editCategory(event)"><i class="fa-solid fa-pencil pe-none"></i></button>
                                </div>
                                <div class = "p-1">
                                    <button type="submit" class="dltButton" id="dltb" onClick="deleteCategory(event)" value="#viewCategory.fldCategory_Id#">
                                        <i class="fa-regular fa-trash-can pe-none"></i>
                                    </button>
                                </div>
                                <div class = "p-1">  
                                    <button type="button" class="viewButton" id="viewBtn1" onClick="redirectSubCategory(#viewCategory.fldCategory_Id#)" >
                                        <i class="fa-solid fa-angle-right pe-none"></i>
                                    </button>
                                </div>
                            </div>
                        </cfloop>

                        <div class="modal fade" id="editContact" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modalData">
                                        <form method="post" name="form" enctype="multipart/form-data" id="createCategory">
                                            <div class="input d-flex-column">
                                                <div class="d-flex">
                                                    <div class="text-secondary mt-4 ms-5"> Enter Category Name: </div>
                                                    <input type="hidden" value="" name = "categoryId" id = "categoryId">
                                                    <input type="text" name="categoryName" class="inputs ms-5" id="categoryNameField">
                                                </div>
                                                <button type="submit" name="submit" class="btn mt-5 ms-5" onClick = "editCategorySubmit(event)">UPDATE</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>
