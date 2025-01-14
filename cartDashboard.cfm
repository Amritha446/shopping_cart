<html>
    <head>
        <title>Admin-dashboard</title>
        <link href = "css/bootstrap.min.css" rel="stylesheet" >
        <script src = "js/bootstrap.bundle.min.js"></script>
        <script src = "js/jquery.min.js"></script>
        <script src = "js/cartDashboard.js"></script>
        <link href = "css/style.css" rel="stylesheet">
        <link rel = "stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css"/>    
    </head>
    <body>
        <cfoutput>
            <div class = "container-fluid" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <!--- <div class = "logo">
                        <img src="assets/logo.jpg" class="logoImg">
                    </div> --->
                    <div class="mainHeading ">
                        <h5 class = "ms-5 mt-3">ADD CATAGORY</h5>
                    </div>
                    <!--- <button type="button" class="btn1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button> --->
                </div>
                <div class = "mainContent d-flex justify-content-center align-items-center h-50" id = "content">
                    <input type="hidden" value="" name = "categoryId1" id = "categoryId1">
                    <div class="d-flex-column">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading">Catagory List</h5>
                            <form action = "add.cfm">
                                <button type="submit" class="addCategoryBtn ms-4 mb-3" id="addCategoryBtn">Add</button>
                            </form>
                        </div>

                        <cfset objCreate = createObject("component","components.myCart")>
                        <cfset viewCategory = objCreate.viewCategoryData()>

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
                                                <!--- <cfset objCreate = createObject("component","components.myCart")>
                                                <cfset viewCategory = objCreate.viewEachCategory()> --->
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
