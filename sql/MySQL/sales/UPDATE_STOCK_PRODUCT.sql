DELIMITER //
CREATE PROCEDURE UPDATE_STOCK_PRODUCT(IN param_date DATE)
BEGIN
-- 変数を宣言する
DECLARE var_sales_id INT DEFAULT 0;
DECLARE done INT DEFAULT 0;
DECLARE loop_count INT DEFAULT 0;
-- カーソルを宣言する
DECLARE my_cur CURSOR FOR --[1]
SELECT SALES_ID FROM SALES_TRAN WHERE SALES_DATE = param_date
AND UPDATE_STOCK_FLAG = 0; 
-- カーソルをオープンする
OPEN my_cur; --[2]
-- ループから抜けるためのハンドラを定義する
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
-- トランザクションを開始する
START TRANSACTION; --[3]
-- ループ処理を開始する
my_cur_loop : LOOP --[4]
  -- ループカウンタに1加算する
  SET loop_count = loop_count + 1;
  -- カーソルをFETCHする。
  FETCH my_cur INTO var_sales_id; --[5]
  -- STOCK_PRODUCTテーブル更新する
  UPDATE STOCK_PRODUCT SP  --[6]
  INNER JOIN (SALES_TRAN ST INNER JOIN SALES_DETAIL SD ON ST.SALES_ID = SD.SALES_ID)
  ON SP.PRODUCT_ID = SD.PRODUCT_ID
  SET SP.QUANTITY = SP.QUANTITY - SD.SALES_COUNT, ST.UPDATE_STOCK_FLAG = 1
  WHERE ST.SALES_ID = var_sales_id;
  -- 10件毎にトランザクションをコミットし、新しいトランザクションを開始する
  IF loop_count % 10 = 0 THEN  --[7]
    COMMIT;
    START TRANSACTION;
  END IF;
  -- 最終データを処理したらトランザクションをコミットし、ループ処理から抜ける
  IF done = 1 THEN
    COMMIT;
    LEAVE my_cur_loop;
  END IF;
END LOOP my_cur_loop;
-- カーソルを閉じる
CLOSE my_cur;
END
//