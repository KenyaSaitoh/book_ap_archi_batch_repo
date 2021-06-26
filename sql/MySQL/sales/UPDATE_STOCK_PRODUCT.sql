DELIMITER //
CREATE PROCEDURE UPDATE_STOCK_PRODUCT(IN param_date DATE)
BEGIN
-- �ϐ���錾����
DECLARE var_sales_id INT DEFAULT 0;
DECLARE done INT DEFAULT 0;
DECLARE loop_count INT DEFAULT 0;
-- �J�[�\����錾����
DECLARE my_cur CURSOR FOR --[1]
SELECT SALES_ID FROM SALES_TRAN WHERE SALES_DATE = param_date
AND UPDATE_STOCK_FLAG = 0; 
-- �J�[�\�����I�[�v������
OPEN my_cur; --[2]
-- ���[�v���甲���邽�߂̃n���h�����`����
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
-- �g�����U�N�V�������J�n����
START TRANSACTION; --[3]
-- ���[�v�������J�n����
my_cur_loop : LOOP --[4]
  -- ���[�v�J�E���^��1���Z����
  SET loop_count = loop_count + 1;
  -- �J�[�\����FETCH����B
  FETCH my_cur INTO var_sales_id; --[5]
  -- STOCK_PRODUCT�e�[�u���X�V����
  UPDATE STOCK_PRODUCT SP  --[6]
  INNER JOIN (SALES_TRAN ST INNER JOIN SALES_DETAIL SD ON ST.SALES_ID = SD.SALES_ID)
  ON SP.PRODUCT_ID = SD.PRODUCT_ID
  SET SP.QUANTITY = SP.QUANTITY - SD.SALES_COUNT, ST.UPDATE_STOCK_FLAG = 1
  WHERE ST.SALES_ID = var_sales_id;
  -- 10�����Ƀg�����U�N�V�������R�~�b�g���A�V�����g�����U�N�V�������J�n����
  IF loop_count % 10 = 0 THEN  --[7]
    COMMIT;
    START TRANSACTION;
  END IF;
  -- �ŏI�f�[�^������������g�����U�N�V�������R�~�b�g���A���[�v�������甲����
  IF done = 1 THEN
    COMMIT;
    LEAVE my_cur_loop;
  END IF;
END LOOP my_cur_loop;
-- �J�[�\�������
CLOSE my_cur;
END
//