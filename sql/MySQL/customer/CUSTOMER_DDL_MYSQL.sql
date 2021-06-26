DROP TABLE IF EXISTS CUSTOMER2;

CREATE TABLE CUSTOMER2 (
CUSTOMER_ID   INT PRIMARY KEY,      -- 顧客番号
CUSTOMER_NAME VARCHAR(30) NOT NULL, -- 顧客名
GENDER        INT NOT NULL,         -- 性別
AGE           INT NOT NULL,         -- 年齢
ADDRESS       VARCHAR(50),          -- 住所
JOB_ID        INT                   -- 職業
)
TYPE = InnoDB;
