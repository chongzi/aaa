label:BEGIN
	###########################  	备份数据库	######################################
	DECLARE curr_date int DEFAULT 0;


	SET curr_date = mydate;
	SET @today = from_unixtime(unix_timestamp(now()), "%Y%m%d");
	
	

	
	
	#每天执行一次，获取昨天的日期  =====对应事件call_agent_app_count_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");	
	END if;
	
	#只能备份今天以前的数据
	if curr_date>=@today then
			LEAVE label; # 退出存储过程 	
	END if;
	

  #################################################################################################
	#备份s_ad_click_log表当天数据
	# set @bak_table = CONCAT('s_ad_click_log_',curr_date);

  #复制表结构
-- 	set @sqlStr=CONCAT('CREATE TABLE IF NOT EXISTS ',@bak_table,' LIKE s_ad_click_log');
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;
--
--   #插入数据
-- 	set @sqlStr=CONCAT('INSERT INTO ',@bak_table,' SELECT * FROM s_ad_click_log where add_date=',curr_date);
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;
--
--
--   #删除当天原始数据
--   delete from s_ad_click_log where add_date=curr_date;
--
--
-- 	#################################################################################################
-- 	#备份s_ad_show_log表当天数据
-- 	set @bak_table = CONCAT('s_ad_show_log_',curr_date);
--
-- 	#复制表结构
-- 	set @sqlStr=CONCAT('CREATE TABLE IF NOT EXISTS ',@bak_table,' LIKE s_ad_show_log');
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;
--
-- 	#插入数据
-- 	set @sqlStr=CONCAT('INSERT INTO ',@bak_table,' SELECT * FROM s_ad_show_log where add_date=',curr_date);
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;
--
--   #删除当天原始数据
--   #delete from s_ad_show_log where add_date=curr_date;


	#################################################################################################
	#备份s_gold_log表当天数据
	set @bak_table = CONCAT('s_gold_log_',curr_date);

	#复制表结构
	set @sqlStr=CONCAT('CREATE TABLE IF NOT EXISTS ',@bak_table,' LIKE s_gold_log');
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  #插入数据
  set @sqlStr=CONCAT('INSERT INTO ',@bak_table,' SELECT * FROM s_gold_log where add_date=',curr_date);
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  #删除当天原始数据
  #delete from s_gold_log where add_date=curr_date;
	
	

END