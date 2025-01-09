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
                        <h5 class = "ms-5 mt-3">ADMIN DASHBOARD</h5>
                    </div>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                <div class = "mainContent d-flex justify-content-center align-items-center h-50" id = "content">
                    <form method="post" name="form" enctype="multipart/form-data">
                        <div class="d-flex-column">
                            <div class = "categorySection d-flex">
                                <h5>Categories List</h5>
                                <button type="submit" class="addCategoryBtn ms-4 mb-3" id="addCategoryBtn" 
                                data-bs-toggle="modal" data-bs-target="##editContact">Add</button>
                            </div>

                            <div class = "contentBox d-flex ">
                                <div class = "categoryName">
                                    Electronics
                                </div>
                                <div class="ms-3 p-1 ">
                                    <button type="button" class="edtButton" data-bs-toggle="modal" data-bs-target="##editContact" 
                                    id="editb" onClick="editOne(event)"><i class="fa-solid fa-pencil"></i></button>
                                </div>
                                <div class=" p-1">
                                    <button type="submit" class="dltButton" id="dltb" onClick="dltOne(event)">
                                        <i class="fa-regular fa-trash-can"></i>
                                    </button>
                                </div>
                                <div class=" p-1">
                                    <button type="submit" class="viewButton" data-bs-toggle="modal" data-bs-target="##viewContact" 
                                    id="viewb" onClick="viewOne(event)">
                                        <i class="fa-solid fa-angle-right"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal fade" id="editContact" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <div class="abc">
                        <form method="post" name="form" enctype="multipart/form-data" >
                            <div class = "editContent">  
                                <div class = "categorySection d-flex">
                                <h5 class = "ms-5 mt-3">Subategory List</h5>
                                <button type="submit" class="addCategoryBtn ms-4 mb-3 mt-3" id="addCategoryBtn" 
                                data-bs-toggle="modal" data-bs-target="##editContact">Add</button>
                            </div>
                            <div class = "contentBox d-flex ms-5 mt-5">
                                <div class = "categoryName">
                                    Electronics
                                </div>
                                <div class="ms-3 p-1 ">
                                    <button type="submit" class="edtButton" data-bs-toggle="modal" data-bs-target="##editContact" 
                                    id="editb" onClick="editOne(event)"><i class="fa-solid fa-pencil"></i></button>
                                </div>
                                <div class=" p-1">
                                    <button type="submit" class="dltButton" id="dltb" onClick="dltOne(event)">
                                        <i class="fa-regular fa-trash-can"></i>
                                    </button>
                                </div>
                                <div class=" p-1">
                                    <button type="submit" class="viewButton" data-bs-toggle="modal" data-bs-target="##viewContact" 
                                    id="viewb" onClick="viewOne(event)">
                                        <i class="fa-solid fa-angle-right"></i>
                                    </button>
                                </div>
                            </div>
                            </div>
                        </form> 
                    </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="viewContact" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                    </div>
                </div>
            </div>

        </cfoutput>
    </body>
</html>
