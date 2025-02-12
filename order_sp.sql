DELIMITER $$

CREATE PROCEDURE sp_AddOrderPayment(
    IN p_UserId INT,
    IN p_AddressId INT,
    IN p_TotalPrice DECIMAL(10, 2),
    IN p_TotalTax DECIMAL(10, 2),
    IN p_ProductId INT,
    IN p_CardNumber BIGINT,
    IN p_CVV INT,
    IN p_UnitPrice DECIMAL(10, 2),
    IN p_UnitTax DECIMAL(10, 2)
)
BEGIN
    DECLARE v_OrderId VARCHAR(64);
    DECLARE v_ProductId INT;
    DECLARE v_Quantity INT;
    DECLARE v_Cursor CURSOR FOR 
        SELECT fldProductId, fldQuantity FROM tblcart WHERE fldUserId = p_UserId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_OrderId = NULL;

    SET v_OrderId = UUID();

    IF p_CardNumber = 4321 AND p_CVV = 434 THEN

        CALL sp_InsertOrder(v_OrderId, p_UserId, p_AddressId, p_TotalPrice, p_TotalTax);

        IF p_ProductId IS NOT NULL AND p_ProductId != 0 THEN
            CALL sp_InsertOrderItems(v_OrderId, p_ProductId, 1, p_UnitPrice, p_UnitTax);
        ELSE
            OPEN v_Cursor;
            read_loop: LOOP
                FETCH v_Cursor INTO v_ProductId, v_Quantity;
                IF v_OrderId IS NULL THEN
                    LEAVE read_loop;
                END IF;

                CALL sp_InsertOrderItems(v_OrderId, v_ProductId, v_Quantity, p_UnitPrice, p_UnitTax);
            END LOOP;
            CLOSE v_Cursor;
        END IF;

        CALL sp_ClearCart(p_UserId);

        SELECT 'Order placed successfully.' AS message;

    ELSE
        SELECT 'Invalid card details.' AS message;
    END IF;

END $$

DELIMITER ;
