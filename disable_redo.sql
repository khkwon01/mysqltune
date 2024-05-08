-- It need to be restart MySQL when you setup the below options
-- 데이터에 대한 빠른 load가 필요할 경우 disable후 작업후 enable (binlog도 disable하면 효과적)

ALTER INSTANCE DISABLE INNODB REDO_LOG; 
set global innodb_extend_and_initialize=OFF; 
set global innodb_max_dirty_pages_pct=10; 
set global innodb_max_dirty_pages_pct_lwm=10;
