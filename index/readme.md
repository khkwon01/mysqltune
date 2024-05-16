### 1. index basic architecture and work flow
![image](https://github.com/khkwon01/mysqltune/assets/8789421/153e554d-e90b-470a-a19a-cc86d73dc6b1)
- The primary key is a `critical factor` in performance
- If you create a secondary indexes, it includes `primary key values`
- If you find some rows using secondary indexes, the following process happens     
  ![image](https://github.com/khkwon01/mysqltune/assets/8789421/a89e511e-feed-45f0-ac0f-9390f9dab054)
- For limiting data access `order by ... limit`, you should need to the following
  - if order by ... limit 2 clause, the query only get 2 rows using index, not filting from result set
  - The query uses an index (`type: range`)
  - The order by column is a `leftmost prefix of index`
  - The Extra field doesn't report `Using filesort`
