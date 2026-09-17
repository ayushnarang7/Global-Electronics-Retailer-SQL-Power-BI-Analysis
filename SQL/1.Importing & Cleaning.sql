			-- IMPORTING & CLEANING

-- 1. Create and import the customers table

CREATE TABLE customers (
	CustomerKey INT,
    Gender VARCHAR(10),
    Name VARCHAR(50),
    City VARCHAR(50),
    StateCode CHAR(5),
    State VARCHAR(50),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    Continent VARCHAR(20),
    Birthday VARCHAR(20)
);

SELECT * FROM  customers
LIMIT 5;


-- 2. Convert customer birthdate from text to DATE

ALTER TABLE customers
ADD COLUMN Birthdate DATE;

UPDATE customers
SET Birthdate = STR_TO_DATE(Birthday,  '%c/%e/%Y');


-- Check for invalid or missing birthdates

SELECT COUNT(*)
FROM customers
WHERE birthdate IS NULL;

ALTER TABLE customers 
DROP COLUMN birthday;

-- 3. Clean product price columns

-- Inspect imported product data

SELECT * FROM products;

DESCRIBE products;


-- Replace the original text columns with numeric price columns

ALTER TABLE products
ADD COLUMN Unit_Cost_Num DECIMAL(10,2);

ALTER TABLE products
ADD COLUMN Unit_Price_Num DECIMAL(10,2);

UPDATE products
SET Unit_Cost_Num = CAST(REPLACE(unit_cost_usd, "$", "") AS DECIMAL(10,2)),
	Unit_Price_Num = CAST(REPLACE(unit_price_usd, "$", "") AS DECIMAL(10,2));
    
    
-- Check for invalid or missing prices

SELECT COUNT(*)
FROM products
WHERE Unit_Cost_Num IS NULL
   OR Unit_Price_Num IS NULL;
   
-- Dropping old text columns
   
ALTER TABLE products
DROP COLUMN Unit_Cost_USD,
DROP COLUMN Unit_Price_USD;

-- Rename and set the final data types

ALTER TABLE products
CHANGE Unit_Cost_Num Unit_Cost_USD DECIMAL(10,2),
CHANGE Unit_Price_Num Unit_Price_USD DECIMAL(10,2);

-- Verify the final product structure

DESCRIBE products;


-- 4. Convert store opening date from text to DATE

-- Inspect imported store data

SELECT * FROM stores;

-- Replace the original text columns with new date columns

ALTER TABLE stores
ADD COLUMN Open_date DATE;

UPDATE stores
SET Open_date = STR_TO_DATE(`Open Date`, '%c/%e/%Y');


-- Check for invalid or missing opening dates

SELECT COUNT(*)
FROM stores
WHERE open_date IS NULL;

ALTER TABLE stores
DROP COLUMN `Open Date`;

-- Verify the final store structure

DESCRIBE stores;


-- 5. Convert sales order and delivery dates from text to DATE

-- Preview imported sales data

SELECT * FROM sales
LIMIT 10;

-- Replace the original text columns with new date columns

ALTER TABLE sales
ADD COLUMN Delivery_date DATE
AFTER `Delivery Date`;

ALTER TABLE sales
ADD COLUMN Order_date DATE
AFTER `Order Date`;


UPDATE sales
SET 
    Order_date = STR_TO_DATE(NULLIF(`Order Date`, ''), '%c/%e/%Y'),
    Delivery_date = STR_TO_DATE(NULLIF(`Delivery Date`, ''), '%c/%e/%Y');
    
    
-- Check for missing order and delivery dates
    
SELECT
    SUM(Order_date IS NULL) AS missing_order_dates,
    SUM(Delivery_date IS NULL) AS missing_delivery_dates
FROM sales;

ALTER TABLE sales
DROP COLUMN `Order Date`,
DROP COLUMN `Delivery Date`;


-- 6. Convert exchange rate date from text to DATE

-- Preview imported exchange rate data

SELECT * FROM exchange_rates
LIMIT 10;


-- Replace the original text columns with new date column

ALTER TABLE exchange_rates
ADD COLUMN Date1 DATE
AFTER DATE;

UPDATE exchange_rates
SET Date1 = STR_TO_DATE(Date,'%c/%e/%Y'); 

ALTER TABLE exchange_rates
DROP COLUMN Date;

ALTER TABLE exchange_rates
CHANGE COLUMN Date1 Date DATE;


-- 7. Verify imported row counts

SELECT COUNT(*) FROM customers
UNION ALL
SELECT COUNT(*) FROM products
UNION ALL
SELECT COUNT(*) FROM stores
UNION ALL
SELECT COUNT(*) FROM sales
UNION ALL
SELECT COUNT(*) FROM exchange_rates;