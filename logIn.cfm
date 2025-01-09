<html>
    <head>
        <title>Login page</title>
        <link href="css/bootstrap.min.css" rel="stylesheet" >
        <script src="js/bootstrap.bundle.min.js"></script>
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"  />
        <script src="js/validateLogIn.js"></script>
    </head>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">USER LOGIN</div>
                    <div class="logIn d-flex">
                        <a href="login.cfm" class="link d-flex">
                            <i class="fa-solid fa-user mb-1 mt-1" style="color:##fff"></i><div class="text-white ms-2">SignUp</div>
                        </a>
                    </div>
                </div>     
                <div class="mainSection mb-5 mt-5 justify-content-center align-items-center ps-5">
                    <h5 class = "heading fs-3 mt-2 ms-5 ps-5">LOGIN</h5>
                    <form method="post" class="ms-5 " name="form">
                        <div class="input d-flex-column">
                            <div class="text-secondary mt-2 ms-5"> Email/Phone No</div>
                            <input type="text" name="userName" class="inputs ms-3">
                            <div class="error text-danger" id="usersError"></div>
                        </div>
                        <div class="input">
                            <div class="text-secondary mt-2 ms-5"> Password </div>
                            <input type="password" name="userPassword" class="inputs ms-3">
                            <div class="error text-danger" id="passError"></div>
                        </div>
                        <button type="submit" name="submit" class="btn mt-3 ms-2" onClick = "return validateLogIn()">LogIn</button>
                        <div class="lastSec mt-3">Dont't have an Account? <a href="signUp.cfm" class="link">SignUp Here!</a></div>
                    </form>
                </div>
            </div>
            <cfif structKeyExists(form,"submit")>
                <cfset loginObj=createObject("component","components.myCart")>
                <cfset result=loginObj.validateLogin(userName = form.userName , userPassword  = form.userPassword )>
                <cfif  result == "true">
                    <cflocation  url="cartDashboard.cfm">
                <cfelse>
                    <div class="text-danger">Invalid Login attempt.</div>
                </cfif>
            </cfif>
        </cfoutput>
    </body>
</html>