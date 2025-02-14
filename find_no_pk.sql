-- find no pk table

select tab.table_schema as database_name,
       tab.table_name
from information_schema.tables tab
left join information_schema.table_constraints tco
          on tab.table_schema = tco.table_schema
          and tab.table_name = tco.table_name
          and tco.constraint_type = 'PRIMARY KEY'
where tco.constraint_type is null
      and tab.table_schema not in('mysql', 'information_schema', 
                                  'performance_schema', 'sys')
      and tab.table_type = 'BASE TABLE'
order by tab.table_schema,
         tab.table_name;

-- after 8.0.30 version, it provided system generated pk if you setup the below parameter..
SET @@sql_generate_invisible_primary_key=ON;
-- if you hide system generated pk, you can setup the below parameter.
set @@show_gipk_in_create_table_and_information_schema=OFF;
