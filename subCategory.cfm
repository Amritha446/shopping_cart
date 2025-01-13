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
            <cfset categoryId = URL.categoryId>
            <div class = "container-fluid" id = "container">
                <div class = "header d-flex col-12" id = "header">
                    <!--- <div class = "logo">
                        <img src="assets/logo.jpg" class="logoImg">
                    </div> --->
                    <div class="mainHeading ">
                        <h5 class = "ms-5 mt-3">ADD SUB-CATEGORY</h5>
                    </div>
                    <button type="button" class="btn1">
                        <div class="signUp d-flex">
                            <i class="fa-solid fa-right-from-bracket mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2" onClick = "logoutUser()">SignOut</div>
                        </div>
                    </button>
                </div>
                <div class = "mainContent d-flex justify-content-center align-items-center h-50" id = "content">
                    <input type="hidden" value="" name = "categoryId1" id = "categoryId1">
                    <div class="d-flex-column">
                        <div class = "categorySection d-flex">
                            <h5 id= "modalHeading">SUB-CATEGORY LIST</h5>
                            <button type="submit" class="addSubCategoryBtn ms-4 mb-3" id="addCategoryBtn" onClick="createSubCategory()">Add</button>
                        </div>

                        <cfset objCreate = createObject("component","components.myCart")>
                        <cfset viewSubCategory = objCreate.viewSubCategoryData(categoryId=categoryId)>

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
                                    <button type="submit" class="viewButton" data-bs-toggle="modal" data-bs-target="##viewProduct" 
                                    id="viewBtn" onClick = "viewProductButton()">
                                        <i class="fa-solid fa-angle-right"></i>
                                    </button>
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
                                                        <cfset viewCategory = objCreate.viewCategoryData()>

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
                                                    id="editSubCategorySubmit" value="">UPDATE</div></button>
                                                <button type="submit" name="addSubCategorySubmit" class="btn mt-5 ms-5"
                                                    id="addSubCategorySubmit" value="">ADD</div></button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <cfif structKeyExists(form, "addSubCategorySubmit")>
                            <cfset obj = createObject("component","components.myCart")>
                            <cfset result = obj.addSubCategory(categoryId=form.categoryFrmSubCategory,
                                subCategoryName=form.subCategoryName)>
                            #result#
                            <!--- <cflocation  url="subCategory.cfm?categoryId=#categoryId#"> --->
                        </cfif>
                        <!--- <cfset obj = createObject("component","components.myCart")>
                        <cfset result = obj.updateSubCategory()>
                        #obj# --->

                        <div class="modal fade" id="viewProduct" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class = "categorySection d-flex">
                                        <h5 id= "modalHeading" class = "ms-5 mt-4">PRODUCT LIST</h5>
                                        <button type="submit" class="addSubCategoryBtn ms-4 mb-3 mt-4" id="addProductBtn" onClick="createNewProduct()"
                                         id="createNewProductBtn">Add</button>
                                    </div>
                                    <div class = "contentBox h-50 d-flex mb-3 bg-success">
                                        <div class = "d-flex-column productData">
                                            <div class="ms-4 font-weight-bold h5">hi</div>
                                            <div class="ms-4 h6 ">hlo</div>
                                            <div class="ms-4 small">hlo</div>
                                        </div>
                                        <div class="prdctImg">
                                            <img src="" alt="img" class = "ms-5 mt-e prdctImg">
                                        </div>
                                        <div class = " p-1">
                                            <button type="submit" class="dltProductButton ms-5 mt-3" id="dltProductBtn" onClick="deleteProduct(event)"  >
                                                <i class="fa-regular fa-trash-can pe-none"></i>
                                            </button>
                                            </div>
                                            <div class = " p-1">
                                            <button type="submit" class="viewProductButton ms-3 mt-3" data-bs-toggle="modal" data-bs-target="##viewProductDetails" 
                                                id="viewProductBtn" onClick = "viewProductDetailsButton()">
                                                <i class="fa-solid fa-angle-right"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="viewProductDetails" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form method="post" name="form" enctype="multipart/form-data" id="createProductData">
                                        <input type="hidden" value="" name = "contactId" id = "contactId">
                                        <div class="headEdit mt-1 ">
                                            <div class="headEditText" id="heading"></div>
                                        </div>
                                        <div class="textHead">
                                            PRODUCT DETAILS
                                        </div><hr class="horizontalLine1 mt-1">                                                
                                        
                                        <div class="d-flex-column" id = "multiSelect">
                                            <cfset objCreate = createObject("component","components.myCart")>
                                            <cfset viewCategory = objCreate.viewCategoryData()>
                                            <div class="textHead ">Category Name:</div>
                                            <select id="categoryList" name="categoryList" class="ms-3" >
                                                <cfloop query = #viewCategory#>
                                                    <option value="#viewCategory.fldCategory_Id#">#viewCategory.fldCategoryName#</option>
                                                </cfloop>
                                            </select>
                                        </div>

                                        <div class="d-flex-column" id = "multiSelect">
                                            <div class="textHead ">Sub-Category Name:</div>
                                            <select id="categoryList" name="categoryList" class="ms-3">
                                                <cfloop query = #viewSubCategory#>
                                                    <option value="#viewSubCategory.fldSubCategory_Id#">#viewSubCategory.fldSubCategoryName#</option>
                                                </cfloop>
                                            </select>
                                        </div>

                                        <div class="d-flex-column">
                                            <div class="textHead">PRODUCT NAME</div>
                                            <input type="text" name="firstName" class="editBtn2 ms-3" id="firstName">
                                            <div class="error text-danger" id="nameError"></div>
                                        </div>

                                        <div class="d-flex-column">
                                            <div class="textHead">PRODUCT BRAND</div>
                                            <select id="categoryList" name="categoryList" class="ms-3">
                                                <cfset obj = createObject("component","components.myCart")>
                                                <cfset brandName = obj.viewBrands()>
                                                <cfloop query = #brandName#>
                                                    <option value="#brandName.fldBrand_Id#">#brandName.fldBrandName#</option>
                                                </cfloop>
                                            </select>
                                            <div class="error text-danger" id="brandError"></div>
                                        </div>

                                        <div class="d-flex-column">
                                            <div class="textHead">PRODUCT DESCRIPTION</div>
                                            <input type="text" name="firstName" class="editBtn2 ms-3" id="firstName">
                                            <div class="error text-danger" id="descriptionError"></div>
                                        </div>

                                        <div class="d-flex-column">
                                            <div class="textHead">PRODUCT PRICE</div>
                                            <input type="text" name="firstName" class="editBtn2 ms-3" id="firstName">
                                            <div class="error text-danger" id="priceError"></div>
                                        </div>

                                        <div class="d-flex ">
                                            <div class="d-flex-column">
                                                <div class="textHead">UPLOAD PHOTO</div>
                                                <input type="file" class="editBtn1 ms-3 " name="img" id="img1" multiple>
                                                <div class="error text-danger" id="imgError"></div>
                                            </div>
                                        </div>

                                        <div class="d-flex-column">
                                            <div class="textHead">PRODUCT TAX</div>
                                            <input type="number" name="firstName" class="editBtn2 ms-3" id="firstName">
                                            <div class="error text-danger" id="taxError"></div>
                                        </div>


                                        <button type="button" value="submit" class="btn mt-3 mb-5 ms-5" name="submit" <!--- onClick="return validation()" --->>SUBMIT</button>
                                        <button type="button" class="btn2 btn-secondary ms-5" data-bs-dismiss="modal">Close</button>
                                    </form>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>
