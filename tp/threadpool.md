### 1. thread pool 관련 참조 사이트
- https://dev.mysql.com/doc/refman/8.0/en/thread-pool.html
- https://dev.mysql.com/blog-archive/the-new-mysql-thread-pool/
  

### 2. 설정
- my.cnf (plugin 설정)
  ```
  [mysqld]
  plugin-load-add=thread_pool.so
  ```
- 설정 여부 체크
  ```
  SELECT PLUGIN_NAME, PLUGIN_STATUS
  FROM INFORMATION_SCHEMA.PLUGINS
  WHERE PLUGIN_NAME LIKE 'thread%';
  ```

### 3. 모니터링
- mysql에서 모니터링 (performance_schema)
  - tp_thread_group_state: thread pool, thread group 상태들에 정보표시
  - tp_thread_group_stats: thread group 통계들
  - tp_thread_state: thread pool, thread status들에 정보표시
