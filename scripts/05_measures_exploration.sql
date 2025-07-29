-- ================================================
-- 📊 Basic Business Metrics
-- ================================================

-- 💰 Total sales across all orders
SELECT 
  SUM(sales_amount) AS total_sales
FROM 
  gold.fact_sales;

-- 📦 Total quantity of items sold
SELECT 
  SUM(quantity) AS total_quantity
FROM 
  gold.fact_sales;

-- 💵 Average selling price per item
SELECT 
  ROUND(AVG(price), 2) AS avg_price
FROM 
  gold.fact_sales;

-- 🧾 Total number of unique orders
SELECT
  COUNT(DISTINCT order_number) AS total_nr_orders  -- DISTINCT: one row per unique order
FROM 
  gold.fact_sales;

-- 🛍️ Total number of products (raw count)
SELECT 
  COUNT(product_name) AS total_products
FROM 
  gold.dim_products;

-- 🛍️ Total number of unique products
SELECT 
  COUNT(DISTINCT product_key) AS total_unique_products
FROM 
  gold.dim_products;

-- 👥 Total number of customers in the system
SELECT 
  COUNT(customer_key) AS total_customers
FROM 
  gold.dim_customers;

-- 📈 Total number of customers who placed at least one order
SELECT 
  COUNT(DISTINCT customer_key) AS active_customers  -- DISTINCT: avoid duplicates
FROM 
  gold.fact_sales;

-- ================================================
-- 📋 Unified Metrics Report (One Result Table)
-- ================================================
SELECT 
  'Total Sales' AS measure_name,
  SUM(sales_amount)::numeric AS measure_value
FROM 
  gold.fact_sales

UNION ALL

SELECT 
  'Total Quantity',
  SUM(quantity)::numeric
FROM 
  gold.fact_sales

UNION ALL

SELECT 
  'Average Price',
  ROUND(AVG(price), 2)
FROM 
  gold.fact_sales

UNION ALL

SELECT 
  'Total Nr. Orders',
  COUNT(DISTINCT order_number)
FROM 
  gold.fact_sales

UNION ALL

SELECT 
  'Total Nr. Products',
  COUNT(product_name)
FROM 
  gold.dim_products

UNION ALL

SELECT 
  'Total Nr. Customers',
  COUNT(customer_key)
FROM 
  gold.dim_customers

UNION ALL

SELECT 
  'Customers with Orders',
  COUNT(DISTINCT customer_key)
FROM 
  gold.fact_sales;
