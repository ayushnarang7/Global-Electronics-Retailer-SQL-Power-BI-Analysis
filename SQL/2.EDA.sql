			-- EXPLORATORY DATA ANALYSIS (EDA)
                
-- Exploring Tables

DESCRIBE CUSTOMERS;
DESCRIBE exchange_rates;
SELECT * FROM exchange_rates
LIMIT 10;
DESCRIBE products;
DESCRIBE sales;
DESCRIBE stores;


-- Q1. What period does our sales data cover?

SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date
FROM sales;


-- Q2. What is the distribution of customers by country?

SELECT
country,
COUNT(customerkey) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;


-- Q3. What is the customer distribution by gender?

SELECT
gender,
COUNT(customerkey) AS total_customers,
ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER() * 100, 2) AS percentage
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;


-- Q4. What is the customer distribution by continent?

SELECT
continent,
COUNT(customerkey) AS total_customers
FROM customers
GROUP BY continent;


-- Q5. What is the average age of customers?

SELECT
ROUND(AVG(TIMESTAMPDIFF(YEAR, birthdate, (SELECT MAX(order_date) FROM sales))), 2) AS avg_customer_age
/* Using the last order date as the reference date instead of CURDATE()
   keeps customer age consistent with the period covered by the sales data. */
FROM customers;

-- Q6. Explore the categories/ divisions of products.

SELECT
category,
subcategory,
productname
FROM products;

-- Q7. What is the distribution of products by category?

SELECT
ROW_NUMBER() OVER(ORDER BY COUNT(productkey) DESC) AS serial_no,
category,
COUNT(productkey) AS total_products
FROM products
GROUP BY category;

-- Q8. What is the distribution of products by subcategory within each category?

SELECT
ROW_NUMBER() OVER(ORDER BY category, COUNT(productkey) DESC) AS serial_no,
category,
subcategory,
COUNT(productkey) AS total_products
FROM products
GROUP BY category, subcategory;

-- Q9. What is the distribution of products by brand?

SELECT
ROW_NUMBER() OVER(ORDER BY COUNT(productkey) DESC) AS serial_no,
brand,
COUNT(productkey) AS total_products
FROM products
GROUP BY brand;

-- Q10. How many total stores are there worldwide?

SELECT
COUNT(storekey) AS total_stores
FROM stores;

-- Q11. Explore the stores and their locations.

SELECT
country,
state,
storekey
FROM stores;

-- Q12. What is the distribution of stores by country?

SELECT
ROW_NUMBER() OVER(ORDER BY COUNT(storekey) DESC) AS serial_no,
country,
COUNT(storekey) AS total_stores
FROM stores
GROUP BY country;

-- Q13. What is the average store size?

SELECT
ROUND(AVG(square_meters), 2) AS avg_area_sq_mtrs
FROM stores;

-- Q14. What currencies are used in sales transactions?

SELECT
DISTINCT currency_code
FROM sales;