
-- check how to use well in memory.

SELECT format_bytes(@@innodb_buffer_pool_size) BufferPoolSize, 
       FORMAT(A.num * 100.0 / B.num,2) BufferPoolFullPct,  
       FORMAT(C.num * 100.0 / D.num,2) BufferPollDirtyPct 
FROM (SELECT variable_value num FROM performance_schema.global_status WHERE variable_name = 'Innodb_buffer_pool_pages_data') A, 
     (SELECT variable_value num FROM performance_schema.global_status WHERE variable_name = 'Innodb_buffer_pool_pages_total') B, 
     (SELECT variable_value num FROM performance_schema.global_status  WHERE variable_name='Innodb_buffer_pool_pages_dirty') C,  
     (SELECT variable_value num FROM performance_schema.global_status  WHERE variable_name='Innodb_buffer_pool_pages_total') D;
     
 
 -- check the ratio how much data read from disk.  
 
 SELECT FORMAT(A.num * 100 / B.num,2) DiskReadRatioPct 
 FROM (SELECT variable_value num FROM performance_schema.global_status WHERE variable_name = 'Innodb_buffer_pool_reads') A, 
 (SELECT variable_value num FROM performance_schema.global_status WHERE variable_name = 'Innodb_buffer_pool_read_requests') B;
