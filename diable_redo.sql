-- It need to be restart MySQL when you setup the below options

ALTER INSTANCE DISABLE INNODB REDO_LOG; 
set global innodb_extend_and_initialize=OFF; 
set global innodb_max_dirty_pages_pct=10; 
set global innodb_max_dirty_pages_pct_lwm=10;
