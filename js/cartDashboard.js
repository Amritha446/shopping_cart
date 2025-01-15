
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

function deleteCategory(event){
    console.log(event.target.value)
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
                    
                    // Add carousel slide
                    carouselContent += `
                    
                    <div class="carousel-item ${activeClass}">
                        <div class="d-flex imageButtonDiv">
                            <button type="submit" class="ms-3 btnImg1 " onClick="setDefaultImage()" value="${image.fldProductImages_Id},${image.fldProductId}">Default</button>
                            <button type="submit" class=" ms-3 btnImg2" onClick="deleteImage()" value="${image.fldProductImages_Id},${image.fldProductId}">Delete</button>
                        </div>
                        <img src="assets/${image.fldImageFileName}" class="d-block w-100 ${defaultImageClass}" alt="Image ${i+1}">
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
                /* loadProductImages(currentProductId); */ // Refresh images
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
                    /* loadProductImages(currentProductId); */ // Refresh images
                }
            });
        }
    }
    
    /* // Event listener for image clicks to set the current image ID
    $(document).on('click', '.image-item', function() {
        currentImageId = $(this).data('id');
        // Highlight the selected image (optional)
        $('.image-item').removeClass('selected');
        $(this).addClass('selected');
    }); */
        