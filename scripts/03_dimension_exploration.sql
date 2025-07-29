-- List all unique countries where customers are located
SELECT DISTINCT 
  country
FROM 
  gold.dim_customers
ORDER BY 
  country;

-- List all unique combinations of category, subcategory, and product name
-- "The major divisions" refers to categories here
SELECT DISTINCT 
  category,        -- Top-level product classification
  subcategory,     -- More specific grouping under each category
  product_name     -- Individual product
FROM 
  gold.dim_products
ORDER BY 
  category NULLS FIRST,  -- Show NULLs (if any) at the top
  subcategory, 
  product_name;
