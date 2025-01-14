
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
        data:{productId:event.target.value,
            subCategoryId:document.getElementById('subCategoryIdProduct').value
        },
        success:function(result){
            let formattedResult=JSON.parse(result);
            console.log(formattedResult)
            document.getElementById('categoryIdProduct').value = formattedResult.DATA[0][0].categoryId;
            document.getElementById('subCategoryIdProduct').value = formattedResult.DATA[0][1].subCategoryId;
            document.getElementById('productName').value = formattedResult.DATA[0][2].productName;
            document.getElementById('productBrand').value = formattedResult.DATA[0][3].productBrandId;
            document.getElementById('productDescrptn').value = formattedResult.DATA[0][4].productDescrptn;
            document.getElementById('productPrice').value = formattedResult.DATA[0][5].productPrice;
            document.getElementById('productTax').value = formattedResult.DATA[0][6].productTax;
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

    /* function viewProductButton1(event){
        $.ajax({
            type:"POST",
            url:"Components/myCart.cfc?method=viewProduct",
            data:{subCategoryId:2},
            success:function(result){
                location.reload();
            }
        })
    } */
    
