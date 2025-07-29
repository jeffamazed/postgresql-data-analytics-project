-- ========================================================
-- Analyze Monthly Sales Performance (Year and Month as separate columns)
-- ========================================================
SELECT
  EXTRACT(YEAR FROM order_date) AS order_year,           -- Extracts the year from the order_date
  EXTRACT(MONTH FROM order_date) AS order_month,         -- Extracts the month from the order_date
  SUM(sales_amount) AS total_sales,                      -- Total revenue for that month
  COUNT(DISTINCT customer_key) AS total_customers,       -- Number of unique customers in that month
  SUM(quantity) AS total_quantity                        -- Total quantity sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
  EXTRACT(YEAR FROM order_date),
  EXTRACT(MONTH FROM order_date)
ORDER BY 
  order_year, 
  order_month;

-- ========================================================
-- Analyze Yearly Sales Performance (Truncated to Year)
-- ========================================================
SELECT
  DATE_TRUNC('year', order_date)::date AS order_date,    -- Truncates to first day of the year (e.g., 2025-01-01)
  SUM(sales_amount) AS total_sales,                      -- Total revenue for the year
  COUNT(DISTINCT customer_key) AS total_customers,       -- Number of unique customers in the year
  SUM(quantity) AS total_quantity                        -- Total quantity sold in the year
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
  DATE_TRUNC('year', order_date)::date
ORDER BY 
  order_date;

-- ========================================================
-- Analyze Monthly Sales Performance (Formatted Date for Reporting)
-- ========================================================
SELECT
  TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-Mon') AS order_date,  -- Month-year label (e.g., 2025-Jul)
  SUM(sales_amount) AS total_sales,                                    -- Total revenue per month
  COUNT(DISTINCT customer_key) AS total_customers,                     -- Number of unique customers in that month
  SUM(quantity) AS total_quantity                                      -- Total quantity sold per month
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
  DATE_TRUNC('month', order_date)
ORDER BY 
  DATE_TRUNC('month', order_date);
