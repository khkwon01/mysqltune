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
- cloud상 heatwave 서비스 성능 확인 (db 구성정보 화면에서 아래 details 클릭)
  - thread pool만 따로 확인 할수 있는 방법은 없고, 전체적인 성능 확인       
  ![image](https://github.com/khkwon01/mysqltune/assets/8789421/d4c30c7e-9f72-4d0c-882a-4a37f3f87bfd)
