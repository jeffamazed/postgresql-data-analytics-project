-- ================================================
-- Top 5 Products by Revenue (By Product Name)
-- ================================================
SELECT 
  p.product_name,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
GROUP BY 
  p.product_name
ORDER BY 
  total_revenue DESC
LIMIT 5;  -- Limit to top 5 products

-- ================================================
-- Top 5 Subcategories by Revenue
-- ================================================
SELECT 
  p.subcategory,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
GROUP BY 
  p.subcategory
ORDER BY 
  total_revenue DESC
LIMIT 5;  -- Limit to top 5 subcategories

-- ========================================================
-- Top 5 Products by Revenue Using Window Function (ROW_NUMBER)
-- Useful if combining with other metrics or joining later
-- ========================================================
SELECT 
  product_name,
  total_revenue,
  rank_products
FROM (
  SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
  GROUP BY 
    p.product_name
) ranked
WHERE rank_products <= 5;

-- ===========================================================
-- Bottom 5 Products by Revenue (Worst-Performing Products)
-- ===========================================================
SELECT 
  p.product_name,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
GROUP BY 
  p.product_name
ORDER BY 
  total_revenue ASC
LIMIT 5;  -- Limit to 5 products with lowest revenue

-- ====================================================
-- Top 10 Customers by Revenue
-- ====================================================
SELECT
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
GROUP BY
  c.customer_key,
  c.first_name,
  c.last_name
ORDER BY 
  total_revenue DESC
LIMIT 10;  -- Top 10 customers with highest total revenue

-- ============================================================
-- Bottom 3 Customers by Number of Orders (Fewest Orders Placed)
-- ============================================================
SELECT
  c.customer_key,
  c.first_name,
  c.last_name,
  COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
GROUP BY
  c.customer_key,
  c.first_name,
  c.last_name
ORDER BY 
  total_orders ASC, 
  c.customer_key ASC  -- Tiebreaker to ensure consistent results
LIMIT 3;
