label:BEGIN
	###########################  	备份数据库(3天一备份)	######################################
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
	set @bak_table = CONCAT('s_kuaishou_imeil_bak_',curr_date);
	set @sqlStr=CONCAT('CREATE TABLE IF NOT EXISTS ',@bak_table,' select * from s_kuaishou_imeil where add_date<=',curr_date);
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  #删除当天原始数据
  delete from s_kuaishou_imeil where add_date<=curr_date;





END