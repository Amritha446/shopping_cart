    </head>
    <body>
        <cfoutput>
            <div class="container-fluid ">
                <div class="header d-flex text-align-center">
                    
                    <div class="headerText ms-5 mt-2 col-6">MyCart</div>
                    
                    <div class="ms-5"><i class="fa-solid fa-cart-shopping me-2 mt-2 p-2" style="color: ##fff"></i></div>

                    <a href="userProfile.cfm" class="profileButton">
                        <div class="profile d-flex me-5 mt-1 text-light p-2">
                            <div class="me-1 ">Profile</div>
                            <i class="fa-regular fa-user mt-1"></i>
                        </div>
                    </a>

                    <div class="logInBtn d-flex">
                        <a href="logIn.cfm" class="imageLink d-flex ms-5 text-light mt-3">
                            Home
                        </a>
                    </div>
                </div>
                <cfinclude template = "navbar.cfm">
                <div class="d-flex flex-column align-items-center justify-content-center p-5">
                    <img src="./assets/error.jpg" alt="errorImg" class="">
                    <div class="d-flex align-items-center justify-content-center text-danger mt-3 fs-5"><i class="fa-regular fa-face-frown me-1"></i> Something went wrong!Try again later.</div>
                    <a href = "homePage.cfm" class="imageLink d-flex align-items-center justify-content-center mt-3">Go back to Home Page</a>
                </div>
        </cfoutput>
    </body>
</html>
