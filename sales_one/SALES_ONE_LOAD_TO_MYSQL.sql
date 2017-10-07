USE DB_S;

TRUNCATE TABLE SALES_ONE;

LOAD DATA LOCAL INFILE './csv/SALES_ONE.csv'
INTO TABLE SALES_ONE
FIELDS TERMINATED BY ','
(SALES_ID,PRODUCT_ID,SALES_COUNT);
