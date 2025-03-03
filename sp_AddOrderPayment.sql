DELIMITER $$
CREATE PROCEDURE sp_AddOrderPayment(
    IN p_UserId INT,
    IN p_AddressId INT,
    IN p_TotalPrice DECIMAL(10, 2),
    IN p_TotalTax DECIMAL(10, 2),
    IN p_ProductId INT,
    IN p_UnitPrice DECIMAL(10, 2),
    IN p_UnitTax DECIMAL(10, 2),
    OUT v_OrderId VARCHAR(64)  
)
BEGIN
    SET v_OrderId = UUID();
    INSERT INTO tblorder (
        fldOrder_Id,
        fldUserId,
        fldAdressId,
        fldTotalPrice,
        fldTotalTax
    )
    VALUES (
        v_OrderId,
        p_UserId,
        p_AddressId,
        p_TotalPrice,
        p_TotalTax
    );
    IF p_ProductId IS NOT NULL AND p_ProductId != 0 THEN
        INSERT INTO tblorderitems (
            fldOrderId,
            fldProductId,
            fldQuantity,
            fldUnitPrice,
            fldUnitTax
        )
        VALUES (
            v_OrderId,
            p_ProductId,
            1,
            p_UnitPrice,
            p_UnitTax
        );
        DELETE FROM 
            tblcart 
        WHERE fldUserId = p_UserId
            AND fldProductId = p_ProductId;
    ELSE
		INSERT INTO tblorderitems (
			fldOrderId,
			fldProductId,
			fldQuantity,
			fldUnitPrice,
			fldUnitTax
		)
		SELECT
			v_OrderId, 
			c.fldProductId,
			c.fldQuantity,
			p.fldPrice,
			p.fldTax
		FROM 
			tblcart c
			INNER JOIN tblproduct p on p.fldProduct_Id = c.fldProductId
		WHERE 
			fldUserId = p_UserId
		;
        DELETE FROM 
            tblcart 
        WHERE 
            fldUserId = p_UserId;
    END IF;

END $$

DELIMITER ;