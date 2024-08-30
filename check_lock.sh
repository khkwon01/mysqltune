-- MySQL 8.0 + 이상 버전에 data_locks 조회할때 oom 버그가 발생함으로 
-- 해당 버그가 해결 될때까지는 아래 명령어를 사용 하지 마시길 바랍니다.

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT index_name, lock_type, lock_mode, lock_status, lock_data
FROM   performance_schema.data_locks
WHERE  object_name = '<<change>>';
