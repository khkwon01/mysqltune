
-- check what type of workload your database is performing.
SELECT SUM(count_read) `tot reads`, CONCAT(ROUND((SUM(count_read)/SUM(count_star))*100, 2),"%") `reads`, SUM(count_write) `tot writes`, 
       CONCAT(ROUND((SUM(count_write)/sum(count_star))*100, 2),"%") `writes` 
FROM performance_schema.table_io_waits_summary_by_table 
WHERE count_star > 0 ;

-- check for each database

SELECT object_schema,  CONCAT(ROUND((SUM(count_read)/SUM(count_star))*100, 2),"%") `reads`, 
       CONCAT(ROUND((SUM(count_write)/SUM(count_star))*100, 2),"%") `writes`  
FROM performance_schema.table_io_waits_summary_by_table  
WHERE count_star > 0 
GROUP BY object_schema;

-- check for each table
SELECT object_schema, object_name, CONCAT(ROUND((count_read/count_star)*100, 2),"%") `reads`, 
       CONCAT(ROUND((count_write/count_star)*100, 2),"%") `writes`  
FROM performance_schema.table_io_waits_summary_by_table  
WHERE count_star > 0; -- and object_schema='sbtest' ;
