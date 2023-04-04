select t2.*, format_bytes(stat_value * @@innodb_page_size) size  
from mysql.innodb_index_stats t1 
  join sys.schema_redundant_indexes t2 on table_schema=database_name and t2.table_name=t1.table_name and t2.redundant_index_name=t1.index_name  
where stat_name='size' order by stat_value desc\G;
