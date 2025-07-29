-- Calculate the total sales per month, cumulative (running) total sales,
-- and a 3-month moving average of the average product price.

SELECT
  order_date,  -- First day of the month (as a DATE, not TIMESTAMP)
  total_sales, -- Total sales for the given month
  SUM(total_sales) OVER (
    ORDER BY order_date
  ) AS running_total_sales,  -- Running total of monthly sales across time

  ROUND(AVG(avg_price) OVER (
    ORDER BY order_date 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  )) AS moving_average_price_3_months  -- 3-month moving average of average price, rounded
FROM (
  -- Aggregate sales and price data by month
  SELECT 
    DATE_TRUNC('month', order_date)::date AS order_date, -- Normalize to first day of the month and cast to DATE
    SUM(sales_amount) AS total_sales,                     -- Monthly sales total
    AVG(price) AS avg_price                               -- Monthly average product price
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATE_TRUNC('month', order_date)
  ORDER BY DATE_TRUNC('month', order_date)
) t;
