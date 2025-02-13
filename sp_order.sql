use shoppingcart

DELIMITER $$
CREATE PROCEDURE sp_InsertOrder(
	IN p_Order_Id VARCHAR(64),
    IN p_UserId INT,
    IN p_AddressId INT,
    IN p_TotalPrice DECIMAL(10,2),
    IN p_TotalTax DECIMAL(10,2)
)
BEGIN
    INSERT INTO tblorder(fldOrder_Id,fldUserId, fldAdressId, fldTotalPrice, fldTotalTax)
    VALUES(p_Order_Id,p_UserId, p_AddressId, p_TotalPrice, p_TotalTax);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_InsertOrderItems(
    IN p_OrderId VARCHAR(64),
    IN p_ProductId INT,
    IN p_Quantity INT,
    IN p_UnitPrice DECIMAL(10,2),
    IN p_UnitTax DECIMAL(10,2)
)
BEGIN
    INSERT INTO tblorderitems(fldOrderId, fldProductId, fldQuantity, fldUnitPrice, fldUnitTax)
    VALUES(p_OrderId, p_ProductId, p_Quantity, p_UnitPrice, p_UnitTax);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_ClearCart(
    IN p_UserId INT
)
BEGIN
    -- Delete all items from tblcart for the specified user
    DELETE FROM tblcart WHERE fldUserId = p_UserId;
END $$
DELIMITER ;

SHOW PROCEDURE STATUS WHERE Db = 'shoppingcart';
CALL sp_ClearCart(3);  -- clear cart
DROP PROCEDURE IF EXISTS sp_AddOrderPayment;

