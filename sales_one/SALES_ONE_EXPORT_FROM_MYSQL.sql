USE DB_S;
SELECT * FROM SALES_ONE INTO OUTFILE './csv/SALES_ONE.csv' FIELDS TERMINATED BY ',';
