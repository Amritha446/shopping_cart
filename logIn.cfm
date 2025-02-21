    <cfparam name="url.productId" default=0>
    <cfparam name="url." default=0>
    <cfif url.productId NEQ 0>
        <cfset variables.productId = application.myCartObj.decryptUrl(encryptedData = url.productId)>
    </cfif>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex">
                    <a href="homePage.cfm" class="imageLink"><div class="headerText ms-5 mt-2 col-6">MyCart</div></a>
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
                            <div class="text-secondary mt-2 ms-3"> Email/Phone No</div>
                            <input type="text" name="userName" class="inputs ms-3">
                            <div class="error text-danger" id="usersError"></div>
                        </div>
                        <div class="input">
                            <div class="text-secondary mt-2 ms-3"> Password </div>
                            <input type="password" name="userPassword" class="inputs ms-3">
                            <div class="error text-danger" id="passError"></div>
                        </div>
                        <button type="submit" name="submit" class="btn mt-3 ms-2" onClick="return validate()">LogIn</button>
                        <div class="lastSec mt-3">Dont't have an Account? <a href="signUp.cfm" class="link">SignUp Here!</a></div>
                    </form>
                    <cfif structKeyExists(form,"submit")>
                    <cfset result=application.myCartObj.validateLogin(userName = form.userName , 
                                            userPassword  = form.userPassword )>
                    <cfif result == "true">
                        <cfif structKeyExists(variables, "productId")> 
                            <cfset application.myCartObj.addToCart(productId = variables.productId,
                                                                    cartToken = url.cartToken)>
                            <cflocation  url="cartPage.cfm"> 
                        <cfelse>
                            <cflocation  url="cartDashboard.cfm">
                        </cfif>
                        <cfelse>
                            <div class="text-danger ms-5">Invalid Login attempt.</div>
                        </cfif>
                    </cfif>
                </div>
            </div>
            
        </cfoutput>
    </body>
</html>