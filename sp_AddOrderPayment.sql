DELIMITER $$
CREATE PROCEDURE sp_AddOrderPayment(
    IN p_UserId INT,
    IN p_AddressId INT,
    IN p_ProductId INT,
    OUT v_OrderId VARCHAR(64),  
    OUT Error VARCHAR(64)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET Error = 'Error occured';
        ROLLBACK;
        SIGNAL SQLSTATE '45000';
    END;

    START TRANSACTION;

    SET v_OrderId = UUID();
   
    INSERT INTO tblorder (
        fldOrder_Id,
        fldUserId,
        fldAdressId,
        fldTotalPrice,
        fldTotalTax
    )
    SELECT 
        v_OrderId,
        p_UserId,
        p_AddressId,
        SUM(c.fldQuantity * p.fldPrice) AS totalPrice, 
        SUM(c.fldQuantity * p.fldTax * p.fldPrice/100) AS totalTax
    FROM 
        tblcart c
        INNER JOIN tblproduct p ON c.fldProductId = p.fldProduct_Id
    WHERE 
        c.fldUserId = p_UserId
	GROUP BY c.fldUserId;
    
    IF p_ProductId IS NOT NULL AND p_ProductId != 0 THEN
        INSERT INTO tblorderitems (
            fldOrderId,
            fldProductId,
            fldQuantity,
            fldUnitPrice,
            fldUnitTax
        )
        SELECT 
            v_OrderId,
            p_ProductId,
            1,
            fldPrice,
            fldTax
        FROM 
            tblproduct
        WHERE 
            fldProduct_Id = p_ProductId;

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
    COMMIT;
END $$

DELIMITER ;