
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

function deleteCategory(event){
    console.log(event.target.value)
    if(confirm("Confirm delete?")){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=delCategory",
            data:{categoryId:event.target.value},
            success:function(result){
                event.target.parentNode.parentNode.remove()
                location.reload()
            }
        })
    }
    else{
        event.preventDefault()
    }
}

function editCategory(event){
    document.getElementById('categoryId').value=event.target.value;
    console.log(event.target.value)
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewEachCategory", 
        data:{categoryId:event.target.value},
        success:function(result){
            let formattedResult=JSON.parse(result);
            console.log(formattedResult)
            let categoryName = formattedResult;
            document.getElementById('categoryNameField').value = categoryName;
        }
    })
}

function editCategorySubmit(event){
    event.preventDefault()
    console.log(event.target.value)
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=updateCategory", 
        data:{categoryId:document.getElementById('categoryId').value,
            categoryName:document.getElementById('categoryNameField').value
        },
        success:function(){
            location.reload();
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

function editSubCategory(event){
    document.getElementById('subCategoryId').value=event.target.value;
    document.getElementById('addSubCategorySubmit').style.display="none";
    document.getElementById('editSubCategorySubmit').style.display="block";
    console.log(event.target.value)
    $.ajax({
        type:"POST",
        url:"Components/myCart.cfc?method=viewEachSubCategory", 
        data:{subCategoryId:event.target.value},
        success:function(result){
            let formattedResult=JSON.parse(result);
            console.log(formattedResult)
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
        url:"Components/myCart.cfc?method=updateSubCategory", 
        data:{subCategoryId:document.getElementById('subCategoryId').value,
            subCategoryName:document.getElementById('subCategoryNameField').value,
            categoryId:categoryId
        },
        success:function(){
           location.reload(); 
        }
    })
}
function deleteSubCategory(event){
    console.log(event.target.value)
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
            subCategoryId: new URLSearchParams(document.URL.split('?')[1]).get('subCategoryId') //passing values through url param
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
    console.log(event.target.value)
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
                    let subCategoryName = data.DATA[i][0];
                    let  subCategoryId= data.DATA[i][1];
                    let optionTag = `<option value="${subCategoryId}">${subCategoryId}</option>`;
                    $("#subCategoryIdProduct").append(optionTag);
                    console.log(subCategoryId)
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
            console.log(images)
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
            
        }
    });
}
    
function deleteImage() {
    let currentId = event.target.value;
    let Id = currentId.split(",")
    let currentImageId=Id[0]
    let currentProductId = Id[1]
    console.log(currentImageId)
    console.log(currentProductId)
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
                
            }
        });
    }
}

let currentIndex = 0;
let images = []; 
let mainImage = document.getElementById('main-image');
let thumbnailImages = document.querySelectorAll('.thumbnail');

// Function to change the main image when a thumbnail is clicked
function changeMainImage(thumbnail) {
    let mainImage = document.getElementById('main-image');
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
    // Get all elements with the class "hiddenProduct"
    var hiddenProducts = document.querySelectorAll('.hiddenProduct');

    hiddenProducts.forEach(function(product) {
        if (product.style.display === "none") {
            product.style.display = "block";
        } else {
            product.style.display = "block";
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
                if(result){
                    window.location.href = "cartPage.cfm";
                }
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
    console.log(event.target.getAttribute('value'))
    console.log('hi')

    if (currentQuantity < 20) { 
        quantityElement.textContent = currentQuantity + 1;
        updateTotalPrice();
        updateCartQuantity(productId, (currentQuantity + 1));
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
        updateCartQuantity(productId, (currentQuantity - 1));
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
        success:function(){
           location.reload(); 
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
        success:function(){
           location.reload(); 
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
        console.log(selectedAddressId)
        if (selectedAddressId) {
            document.getElementById('selectedAddressId').value = selectedAddressId;
            document.getElementById('hiddenAddressId').value = selectedAddressId;
        }
    });
});


function paymentData() {
    
    let cvv = $('#paymentCardCvv').val();
    let productId = $('#productDetailsPassing').val();
    let addressId = $('#addressDetailsPassing').val();
    let totalPrice = $('#priceDetailsHeading').text(); 
    let totalTax = $('#taxDetailsHeading').text(); 
    let cardNumber = document.getElementById('paymentCardNumber').value;

    console.log(cartId);
   
    let data = {
        cardNumber: cardNumber,
        cardCvv: cvv,
        productId: productId,
        addressId: addressId,
        totalPrice: totalPrice,
        totalTax: totalTax
    };

    console.log(data);

    $.ajax({
        url: "Components/myCart.cfc?method=vieworderPayment",
        type: "GET",
        data: data,
        success: function(response) {
            console.log("response: ", response);
        },
        error: function(xhr, status, error) {
            alert('error');
        }
    });
}



