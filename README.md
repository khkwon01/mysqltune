# mysqltune

### 1. MySQL thread pool 
| parameter | recommended value |
|---|:---|
| `thread_pool_size` | #physical_cores, max 512 |
| `thread_pool_max_transaction_limit` | #physical_cores * 32, max 512 |
| `thread_pool_algorithm` | 1 (high concurrency algorithm) |
| `thread_pool_query_worker_threads_per_group` | > 2 |
