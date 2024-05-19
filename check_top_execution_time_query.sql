SELECT schema_name, format_pico_time(total_latency) tot_lat, exec_count, format_pico_time(total_latency/exec_count) latency_per_call, query_sample_text 
FROM sys.x$statements_with_runtimes_in_95th_percentile AS t1 
  JOIN performance_schema.events_statements_summary_by_digest AS t2 ON t2.digest=t1.digest 
WHERE schema_name NOT in ('performance_schema', 'sys') ORDER BY (total_latency/exec_count) desc LIMIT 5\G

-- the response time(ms) over 95%
SELECT
  ROUND(bucket_quantile * 100, 1) AS p,
  ROUND(BUCKET_TIMER_HIGH / 1000000000, 3) AS ms
FROM
  performance_schema.events_statements_histogram_global
WHERE
  bucket_quantile >= 0.95
ORDER BY bucket_quantile LIMIT 1;
