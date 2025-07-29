-- Total number of customers grouped by their country
SELECT 
  country,
  COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total number of customers grouped by gender
SELECT 
  gender,
  COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Number of products available in each category
SELECT
  category,
  COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average cost of products per category (rounded to 2 decimal places)
SELECT
  category,
  ROUND(AVG(cost), 2) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total revenue grouped by customer gender
SELECT 
  c.gender,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_revenue DESC;

-- Total revenue per product category
SELECT
  dp.category,
  SUM(fs.sales_amount) AS total_revenue_category
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.category
ORDER BY total_revenue_category DESC;

-- Revenue contribution of each customer
SELECT
  dc.customer_key,
  dc.first_name,
  dc.last_name,
  SUM(fs.sales_amount) AS total_revenue_customer
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue_customer DESC;

-- Quantity of items sold by customer country
SELECT
  c.country,
  SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
