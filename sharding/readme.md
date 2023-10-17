### 1. MySQL 고려 가능한 sharding 전략
- 아래 그림과 같이 Single H/W 서버 구성된 MySQL은 한정된 자원과 성능을 가지고 있기 때문에 성능(특히 write)을 확장하기 위해서는 데이터베이스 샤딩이 필요함       
<img width="335" alt="image" src="https://github.com/khkwon01/mysqltune/assets/8789421/7175fd5a-e245-47eb-806e-5b1c99808b60">         

- 확장시 선택 가능한 옵션 :  MySQL Scale up(H/W 변경/증설) < MySQL Replication (scale out, read 중심) < application 샤딩 (shard key 기반)
  
### 1) 

### 2) 
| 구분 | `Hash 방식` | `Range 방식` | `Lookup 방식` | 비고 |
|---|:---|:---|:---|:---|
| 설명 | 주요 키에 hashing algorithm 사용 | | | |
| Diagram | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/36722d3c-a8f2-46b8-beea-faab72ee4390) | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/96315ac6-e73c-49ab-88a4-6fd6c9818b29) | ![image](https://github.com/khkwon01/mysqltune/assets/8789421/58cab968-b900-416f-8f34-129064903f64) | |
