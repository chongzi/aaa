label:BEGIN
	###########################  	同步s_ad_show_log表字段值信息	######################################
	DECLARE curr_date int DEFAULT 0;
	#DECLARE t1 int DEFAULT 0;
	#DECLARE t2 int DEFAULT 0;

	SET curr_date = mydate;


	#每天执行一次，获取昨天的日期  =====对应事件call_upd_ad_show_log_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");
			#每1分钟执行一次，获取当前日期 =====对应事件call_upd_ad_show_log_1min
	elseif curr_date = 1 then
		  SET curr_date = from_unixtime(unix_timestamp(now()), "%Y%m%d");
	END if;

	#SET t1 = UNIX_TIMESTAMP(curr_date); #当天的0点的时间戳
	#SET t2 = UNIX_TIMESTAMP(DATE_SUB(curr_date,INTERVAL -1 DAY));    #当天后一天0点的时间戳
	#LEAVE label; # 退出存储过程

	 #################################################################################################
	#今天日期
	SET @today = from_unixtime(unix_timestamp(now()), "%Y%m%d");

	if curr_date<20200111 then
			set @s_ad_click_log = 's_ad_click_log_20200110';
			set @s_ad_show_log = 's_ad_show_log_20200110';
	elseif	curr_date<=@today then
			set @s_ad_click_log = CONCAT('s_ad_click_log_',curr_date);
			set @s_ad_show_log = CONCAT('s_ad_show_log_',curr_date);
	else
			set @s_ad_click_log = 's_ad_click_log';
			set @s_ad_show_log = 's_ad_show_log';
	end if;


	#如果表不存在，则走默认
	if !(SELECT COUNT(*) FROM information_schema.`TABLES` WHERE TABLE_NAME=@s_ad_click_log) then
		set @s_ad_click_log = 's_ad_click_log';
	end if;

	if !(SELECT COUNT(*) FROM information_schema.`TABLES` WHERE TABLE_NAME=@s_ad_show_log) then
		set @s_ad_show_log = 's_ad_show_log';
	end if;


	#select @s_ad_show_log;
	#LEAVE label; # 退出存储过程


  #################################################################################################
	#同步show_log表用户信息
	set @sqlstr = concat("
			update ",@s_ad_show_log," as a
			inner join s_user as b on a.user_id=b.id
			set a.app_id=b.app_id, a.agent_pid=b.agent_pid, a.agent_id=b.agent_id, a.plan_id=b.plan_id, a.user_reg_date=b.reg_date, a.user_reg_hour=b.reg_hour
			where a.add_date = ",curr_date," and a.agent_id=0;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

	#同步新老用户
	set @sqlstr = concat("
			update ",@s_ad_show_log,"
			set is_new_user = if(add_date=user_reg_date,1,0)
			where add_date=",curr_date," and user_reg_date!=0 and is_new_user=-1;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  #同步广告位相关字段信息
	#(旧版本)
	set @sqlstr = concat("
			update ",@s_ad_show_log," as a
			inner join s_ad as b on a.ad_position=b.position
			set a.ad_id=b.id, a.ad_name=b.name, a.ad_code=b.code, a.ad_type=b.type
			where a.add_date=",curr_date," and a.app_id=17 and a.ad_id=0;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#(新版本)---ad_code有可能为0或为''，所以不能根据ad_code更新，要根据app_id,agent_id,position,is_new_user来确定ad_id
  set @sqlstr = concat("
			update ",@s_ad_show_log," as a
			inner join s_ad as b
			on a.app_id=b.app_id and a.agent_id=b.agent_id and a.ad_position=b.position and a.is_new_user=b.is_new_user
			set a.ad_id=b.id, a.ad_name=b.name,a.ad_type=b.type
			where a.add_date=",curr_date,"  and a.app_id!=17 and a.ad_id=0 and (a.ad_code=0 or a.ad_code='');
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


	#(新版本)---ad_code不为0的情况
  set @sqlstr = concat("
			update ",@s_ad_show_log," as a
			inner join s_ad as b
			on a.ad_code=b.code
			set a.ad_id=b.id, a.ad_name=b.name, a.ad_type=b.type
			where a.add_date=",curr_date,"  and a.app_id!=17 and a.ad_id=0 and (a.ad_code!=0 and a.ad_code!='');
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



  #(新版)---针对默认渠道再更新一遍(agent_id值在s_ad表不存在)
--   set @sqlstr = concat("
-- 			update ",@s_ad_show_log," as a
-- 			inner join s_ad as b
-- 			on a.app_id=b.app_id and a.agent_id>0 and b.agent_id=0 and a.ad_position=b.position and a.is_new_user=b.is_new_user
-- 			set a.ad_id=b.id, a.ad_name=b.name,a.ad_type=b.type
-- 			where a.add_date=",curr_date,"  and a.app_id!=17 and a.ad_id=0 and (a.ad_code=0 or a.ad_code='');
-- 	");
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;




######################################################################################################
  #同步click_log表用户信息
	set @sqlstr = concat("
			update ",@s_ad_click_log," as a
			inner join s_user as b on a.user_id=b.id
			set a.app_id=b.app_id, a.agent_pid=b.agent_pid, a.agent_id=b.agent_id, a.plan_id=b.plan_id, a.user_reg_date=b.reg_date, a.user_reg_hour=b.reg_hour
			where a.add_date = ",curr_date," and a.agent_id=0;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

	#同步新老用户
	set @sqlstr = concat("
			update ",@s_ad_click_log,"
			set is_new_user = if(add_date=user_reg_date,1,0)
			where add_date=",curr_date," and user_reg_date!=0 and is_new_user=-1;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  #(旧版本)
	set @sqlstr = concat("
			update ",@s_ad_click_log," as a
			inner join s_ad as b on a.ad_position=b.position
			set a.ad_id=b.id, a.ad_name=b.name, a.ad_type=b.type
			where a.add_date = ",curr_date," and a.app_id=17 and a.ad_id=0;
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#(新版本)---ad_code有可能为0或为''，所以不能根据ad_code更新，要根据app_id,agent_id,position,is_new_user来确定ad_id
	set @sqlstr = concat("
			update ",@s_ad_click_log," as a
			inner join s_ad as b
			on a.app_id=b.app_id and a.agent_id=b.agent_id and a.ad_position=b.position and a.is_new_user=b.is_new_user
			set a.ad_id=b.id, a.ad_name=b.name, a.ad_type=b.type
			where a.add_date = ",curr_date," and a.app_id!=17 and a.ad_id=0 and (a.ad_code=0 or a.ad_code='');
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


	#(新版本)---ad_code不为0的情况
	set @sqlstr = concat("
			update ",@s_ad_click_log," as a
			inner join s_ad as b
			on a.ad_code=b.code
			set a.ad_id=b.id, a.ad_name=b.name, a.ad_type=b.type
			where a.add_date=",curr_date,"  and a.app_id!=17 and a.ad_id=0 and (a.ad_code!=0 and a.ad_code!='');
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  #(新版本)---针对默认渠道再更新一遍(agent_id值在s_ad表不存在的情况)
-- 	set @sqlstr = concat("
-- 			update ",@s_ad_click_log," as a
-- 			inner join s_ad as b
-- 			on a.app_id=b.app_id and a.agent_id>0 and b.agent_id=0 and a.ad_position=b.position and a.is_new_user=b.is_new_user
-- 			set a.ad_id=b.id, a.ad_name=b.name,a.ad_type=b.type
-- 			where a.add_date=",curr_date,"  and a.app_id!=17 and a.ad_id=0 and (a.ad_code=0 or a.ad_code='');
-- 	");
-- 	PREPARE stmt from @sqlStr;
--   EXECUTE stmt;
--   DEALLOCATE PREPARE stmt;




END