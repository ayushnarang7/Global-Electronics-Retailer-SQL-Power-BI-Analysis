
-- Q27. What is the monthly revenue and profit trend?

SELECT
YEAR(s.order_date) AS year,
MONTHNAME(s.order_date) AS month,
SUM(s.quantity * p.unit_price_usd) AS revenue,
SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd) AS profit
FROM sales s
JOIN products p ON s.productkey = p.productkey
GROUP BY year, month, MONTH(s.order_date)
ORDER BY year, MONTH(s.order_date);

-- Q28. What is the monthly orders and quantity sold trend?

SELECT
YEAR(order_date) AS year,
MONTHNAME(order_date) AS month,
COUNT(DISTINCT order_number) AS total_orders,
SUM(quantity) AS quantity_sold
FROM sales
GROUP BY year, month, month(order_date)
ORDER BY  year, month(order_date);

-- Q29. What is the monthly active customer trend?

SELECT
YEAR(order_date) AS year,
MONTHNAME(order_date) AS month,
COUNT(DISTINCT customerkey) AS total_customers
FROM sales
GROUP BY year, month, month(order_date)
ORDER BY year, month(order_date);

-- Q30. What is the growth of the total customer base over time?

SELECT 
YEAR(first_order_date) AS year,
MONTHNAME(first_order_date) AS month,
SUM(COUNT(customerkey)) OVER (ORDER BY YEAR(first_order_date), month(first_order_date)) AS customer_base
FROM
(SELECT
MIN(order_date) AS first_order_date,
customerkey
FROM sales
GROUP BY customerkey) a
GROUP BY year, month, month(first_order_date);

-- Q31. Calculate the total revenue per month and Year-To-Date (YTD) revenue.

SELECT
order_month,
revenue,
SUM(revenue) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month) AS ytd_revenue
FROM
(SELECT
DATE_FORMAT(s.order_date, '%Y-%m-01') AS order_month,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM sales s
JOIN products p ON s.productkey = p.productkey
GROUP BY order_month) a;

-- Q32. What is the quarterly profit margin trend?

SELECT
YEAR(s.order_date) AS year,
CONCAT("Q", QUARTER(s.order_date)) AS quarter,
CONCAT(ROUND((SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) /
SUM(s.quantity * p.unit_price_usd) * 100, 2), "%") AS profit_margin
FROM sales s
JOIN products p ON s.productkey = p.productkey
GROUP BY year, quarter
ORDER BY year, quarter;

/* Q33. Compare the current year's product category revenue
        with that of previous year's and calculate the gap. */
 
SELECT 
year,
category,
revenue AS current_year_revenue,
ROUND(LAG(revenue) OVER(PARTITION BY category ORDER BY year)) AS prev_year_revenue,
ROUND(revenue - LAG(revenue) OVER(PARTITION BY category ORDER BY year)) AS gap
FROM
(SELECT
YEAR(s.order_date) AS year,
p.category,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM sales s
JOIN products p ON s.productkey = p.productkey
WHERE YEAR(s.order_date) >= (SELECT YEAR(MAX(order_date)) - 1  FROM sales) -- current and previous year
	  AND s.order_date < MONTH(3)
GROUP BY year, p.category) a; 

-- Q34. What is the revenue and profit performance by category?

WITH category_performance AS
(SELECT
p.category,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue,
ROUND(SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) AS profit
FROM products p
JOIN sales s ON p.productkey = s.productkey
GROUP BY p.category) 

SELECT
category,
revenue,
ROUND(revenue / SUM(revenue) OVER() * 100, 2) AS revenue_percentage,
profit,
ROUND(profit / SUM(profit) OVER() * 100, 2) AS profit_percentage
FROM category_performance
ORDER BY revenue_percentage DESC, profit_percentage DESC;


-- Q35. Which are the top 10 products by revenue?

SELECT
p.productname,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM sales s 
JOIN products p ON s.productkey = p.productkey
GROUP BY p.productname
ORDER BY revenue DESC
LIMIT 10; 

-- Q36. Which are the top 10 product brands by quantity_sold?

SELECT
p.brand,
SUM(s.quantity) AS quantity_sold
FROM sales s 
JOIN products p ON s.productkey = p.productkey
GROUP BY p.brand
ORDER BY quantity_sold DESC
LIMIT 10; 

-- Q37. Which are the top 5 product brands with lowest profit margin?

SELECT
p.brand,
CONCAT(ROUND((SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) /
SUM(s.quantity * p.unit_price_usd) * 100, 2), "%") AS profit_margin
FROM sales s
JOIN products p ON s.productkey = p.productkey
GROUP BY p.brand
ORDER BY profit_margin 
LIMIT 5;

-- Q38. What is the average product price by category?

SELECT 
category,
ROUND(AVG(unit_price_usd), 2) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- Q39. What is the distribution of revenue by country?

SELECT *,
ROUND(total_revenue / SUM(total_revenue) OVER() * 100, 2) AS revenue_percentage
FROM
(SELECT
st.country,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS total_revenue
FROM stores st 
JOIN sales s ON st.storekey = s.storekey
JOIN products p ON s.productKey = p.productkey
GROUP BY st.country
ORDER BY total_revenue DESC) a;

-- Q40. What is the profit and profit percentage by country?

SELECT
country,
profit,
ROUND(profit / SUM(profit) OVER() * 100, 2) AS profit_percentage
FROM
(SELECT
st.country,
ROUND(SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) AS profit
FROM stores st
JOIN sales s
ON st.storekey = s.storekey
JOIN products p
ON p.productkey = s.productkey
GROUP BY st.country) a
ORDER BY profit DESC;

-- Q41. What are the total orders and quantity sold by country?

SELECT
st.country,
COUNT(DISTINCT s.order_number) AS total_orders,
SUM(s.quantity) AS quantity_sold
FROM stores st
JOIN sales s
ON st.storekey = s.storekey
GROUP BY st.country
ORDER BY total_orders DESC;

-- Q42. Which are the top 10 customers by revenue?

SELECT
c.customerkey,
c.name,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM customers c
JOIN sales s
ON c.customerkey = s.customerkey
JOIN products p
ON p.productkey = s.productkey
GROUP BY c.customerkey, c.name
ORDER BY revenue DESC
LIMIT 10;

-- Q43. Which are the top 10 customers by number of orders?

SELECT
c.customerkey,
c.name,
COUNT(DISTINCT s.order_number) AS total_orders
FROM customers c
JOIN sales s
ON c.customerkey = s.customerkey
GROUP BY c.customerkey, c.name
ORDER BY total_orders DESC
LIMIT 10;

-- Q44. Which customers have been inactive for the longest time?

SELECT
c.customerkey,
c.name,
MAX(s.order_date) AS last_order_date,
DATEDIFF((SELECT MAX(order_date) FROM sales), MAX(s.order_date)) AS days_since_last_order
-- Using the overall last order date in the dataset as the reference date.
FROM customers c
JOIN sales s
ON c.customerkey = s.customerkey
GROUP BY c.customerkey, c.name
ORDER BY days_since_last_order DESC;

-- Q45. What is the revenue distribution by age segment?

WITH age AS
(SELECT
customerkey,
TIMESTAMPDIFF(YEAR, birthdate, (SELECT MAX(order_date) FROM sales)) AS age
-- Using the overall last order date in the dataset as the reference date.
FROM customers)
SELECT
CASE WHEN age < 20 THEN "Under 20"
	 WHEN age < 30 THEN "20 - 29"
     WHEN age < 40 THEN "30 - 39"
	 WHEN age < 50 THEN "40 - 49"
     WHEN age < 60 THEN "50 - 59"
     ELSE "60 and Above"
     
END AS age_segment,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM age a
JOIN sales s ON a.customerkey = s.customerkey
JOIN products p ON s.productkey = p.productkey
GROUP BY age_segment
ORDER BY revenue DESC;

-- Q46. What is the revenue and profit performance by store?

SELECT
s.storekey,
st.country,
st.state,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue,
ROUND(SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) AS profit
FROM sales s
JOIN products p
ON s.productkey = p.productkey
JOIN stores st
ON s.storekey = st.storekey
GROUP BY s.storekey, st.country, st.state
ORDER BY revenue DESC;

-- Q47. What is the revenue performance across different store area segments?

SELECT
CASE WHEN st.square_meters < 500 THEN "Under 500"
	 WHEN st.square_meters < 1000 THEN "500 - 999"
	 WHEN st.square_meters < 1500 THEN "1000 - 1499"
	 WHEN st.square_meters < 2000 THEN "1500 - 1999"
	 ELSE "2000 and Above"
END AS area_segment_sq_m,
COUNT(DISTINCT st.storekey) AS total_stores,
ROUND(SUM(s.quantity * p.unit_price_usd)) AS revenue
FROM stores st
JOIN sales s ON st.storekey = s.storekey
JOIN products p ON s.productkey = p.productkey 
GROUP BY area_segment_sq_m
ORDER BY total_stores DESC;

-- Q48. What are the total orders and quantity sold by store?

SELECT
st.storekey,
st.country,
st.state,
COUNT(DISTINCT s.order_number) AS total_orders,
SUM(s.quantity) AS quantity_sold
FROM stores st
JOIN sales s
ON st.storekey = s.storekey
GROUP BY st.storekey, st.country, st.state
ORDER BY total_orders DESC;

-- Q49. Which are the top 10 stores by profit margin?

SELECT
st.storekey,
st.country,
st.state,
ROUND(
(SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) /
SUM(s.quantity * p.unit_price_usd) * 100, 2) AS profit_margin
FROM stores st
JOIN sales s
ON st.storekey = s.storekey
JOIN products p
ON s.productkey = p.productkey
GROUP BY st.storekey, st.country, st.state
ORDER BY profit_margin DESC
LIMIT 10;

-- Q50. What are the top 3 products by number of orders within each category?

WITH product_orders AS
(SELECT
p.category,
p.subcategory,
p.productname AS product,
COUNT(DISTINCT s.order_number) AS total_orders
FROM products p
JOIN sales s ON p.productkey = s.productkey
GROUP BY p.category, p.subcategory, p.productname),

product_ranking AS
(SELECT
category,
subcategory,
product,
total_orders,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_orders DESC) AS ranking
FROM product_orders)

SELECT *
FROM product_ranking
WHERE ranking <= 3;