DROP PROCEDURE IF EXISTS UPDATE_STOCK_PRODUCT;
DELIMITER //
CREATE PROCEDURE UPDATE_STOCK_PRODUCT(IN param_date DATE)
BEGIN

-- 変数を定義する
DECLARE var_sales_id INT DEFAULT 0;
DECLARE done INT DEFAULT 0;
DECLARE hit_row_count INT;
DECLARE exist_row_count INT;

-- カーソルを定義する
DECLARE my_cur CURSOR FOR
SELECT SALES_ID FROM SALES_TRAN
WHERE SALES_DATE = param_date
AND UPDATE_STOCK_FLAG = 0; 

-- ループから抜けるためのハンドラを定義する
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

-- エラーの場合にロールバックするためのハンドラを定義する
DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;

-- カーソルを開く
OPEN my_cur;

-- メインとなるループ処理
my_cur_loop : LOOP 
  -- トランザクションを開始する
  START TRANSACTION;

  -- カーソルをFETCHする
  FETCH my_cur INTO var_sales_id;

  -- STOCK_PRODUCTテーブル更新する
  UPDATE STOCK_PRODUCT SP
  INNER JOIN (SALES_TRAN ST INNER JOIN SALES_DETAIL SD ON ST.SALES_ID = SD.SALES_ID)
  ON SP.PRODUCT_ID = SD.PRODUCT_ID
  SET SP.QUANTITY = SP.QUANTITY - SD.SALES_COUNT,
  ST.UPDATE_STOCK_FLAG = 1
  WHERE ST.SALES_ID = var_sales_id;
  SET hit_row_count = FOUND_ROWS();

  -- SALES_DETAILの件数を取得する
  SET exist_row_count = (SELECT COUNT(*) FROM SALES_DETAIL WHERE SALES_ID = var_sales_id);

  -- ヒット件数がSALES_DETAILの件数と異なるかどうかをチェックする
  IF hit_row_count = exist_row_count THEN
    -- トランザクションをコミットする
    COMMIT;
  ELSE
    -- トランザクションをロールバックする
    ROLLBACK;
  END IF;

  -- 最終データを処理したらループ処理から抜ける
  IF done = 1 THEN LEAVE my_cur_loop;
  END IF;
END LOOP my_cur_loop;

-- カーソルを閉じる
CLOSE my_cur;

END
//

