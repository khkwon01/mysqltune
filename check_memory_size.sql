-- check the innodb buffer pool memory allocation usage
SELECT * FROM sys.memory_global_by_current_bytes WHERE event_name LIKE 'memory/innodb/buf_buf_pool'\G;

SELECT * FROM sys.memory_global_total;

SELECT SUBSTRING_INDEX(event_name,'/',2) AS code_area,  format_bytes(SUM(current_alloc)) AS current_alloc  
FROM sys.x$memory_global_by_current_bytes  
GROUP BY SUBSTRING_INDEX(event_name,'/',2)  
ORDER BY SUM(current_alloc) DESC;


-- for protecting disk swapping, you can setup the below parameter (track and limit the memory consumption).
set @@global_connection_memory_tracking=1;

SET GLOBAL global_connection_memory_limit=536870912000;

-- check the connection consumption size
SELECT format_bytes(variable_value) global_connection_memory  
FROM performance_schema.global_status  
WHERE variable_name='Global_connection_memory';
