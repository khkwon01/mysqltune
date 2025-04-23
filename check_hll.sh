# setup related metric for monitoring HLL (History List Length)
# HLL means that Innodb is keeping a significant number of old row versions regarding long-running and abandoned transaction has not committed.
set global innodb_monitor_enable=module_trx;

# check for HLL using the following query (if it is less than 1000, it's normal, otherwise, if it greater than 100,000, check the reason)
SELECT * FROM INFORMATION_SCHEMA.INNODB_METRICS where name like 'trx_rseg_his%' ORDER BY NAME;

SELECT name, count FROM information_schema.innodb_metrics WHERE  name = 'trx_rseg_history_len';
