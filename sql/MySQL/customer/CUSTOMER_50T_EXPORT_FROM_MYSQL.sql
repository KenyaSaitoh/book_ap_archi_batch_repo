USE DB_C;
SELECT * FROM CUSTOMER2 INTO OUTFILE '/work/init_data/customer/csv/CUSTOMER_50T.csv' FIELDS TERMINATED BY ','
