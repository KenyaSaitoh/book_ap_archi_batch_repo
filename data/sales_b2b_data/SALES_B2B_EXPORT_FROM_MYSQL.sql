USE DB_S;
SELECT * FROM PRODUCT_TYPE INTO OUTFILE '/work/files/sales_b2b/csv/PRODUCT_TYPE.csv' FIELDS TERMINATED BY ',';
SELECT * FROM PRODUCT INTO OUTFILE '/work/files/sales_b2b/csv/PRODUCT.csv' FIELDS TERMINATED BY ',';
SELECT * FROM PRODUCT_NEW_PRICE INTO OUTFILE '/work/files/sales_b2b/csv/PRODUCT_NEW_PRICE.csv' FIELDS TERMINATED BY ',';
SELECT * FROM STOCK_PRODUCT INTO OUTFILE '/work/files/sales_b2b/csv/STOCK_PRODUCT.csv' FIELDS TERMINATED BY ',';
SELECT * FROM BRANCH INTO OUTFILE '/work/files/sales_b2b/csv/BRANCH.csv' FIELDS TERMINATED BY ',';
SELECT * FROM STAFF INTO OUTFILE '/work/files/sales_b2b/csv/STAFF.csv' FIELDS TERMINATED BY ',';
SELECT * FROM CUSTOMER INTO OUTFILE '/work/files/sales_b2b/csv/CUSTOMER.csv' FIELDS TERMINATED BY ',';
SELECT * FROM SALES_TRAN INTO OUTFILE '/work/files/sales_b2b/csv/SALES_TRAN.csv' FIELDS TERMINATED BY ',';
SELECT * FROM SALES_DETAIL INTO OUTFILE '/work/files/sales_b2b/csv/SALES_DETAIL.csv' FIELDS TERMINATED BY ',';