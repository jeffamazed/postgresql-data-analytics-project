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
