-- ================================================
-- 📅 Find the first and last order dates
-- 🔄 Calculate the range of sales dates in days and months
-- ================================================
SELECT 
  MIN(order_date) AS first_order_date,     -- Earliest order date
  MAX(order_date) AS last_order_date,      -- Most recent order date
  MAX(order_date) - MIN(order_date) AS order_range_days,  -- Total range in days
  DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
  DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS order_range_months  -- Total range in calendar months
FROM 
  gold.fact_sales;

-- ================================================
-- 👤 Find the youngest and oldest customers
-- 🎂 Calculate their current ages
-- ================================================
SELECT
  MIN(birthdate) AS oldest_birthdate,      -- Oldest birthdate in the data
  MAX(birthdate) AS youngest_birthdate,    -- Youngest birthdate in the data
  DATE_PART('year', AGE(NOW(), MIN(birthdate))) AS oldest_age,    -- Age of the oldest customer
  DATE_PART('year', AGE(NOW(), MAX(birthdate))) AS youngest_age   -- Age of the youngest customer
FROM 
  gold.dim_customers;
