label:BEGIN
	###########################  	应用渠道数据统计	######################################
	DECLARE curr_date int DEFAULT 0;
  DECLARE curr_hour int DEFAULT 100;
	DECLARE appId int DEFAULT 0;


	SET curr_date = mydate;
-- 	SET curr_hour = myhour;
	set appId = myAppId;

	 #传入日期，应用，广告id
	if curr_date=0 then
			select '没有选择日期';
			LEAVE label; # 退出存储过程
	END if;

-- 	if curr_hour=100 then
-- 			select '没有选择小时';
-- 			LEAVE label; # 退出存储过程
-- 	END if;


	if appId=0 then
			select '没有选择应用id';
			LEAVE label; # 退出存储过程
	END if;

		#################################################################################################
	#今天日期
	SET @today = from_unixtime(unix_timestamp(now()), "%Y%m%d");

	if curr_date<20200111 then
			set @s_ad_click_log = 's_ad_click_log_20200110';
			set @s_ad_show_log = 's_ad_show_log_20200110';
	elseif	curr_date<@today then
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



	#LEAVE label; # 退出存储过程

  #################################################################################################


		#更新当天每小时的广告收入
		set @sqlstr = concat("
			update s_tg_count_hour as c inner join (
				select a.date,b.add_hour as hour,a.plan_id,a.app_id,a.agent_pid,a.agent_id, round(a.money/a.num*b.new_click_num,2) as money from
				(
					select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money,sum(ad_click_num) as num from s_ad_income where date=",curr_date," and app_id=",appId," group by plan_id,app_id,agent_pid,agent_id
				)as a
				inner join (
							select add_date,add_hour,plan_id,app_id,agent_pid,agent_id,count(1) as new_click_num from ",@s_ad_click_log," where add_date=",curr_date," and app_id=",appId," group by add_hour,plan_id,app_id,agent_pid,agent_id
				)
				as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			)as d
			on c.date=d.date and c.hour=d.hour and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
			set c.ad_income = d.money
			where c.date=",curr_date," and c.app_id=",appId,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;






		#更新当天每小时注册的用户产生的收入
		set @sqlstr = concat("
			update s_tg_count_hour as c inner join (
			select a.date,b.add_hour as hour,a.plan_id,a.app_id,a.agent_pid,a.agent_id, round(a.money/a.num*b.new_click_num,2) as money from
			(
				select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money,sum(ad_click_num) as num from s_ad_income where date=",curr_date," and app_id=",appId," group by plan_id,app_id,agent_pid,agent_id
			)as a
			inner join (
						select add_date,add_hour,plan_id,app_id,agent_pid,agent_id,count(1) as new_click_num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",curr_date," and user_reg_hour=",add_hour," and app_id=",appId," group by add_hour,plan_id,app_id,agent_pid,agent_id
			)
			as b on a.date=b.add_date  and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
		)as d
		on c.date=d.date and c.hour=d.hour and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
		set c.new_ad_income = d.money
		where c.date=",curr_date," and c.app_id=appId;
	");

		PREPARE stmt from @sqlStr;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;



























END