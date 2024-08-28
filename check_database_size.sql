SELECT
  table_schema AS db,
  ROUND(SUM(data_length + index_length) / 1073741824 , 2) AS 'size_GB'
FROM
  information_schema.tables
GROUP BY table_schema;
