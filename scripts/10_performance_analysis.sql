/*
  Analyze the yearly performance of products by comparing:
  - Their yearly sales (`current_sales`)
  - Their sales in the previous year (`prev_year_sales`)
  - Their average sales across all years (`avg_sales`)
*/

WITH yearly_product_sales AS (
  SELECT 
    EXTRACT(YEAR FROM f.order_date) AS order_year,    -- Extract year from order_date
    p.product_name,                                   -- Product name
    SUM(f.sales_amount) AS current_sales              -- Total sales for the product in the year
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
  WHERE f.order_date IS NOT NULL
  GROUP BY 
    EXTRACT(YEAR FROM f.order_date),
    p.product_name
)

SELECT 
  order_year,
  product_name,
  current_sales,

  -- Previous year's sales using LAG window function
  LAG(current_sales) OVER (
    PARTITION BY product_name 
    ORDER BY order_year
  ) AS prev_year_sales,

  -- Difference from the previous year
  current_sales - LAG(current_sales) OVER (
    PARTITION BY product_name 
    ORDER BY order_year
  ) AS diff_prev_year_sales,

  -- Trend compared to previous year
  CASE 
    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increasing'
    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreasing'
    ELSE 'No Change'
  END AS prev_year_change,

  -- Average sales across all years per product
  ROUND(AVG(current_sales) OVER (
    PARTITION BY product_name
  )) AS avg_sales,

  -- Difference from average
  current_sales - ROUND(AVG(current_sales) OVER (
    PARTITION BY product_name
  )) AS diff_avg,

  -- Trend compared to average
  CASE 
    WHEN current_sales > AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
    WHEN current_sales < AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
    ELSE 'Avg'
  END AS avg_change

FROM yearly_product_sales
ORDER BY 
  product_name,
  order_year;
