
-- check what type of workload your database is performing.

SELECT SUM(count_read) `tot reads`, CONCAT(ROUND((SUM(count_read)/SUM(count_star))*100, 2),"%") `reads`, SUM(count_write) `tot writes`, 
       CONCAT(ROUND((SUM(count_write)/sum(count_star))*100, 2),"%") `writes` 
FROM performance_schema.table_io_waits_summary_by_table 
WHERE count_star > 0 ;
