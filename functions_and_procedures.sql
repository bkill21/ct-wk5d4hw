--Function syntax

--CREATE FUNCTION <FUNC_NAME> (
--	param1 <DATA TYPE>
--	param2 <DATA TYPE>
--)
--RETURNS <RETURN value DATA TYPE> AS
--$$
--	BEGIN
--	func body;
--	END;
--$$
--LANGUAGE plpgsql;

CREATE FUNCTION double_num (
	num INTEGER 
)
RETURNS INTEGER AS 
$$
	BEGIN 
		RETURN num * 2;
	END;
$$
LANGUAGE plpgsql;

--Call FUNCTION 
SELECT double_num(5);

--
CREATE OR REPLACE FUNCTION add_late_fee (
	_payment_id INTEGER,
	_customer_id INTEGER,
	late_fee_amount NUMERIC(4,2)
)
RETURNS NUMERIC(4,2) AS
$$
	BEGIN 
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE payment_id = _payment_id AND customer_id = _customer_id;
		RETURN late_fee_amount;
	END;
	
$$
LANGUAGE plpgsql;

SELECT add_late_fee(17504, 341, 1.00);
--

--create a function to change/update actor last name

CREATE OR REPLACE FUNCTION replace_actor_last_name (
	_actor_id INTEGER,
	_first_name varchar(50),
	_last_name varchar(50),
	new_last_name VARCHAR(50)
)
RETURNS varchar(50) AS 
$$
	BEGIN
		UPDATE actor
		SET last_name = new_last_name
		WHERE actor_id = _actor_id;
	RETURN concat(_first_name, ' ', new_last_name) AS full_name;
	END;	
$$
LANGUAGE plpgsql;

SELECT replace_actor_last_name(3,'Ed', 'Chase', 'Kill');

--===============================================
-- PROCEDURES

-- Updates return date on rental TABLE 

SELECT *
FROM rental
WHERE return_date IS NULL;

CREATE OR REPLACE PROCEDURE update_return_date(
	_rental_id integer,
	_customer_id integer
)
AS
$$
	BEGIN 
		UPDATE rental 
		SET return_date = current_date 
		WHERE rental_id = _rental_id AND customer_id = _customer_id;
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

CALL update_return_date(11496, 155);

SELECT *
FROM rental 
WHERE rental_id = 11496;


SELECT * 
FROM actor;

CREATE OR REPLACE PROCEDURE add_actor(
	_first_name varchar(50),
	_last_name varchar(50)
)
AS
$$
	BEGIN 
		INSERT INTO actor (
			first_name,
			last_name 
		) VALUES (
			_first_name,
			_last_name
		);
		COMMIT;
	END;
	
$$
LANGUAGE plpgsql;

CALL add_actor('Tom', 'Hardy');

SELECT *
FROM actor 
WHERE last_name = 'Hardy';


--drop an entry from inventory table
--method delete from <table_name> WHERE <parameter>

SELECT *
FROM inventory;



CREATE OR REPLACE PROCEDURE inventory_item(
	_inventory_id integer,
	_film_id integer
)
AS 
$$
	BEGIN 
		DELETE FROM inventory, rental
		FROM inventory
		INNER JOIN rental 
		ON inventory.inventory_id = rental.inventory_id
		WHERE inventory.inventory_id = _inventory_id;
		COMMIT;
	END;
	
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_inventory (
	_inventory_id integer,
	_film_id integer
)
LANGUAGE plpgsql
AS $$
	BEGIN 
		UPDATE rental 
		SET inventory_id = Null
		WHERE inventory_id = _inventory_id;
		DELETE FROM inventory 
		WHERE inventory_id = _inventory_id AND film_id = _film_id;
	COMMIT;
	END;
$$

alter table rental alter column inventory_id drop not NULL;

SELECT *
FROM inventory;

CALL remove_inventory(3,1);






