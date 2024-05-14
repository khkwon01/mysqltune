## 데이터베이스 디자인

### 1. table 구조
- 테이블 정규화 : 중복 데이터 최소화 및 데이터 정합성 향상
- 적정한 데이터 타입 사용 : 스토리지 공간 줄이고 데이터베이스 성능 향상
- NULL값 사용 지양 : 데이터 정합성 및 쿼리 성능 향상 (NULL 대신 default 값 사용)
- 의미 있는 테이블과 컬럼 이름 사용 : 데이터베이스 스키마 및 쿼리 데이터에 이해 증가
- Primary keys 사용 : 성능 향상 및 데이터 정합성 증가
- GIPK : default primary key 생성 (sql_generate_invisible_primary_key)
- Partitioning 사용 : 파티션별 쿼리 병렬 수행 및 필요로 하는 데이터 읽기 수행 최소화

### 2. 쿼리 최적화
- indexes 사용: 쿼리에서 많이 사용되는 컬럼을 기준으로 index 생성
- select * 제거: select시 필요한 컬럼만 사용
- explain 사용 : 쿼리 plan 분석 및 성능 이슈 확인
- where 조건 사용 : 불필요한 데이터 필터링후 관련된 데이터만 return


