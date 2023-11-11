/*
*********************************************************************
                         TERM PROJECT 1
                         ABDULLAH DUMAN
*********************************************************************
*/

-- Creating a new database which name is Term1
DROP SCHEMA IF EXISTS Term1;

CREATE SCHEMA Term1;

-- Using this database
USE Term1;

-- Deactivating the Foreing Keys to import the data 
SET FOREIGN_KEY_CHECKS=0;

-- Creating the Category Table
DROP TABLE IF EXISTS category;

CREATE TABLE category
(category_id VARCHAR(10) NOT NULL,
employee_id INT(10) NOT NULL,
category_name VARCHAR(100) NOT NULL,
rating DECIMAL(10,0) NOT NULL,
quantity_sold INT(50) NOT NULL,
total_sold_value INT(100) NOT NULL,
PRIMARY KEY(category_id),
CONSTRAINT category_fk_1 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Checking if the "local_infile" is ON and "secure_file_priv" is NOT NULL for importing the data set from local
SHOW VARIABLES LIKE "secure_file_priv";
SHOW VARIABLES LIKE "local_infile";

-- Importing the data set from local
LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/category.csv' 
INTO TABLE category
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(category_id, employee_id, category_name, rating, quantity_sold, total_sold_value);

SELECT * FROM category;


DROP TABLE IF EXISTS customer;

CREATE TABLE customer
(customer_id INT(10) NOT NULL,
employee_id INT(10) NOT NULL,
customer_firstname VARCHAR(50) NOT NULL,
customer_lastname VARCHAR(50) NOT NULL,
customer_date_of_birth DATE NOT NULL,
customer_phone VARCHAR(100) NOT NULL,
customer_email VARCHAR(100) NOT NULL,
customer_city VARCHAR(100) NOT NULL,
customer_country VARCHAR(100) NOT NULL,
PRIMARY KEY(customer_id),
CONSTRAINT customer_fk_1 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/customer.csv' 
INTO TABLE customer
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(customer_id, employee_id, customer_firstname, customer_lastname, customer_date_of_birth, customer_phone, customer_email, customer_city, customer_country);


SELECT * FROM customer;


DROP TABLE IF EXISTS employee;

CREATE TABLE employee
(employee_id INT(10) NOT NULL,
store_id INT(10) NOT NULL,
employee_firstname VARCHAR(50) NOT NULL,
employee_lastname VARCHAR(50) NOT NULL,
employee_date_of_birth DATE NOT NULL,
employee_phone VARCHAR(100) NOT NULL,
employee_email VARCHAR(100) NOT NULL,
employee_status VARCHAR(50) NOT NULL,
employee_salary INT (100) NOT NULL,
employee_city VARCHAR(100) NOT NULL,
employee_country VARCHAR(100) NOT NULL,
PRIMARY KEY(employee_id),
CONSTRAINT employee_fk_1 FOREIGN KEY (store_id) REFERENCES store (store_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/employee.csv' 
INTO TABLE employee
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(employee_id, store_id, employee_firstname, employee_lastname, employee_date_of_birth, employee_phone, employee_email, employee_status, employee_salary, employee_city, employee_country);


SELECT * FROM employee;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(order_id VARCHAR(50) NOT NULL,
customer_id INT(10) NOT NULL,
car_id INT(50) NOT NULL,
store_id INT(50) NOT NULL,
employee_id INT(50) NOT NULL,
order_date DATE NOT NULL,
shipped_date DATE NOT NULL,
arrival_date DATE NOT NULL,
order_status VARCHAR(50) NOT NULL,
order_quantity INT(50) NOT NULL,
PRIMARY KEY(order_id),
CONSTRAINT orders_fk_1 FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
CONSTRAINT orders_fk_2 FOREIGN KEY (car_id) REFERENCES cars (car_id),
CONSTRAINT orders_fk_3 FOREIGN KEY (store_id) REFERENCES store (store_id),
CONSTRAINT orders_fk_4 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/order.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(order_id, customer_id, car_id, store_id, employee_id, order_date, shipped_date, arrival_date, order_status, order_quantity);


SELECT * FROM orders;

DROP TABLE IF EXISTS cars;

CREATE TABLE cars
(car_id INT(50) NOT NULL,
provider_id VARCHAR(50) NOT NULL,
category_id VARCHAR(10) NOT NULL,
brand_name VARCHAR(50) NOT NULL,
model_name VARCHAR(50) NOT NULL,
manufactured_year YEAR NOT NULL,
car_color VARCHAR(50) NOT NULL,
car_curr_km INT(50) NOT NULL,
car_price INT(50) NOT NULL,
PRIMARY KEY(car_id),
CONSTRAINT cars_fk_1 FOREIGN KEY (provider_id) REFERENCES providers (provider_id),
CONSTRAINT cars_fk_2 FOREIGN KEY (category_id) REFERENCES category (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/car.csv' 
INTO TABLE cars
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(car_id, provider_id, category_id, brand_name, model_name, manufactured_year, car_color, car_curr_km, car_price);

SELECT * FROM cars;


DROP TABLE IF EXISTS providers;

CREATE TABLE providers
(provider_id VARCHAR(50) NOT NULL,
employee_id INT(10) NOT NULL,
provider_name VARCHAR(50) NOT NULL,
debt INT(50) NOT NULL,
provider_phone VARCHAR(50) NOT NULL,
provider_email VARCHAR(50) NOT NULL,
provider_city VARCHAR(50) NOT NULL,
provider_country VARCHAR(50) NOT NULL,
PRIMARY KEY(provider_id),
CONSTRAINT providers_fk_1 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/provider.csv' 
INTO TABLE providers
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(provider_id, employee_id, provider_name, debt, provider_phone, provider_email, provider_city, provider_country);

SELECT * FROM providers;

DROP TABLE IF EXISTS store;

CREATE TABLE store
(store_id INT(10) NOT NULL,
employee_id INT(10) NOT NULL,
store_name VARCHAR(50) NOT NULL,
store_phone VARCHAR(50) NOT NULL,
store_city VARCHAR(50) NOT NULL,
store_country VARCHAR(50) NOT NULL,
store_email VARCHAR(50) NOT NULL,
store_post_code INT(50) NOT NULL,
PRIMARY KEY(store_id),
CONSTRAINT store_fk_1 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/Users/abdullahduman/Desktop/mysqlfiles/store.csv' 
INTO TABLE store
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(store_id, employee_id, store_name, store_phone, store_city, store_country, store_email, store_post_code);

SELECT * FROM store;

-- Activating the Foreign Keys
SET FOREIGN_KEY_CHECKS=1;

/*
*********************************************************************
                         PART I- EMPLOYEE PERFORMANCE
*********************************************************************
*/

-- This store procedure creates a denormalized snaphot about the Employee Performance of our company. It takes the data from operation data layer to data warehouse with ETL(Extract Transform Load) process.
-- In this store procedure, personal informations of emploees represents the fact part and other parts represent the dimensions.
DROP PROCEDURE IF EXISTS EmployeePerformanceStore;

DELIMITER //

CREATE PROCEDURE EmployeePerformanceStore()
BEGIN

	DROP TABLE IF EXISTS employee_performance;
	-- Load Process
	CREATE TABLE employee_performance AS
    -- Extract Process
	SELECT 
	   employee.employee_id AS EmployeeId,
       employee.employee_firstname AS EmployeeFirstName,
       employee.employee_lastname AS EmployeeLastName,
       employee.employee_status AS EmployeeStatus,
       employee.employee_city AS EmployeeCity,
       employee.employee_country AS EmployeeCountry,
       category.category_name AS Category,
	   cars.brand_name As Brand,
       cars.model_name As Model,
	   cars.car_price AS Price, 
	   orders.order_quantity AS Unit,
       -- Transform Process
       cars.car_price * orders.order_quantity AS EmployeeTotalReturn
	FROM
		employee
	INNER JOIN
		category USING (employee_id)
	INNER JOIN
		cars USING (category_id)
	INNER JOIN
		orders USING (car_id)
	ORDER BY 
		EmployeeTotalReturn DESC;

END //
DELIMITER ;


CALL EmployeePerformanceStore();
SELECT * FROM employee_performance;


-- ADDING MESSAGES
CREATE TABLE IF NOT EXISTS messages_HR (message varchar(100) NOT NULL);
TRUNCATE messages_HR;


-- ADDING EVENT SCHEDULER. Thanks to this event, EmployeePerformanceStoreEvent is called every 1 minute in the next 1 hour.
SHOW VARIABLES LIKE "event_scheduler";

DROP EVENT IF EXISTS EmployeePerformanceStoreEvent;

DELIMITER $$

CREATE EVENT EmployeePerformanceStoreEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages_HR SELECT CONCAT('event:',NOW());
    		CALL EmployeePerformanceStore();
	END$$
DELIMITER ;

SHOW EVENTS;



-- ADDING TRIGGER. Trigger is activated when inserting data into previously created data table(employee_performance).
SELECT * FROM employee_performance;


DROP TRIGGER IF EXISTS new_employee_insert; 

DELIMITER $$

CREATE TRIGGER new_employee_insert
AFTER INSERT
ON employee FOR EACH ROW
BEGIN
	
	-- Adding a message to messages table when we insert a new order id
    	INSERT INTO messages_HR SELECT CONCAT('added employee: ', NEW.employee_id);

	-- Archiving the all orders and connected table entries to car_sales
  	INSERT INTO employee_performance
	SELECT 
	   employee.employee_id AS EmployeeId,
       employee.employee_firstname AS EmployeeFirstName,
       employee.employee_lastname AS EmployeeLastName,
       employee.employee_status AS EmployeeStatus,
       employee.employee_city AS EmployeeCity,
       employee.employee_country AS EmployeeCountry,
       category.category_name AS Category,
	   cars.brand_name As Brand,
       cars.model_name As Model,
	   cars.car_price AS Price, 
	   orders.order_quantity AS Unit,
       -- Transform Process
       cars.car_price * orders.order_quantity AS EmployeeTotalReturn
	FROM
		employee
	INNER JOIN
		category USING (employee_id)
	INNER JOIN
		cars USING (category_id)
	INNER JOIN
		orders USING (car_id)
	ORDER BY 
		EmployeeTotalReturn DESC;
        
END $$

DELIMITER ;



-- Activating triggers by inserting data into tables

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO employee VALUES(2, 534, 'Okan', 'Buruk', '2013-07-04','328-098-48', 'okanburuk@example.com', 'Off', 43567, 'Istanbul', 'Turkey');
INSERT INTO cars VALUES(12605, 'Pr7078', 'XBD', 'Tesla', 'X90', '1995', 'Red', 4356459, 320985);
INSERT INTO category  VALUES('XBD', 2, 'Hatch Back', 28, 45895, 5803477);
INSERT INTO orders VALUES('O32456', 4689, 12605, 534, 2,'2014-11-06','2018-10-12', '2020-06-24', 'Completed', 9);



-- Testing the triggers
CALL EmployeePerformanceStore();
SELECT * FROM employee_performance ORDER BY EmployeeId;


-- DATA MARTS

-- This data mart shows the active employees whose number of unit(sold) is more than 8 .

DROP VIEW IF EXISTS ActiveEmp_UnitMoreThan_8;

CREATE VIEW `ActiveEmp_UnitMoreThan_8` AS
SELECT * FROM employee_performance WHERE EmployeeStatus='Active' AND Unit > 8;

-- This data mart shows the employees from Poland whose total return is more than 10000 to the company
DROP VIEW IF EXISTS Emp_Poland_Return10000;

CREATE VIEW `Emp_Poland_Return10000` AS
SELECT * FROM employee_performance WHERE EmployeeCountry='Poland' AND EmployeeTotalReturn > 10000;

-- What is total employee return of the Polish employees?
SELECT SUM(EmployeeTotalReturn) FROM Term1.Emp_Poland_Return10000;


-- This datamart shows the cities and countries of employees who sold Sports Car with price more than 20000
DROP VIEW IF EXISTS CitiesCountires_Sold_SportsCar_Price20000;

CREATE VIEW `CitiesCountires_Sold_SportsCar_Price20000` AS
SELECT DISTINCT EmployeeCity,EmployeeCountry,Category,Price FROM employee_performance WHERE Category='Sports Car' AND Price > 20000 GROUP BY EmployeeCity,EmployeeCountry,Category,Price;

/*
*********************************************************************
                         PART II- CAR SALES 
*********************************************************************
*/

-- This store procedure creates a denormalized snaphot about the Car Sales of our company. It takes the data from operation data layer to data warehouse with ETL(Extract Transform Load) process.
-- In this store procedure, price and unit represents the fact part and other parts represent the dimensions.
DROP PROCEDURE IF EXISTS CarSalesStore;

DELIMITER //

CREATE PROCEDURE CarSalesStore()
BEGIN

	DROP TABLE IF EXISTS car_sales;
	-- Load Process
	CREATE TABLE car_sales AS
    -- Extract Process
	SELECT 
	   orders.order_id AS SalesId, 
	   cars.car_price AS Price, 
	   orders.order_quantity AS Unit,
	   category.category_name AS Category,
	   cars.brand_name As Brand,
       cars.model_name As Model, 
	   store.store_city As StoreCity,
	   store.store_country As StoreCountry,   
	   orders.order_date AS Date,
       -- Transform Process
	   MONTH(orders.order_date) as MonthOfYear
	FROM
		orders
	INNER JOIN
		cars USING (car_id)
	INNER JOIN
		category USING (category_id)
	INNER JOIN
		store USING (store_id)
	ORDER BY 
		order_id;

END //
DELIMITER ;


CALL CarSalesStore();



-- ADDING MESSAGES
CREATE TABLE IF NOT EXISTS messages_sales (message varchar(100) NOT NULL);
TRUNCATE messages_sales;



-- ADDING EVENT SCHEDULER
SHOW VARIABLES LIKE "event_scheduler";

DROP EVENT IF EXISTS CarSalesStoreEvent;

DELIMITER $$

CREATE EVENT CarSalesStoreEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages_sales SELECT CONCAT('event:',NOW());
    		CALL CarSalesStore();
	END$$
DELIMITER ;

SHOW EVENTS;



-- ADDING TRIGGER
SELECT * FROM car_sales;

DROP TRIGGER IF EXISTS new_order_insert; 

DELIMITER $$

CREATE TRIGGER new_order_insert
AFTER INSERT
ON orders FOR EACH ROW
BEGIN
	
	-- Adding a message to messages table when we insert a new order id
    	INSERT INTO messages_sales SELECT CONCAT('added order_id: ', NEW.order_id);

	-- Archiving the all orders and connected table entries to car_sales
  	INSERT INTO car_sales
	SELECT 
	   orders.order_id AS SalesId, 
	   cars.car_price AS Price, 
	   orders.order_quantity AS Unit,
	   category.category_name AS Category,
	   cars.brand_name As Brand,
       cars.model_name As Model, 
	   store.store_city As StoreCity,
	   store.store_country As StoreCountry,   
	   orders.order_date AS Date,
	   MONTH(orders.order_date) as MonthOfYear
	FROM
		orders
	INNER JOIN
		cars USING (car_id)
	INNER JOIN
		category USING (category_id)
	INNER JOIN
		store USING (store_id)
	WHERE order_id = NEW.order_id
	ORDER BY 
		order_id; 
        
END $$

DELIMITER ;

SELECT * FROM car_sales ORDER BY SalesId;

-- Activating triggers by inserting data into tables

SET FOREIGN_KEY_CHECKS=0;
INSERT INTO orders VALUES('1', 4351, 12606, 971, 24,'2019-11-06','2020-10-12', '2021-06-24', 'Completed', 5);
INSERT INTO cars VALUES(12606, 'Pr7077', 'XBC', 'Tofas', 'Kartal', '1991', 'DarkGray', 4356454, 13545);
INSERT INTO category  VALUES('XBC', 24, 'Sedan', 20, 45892, 5803478);
INSERT INTO store  VALUES(971, 24, 'Whatsons Place', '342-467-863', 'Nagazaki', 'Japan', 'whatson3427@example.com', 4921);


-- Testing the triggers
CALL CarSalesStore();
SELECT * FROM car_sales;

DELETE FROM orders WHERE order_id='1';
DELETE FROM cars WHERE car_id=12606;
DELETE FROM category WHERE category_id='XBC';
DELETE FROM store WHERE store_id=971;

-- DATA MARTS

-- This data mart shows the cars whose brand is Ford and have price more than 20000 dollars.

DROP VIEW IF EXISTS Price_Ford_More_Than_20000;

CREATE VIEW `Price_Ford_More_Than_20000` AS
SELECT * FROM car_sales WHERE Brand='Ford' AND Price > 20000;

-- This datamart shows electric vehicles sold between 2016-2019
DROP VIEW IF EXISTS Electric_Car_Btw_2016and2019;

CREATE VIEW `Electric_Car_Btw_2016and2019` AS
SELECT * FROM car_sales WHERE DATE BETWEEN "2016-01-01" AND "2019-01-01" AND Category='Electric Car';

-- How many electric cars sold between 2016 and 2019?
SELECT COUNT(*) FROM Term1.Electric_Car_Btw_2016and2019;

-- This datamart shows the countries in which sold more than 8 cars between January to March in the corresponding year
DROP VIEW IF EXISTS Countries_SoldMoreThan8_JanuarytoMarch;

CREATE VIEW `Countries_SoldMoreThan8_JanuarytoMarch;` AS
SELECT DISTINCT StoreCountry FROM car_sales WHERE MonthofYear BETWEEN 1 AND 3 AND Unit > 8;










