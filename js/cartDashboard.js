function logoutUser(){
    if(confirm("Confirm Logout?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=logout",
            success:function(result){
                if(result){
                    location.reload();
                    return true; 
                }
            }
        })
    }
    else{
        event.preventDefault()
    }
}