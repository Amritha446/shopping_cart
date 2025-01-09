function validateLogIn(){
    let userName = document.forms["form"]["userName"].value;
    let userPassword  = document.forms["form"]["userPassword"].value;
    let valid = true;

    if(userName == '' || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(mail) || !/^\d{10}$/.test(userName)){
        document.getElementById('usersError').textContent = 'Please enter your Mail/Phone No';
        valid = false;
    }
    else{
        document.getElementById('usersError').textContent = '';
    }
    if(userPassword  == '' || !/^\d{4}$/.test(userPassword)){
        document.getElementById('passError').textContent = 'Please enter your Password';
        valid = false;
    }
    else{
        document.getElementById('passError').textContent = '';
    }
    return valid;
}