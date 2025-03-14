
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
            else if(!response.success){
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
    
function deleteCategory(event) {
    console.log(event.target.value);
    
    Swal.fire({
        title: 'Confirm Delete?',
        text: 'Are you sure you want to delete this category?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        reverseButtons: true, 
        customClass: {
            confirmButton: 'btn btn-success', 
            cancelButton: 'btn btn-danger' 
        }
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "Components/myCart.cfc?method=delItem",
                data: {
                    itemId: event.target.value,
                    itemType: "category"
                },
                success: function(result) {
                    event.target.parentNode.parentNode.remove();
                    Swal.fire(
                        'Deleted!',
                        'The category has been deleted.',
                        'success'
                    );
                }
            });
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            Swal.fire(
                'Cancelled',
                'The category was not deleted.',
                'info'
            );
        }
    });
}


function addCategoryFormSubmit(){
    event.preventDefault();
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveCategory", 
        data:{
            categoryName:document.getElementById('categoryNameAdd').value,
            operation:"add"
        },
        success:function(response){
            console.log(response)
            let result = JSON.parse(response);
            if (result == "Category added successfully.") {
                location.reload();
            } else {
                document.getElementById('categoryErrorMsg1').innerHTML = result;  
                console.log(response)
            }   
        } 
    })
}  

function editCategory(event, categoryId) {
    document.getElementById('categoryName_' + categoryId).style.display = 'none';
    document.getElementById('categoryNameField_' + categoryId).style.display = 'block';
    
    document.getElementById('saveb_' + categoryId).style.display = 'inline-block';
}

function saveCategory(event, categoryId) {
    event.preventDefault();
    const updatedCategoryName = document.getElementById('categoryNameField_' + categoryId).value;
    if (!updatedCategoryName.trim()) {
        document.getElementById('categoryErrorMsg').innerHTML = 'Category name cannot be empty.';
        return;
    }
    $.ajax({
        type: "POST",
        url: "Components/myCart.cfc?method=saveCategory", 
        data: {
            categoryId: categoryId,
            categoryName: updatedCategoryName,
            operation: "update"
        },
        success: function(response) {
            console.log(response)
            let result = JSON.parse(response);
            if (result == "Category updated successfully.") {
                document.getElementById('categoryName_' + categoryId).innerText = updatedCategoryName;
                document.getElementById('categoryName_' + categoryId).style.display = 'block';
                document.getElementById('categoryNameField_' + categoryId).style.display = 'none';
                document.getElementById('saveb_' + categoryId).style.display = 'none';
                document.getElementById('categoryErrorMsg').innerHTML = '';
            } else {
                document.getElementById('categoryErrorMsg').innerHTML = response;
            }
        }
    });
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
    document.getElementById('subCategoryErrorMsg').innerHTML = "";
    console.log('hi')
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=saveSubCategory", 
        data:{
            subCategoryName:document.getElementById('subCategoryNameField').value,
            categoryId:categoryId,
            operation:"add"
        },
        success:function(response){
            let result = JSON.parse(response);
            if (result == "Subcategory added successfully") {
                location.reload();
            } else {
                document.getElementById('subCategoryErrorMsg').innerHTML = result;
               
                console.log(result)
            }    
        }
    })
}

function editSubCategory(){
    document.getElementById('editSubCategorySubmit').style.display="block";
    document.getElementById('addSubCategorySubmit').style.display="none";
    document.getElementById('subCategoryId').value = event.target.value;
}

function editSubCategoryFormSubmit(){
    event.preventDefault()
    console.log(document.getElementById('subCategoryId').value)
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
            let result = JSON.parse(response);
            if (result == "Sub-category updated successfully!") {
                location.reload();
            } else {
                document.getElementById('subCategoryErrorMsg').innerHTML = result; 
            }  
        }
    })
}

function deleteSubCategory(event) {
    Swal.fire({
        title: 'Confirm Delete?',
        text: 'Are you sure you want to delete this subcategory?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        customClass: {
            confirmButton: 'btn btn-success', 
            cancelButton: 'btn btn-danger' 
        }
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "Components/myCart.cfc?method=delItem",
                data: {
                    itemId: event.target.value,
                    itemType: "subcategory"
                },
                success: function(result) {
                    event.target.parentNode.parentNode.remove();
                    Swal.fire(
                        'Deleted!',
                        'The subcategory has been deleted.',
                        'success'
                    );
                }
            });
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            Swal.fire(
                'Cancelled',
                'The subcategory was not deleted.',
                'info'
            );
        }
    });
}

function createNewProduct(){
    document.getElementById('heading').textContent = "Add Product";
    document.getElementById('createProductData').reset();
    document.getElementById('selectedImagesList').style.display = "none";
    document.getElementById('viewSelectedImgBtn').style.display = "none";
    $('.error').text("");
    $('#editProductDetails').modal('show'); 
}

function editProductDetailsButton(event){
    document.getElementById('heading').textContent = "Edit Product";
    document.getElementById('selectedImagesList').innerHTML = "";
    document.getElementById('createProductData').reset();
    document.getElementById('productId').value= event.target.value; 
    document.getElementById('selectedImagesList').style.display = "block";
    document.getElementById('viewSelectedImgBtn').style.display = "block";
    $('.error').text("");
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewProduct", 
        data:{productId:  event.target.value,
            subCategoryId: new URLSearchParams(document.URL.split('?')[1]).get('subCategoryId')
        },
        success:function(result){
            let formattedResult=JSON.parse(result);
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

function viewSelectedImages() {
    event.stopPropagation();
    let productId = document.getElementById('productId').value;
    $.ajax({
        type: "POST",
        url: "Components/myCart.cfc?method=getProductImages",
        data: { productId: productId },
        success: function (result) {
            document.getElementById('selectedImagesList').innerHTML = '';
            let images = JSON.parse(result);
            
            if (images.length === 0) {
                document.getElementById('selectedImagesList').innerHTML = 'No images found for this product.';
            } else {   
                let imageHtml = '';      
                images.forEach(function(image) {
                    let deleteButtonHtml = image.fldDefaultImage === 1 ? '' : `<button type="button" value="${image.fldProductImages_Id},${productId}" class="closeLink1">Delete</button>`;
                    let defaultButton = image.fldDefaultImage === 1 ? '' : `<button type="button" value="${image.fldProductImages_Id},${productId}" class="DefaultLink">Default</button>`;
                    imageHtml += `<div class="d-flex ">
                        <img src="assets/${image.fldImageFileName}" alt="${image.fldImageFileName}" width="50" height="50" />
                        <span>${image.fldImageFileName}</span>
                        ${deleteButtonHtml} 
                        ${defaultButton}
                    </div>`;
                });
                document.getElementById('selectedImagesList').innerHTML = imageHtml;
                document.getElementById('selectedImagesList').addEventListener('click', function(event) {
                    if (event.target && event.target.tagName === 'BUTTON') {
                        event.stopPropagation(); 
                        
                        if (event.target.classList.contains('closeLink')) {
                            deleteImage(event);
                        } 
                        else if (event.target.classList.contains('DefaultLink')) {
                            setDefaultImage(event);
                        }
                    }
                });
            }
        },    
        error: function (xhr, status, error) {
            document.getElementById('selectedImagesList').innerHTML = 'An error occurred while loading images.';
        }
    });
} 
 
function deleteProduct(event) {
    Swal.fire({
        title: 'Confirm Delete?',
        text: 'Are you sure you want to delete this product?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        customClass: {
            confirmButton: 'btn btn-success', 
            cancelButton: 'btn btn-danger'  
        }
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "Components/myCart.cfc?method=delItem",
                data: {
                    itemId: event.target.value,
                    itemType: "product"
                },
                success: function() {
                    event.target.parentNode.parentNode.remove();
                    Swal.fire(
                        'Deleted!',
                        'The product has been deleted.',
                        'success'
                    );
                }
            });
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            Swal.fire(
                'Cancelled',
                'The product was not deleted.',
                'info'
            );
        }
    });
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
                if (data.message === "Success") {
                    $("#subCategoryIdProduct").empty();

                    for (let i = 0; i < data.data.length; i++) {
                        let subCategoryId = data.data[i].fldSubCategory_Id;
                        let subCategoryName = data.data[i].fldSubCategoryName;
                        let optionTag = `<option value="${subCategoryId}">${subCategoryName}</option>`;
                        $("#subCategoryIdProduct").append(optionTag);
                    }
                } else {
                    alert('Error: ' + data.message);
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
            let activeClass = 'active';
            for (let i = 0; i < images.length; i++) {
                let image = images[i];
                let defaultImageClass = image.fldDefaultImage == 1 ? 'default-image' : '';
                let deleteButton = ''; 
                
                if (image.fldDefaultImage != 1) {
                    deleteButton = `
                        <button type="submit" class="btnImg2" onClick="deleteImage()" 
                        value="${image.fldProductImages_Id},${image.fldProductId}">Delete</button>
                    `;
                }
                carouselContent += `
                <div class="carousel-item ${activeClass}">
                    <div class="d-flex justify-content-evenly mb-2">
                        <button type="submit" class="btnImg1 " onClick="setDefaultImage()" 
                        value="${image.fldProductImages_Id},${image.fldProductId}">Default Set</button>
                        
                        ${deleteButton} 
                    </div>
                    <img src="assets/${image.fldImageFileName}" class="d-block ${defaultImageClass} mx-auto border border-1 p-3" alt="Image ${i+1}" height="200" width="200">
                    
                </div>
                `;
                
                activeClass = '';
            }

            $('#carouselImages').append(carouselContent);

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
    Swal.fire({
        title: 'Are you sure?',
        text: "Do you want to remove this product from your cart?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, remove it!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "Components/myCart.cfc?method=removeCartProduct",
                data: { CartId: event.target.value },
                success: function(result) {
                    Swal.fire({
                        title: 'Removed!',
                        text: 'The product has been removed from your cart.',
                        icon: 'success',
                        confirmButtonText: 'Okay'
                    }).then(() => {
                        location.reload();
                    });
                }
            });
        }
    });
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
            userPhoneNumber:document.getElementById('userPhoneNumber').value
        },
        success:function(response1){
            let response = JSON.parse(response1);
            console.log(response)
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
            success:function(response){
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
            let result = JSON.parse(response);
            if (result == "Order placed successfully.") {
                window.location.href = "paymentPage.cfm";
            } else {
                document.getElementById('paymentError').textContent = result;
            }
        },
        error: function (xhr, ajaxOptions, thrownError) {
            alert(thrownError);
          }
    });
}

function downloadInvoice(event) {
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=downloadOrderData",
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

let offset = 0;
function loadMoreProducts(subcategoryId,sort,count,min,max,minRange,maxRange) {
    var limit = 5; 
    offset = offset + limit;
    if (count < offset+5) {
        document.getElementById('viewMoreBtn').style.display = "none";
    } else {
        document.getElementById('viewMoreBtn').style.display = "block";
    }
    
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewProduct",
        data:{offset:offset,
            limit:limit,
            subcategoryId:subcategoryId,
            sort:sort,
            min:min,
            max:max,
            minRange:minRange,
            maxRange:maxRange
        },
        success: function(response) {
            let result = JSON.parse(response);
            result.DATA.forEach((product) => {
                let div = `
                    <div class="productBox d-flex flex-column">
                        <a href="productDetails.cfm?productId=${product[0]}&random=1" class="imageLink">
                            <img src="assets/${product[9]}" alt="img" class="productBoxImage">
                            <div class="ms-4 font-weight-bold h5">${product[2]}</div>
                            <div class="ms-4 h6 ">${product[3]}</div>
                            <div class="ms-4 small">$${product[5]}</div>
                        </a>
                    </div>
                `
            $('#productContainer').append(div);
            
            });
        },
    })
}




    


