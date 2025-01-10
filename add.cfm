<html>
    <head>
        <title>Add Catgory</title>
        <link href = "css/bootstrap.min.css" rel="stylesheet" >
        <script src = "js/bootstrap.bundle.min.js"></script>
        <script src = "js/jquery.min.js"></script>
        <script src = "js/cartDashboard.js"></script>
        <link href = "css/style.css" rel="stylesheet">
        <link rel = "stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css"/>    
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
                                <input type="text" name="categoryName" class="inputs ms-5">
                            </div>
                            <button type="submit" name="submit" class="btn mt-3 ms-5">ADD</button>
                        </div>
                    </form>
                </div>
            </div>
             <cfif structKeyExists(form,"submit") >
                <cfset objCreate = createObject("component","components.myCart")>
                <cfset result = objCreate.addCategory(categoryName = form.categoryName)>
                <cflocation url="cartDashBoard.cfm">
            </cfif>
        </cfoutput>
    </body>
</html>