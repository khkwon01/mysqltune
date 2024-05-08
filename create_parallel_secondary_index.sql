if you want to make secondary index fastly, you can setup the below parameter(8.0.27~).

MySQL > SET innodb_ddl_threads = 8; 
MySQL > SET innodb_parallel_read_threads = 8; 
MySQL > SET innodb_ddl_buffer_size = 1048576000;  -- 1GB, 2GB if you want to best performance
