/*
  Analyze the yearly performance of products by comparing:
  - Their sales each year (`current_sales`)
  - The average sales of the product across all years (`avg_sales`)
  - The sales in the previous year (`prev_year_sales`)
*/

WITH yearly_product_sales AS (
  SELECT 
    EXTRACT(YEAR FROM f.order_date) AS order_year,        -- Extract the year from the order date
    p.product_name,                                       -- Product name from the dimension table
    SUM(f.sales_amount) AS current_sales,                 -- Total sales per product per year

    -- Average yearly sales per product across all years (window function)
    ROUND(AVG(SUM(f.sales_amount)) OVER (
      PARTITION BY p.product_name
    )) AS avg_sales,

    -- Sales in the previous year per product (using LAG)
    LAG(SUM(f.sales_amount)) OVER (
      PARTITION BY p.product_name 
      ORDER BY EXTRACT(YEAR FROM f.order_date)
    ) AS prev_year_sales

  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key

  WHERE f.order_date IS NOT NULL

  GROUP BY 
    EXTRACT(YEAR FROM f.order_date),
    p.product_name
)

SELECT 
  order_year,                       -- Year of the sales record
  product_name,                     -- Product name
  current_sales,                    -- Current year's total sales
  prev_year_sales,                 -- Last year's sales (if available)
  
  -- Difference from the previous year
  current_sales - prev_year_sales AS diff_prev_year_sales,

  -- Sales trend vs previous year
  CASE 
    WHEN current_sales - prev_year_sales > 0 THEN 'Increasing'
    WHEN current_sales - prev_year_sales < 0 THEN 'Decreasing'
    ELSE 'No Change'
  END AS prev_year_change,

  avg_sales,                        -- Average sales of the product across all years

  -- Difference from the average
  current_sales - avg_sales AS diff_avg,

  -- Sales trend vs average
  CASE 
    WHEN current_sales > avg_sales THEN 'Above Avg'
    WHEN current_sales < avg_sales THEN 'Below Avg'
    ELSE 'Avg'
  END AS avg_change

FROM yearly_product_sales
ORDER BY 
  product_name,
  order_year;
