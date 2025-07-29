/*
================================================================================
Customer Report
================================================================================
Purpose:
  - Consolidates key customer metrics and behaviors.

Highlights:
  1. Retrieves essential fields (name, age, transactions).
  2. Segments customers by behavior and age groups.
  3. Aggregates customer-level metrics:
     - Total orders, total sales, quantity, distinct products, lifespan (months).
  4. Calculates KPIs:
     - Recency (months since last order),
     - Average Order Value (AOV),
     - Average Monthly Spend.
================================================================================
*/

-- Drop the view if it already exists to avoid conflict
DROP VIEW IF EXISTS gold.report_customers;

-- Create the view
CREATE VIEW gold.report_customers AS

/*
================================================================================
1) Base Query: Joins fact and dimension tables to retrieve raw transactional data
================================================================================
*/
WITH base_query AS (
  SELECT 
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    EXTRACT(YEAR FROM AGE(NOW(), c.birthdate)) AS age
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
  WHERE f.order_date IS NOT NULL
),

/*
================================================================================
2) Customer Aggregation: Summarizes metrics at the customer level
================================================================================
*/
customer_aggregation AS (
  SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    -- Lifespan in months between first and last order
    DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
    DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan
  FROM base_query
  GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)

/*
================================================================================
3) Final Report Output: Enriches data with segments and KPIs
================================================================================
*/
SELECT
  customer_key,
  customer_number,
  customer_name,
  age,

  -- Age group classification
  CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50 and above'
  END AS age_group,

  -- Customer segmentation based on lifespan and sales
  CASE
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    WHEN lifespan < 12 AND total_sales > 5000 THEN 'High Potential'
    ELSE 'New'
  END AS customer_segment,

  last_order_date,

  -- Recency: months since last order
  DATE_PART('year', AGE(NOW(), last_order_date)) * 12 +
  DATE_PART('month', AGE(NOW(), last_order_date)) AS recency,

  total_orders,
  total_sales,
  total_quantity,
  total_products,
  lifespan,

  -- Average Order Value (AOV)
  CASE 
    WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders
  END AS avg_order_value,

  -- Average Monthly Spend (protects against division by zero)
  CASE 
    WHEN lifespan = 0 THEN total_sales
    ELSE ROUND(total_sales / lifespan::numeric, 2)
  END AS avg_monthly_spend

FROM customer_aggregation;
