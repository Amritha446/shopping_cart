function validation(){
    let categoryIdProduct = document.forms["form"]["categoryIdProduct"].value;
    let subCategoryIdProduct = document.forms["form"]["subCategoryIdProduct"].value;
    let productName = document.forms["form"]["productName"].value;
    let productBrand = document.forms["form"]["productBrand"].value;
    let productDescrptn = document.forms["form"]["productDescrptn"].value;
    let productPrice = document.forms["form"]["productPrice"].value;
    let productImg = document.forms["form"]["productImg"].value;
    let productTax = document.forms["form"]["productTax"].value;
    let valid = true;

    if(categoryIdProduct == ''){
        document.getElementById('categoryError').textContent = 'Please select category';
        valid = false;
    }
    else{
        document.getElementById('categoryError').textContent = '';
    }
    if(subCategoryIdProduct == ''){
        document.getElementById('subCategoryError').textContent = 'Please select sub-category';
        valid = false;
    }
    else{
        document.getElementById('subCategoryError').textContent = '';
    }
    if(productName == ''){
        document.getElementById('productNameError').textContent = 'Please enter Product Name';
        valid = false;
    }
    else{
        document.getElementById('productNameError').textContent = '';
    }
    if(productBrand == ''){
        document.getElementById('brandError').textContent = 'Please select Brand';
        valid = false;
    }
    else{
        document.getElementById('brandError').textContent = '';
    }
    if(productDescrptn == ''){
        document.getElementById('descriptionError').textContent = 'Please enter product description';
        valid = false;
    }
    else{
        document.getElementById('descriptionError').textContent = '';
    }
    if(productPrice == ''){
        document.getElementById('priceError').textContent = 'Please enter product price';
        valid = false;
    }
    else{
        document.getElementById('priceError').textContent = '';
    }
    if(productImg == '' && document.getElementById('productId').value == ""){
        document.getElementById('imgError').textContent = 'Please upload image';
        valid = false;
    }
    else{
        document.getElementById('imgError').textContent = '';
    }
    if(productTax == ''){
        document.getElementById('taxError').textContent = 'Please enter product tax';
        valid = false;
    }
    else{
        document.getElementById('taxError').textContent = '';
    }
    return valid;
}