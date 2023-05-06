--Calculate discounted payment total with perentage
CREATE OR REPLACE FUNCTION calc_discounted_total (
    _payment_id INTEGER,
    _customer_id INTEGER,
    discount_percent NUMERIC(4,2)
)
RETURNS NUMERIC(4,2) AS
$$
BEGIN 
    UPDATE payment
    SET amount = amount * (1- (discount_percent / 100))
    WHERE payment_id = _payment_id AND customer_id = _customer_id;
    RETURN (SELECT amount FROM payment WHERE payment_id = _payment_id AND customer_id = _customer_id);
END;  
$$
LANGUAGE plpgsql;


SELECT calc_discounted_total(17506, 341, 20);

--Change staff password procedure
SELECT *
FROM staff;

CREATE OR REPLACE PROCEDURE change_staff_pw(
	_staff_id integer,
	old_password varchar(100),
	new_password varchar(100)
)
AS
$$
	BEGIN 
		UPDATE staff 
		SET "password" = new_password
		WHERE staff_id = _staff_id AND "password" = old_password;
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

CALL change_staff_pw(1, 'badpassword', 'drowssap');

SELECT *
FROM staff;
