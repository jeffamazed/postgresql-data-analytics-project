-- Segment products into cost ranges and count how many products fall into each segment

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost >= 100 AND cost < 500 THEN '100–499'
            WHEN cost >= 500 AND cost < 1000 THEN '500–999'
            ELSE '1000 and above'
        END AS cost_range
    FROM gold.dim_products
)

SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- Group customers based on their spending behavior:
--   - VIP: at least 12 months of history and spending more than 5,000 euro
--   - Regular: at least 12 months of history and spending 5,000 euro or less
--   - High Potential: less than 12 months of history and spending more than 5,000 euro
--   - New: less than 12 months of history and spending 5,000 euro or less
-- Count the total number of customers in each segment

WITH customer_spending AS (
    SELECT 
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order,
        MAX(f.order_date) AS last_order,
        EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY c.customer_key
)

SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            WHEN lifespan < 12 AND total_spending > 5000 THEN 'High Potential'
            WHEN lifespan < 12 AND total_spending <= 5000 THEN 'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
