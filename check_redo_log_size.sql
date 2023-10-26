
-- check redo log size generated when the service peak.
SELECT VARIABLE_VALUE from performance_schema.global_status  WHERE VARIABLE_NAME='Innodb_redo_log_current_lsn' INTO @a;
SELECT sleep(60)  INTO @garb ;
SELECT VARIABLE_VALUE FROM performance_schema.global_status  WHERE VARIABLE_NAME='Innodb_redo_log_current_lsn' INTO @b;
select  format_bytes(abs(@a - @b)) per_min, format_bytes(abs(@a - @b)*60) per_hour;


-- if you only use a dedicated server for MySQL, you can setup the below parameter for auto control of redo and buffer, flush.
(adjust innodb_buffer_pool_size, innodb_redo_log_capacity, innodb_flush_method automatically)
set @@innodb_dedicated_server=ON
