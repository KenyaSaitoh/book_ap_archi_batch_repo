USE DB_C;
TRUNCATE TABLE CUSTOMER2;
LOAD DATA LOCAL INFILE '/work/init_data/customer/csv/CUSTOMER_1M.csv'
INTO TABLE CUSTOMER2
FIELDS TERMINATED BY ','
(CUSTOMER_ID,CUSTOMER_NAME,GENDER,AGE,ADDRESS,JOB_ID)
