### 1. MySQL 고려 가능한 sharding 전략
- 아래 그림과 같이 Single H/W 서버 구성된 MySQL은 한정된 자원과 성능을 가지고 있기 때문에 성능(특히 write)을 확장하기 위해서는 데이터베이스 샤딩이 필요함       
<img width="335" alt="image" src="https://github.com/khkwon01/mysqltune/assets/8789421/7175fd5a-e245-47eb-806e-5b1c99808b60">         

- 확장시 선택 가능한 옵션   
  MySQL Scale up(H/W 변경/증설) < MySQL Replication (scale out, read 중심) < application 샤딩 (shard key 기반)    
  
### 1) MySQL sharding key
- 이상적인 shard key는 아래와 같이 3가지 속성을 가져야 함
  - High cardinality : shard 데이터베이스에 공평하게 분산되기 위해 unique한 값을 가진 key를 선택하면 좋음
  - Application Based : application에서 접근 하는 key를 통해서 같은 shard 데이터베이스에서 데이터 획득 (ex. 고객의 customer key)
  - Small : shard key는 가능하면 작은 사이즈로 구성

### 2) MySQL sharding 전략   
위에 1) 에서 선택된 shard key에 아래 shard 방식들을 적용하여 물리적으로 실제 shard 데이터베이스를 구성
| 구분 | `Hash 방식` | `Range 방식` | `Lookup 방식` | 비고 |
|---|:---|:---|:---|:---|
| 설명 | 주요 키에 hashing algorithm 사용 | 연속적인 값을 사용| shard에 미리 지정된 값을 사용 | |
| Diagram | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/36722d3c-a8f2-46b8-beea-faab72ee4390) | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/96315ac6-e73c-49ab-88a4-6fd6c9818b29) | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/58cab968-b900-416f-8f34-129064903f64) | |
