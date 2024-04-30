CREATE TABLE `students` (
  `first_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `mobile_no` varchar(10) DEFAULT NULL,
  `age` int DEFAULT NULL,
  KEY `age_index` (`age`)
) --ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DELIMITER $$

CREATE PROCEDURE load_data()
begin
  DECLARE i int DEFAULT 0;
  while i < 200000 do
    INSERT INTO `students`
              (
                          `first_name`,
                          `last_name`,
                          `age`,
                          `mobile_no`
              )
              VALUES
              (
                          conv(floor(rand() * 99999999999999), 10, 36),
                          conv(floor(rand() * 99999999999999), 10, 36),
                          round(rand()*100,2),
                          lpad(floor(rand() * 10000000000), 10, '0')
              );

    set i = i + 1;
  end while;
end
$$

DELIMITER ;
