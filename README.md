# mysqltune

<!---
1. 작업시 screen or tmux 사용 (yum install tmux)
2. 테이블 검색시 pt-table-checksum
-->

### 1. The overall process of MySQL tuning
- MySQL All aspect
![image](https://github.com/khkwon01/mysqltune/assets/8789421/a635850e-bfba-4a7e-bee8-a269f3c1a5dd)

- Application(Client) aspect
![image](https://github.com/khkwon01/mysqltune/assets/8789421/9d6ba897-1b79-462e-b338-5673cccbd092)

### 2. Hardware associated option
- Cpu configuration: recommend `multiple cores and a fast CPU clock`
  - innodb_buffer_pool_instances
    - controls the number of buffer pool instances
    - help to distribute the load across multiple CPUs (default : 8)
  - innodb_flush_log_at_trx_commit
    - controls the timing of writing and flushing binlog and redo logs to disk (default : 1)
  - max_connections
    - controls the maximum number of concurrent connections to the MySQL
- Memory configuration: recommend allocating `enough memory` as possible as the system can
  - innodb_buffer_pool_size
    - controls the size of the buffer pool utilized by InnoDB engine
    - enhance read performance according to the allocation of memory
  - sort_buffer_size
    - controls the buffer size in sorting operations
    - optimize the performance of unindexed sorting
  - join_buffer_size
    - controls the buffer size in join operations
    - optimize the performance of queries involving the joining of tables
  - tmp_table_size
    - controls the maximum size of any individual in-memory internal temporary table by Temptable engine
    - if tmp_table_size limit is reached, it can be made on-disk-based temporary table
    - TempTable based on memory is controlled by the temptable_max_ram and temptable_max_mmap
      - temptable_max_ram size is 3% of the total memory available on the server (minimum : 1GB, maximum : 4GB)
        
  - memory management library (recommend `tcmalloc` library)
    - jemalloc: good perf, less memory management, use `install_jemalloc.sh` script how to build
    - tcmalloc: great, use `install_tcmalloc.sh` script how to build
- Huge Pages : recommend `disabling huge pages`
  ```
  # check the huge pages whether it use or not
  cat /sys/kernel/mm/transparent_hugepage/enabled

  # disable huge pages in os
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  echo never > /sys/kernel/mm/transparent_hugepage/defrag 
  ```
- Disk configuration: recommend `fast disk devices` like 'SSDs, RAID10, XFS or EXT4'
  - innodb_io_capacity
    - controls the I/O capacity limit
    - improve the throughput I/O if it can be increased this value on the assumption that the disk can support
  - innodb_io_capacity_max
    - controls the maximun I/O capacity limit
  - innodb_redo_log_capacity
    - controls the size in redo log files
    - improve performance by reducing the frequency of disk writes using adjusting this value
  - binlog_row_image
    - reduces the amount of data written to the binary log if it define "minimal" as value
- Kernel and parameter examples for increasing the connection between client and mysql
  - https://www.percona.com/blog/mysql-challenge-100k-connections/ 
      
### 3. Primary Key Design (recommend integer auto-increment as pk)
- The PK must be mandatory in MySQL
- It needs to be a well-designed PK because PK as cluster index stores the data
- The secondary index uses the primary key to get the actual data
- For finding no pk table in a database, execute `find_no_pk.sql` script included in this GitHub repo
- For finding unused or duplicate index in table, execute `find_not_used_index.sql, find_duplicate_index.sql` script

### 4. Redo Log Size
- During service peak time, measure the amount of redo usage using `check_redo_log_size.sql`
- And you estimate the required amount during 1 hour and set like below    
  ```set persist innodb_redo_log_capacity=<estimated value>*1024*1024*1024;``` 
      
### 5. MySQL thread pool (commercial version)
| parameter | recommended value |
|---|:---|
| `thread_pool_size` | #physical_cores, max 512 |
| `thread_pool_max_transaction_limit` | #physical_cores * 32, max 512 |
| `thread_pool_algorithm` | 1 (high concurrency algorithm) |
| `thread_pool_query_threads_per_group` | > 2 |

### 6. Performance schema set up
- enable the performance schema (default : enable, my.cnf file)
  ```
  performance_schema=ON  
  ```
- list all events for monitoring through performance schema
  ```  
  SELECT NAME, ENABLED, TIMED
         FROM performance_schema.setup_instruments;
  ```
- adjust values of specific events whether its data collect or not  (value : YES / NO)
  ```
  UPDATE performance_schema.setup_instruments
       SET ENABLED = 'NO'
       WHERE NAME = 'wait/synch/mutex/sql/LOCK_mysql_create_db';
  ```
- list associated table related to above event
  ```
  SELECT * FROM performance_schema.setup_consumers;
  ```
  
### 7. SQL Explain Plan
- explain select ~~   
  explain format=json select ~~   
  explain format=tree select ~~   
- explain analyze select ~~  (실제 데이터 기반)

### 8. Slow query analysis using sys schema
1) Identify Slow Queries
   ```
   # query top 5 query ordered by total latency of execution query 
   SELECT query, exec_count, total_latency FROM statements_with_runtimes_in_95th_percentile
   ORDER BY total_latency DESC LIMIT 5;

   # get top 10 slow query
   SELECT * FROM performance_schema.events_statements_summary_by_digest
   WHERE digest_text LIKE '%SELECT%'
   ORDER BY sum_timer_wait DESC LIMIT 10;

   # get top 10 execution time
   SELECT * FROM performance_schema.events_statements_history_long
   ORDER BY timer_wait DESC LIMIT 10;

   # get top 10 resource usage (especially cpu)
   SELECT * FROM
   performance_schema.events_stages_summary_global_by_event_name
   WHERE event_name LIKE '%wait/synch/mutex/sql/THD%'
   ORDER BY sum_timer_wait DESC LIMIT 10;
   ```
2) Check for query errors in execution time
   ```
   SELECT query, errors FROM statements_with_errors_or_warnings ORDER BY errors DESC LIMIT 5;
   ```
3) Check for access latency per table
   ```
   SELECT table_name, total_latency, rows_fetched, avg_fetched_latency FROM schema_table_statistics
   WHERE table_name IN ('table_1', 'table_2') ORDER BY total_latency DESC;
   ```
4) Review index performance against the existing index
   ```
   SELECT index_name, rows_selected FROM schema_index_statistics
   WHERE table_name = 'your_table’ ORDER BY rows_selected DESC;
   ```
5) According to the above results, you can adjust or modify the indexes or queries etc.

### 9. check the memory for MySQL against OOM
1) OS Metric
   - command : ps -eo user,pid,ppid,rss,size,vsize,pmem,pcpu,time,cmd --sort -rss | head -n 11
   - top     : top -d 1 | egrep "PID|systemd"  
               Shift + m  (display memory size order in top)
2) MySQL Metric
   ```
   select * from sys.memory_global_total;
   select * from sys.memory_global_by_current_bytes;
   select * from sys.memory_by_user_by_current_bytes;
   select * from sys.memory_by_thread_by_current_bytes;
   select * from sys.memory_by_host_by_current_bytes;

   select * from sys.innodb_lock_waits;
   select * from sys.statement_analysis;
   select * from sys.statements_with_full_table_scans;
   select * from sys.statements_with_temp_tables;

   select * from performance_schema.threads ;
   select * from performance_schema.metadata_locks ;
   select * from performance_schema.mutex_instances ;
   select * from performance_schema.processlist ;
   select * from information_schema.innodb_trx\G

   select EVENT_NAME, sum(CURRENT_NUMBER_OF_BYTES_USED/1024/1024/1024) as sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB 
   ,sum(SUM_NUMBER_OF_BYTES_ALLOC/1024/1024/1024) from performance_schema.memory_summary_by_account_by_event_name WHERE 
   CURRENT_NUMBER_OF_BYTES_USED > 0 group by EVENT_NAME order by sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB desc ;
   select EVENT_NAME, sum(CURRENT_NUMBER_OF_BYTES_USED/1024/1024/1024) as sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB 
   ,sum(SUM_NUMBER_OF_BYTES_ALLOC/1024/1024/1024) from performance_schema.memory_summary_by_host_by_event_name WHERE 
   CURRENT_NUMBER_OF_BYTES_USED > 0 group by EVENT_NAME order by sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB desc ;
   select EVENT_NAME, sum(CURRENT_NUMBER_OF_BYTES_USED/1024/1024/1024) as sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB 
   ,sum(SUM_NUMBER_OF_BYTES_ALLOC/1024/1024/1024) from performance_schema.memory_summary_by_thread_by_event_name WHERE 
   CURRENT_NUMBER_OF_BYTES_USED > 0 group by EVENT_NAME order by sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB desc ;
   select EVENT_NAME, sum(CURRENT_NUMBER_OF_BYTES_USED/1024/1024/1024) as sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB 
   ,sum(SUM_NUMBER_OF_BYTES_ALLOC/1024/1024/1024) from performance_schema.memory_summary_by_user_by_event_name WHERE 
   CURRENT_NUMBER_OF_BYTES_USED > 0 group by EVENT_NAME order by sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB desc ;
   select EVENT_NAME, sum(CURRENT_NUMBER_OF_BYTES_USED/1024/1024/1024) as sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB 
   ,sum(SUM_NUMBER_OF_BYTES_ALLOC/1024/1024/1024) from performance_schema.memory_summary_global_by_event_name WHERE 
   CURRENT_NUMBER_OF_BYTES_USED > 0 group by EVENT_NAME order by sum_CURRENT_NUMBER_OF_BYTES_USED_for_GB desc ;
   SELECT SUM(CURRENT_NUMBER_OF_BYTES_USED) FROM performance_schema.memory_summary_global_by_event_name WHERE `EVENT_NAME` like 
   'memory/performance_schema%';

   SELECT PATH, format_bytes(SIZE), STATE, PURPOSE FROM INFORMATION_SCHEMA.INNODB_SESSION_TEMP_TABLESPACES;  
   ```
### 10. replication tunning
![image](https://github.com/khkwon01/mysqltune/assets/8789421/84c46f96-b031-47cf-b168-2ae1df931efb)

- source aspect
  - set up minimal value for at least storing changed data (default: full)
    - binlog_row_image = minimal (log only changed columns)
    * in the case of noblob value, log all columns except for BLOB and TEXT
  - set up more binlog_cache_size variable if Binlog_cache_disk_use(status) increased for replicating data from source and replica
    - binlog_cache_size = ? (default 32K)
    * if the binary log cache is too small to hold transaction per client, the changes are written to disk
  - set up binlog_group_commit_sync_delay to make more big group transaction
- replica aspect
  - set up multithreaded replication
    - replica_parallel_workers=4  (how many sql thread(applier) use, default 4)
    - replica_parallel_type=LOGICAL_CLOCK (8.0.26~, parallelization based on timestamp in transaction regardless of database)
    - replica_preserve_commit_order=1 (same order commit as source executed)
  
### 11. Schema management tool (open source: Skeema)
- URl : https://www.skeema.io/

### 12. MySQL monitoring (self-made tool based on python)
- https://github.com/khkwon01/mysqlhealth/tree/main

### 13. Load test for MySQL
- Open-source Qb
  - work architecture   
  ![image](https://github.com/khkwon01/mysqltune/assets/8789421/f7b51efa-cee2-4ebd-a52d-09cd726da3b1)
  - source code : https://github.com/khkwon01/qb
- built-in function in mysql : execute times of number defined parameter and as a result, get execution time
  ```
  select benchmark(100000000, 2+2) ;
  ```
- mysqlslap : mysql command line tool
  ```
  -- generate sql automatically and execute 100 concurrent connection simantanously
  mysqlslap --user=admin --auto-generate-sql --concurrency=100

  -- execute 5 times with 200 concurrent connections
  mysqlslap --user=adimn --create-schema=test --query="select * from test1 where name = 't1';" --concurrency=200 --iterations=5
  ```
- sysbench : cross-platform, multithreaded benchmark tool. it can evaluates OS parameters.
  ```
  -- step1 : make schema and table and then generate temporary data based on it
  sysbench oltp_read_write --table_size=1000000 --mysql-db=test --mysql-host=localhost --mysql-port=3306 --mysql-user=root --mysql-password=mysql prepare
  -- step2: execute benchmark query
  sysbench oltp_read_write --threads=8 --time=60 --events=0 --table_size=1000000 --mysql-db=test --mysql-host=localhost --mysql-port=3306 --mysql-user=root --mysql-password=mysql run
  -- step3: after testing, remove benchmark schema and table, data
  sysbench oltp_read_write --mysql-db=test --mysql-host=localhost --mysql-port=3306 --mysql-user=root --mysql-password=mysql cleanup
  ```
