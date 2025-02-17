 
    <body>
        <cfoutput>
            
            <div class = "container-fluid" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <div class="mainHeading ">
                        <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
                        <h5 class = "ms-5 mt-3">ADD SUB-CATEGORY</h5>
                    </div>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                <cfset categoryId = URL.categoryId>
                <div class = "mainContent d-flex justify-content-center align-items-center h-50" id = "content">
                    <input type="hidden" value="" name = "categoryId1" id = "categoryId1">
                    <div class="d-flex-column">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading">SUB-CATEGORY LIST</h5>
                            <button type="submit" class="addSubCategoryBtn ms-4 mb-3" id="addCategoryBtn" onClick="createSubCategory()">Add</button>
                        </div>

                        <cfset objCreate = createObject("component","components.myCart")>
                        <cfset viewSubCategory = application.myCartObj.viewSubCategoryData(categoryId=categoryId)>
                        <cfloop query = "#viewSubCategory#"> 
                            <div class = "contentBox d-flex mb-3">
                                <div class = "col-5 categoryName" id="subCategoryName">
                                    #viewSubCategory.fldSubCategoryName# 
                                </div>
                                <div class=" p-1 ">
                                    <button type="button" class="edtButton" data-bs-toggle="modal" data-bs-target="##editSubContact" 
                                    id="editBtn"  value="#viewSubCategory.fldSubCategory_Id#" onClick = "editSubCategory(event)"><i class="fa-solid fa-pencil pe-none"></i></button>
                                </div>
                                <div class = " p-1">
                                    <button type="submit" class="dltButton" id="dltBtn" onClick="deleteSubCategory(event)" value="#viewSubCategory.fldSubCategory_Id#" >
                                        <i class="fa-regular fa-trash-can pe-none"></i>
                                    </button>
                                </div>
                                <div class = " p-1">
                                    <form action = "productPage.cfm" method="GET">
                                        <button type="submit" class="viewButton" 
                                        id="viewBtn1" value ="#viewSubCategory.fldSubCategory_Id#" <!--- onClick = "viewProductButton1(event)" ---> >
                                            <i class="fa-solid fa-angle-right"></i>
                                        </button>
                                        <input type="hidden" value="#url.categoryId#" name="categoryId">
                                        <input type="hidden" value="#viewSubCategory.fldSubCategory_Id#" name="subCategoryId">
                                    </form>
                                </div>
                            </div>
                        </cfloop>

                        <div class="modal fade" id="editSubContact" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modalData">
                                        <form method="post" name="form" enctype="multipart/form-data" id="createSubCategory">
                                            <div class="input d-flex-column">
                                                <div class="d-flex">
                                                    <div class = "d-flex-column">
                                                        <div class="text-secondary mt-4 ms-5"> Enter Category Name: </div>
                                                        <!--- <input type="text" class="inputs ms-5" value="" name = "categoryFrmSubCategory" id = "categoryFrmSubCategory"> --->
                                                        <cfset objCreate = createObject("component","components.myCart")>
                                                        <cfset viewCategory = application.myCartObj.viewCategoryData()>

                                                        <select name="categoryFrmSubCategory" id="categoryFrmSubCategory" class="inputs ms-5">
                                                            <cfloop query="#viewCategory#">
                                                                <option value="#viewCategory.fldCategory_Id#">#viewCategory.fldCategoryName#</option>
                                                            </cfloop>
                                                        </select>
                                                    </div>
                                                    <div class = "d-flex-column">
                                                        <div class="text-secondary mt-4 ms-5"> Enter Sub-Category Name: </div>
                                                        <input type="hidden" value="#categoryId#" name = "categoryIdUrl" id = "categoryIdUrl">
                                                        <input type="hidden" value="" name = "subCategoryId" id = "subCategoryId">
                                                        <input type="text" name="subCategoryName" class="inputs ms-5" id="subCategoryNameField">
                                                    </div>
                                                </div>
                                                <button type="button" name="editSubCategorySubmit" class="btn mt-5 ms-5" onClick ="editSubCategoryFormSubmit()"
                                                    id="editSubCategorySubmit" value="">UPDATE</button>
                                                <button type="submit" name="addSubCategorySubmit" class="btn mt-5 ms-5"
                                                    id="addSubCategorySubmit" value="" onClick="addSubCategoryFormSubmit()">ADD</button>
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
