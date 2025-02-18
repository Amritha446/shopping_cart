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
    DECLARE v_ProductId INT;
    DECLARE v_Quantity INT;
    DECLARE v_TotalCartItems INT;
    DECLARE v_Index INT DEFAULT 0;
    
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
    ELSE
        SELECT COUNT(*) INTO v_TotalCartItems
        FROM tblcart
        WHERE fldUserId = p_UserId;
        
        WHILE v_Index < v_TotalCartItems DO
            SELECT fldProductId, fldQuantity
            INTO v_ProductId, v_Quantity
            FROM tblcart
            WHERE fldUserId = p_UserId
            LIMIT v_Index, 1;
            
            INSERT INTO tblorderitems (
                fldOrderId,
                fldProductId,
                fldQuantity,
                fldUnitPrice,
                fldUnitTax
            )
            SELECT 
                p.fldUnitPrice,
                p.fldUnitTax,
                c.fldQuantity,
                v_OrderId,
                c.fldProductId
            FROM 
                tblcart c
                INNER JOIN tblproduct p on p.fldProduct_Id = c.fldProductId
            WHERE 
                fldUserId = p_UserId
            ;
            
            SET v_Index = v_Index + 1;
        END WHILE;
    END IF;
    
    DELETE FROM tblcart WHERE fldUserId = p_UserId;

    SELECT 'Order placed successfully.' AS message;
END $$

DELIMITER ;
