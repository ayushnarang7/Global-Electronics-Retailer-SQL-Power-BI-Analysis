			-- MEASURES AND KPIs

-- Q15. What percentage of total customers are active?

SELECT
(SELECT COUNT(*) FROM customers) AS total_customers,
COUNT( DISTINCT customerkey) AS active_customers,
ROUND(COUNT( DISTINCT customerkey) / (SELECT COUNT(*) FROM customers) * 100, 2) AS active_customer_rate
FROM sales;

-- Q16. How many total orders are placed?

SELECT
COUNT(DISTINCT order_number) AS total_orders
FROM sales;

-- Q17. How many total units have been sold?

SELECT
SUM(quantity) AS quantity_sold
FROM sales;

-- Q18. What is the total revenue?

SELECT
SUM(s.quantity * p.unit_price_usd) AS total_revenue
FROM sales s
JOIN products p ON s.productkey = p.productkey;

-- Q19. What is the total cost?

SELECT
SUM(s.quantity * p.unit_cost_usd) AS total_cost
FROM sales s
JOIN products p ON s.productkey = p.productkey;

-- Q20. What is the total profit?

SELECT
SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd) AS total_profit
FROM sales s
JOIN products p ON s.productkey = p.productkey;

-- Q21: What is the overall profit margin?

SELECT
ROUND((SUM(s.quantity * p.unit_price_usd) - SUM(s.quantity * p.unit_cost_usd)) /
SUM(s.quantity * p.unit_price_usd) * 100, 2) AS profit_margin
FROM sales s
JOIN products p ON s.productkey = p.productkey;

-- Q22. How many unique products (SKUs) have been sold?

SELECT
COUNT(DISTINCT productkey) AS total_sku_sold
FROM sales;

-- Q23. What is the average price of products?

SELECT
ROUND(AVG(unit_price_usd), 2) AS avg_product_price
FROM products;

-- Q24. What is the average order value?

SELECT
ROUND(SUM(s.quantity * p.unit_price_usd) / COUNT(DISTINCT order_number), 2) AS AOV
FROM sales s
JOIN products p ON s.productkey = p.productkey;

-- Q25. What is the average number of units sold per order?

SELECT
ROUND(SUM(quantity) / COUNT(DISTINCT order_number), 2) AS avg_quantity_per_order
FROM sales;

-- Q26. What is the average delivery time in days?

SELECT
ROUND(AVG(DATEDIFF(delivery_date, order_date)), 2) AS avg_delivery_days
FROM sales;

