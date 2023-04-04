-- find no pk table

SELECT i.TABLE_ID, t.NAME  
FROM INFORMATION_SCHEMA.INNODB_INDEXES i  
   JOIN INFORMATION_SCHEMA.INNODB_TABLES t ON (i.TABLE_ID = t.TABLE_ID)  
WHERE      i.NAME='GEN_CLUST_INDEX';


-- after 8.0.30 version, it provided system generated pk if you setup the below parameter..
SET @@sql_generate_invisible_primary_key=ON;
