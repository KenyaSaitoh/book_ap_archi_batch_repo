UPDATE STOCK_PRODUCT SP
INNER JOIN (SALES_TRAN ST INNER JOIN SALES_DETAIL SD ON ST.SALES_ID = SD.SALES_ID)
ON SP.PRODUCT_ID = SD.PRODUCT_ID
SET SP.QUANTITY = SP.QUANTITY - SD.SALES_COUNT,
ST.UPDATE_STOCK_FLAG = 1
WHERE ST.SALES_DATE = '2015-01-06'
AND ST.UPDATE_STOCK_FLAG = 0;
