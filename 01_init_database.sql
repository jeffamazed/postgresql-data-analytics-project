-- WARNING:
-- This will drop the 'data_warehouse_analytics' database if it exists.
-- All data will be permanently deleted.

-- Run this part while connected to another database (e.g., 'postgres')
DROP DATABASE IF EXISTS data_warehouse_analytics;
CREATE DATABASE data_warehouse_analytics;

-- After creation, connect to the new database:
-- In psql: \c data_warehouse_analytics

-- Once connected to 'data_warehouse_analytics', run:
CREATE SCHEMA IF NOT EXISTS gold;

-- Drop table if exists
DROP TABLE IF EXISTS gold.dim_customers;
DROP TABLE IF EXISTS gold.dim_products;
DROP TABLE IF EXISTS gold.fact_sales;

-- Create tables

CREATE TABLE gold.dim_customers(
  customer_key int,
  customer_id int,
  customer_number nvarchar(50),
  first_name nvarchar(50),
  last_name nvarchar(50),
  country nvarchar(50),
  marital_status nvarchar(50),
  gender nvarchar(50),
  birthdate date,
  create_date date
);

CREATE TABLE gold.dim_products(
  product_key int ,
  product_id int ,
  product_number nvarchar(50) ,
  product_name nvarchar(50) ,
  category_id nvarchar(50) ,
  category nvarchar(50) ,
  subcategory nvarchar(50) ,
  maintenance nvarchar(50) ,
  cost int,
  product_line nvarchar(50),
  start_date date 
);

CREATE TABLE gold.fact_sales(
  order_number nvarchar(50),
  product_key int,
  customer_key int,
  order_date date,
  shipping_date date,
  due_date date,
  sales_amount int,
  quantity tinyint,
  price int 
);