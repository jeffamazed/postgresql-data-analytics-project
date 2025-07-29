-- ============================================================================
-- WARNING: This will drop the 'data_warehouse_analytics' database if it exists.
--          All data will be permanently deleted.
-- ============================================================================

-- STEP 1: Run this section while connected to another database (e.g., 'postgres')
DROP DATABASE IF EXISTS data_warehouse_analytics;
CREATE DATABASE data_warehouse_analytics;

-- ============================================================================
-- STEP 2: After creation, connect to the new database:
--         In psql: \c data_warehouse_analytics
-- ============================================================================

-- STEP 3: Create the target schema if it doesn't already exist
CREATE SCHEMA IF NOT EXISTS gold;

-- ============================================================================
-- STEP 4: Drop existing tables in the 'gold' schema to avoid conflicts
-- ============================================================================

DROP TABLE IF EXISTS gold.fact_sales;
DROP TABLE IF EXISTS gold.dim_products;
DROP TABLE IF EXISTS gold.dim_customers;

-- ============================================================================
-- STEP 5: Create Dimension and Fact Tables
-- ============================================================================

-- Customer Dimension Table
CREATE TABLE gold.dim_customers (
  customer_key     INT,
  customer_id      INT,
  customer_number  VARCHAR(50),
  first_name       VARCHAR(50),
  last_name        VARCHAR(50),
  country          VARCHAR(50),
  marital_status   VARCHAR(50),
  gender           VARCHAR(50),
  birthdate        DATE,
  create_date      DATE
);

-- Product Dimension Table
CREATE TABLE gold.dim_products (
  product_key      INT,
  product_id       INT,
  product_number   VARCHAR(50),
  product_name     VARCHAR(50),
  category_id      VARCHAR(50),
  category         VARCHAR(50),
  subcategory      VARCHAR(50),
  maintenance      VARCHAR(50),  -- Fixed capitalization of 'maintenance'
  cost             INT,
  product_line     VARCHAR(50),
  start_date       DATE
);

-- Fact Table: Sales
CREATE TABLE gold.fact_sales (
  order_number     VARCHAR(50),
  product_key      INT,
  customer_key     INT,
  order_date       DATE,
  shipping_date    DATE,
  due_date         DATE,
  sales_amount     INT,
  quantity         SMALLINT,
  price            INT
);

-- ============================================================================
-- STEP 6: Load data from CSV files
-- NOTE:
--   - These paths are relative, so ensure your terminal's working directory
--     is set correctly (where 'datasets/csv_files/' is accessible).
--   - '\COPY' is a psql client command, not SQL — run this inside psql.
-- ============================================================================

-- Clear existing data (if any) before inserting
TRUNCATE TABLE gold.dim_customers;
TRUNCATE TABLE gold.dim_products;
TRUNCATE TABLE gold.fact_sales;

-- Load data from CSV files
\COPY gold.dim_customers FROM 'datasets/csv_files/gold.dim_customers.csv' WITH (FORMAT csv, HEADER true);
\COPY gold.dim_products  FROM 'datasets/csv_files/gold.dim_products.csv'  WITH (FORMAT csv, HEADER true);
\COPY gold.fact_sales    FROM 'datasets/csv_files/gold.fact_sales.csv'    WITH (FORMAT csv, HEADER true);
