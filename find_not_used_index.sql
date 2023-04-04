
select database_name, table_name, t1.index_name,  format_bytes(stat_value * @@innodb_page_size) size  
from mysql.innodb_index_stats t1  
  join sys.schema_unused_indexes t2 on object_schema=database_name and object_name=table_name and t2.index_name=t1.index_name  
where stat_name='size' order by stat_value desc;
