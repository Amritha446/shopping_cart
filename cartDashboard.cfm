
    <body>
        <cfoutput>
            <div class = "container-fluid" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <div class="mainHeading ">
                        <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
                    </div>
                    <div class="col-6"></div>
                    <cfif structKeyExists(session, "isAuthenticated") AND session.isAuthenticated EQ true>
                        <button type="button" class="logOutBtn p-1 col-1">
                            <div class="signUp d-flex">
                                <i class="fa-solid fa-right-from-bracket mb-1 mt-2" style="color:##fff"></i><div class="text-white footerContent mt-2 ms-1" onClick = "logoutUser()">LOGOUT</div>
                            </div>
                        </button>
                    <cfelse>
                        <div class="logInBtn d-flex">
                            <a href="logIn.cfm" class="signUp d-flex">
                                <i class="fa-solid fa-right-to-bracket mb-1 mt-1 " style="color:##fff"></i><div class="text-white ">LogIn</div>
                            </a>
                        </div>
                    </cfif>
                </div>
                <div class = "mainContentDiv d-flex flex-column justify-content-center align-items-center mt-3 p-1" id = "content">
                    <input type="hidden" value="" name = "categoryId1" id = "categoryId1">
                    <div class = "categorySection d-flex">
                        <h5 id= "modalHeading" >Catagory List</h5>
                        <button type="submit" class="addCategoryBtn ms-4 mb-3" id="addCategoryBtn" data-bs-toggle="modal" data-bs-target="##addContact" >Add</button>
                    </div>
                    <div class="mainContent d-flex flex-column mt-3">
                        <cfset viewCategory = application.myCartObj.viewCategoryData()>
                        <cfloop query = "#viewCategory#">
                            <div class="contentBox d-flex mb-3">
                                <div class="col-5 categoryName" id="categoryName_#viewCategory.fldCategory_Id#">
                                    #viewCategory.fldCategoryName#
                                </div>
                                <div>
                                    <input type="text" class="categoryName" id="categoryNameField_#viewCategory.fldCategory_Id#" 
                                        value="#viewCategory.fldCategoryName#" style="display:none;width:150px;border:transparent;" maxlength="32">
                                </div>
                                <div class="p-1">
                                    <button type="button" class="edtButton" id="editb" value="#viewCategory.fldCategory_Id#" 
                                        onClick="editCategory(event, #viewCategory.fldCategory_Id#)">
                                        <i class="fa-solid fa-pencil pe-none"></i>
                                    </button>
                                </div>
                                <div class="p-1">
                                    <button type="button" class="dltButton" id="saveb_#viewCategory.fldCategory_Id#" 
                                        onClick="saveCategory(event, #viewCategory.fldCategory_Id#)" style="display:none;">
                                        <i class="fa-solid fa-check pe-none"></i>
                                    </button>
                                </div>
                                <div class = "p-1">  
                                    <button type="button" class="viewButton" id="viewBtn1" onClick="redirectSubCategory(#viewCategory.fldCategory_Id#)" >
                                        <i class="fa-solid fa-angle-right pe-none"></i>
                                    </button>
                                </div>
                                <div class="p-1">
                                    <button type="submit" class="dltButton" id="dltb" onClick="deleteCategory(event)" 
                                        value="#viewCategory.fldCategory_Id#">
                                        <i class="fa-regular fa-trash-can pe-none"></i>
                                    </button>
                                </div>
                            </div>
                        </cfloop>

                        <div id="categoryErrorMsg" class="text-danger"></div>

                        <div class="modal fade" id="addContact" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modalData">
                                        <form method="post" name="form" enctype="multipart/form-data" id="createCategory">
                                            <div class="input d-flex flex-column">
                                                <div class="d-flex">
                                                    <div class="text-secondary mt-4 ms-5"> Enter Category Name: </div>
                                                    <input type="text" name="categoryName" class="inputs ms-5" id="categoryNameAdd">
                                                </div>
                                                <button type="submit" name="submit" class="btn mt-5 ms-5" onClick = "addCategoryFormSubmit()">ADD</button>
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
