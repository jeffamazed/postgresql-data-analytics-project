-- Determine which product categories contribute the most to overall sales

WITH category_sales AS (
  SELECT
    p.category,                            -- Product category
    SUM(f.sales_amount) AS total_sales    -- Total sales per category
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
  GROUP BY p.category
)

SELECT 
  category,                                -- Product category name
  total_sales,                             -- Total sales for the category

  -- Total sales across all categories (same for every row)
  SUM(total_sales) OVER () AS overall_sales,

  -- Percentage contribution to total sales, rounded and formatted with '%'
  ROUND((total_sales * 100.0 / SUM(total_sales) OVER ()), 2) || '%' AS percentage_of_total

FROM category_sales
ORDER BY total_sales DESC;                 -- Show top contributing categories first
