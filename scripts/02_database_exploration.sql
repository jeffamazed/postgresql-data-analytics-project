-- List all user-defined base tables in the current database
SELECT 
  table_catalog AS database_name,  -- Current database name
  table_schema,                    -- Schema the table belongs to
  table_name,                      -- Table name
  table_type                       -- Usually 'BASE TABLE'
FROM 
  information_schema.tables
WHERE 
  table_type = 'BASE TABLE' -- Only regular tables (exclude views)
  AND table_schema NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
ORDER BY 
  table_schema, table_name;

-- List all columns for user-defined tables in the current database
SELECT 
  table_schema,        -- Schema name
  table_name,          -- Table name
  column_name,         -- Column name
  ordinal_position,    -- Column order in the table
  data_type,           -- Data type (e.g., integer, text, timestamp)
  is_nullable,         -- Whether NULL is allowed
  column_default       -- Default value if defined
FROM 
  information_schema.columns
WHERE 
  table_schema NOT IN ('pg_catalog', 'information_schema')  -- Exclude system schemas
ORDER BY 
  table_schema, table_name, ordinal_position;

