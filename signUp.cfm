<!--- <html>
    <head>
        <title>signUp page</title>
        <script src="js/validate.js"></script>
         <link href="css/bootstrap.min.css" rel="stylesheet" >
        <script src="js/bootstrap.bundle.min.js"></script>
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"/> --->
    </head>
    <body>
        <cfoutput>
            <div class="container-fluid">
                <div class="header d-flex">
                    <div class="headerText ms-5 mt-2">USER SIGNUP</div>
                    <div class="logIn d-flex">
                        <a href="login.cfm" class="link d-flex">
                            <i class="fa-solid fa-right-to-bracket mb-1 mt-1 ms-3" style="color:##fff"></i>
                            <div class="text-white ms-2">LogIn</div>
                        </a>
                    </div>
                </div>
                    <div class="mainSection mb-5 mt-5">
                        <p class=" headingSignup fs-3 mt-2 ms-5 ps-5">USER DETAILS</p>
                        <form method="post" class="ms-4 signUpForm" enctype="multipart/form-data" name="form">
                            <div class = "d-flex">
                                <div class="input d-flex-column">
                                    <div class="text-secondary mt-3 ms-2"> First Name</div>
                                    <input type="text" name="firstName" class="inputs me-2" required>
                                    <div class="error text-danger" id="fullnameError"></div>
                                </div>
                                <div class="input d-flex-column">
                                    <div class="text-secondary mt-3 ms-2"> Last Name</div>
                                    <input type="text" name="lastName" class="inputs ms-2" required>
                                    <div class="error text-danger" id="fullnameError"></div>
                                </div>
                            </div>
                            <div class = "d-flex">
                                <div class="input d-flex-column">
                                    <div class="text-secondary mt-3 ms-2"> Email Id</div>
                                    <input type="text" name="mail" class="inputs me-2">
                                    <div class="error text-danger" id="mailError"></div>
                                </div>
                                <div class="input d-flex-column">
                                    <div class="text-secondary mt-3 ms-2"> Phone No</div>
                                    <input type="text" name="phone" class="inputs ms-2">
                                    <div class="error text-danger" id="userError"></div>
                                </div>
                            </div>
                            <div class = "d-flex">
                                <div class="input">
                                <div class="text-secondary mt-3 ms-2"> Password </div>
                                    <input type="password" name="userPassword" class="inputs me-2">
                                    <div class="error text-danger" id="pass1Error"></div>
                                </div>
                                <div class="input d-flex-column">
                                <div class="text-secondary mt-3 ms-2"> Confirm Password</div>
                                    <input type="password" name="userPassword2" class="inputs ms-2">
                                    <div class="error text-danger" id="pass2Error"></div>
                                </div>
                            </div>
                            <button type="submit" name="submit" class="btn mt-5 ms-5" >REGISTER</button>
                            <div class="lastSec mt-3 ms-5">Already have an Account? <a href="login.cfm" class="link">LogIn Here!</a></div>
                        </form>
                    </div>
                </div>
            </div>
            <cfif structKeyExists(form, "submit")>
                <cfset obj=createObject("component","components.myCart")>
                <cfset result=obj.signUp(firstName = form.firstName ,
                    lastName = form.lastName ,
                    mail = form.mail ,
                    phone = form.phone ,
                    password = form.userPassword)>
                    <cflocation  url="homePage.cfm">
                <!--- <cftry>
                    #result#
                </cftry> --->
            </cfif>
            
        </cfoutput>    
    </body>
</html>