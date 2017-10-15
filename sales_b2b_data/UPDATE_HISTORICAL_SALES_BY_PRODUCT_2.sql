DROP PROCEDURE IF EXISTS COUNT_HISTORICAL_SALES_BY_PRODUCT;
DELIMITER //
CREATE PROCEDURE COUNT_HISTORICAL_SALES_BY_PRODUCT()
BEGIN

-- 変数を定義する
DECLARE product_id INT;
DECLARE sales_month VARCHAR(10);
DECLARE sales_count INT;
DECLARE done INT DEFAULT 0;

-- カーソルを定義する
DECLARE my_cur CURSOR FOR
SELECT SD.PRODUCT_ID, DATE_FORMAT(ST.SALES_DATE,'%Y%m'), SD.SALES_COUNT
FROM SALES_TRAN ST INNER JOIN SALES_DETAIL SD
ON ST.SALES_ID = SD.SALES_ID;

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
  FETCH my_cur INTO product_id, sales_month, sales_count;
  -- HISTORICAL_SALES_BY_PRODUCTテーブル更新する
  INSERT INTO HISTORICAL_SALES_BY_PRODUCT VALUES(product_id, sales_month, sales_count)
  ON DUPLICATE KEY UPDATE SALES_COUNT = SALES_COUNT + VALUES(sales_count);
  -- トランザクションをコミットする
  COMMIT;
  -- 最終データを処理したらループ処理から抜ける
  IF done = 1 THEN LEAVE my_cur_loop;
  END IF;
END LOOP my_cur_loop;

-- カーソルを閉じる
CLOSE my_cur;

END
//

