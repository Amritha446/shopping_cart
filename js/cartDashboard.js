
function logoutUser(){
    if(confirm("Confirm Logout?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=logout",
            success:function(){
                location.reload();
            }
        })
    }
}

function signUpFunction() {

    var firstName = document.getElementById('firstName').value;
    var lastName = document.getElementById('lastName').value;
    var mail = document.getElementById('mail').value;
    var phone = document.getElementById('phone').value;
    var password = document.getElementById('userPassword').value;
    document.getElementById('validationError').innerHTML = "";
    $.ajax({
        type: "POST",
        url: "Components/myCart.cfc?method=signUp", 
        data: {
            firstName: firstName,
            lastName: lastName,
            mail: mail,
            phone: phone,
            password: password
        },
        success: function(response1) {
            let response = JSON.parse(response1);
            document.getElementById('firstnameError').innerHTML = '';
            document.getElementById('lastnameError').innerHTML = '';
            document.getElementById('mailError').innerHTML = '';
            document.getElementById('phoneError').innerHTML = '';
            document.getElementById('passwordError').innerHTML = '';
            // document.getElementById('successMsg').remove();
            if (response.firstName) {
                document.getElementById('firstnameError').innerHTML = response.firstName;
            }
            if (response.lastName) {
                document.getElementById('lastnameError').innerHTML = response.lastName;
            }
            if (response.mail) {
                document.getElementById('mailError').innerHTML = response.mail;
            }
            if (response.phone) {
                document.getElementById('phoneError').innerHTML = response.phone;
            }
            if (response.password) {
                document.getElementById('passwordError').innerHTML = response.password;
            }

            if(!response.success){
                document.getElementById('validationError').innerHTML = response.message;
            }
            else{    
                document.getElementById('successMsg').innerHTML = response.message;
                let aTag = document.createElement('a'); 
                aTag.className = "successAnchor";
                aTag.innerHTML = "Click here to log in";
                aTag.href = "logIn.cfm";
                document.getElementById('successMsg').append(aTag)
            }
        },
        error: function() {
            alert('An error occurred while submitting the form.');
        }
    });
}
    
function deleteCategory(event){
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=delCategory",
            data:{categoryId:event.target.value},
            success:function(result){
                event.target.parentNode.parentNode.remove()
            }
        })
    }
    else{
        event.preventDefault()
    }
}

function addCategoryFormSubmit(){
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveCategory", 
        data:{
            categoryName:document.getElementById('categoryNameAdd').value,
            operation:"add"
        },
        success:function(response){
            location.reload();
           if (response === "Category addedd successfully") {
                window.location.href="cartDashboard.cfm";
            } else {
                alert(response);  
            }   
        } 
    })
}

function editCategory(event){
    document.getElementById('categoryId').value=event.target.value;
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewEachCategory", 
        data:{categoryId:event.target.value},
        success:function(result){
            let formattedResult=JSON.parse(result);
            let categoryName = formattedResult;
            document.getElementById('categoryNameField').value = categoryName;
        }
        }
    )
}

function editCategorySubmit(event){
    event.preventDefault()
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveCategory", 
        data:{categoryId:document.getElementById('categoryId').value,
            categoryName:document.getElementById('categoryNameField').value,
            operation:"update"
        },
        success:function(response){
            location.reload();
            if (response === "Updated successfully") {
                location.reload();
            } else {
                alert(response);
            } 
        }
    })
}

function redirectSubCategory(event){
    window.location.href = "subCategory.cfm?categoryId=" + event;
}

function createSubCategory(){
    document.getElementById('createSubCategory').reset();
    $('.error').text("");
    $('#editSubContact').modal('show')
    document.getElementById('editSubCategorySubmit').style.display="none";
    document.getElementById('addSubCategorySubmit').style.display="block";

}

function addSubCategoryFormSubmit(){
    let categoryId = document.getElementById('categoryFrmSubCategory').value;
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveSubCategory", 
        data:{
            subCategoryName:document.getElementById('subCategoryNameField').value,
            categoryId:categoryId,
            operation:"add"
        },
        success:function(response){
            location.reload();
           if (response === "Subcategory updated successfully") {
                location.reload();
            } else {
                alert(response);  
            }    
        }
    })
}

function editSubCategory(event){
    document.getElementById('subCategoryId').value=event.target.value;
    document.getElementById('addSubCategorySubmit').style.display="none";
    document.getElementById('editSubCategorySubmit').style.display="block";
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewEachSubCategory", 
        data:{subCategoryId:event.target.value},
        success:function(result){
            let formattedResult=JSON.parse(result);
            let subCategoryName = formattedResult;
            document.getElementById('subCategoryNameField').value = subCategoryName;
        }
    })
}

function editSubCategoryFormSubmit(){
    event.preventDefault()
    /* document.getElementById('buttonName').textContent = "update"; */
    let categoryId = document.getElementById('categoryFrmSubCategory').value;
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveSubCategory", 
        data:{subCategoryId:document.getElementById('subCategoryId').value,
            subCategoryName:document.getElementById('subCategoryNameField').value,
            categoryId:categoryId,
            operation:"update"
        },
        success:function(response){
            location.reload();
           if (response === "Sub-Category updated successfully!") {
                location.reload();
            } else {
                alert(response);  
            }  
        }
    })
}
function deleteSubCategory(event){
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=delSubCategory",
            data:{subCategoryId:event.target.value},
            success:function(result){
                event.target.parentNode.parentNode.remove()
            }
        })
    }
    else{
        event.preventDefault()
    }
}

function createNewProduct(){
    document.getElementById('heading').textContent = "ADD PRODUCT";
    document.getElementById('createProductData').reset();
    $('.error').text("");
    $('#editProductDetails').modal('show'); 
}

function editProductDetailsButton(event){
    document.getElementById('heading').textContent = "EDIT PRODUCT";
    document.getElementById('createProductData').reset();
    document.getElementById('productId').value= event.target.value; 
    $('.error').text("");
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewProduct", 
        data:{productId:  event.target.value,
            subCategoryId: new URLSearchParams(document.URL.split('?')[1]).get('subCategoryId')
        },
        success:function(result){
            let formattedResult=JSON.parse(result);
            console.log(formattedResult)
            document.getElementById('productId').value = formattedResult.DATA[0][0];
            document.getElementById('subCategoryIdProduct').value = formattedResult.DATA[0][1];
            document.getElementById('productName').value = formattedResult.DATA[0][2];
            document.getElementById('productBrand').value = formattedResult.DATA[0][7];
            document.getElementById('productDescrptn').value = formattedResult.DATA[0][4];
            document.getElementById('productPrice').value = formattedResult.DATA[0][5];
            document.getElementById('productTax').value = formattedResult.DATA[0][6];  
        }
    })
}

function deleteProduct(event){
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=delProduct",
            data:{productId:event.target.value},
            success:function(result){
                event.target.parentNode.parentNode.remove()
            }
        })
    }
    else{
        event.preventDefault()
    }
}

$(document).ready(function() {
    $("#categoryIdProduct").change(function() {
        let categoryId = this.value;
        $.ajax({
            type: "POST",
            url: "./Components/myCart.cfc?method=viewSubCategoryData",
            data: {
                categoryId: categoryId
            },
            success: function(response) {
                const data = JSON.parse(response);
                $("#subCategoryIdProduct").empty();
                for(let i=0; i<data.DATA.length; i++) {
                    let subCategoryId = data.DATA[i][0];
                    let  subCategoryName= data.DATA[i][1];
                    let optionTag = `<option value="${subCategoryId}">${subCategoryName}</option>`;
                    $("#subCategoryIdProduct").append(optionTag);
                }
            }
        });	
    });
});

function loadProductImages() {
    let productId = event.target.value;
    
    $.ajax({
        url: './Components/myCart.cfc?method=getProductImages', 
        data: { productId: productId },
        type: 'POST',
        success: function(response) {
            let images = JSON.parse(response);
            let carouselContent = '';
            let activeClass = 'active'; // To mark the first image as active
            for (let i = 0; i < images.length; i++) {
                let image = images[i];
                let defaultImageClass = image.fldDefaultImage == 1 ? 'default-image' : '';
                
                carouselContent += `
                
                <div class="carousel-item ${activeClass}">
                    <div class="d-flex imageButtonDiv">
                        <button type="submit" class="ms-3 btnImg1 " onClick="setDefaultImage()" 
                        value="${image.fldProductImages_Id},${image.fldProductId}">Default Set</button>
                        <button type="submit" class=" ms-3 btnImg2" onClick="deleteImage()" 
                        value="${image.fldProductImages_Id},${image.fldProductId}">Delete</button>
                    </div>
                    <img src="assets/${image.fldImageFileName}" class="d-block w-100 ${defaultImageClass}" alt="Image ${i+1}">
                    <button type="button" class="btn3 btn-secondary ms-4" data-bs-dismiss="modal" id="closeBtnId">Close</button>
                </div>
                
                `;
                
                activeClass = '';
            }

            $('#carouselImages').html(carouselContent);
            
        }
    });
}
    
function setDefaultImage() {
    let currentId = event.target.value;
    let Id = currentId.split(",")
    let currentImageId=Id[0]
    let currentProductId = Id[1]

    if (!currentImageId) return alert('No image selected');

    $.ajax({
        url: './Components/myCart.cfc?method=setDefaultImage',
        type: 'POST',
        data: { 
            productId: currentProductId,
            imageId: currentImageId
        },
        success: function(response) {
            alert('Default image updated successfully!');
            location.reload();
        }
    });
}
    
function deleteImage() {
    let currentId = event.target.value;
    let Id = currentId.split(",")
    let currentImageId=Id[0]
    let currentProductId = Id[1]
    if (!currentImageId) return alert('No image selected');

    if (confirm('Are you sure you want to delete this image?')) {
        $.ajax({
            url: './Components/myCart.cfc?method=deleteImage',
            type: 'POST',
            data: { 
                productId: currentProductId,
                imageId: currentImageId
            },
            success: function(response) {
                alert('Image deleted successfully!');
                location.reload();
            }
        });
    }
}

let currentIndex = 0;
let images = []; 
let mainImage = document.getElementById('mainImage');
let thumbnailImages = document.querySelectorAll('.thumbnail');

// Function to change the main image when a thumbnail is clicked
function changeMainImage(thumbnail) {
    let mainImage = document.getElementById('mainImage');
    let newImageSrc = thumbnail.src; 
    mainImage.src = newImageSrc; 
    
    images.forEach((img, index) => {
        if (img === newImageSrc) {
            currentIndex = index;
        }
    });
}
window.onload = function() {
    thumbnailImages = document.querySelectorAll('.thumbnail');
    thumbnailImages.forEach(thumbnail => {
        thumbnail.addEventListener('click', function() {
            changeMainImage(thumbnail);
        });
    });
};

function toggleProducts() {
    // elements with class "hiddenProduct"
    var hiddenProducts = document.querySelectorAll('.hiddenProduct');

    hiddenProducts.forEach(function(product) {
        if (product.style.display === "none") {
            product.style.display = "block";
        } else {
            product.style.display = "none";
        }
    });

    let button = document.querySelector('.viewMoreButton');
    if (button.innerHTML === "View More") {
        button.innerHTML = "View Less";
    } else{
        button.innerHTML = "View More";
    }
}
//  hiding extra products 
document.querySelectorAll('.hiddenProduct').forEach(function(product) {
    product.style.display = "none";
});
 
function removeCartProduct(event) {
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=removeCartProduct", 
            data:{CartId:event.target.value},
            success:function(result){
                location.reload()
            }     
        })
    } 
}      

function updateTotalPrice() {
    let totalPrice = 0;
    let totalTaxAmount = 0; 

    document.querySelectorAll('.cartItem').forEach(cartItem => {
        const quantityElement = cartItem.querySelector('.quantityNumber');
        const priceElement = cartItem.querySelector('.productPrice');
        const taxElement = cartItem.querySelector('.productActualPrice');
        const actualPriceElement = cartItem.querySelector('.productTax');
        const totalPriceElement = cartItem.querySelector('.totalPrice');
        
        if (!quantityElement || !priceElement || !taxElement || !actualPriceElement || !totalPriceElement) return;

        const quantity = parseInt(quantityElement.textContent);
        const price = parseFloat(priceElement.textContent.replace('Unit Price:$', '').trim());
        const taxPercentage = parseFloat(taxElement.textContent.replace('Product Tax:', '').replace('%', '').trim());

        const unitTaxAmount = (taxPercentage / 100) * price;

        const actualPrice = price + unitTaxAmount;

        actualPriceElement.textContent = 'Actual Price:$' + actualPrice.toFixed(2);

        const totalPriceForItem = quantity * actualPrice; 

        totalPrice += totalPriceForItem;

        totalPriceElement.textContent = 'Total Price:$' + totalPriceForItem.toFixed(2);

        const totalTaxForItem = quantity * unitTaxAmount;

        totalTaxAmount += totalTaxForItem;
    });

    const totalPriceElement = document.querySelector('.priceDetailsHeading');
    if (totalPriceElement) {
        totalPriceElement.textContent = 'Total Price: $' + totalPrice.toFixed(2);
    }
    const totalTaxElement = document.querySelector('.taxDetailsHeading');
    if (totalTaxElement) {
        totalTaxElement.textContent = 'Total Tax: $' + totalTaxAmount.toFixed(2);
    }
}


function incrementQuantity(event) {
    const cartItem = event.target.closest('.cartItem');
    const quantityElement = cartItem.querySelector('.quantityNumber');
    let currentQuantity = parseInt(quantityElement.textContent);
    let productId = event.target.getAttribute('value');
    if (currentQuantity < 21) { 
        quantityElement.textContent = currentQuantity + 1;
        updateTotalPrice();
        if (document.getElementById('hiddenQuantityUpdate').value == 1) {
            updateCartQuantity(productId, (currentQuantity + 1));
        } 
    }
}

function decrementQuantity(event) {
    const cartItem = event.target.closest('.cartItem');
    const quantityElement = cartItem.querySelector('.quantityNumber');
    let currentQuantity = parseInt(quantityElement.textContent);
    let productId = event.target.getAttribute('value');

    if (currentQuantity > 1) { 
        quantityElement.textContent = currentQuantity - 1;
        updateTotalPrice(); 
        if (document.getElementById('hiddenQuantityUpdate').value == 1) {
            updateCartQuantity(productId, (currentQuantity - 1));
        } 
    }
}

document.addEventListener('DOMContentLoaded', updateTotalPrice);

document.querySelectorAll('.increment').forEach(button => {
    button.addEventListener('click', incrementQuantity);
});

document.querySelectorAll('.decrement').forEach(button => {
    button.addEventListener('click', decrementQuantity);
});

function updateCartQuantity(productId, newQuantity) {
    $.ajax({
        type: "GET",
        url: "Components/myCart.cfc?method=addToCart",
        data: {
            productId: productId,
            quantity: newQuantity
        },
        success: function() {
            console.log("Quantity updated successfully");
        }
    });
}


function editUser(){
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=userDetailsFetching", 
        success:function(result){
            let formattedResult=JSON.parse(result);
            document.getElementById('userFirstNameProfile').value = formattedResult.DATA[0][0]; 
            document.getElementById('userLastNameProfile').value = formattedResult.DATA[0][1];
            document.getElementById('userPhoneNumberProfile').value = formattedResult.DATA[0][2];
            document.getElementById('userEmailProfile').value = formattedResult.DATA[0][3];
        }
    })
}
function editUserSubmit(){
    event.preventDefault()
    $.ajax({
        type:"GET",
        url:"Components/myCart.cfc?method=userDetailsUpdating", 
        data:{userFirstName:document.getElementById('userFirstNameProfile').value,
            userLastName:document.getElementById('userLastNameProfile').value,
            userEmail:document.getElementById('userPhoneNumberProfile').value,
            userPhoneNumber:document.getElementById('userEmailProfile').value 
        },
        success:function(response){
            if (JSON.parse(response) === "Updated User details successfully") {
                alert("User details updated successfully!");
                location.reload();
            } else {
                alert(response);
            } 
        }
    })
}

function editUserAddress(){
    event.preventDefault()
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=addUserAddress", 
        data:{userFirstName:document.getElementById('addressFirstName').value,
            userLastName:document.getElementById('addressLastName').value,
            addressLine1:document.getElementById('addressLine1').value,
            addressLine2:document.getElementById('addressLine2').value,
            userCity:document.getElementById('userCity').value,
            userState:document.getElementById('userState').value,
            userPincode:document.getElementById('userPincode').value,
            userPhoneNumber:document.getElementById('userPhoneNumber').value,
        },
        success:function(response1){
            
            let response = JSON.parse(response1);
            document.getElementById('addressFirstNameError').innerHTML = '';
            document.getElementById('addressLastNameError').innerHTML = '';
            document.getElementById('addressLine1Error').innerHTML = '';
            document.getElementById('addressLine2Error').innerHTML = '';
            document.getElementById('userCityError').innerHTML = '';
            document.getElementById('userStateError').innerHTML = '';
            document.getElementById('userPincodeError').innerHTML = '';
            document.getElementById('userPhoneNumberError').innerHTML = '';
            if (response.userFirstName) {
                document.getElementById('addressFirstNameError').innerHTML = response.userFirstName;
            }
            if (response.userLastName) {
                document.getElementById('addressLastNameError').innerHTML = response.userFirstName;
            }
            if (response.addressLine1) {
                document.getElementById('addressLine1Error').innerHTML = response.addressLine1;
            }
            if (response.addressLine2) {
                document.getElementById('addressLine2Error').innerHTML = response.addressLine2;
            }
            if (response.userCity) {
                document.getElementById('userCityError').innerHTML = response.userCity;
            }
            if (response.userState) {
                document.getElementById('userStateError').innerHTML = response.userState;
            }
            if (response.userPincode) {
                document.getElementById('userPincodeError').innerHTML = response.userPincode;
            }
            if (response.userPhoneNumber) {
                document.getElementById('userPhoneNumberError').innerHTML = response.userPhoneNumber;
            }
            else{    
                window.location.href = "userProfile.cfm";
            }
        },
        error: function() {
            alert('An error occurred while submitting the form.');
        }
    })
}

function removeAddress(event){
    event.preventDefault
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"GET",
            url:"Components/myCart.cfc?method=removeUserAddress",
            data:{addressId:event.target.value},
            success:function(){
                location.reload(); 
            }
        })
    }
}

document.querySelectorAll('.address-radio').forEach(function (radioButton) {
    radioButton.addEventListener('change', function () {
        const selectedAddressId = document.querySelector('input[name="addressRadio"]:checked')?.value;
        if (selectedAddressId) {
            document.getElementById('selectedAddressId').value = selectedAddressId;
            document.getElementById('hiddenAddressId').value = selectedAddressId;
        }
    });
});

function paymentData() {
    let cvv = $('#paymentCardCvv').val();
    let cardNumber = document.getElementById('paymentCardNumber').value;
    let productIdd = $('#productDetailsPassing').val();
    let addressId = $('#addressDetailsPassing').val();
    let totalPriceText = $('#priceDetailsHeading').text().trim();
    let totalTaxText = $('#taxDetailsHeading').text().trim();
    let unitPrice = document.getElementById('unitPriceProduct').value;
    let unitTax = document.getElementById('unitTaxProduct').value;

    let cleanTotalPrice = totalPriceText.replace(/[^\d.-]/g, '');
    let cleanTotalTax = totalTaxText.replace(/[^\d.-]/g, '');
    let cleanProductId = productIdd.replace(/[^\d.-]/g, '');

    let totalPrice = isNaN(parseFloat(cleanTotalPrice)) ? 0 : parseFloat(cleanTotalPrice);
    let totalTax = isNaN(parseFloat(cleanTotalTax)) ? 0 : parseFloat(cleanTotalTax);
    let productId = isNaN(parseFloat(cleanProductId)) ? 0 : parseFloat(cleanProductId);

    document.querySelectorAll('.cartItem').forEach(cartItem => {
        const productId = cartItem.querySelector('.increment').getAttribute('value'); 
        const quantity = parseInt(cartItem.querySelector('.quantityNumber').textContent);
        updateCartQuantity(productId, quantity); 
    });
    console.log(productId)

    let data = {
        cardNumber: cardNumber,
        cvv: cvv,
        productId: productId,
        addressId: addressId,
        totalPrice: totalPrice,
        totalTax: totalTax,
        unitPrice: unitPrice,
        unitTax: unitTax
    };
    $.ajax({
        url: "Components/myCart.cfc?method=addOrderPayment",
        type: "POST",
        data: data,
        success: function(response) {
           if (JSON.parse(response) === "Order placed successfully.") {
                window.location.href = "paymentPage.cfm";
            } else {
                alert(response);
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
          }
    });
}

function downloadInvoice(event) {
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=orderHistoryDisplay",
        data:{orderId:event.target.value}
    })
}
function checkAddressBeforeOrder(event) {
    var addressRecordCount = event.target.getAttribute('data-recordcount');
    if (addressRecordCount == 0) {
        document.getElementById('addressErrorMessage').style.display = 'block';
        document.getElementById('placeOrderBtn').disabled = true; 
    } else {
        $('#orderItems').modal('show');
    }
}
    


