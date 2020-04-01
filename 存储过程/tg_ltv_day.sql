label:BEGIN
	###########################  	应用渠道数据统计	######################################
	DECLARE curr_date int DEFAULT 0;
  DECLARE bef2_date int DEFAULT 0; #前一天
  DECLARE bef3_date int DEFAULT 0; #前两天
	DECLARE bef4_date int DEFAULT 0; #前两天
	DECLARE bef5_date int DEFAULT 0; #前两天
	DECLARE bef6_date int DEFAULT 0; #前两天
	DECLARE bef7_date int DEFAULT 0; #前两天
	DECLARE bef8_date int DEFAULT 0; #前两天
	DECLARE bef9_date int DEFAULT 0; #前两天
  DECLARE bef10_date int DEFAULT 0; #前七天
	DECLARE bef11_date int DEFAULT 0; #前七天
	DECLARE bef12_date int DEFAULT 0; #前七天
	DECLARE bef13_date int DEFAULT 0; #前七天
	DECLARE bef14_date int DEFAULT 0; #前七天
  DECLARE bef15_date int DEFAULT 0;#前15天
  DECLARE bef30_date int DEFAULT 0;#前30天
	DECLARE bef45_date int DEFAULT 0;#前45天
  DECLARE bef60_date int DEFAULT 0;#前60天
	DECLARE bef90_date int DEFAULT 0;#前90天
  DECLARE bef120_date int DEFAULT 0;#前120天
	DECLARE bef150_date int DEFAULT 0;#前150天
	DECLARE bef180_date int DEFAULT 0;#前180天

	SET curr_date = mydate;
	#每天执行一次，获取昨天的日期  =====对应事件call_agent_app_count_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");
	#每10分钟执行一次，获取当前日期 =====对应事件call_agent_app_count_day_10mins
	elseif curr_date = 1 then
		  SET curr_date = from_unixtime(unix_timestamp(now()), "%Y%m%d");
	END if;

	SET bef2_date = from_unixtime(unix_timestamp(curr_date)-24*3600, "%Y%m%d");
  SET bef3_date = from_unixtime(unix_timestamp(curr_date)-24*3600*2, "%Y%m%d");
  SET bef4_date = from_unixtime(unix_timestamp(curr_date)-24*3600*3, "%Y%m%d");
	SET bef5_date = from_unixtime(unix_timestamp(curr_date)-24*3600*4, "%Y%m%d");
	SET bef6_date = from_unixtime(unix_timestamp(curr_date)-24*3600*5, "%Y%m%d");
	SET bef7_date = from_unixtime(unix_timestamp(curr_date)-24*3600*6, "%Y%m%d");
	SET bef8_date = from_unixtime(unix_timestamp(curr_date)-24*3600*7, "%Y%m%d");
	SET bef9_date = from_unixtime(unix_timestamp(curr_date)-24*3600*8, "%Y%m%d");
	SET bef10_date = from_unixtime(unix_timestamp(curr_date)-24*3600*9, "%Y%m%d");
	SET bef11_date = from_unixtime(unix_timestamp(curr_date)-24*3600*10, "%Y%m%d");
	SET bef12_date = from_unixtime(unix_timestamp(curr_date)-24*3600*11, "%Y%m%d");
	SET bef13_date = from_unixtime(unix_timestamp(curr_date)-24*3600*12, "%Y%m%d");
	SET bef14_date = from_unixtime(unix_timestamp(curr_date)-24*3600*13, "%Y%m%d");
  SET bef15_date = from_unixtime(unix_timestamp(curr_date)-24*3600*14, "%Y%m%d");
	SET bef30_date = from_unixtime(unix_timestamp(curr_date)-24*3600*29, "%Y%m%d");
	SET bef45_date = from_unixtime(unix_timestamp(curr_date)-24*3600*44, "%Y%m%d");
	SET bef60_date = from_unixtime(unix_timestamp(curr_date)-24*3600*59, "%Y%m%d");
	SET bef90_date = from_unixtime(unix_timestamp(curr_date)-24*3600*89, "%Y%m%d");
	SET bef120_date = from_unixtime(unix_timestamp(curr_date)-24*3600*119, "%Y%m%d");
	SET bef150_date = from_unixtime(unix_timestamp(curr_date)-24*3600*149, "%Y%m%d");
	SET bef180_date = from_unixtime(unix_timestamp(curr_date)-24*3600*179, "%Y%m%d");


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

	#创建临时表
	CREATE TABLE IF NOT EXISTS s_tmp_date (
		id INT(11) NOT NULL AUTO_INCREMENT,
		date INT(11) NOT NULL DEFAULT 0 COMMENT '日期',
		plan_id INT(11) NOT NULL DEFAULT 0 COMMENT '投放计划ID',
		app_id INT(11) NOT NULL DEFAULT 0 COMMENT '应用编号',
		agent_pid INT(11) NOT NULL DEFAULT 0 COMMENT '一级渠道ID',
		agent_id INT(11) NOT NULL DEFAULT 0 COMMENT '二级渠道ID',
		PRIMARY KEY (`id`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='临时数据表(天)';


	#清空临时表数据
	truncate TABLE s_tmp_date;

	#向临时表中插入数据
	insert into s_tmp_date(id,date,plan_id,app_id,agent_pid,agent_id)
	select (@i:=@i+1)pm,a.* from (
				select add_date,plan_id,app_id,agent_pid,agent_id from s_user_login_log where add_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	) as a,(select @i:=0)t;

	#插入缺失数据
	insert into s_tg_ltv_day (date,plan_id,app_id,agent_pid,agent_id)
	select date,plan_id,app_id,agent_pid,agent_id from s_tmp_date where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id from s_tg_ltv_day where date=curr_date group by plan_id,app_id,agent_pid,agent_id
			) as a
			inner join (
				select * from s_tmp_date
			)as b
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	);

	#在s_tg_ltv_day中增加缺失的数据
-- 	delete from s_tg_ltv_day where date=curr_date;
-- 	insert into s_tg_ltv_day(date,plan_id,app_id,agent_pid,agent_id)
-- 	select date,plan_id,app_id,agent_pid,agent_id from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id;
	 #################################################################################################

	#用户注册数
--   update s_tg_ltv_day as a inner join (
-- 		select reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from s_user where reg_date=curr_date group by plan_id,app_id,agent_pid,agent_id
-- 	)as b on a.date=b.reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
-- 	set a.reg_num=b.num
-- 	where a.date=curr_date;



	#当天注册的用户当天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log,"
				where add_date=",curr_date," and user_reg_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num=b.num
			where a.date=",curr_date,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第2天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log,"
				where add_date=",curr_date," and user_reg_date=",bef2_date,"
				group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num2=b.num
			where a.date=",bef2_date,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




  #当天注册的用户第3天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef3_date,"
				group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num3=b.num
			where a.date=",bef3_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	#当天注册的用户第4天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef4_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num4=b.num
			where a.date=",bef4_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;






	#当天注册的用户第5天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef5_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num5=b.num
			where a.date=",bef5_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	#当天注册的用户第6天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef6_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num6=b.num
			where a.date=",bef6_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第7天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef7_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num7=b.num
			where a.date=",bef7_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第8天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef8_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num8=b.num
			where a.date=",bef8_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第9天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef9_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num9=b.num
			where a.date=",bef9_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第10天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef10_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num10=b.num
			where a.date=",bef10_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第11天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef11_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num11=b.num
			where a.date=",bef11_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第12天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef12_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num12=b.num
			where a.date=",bef12_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第13天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef13_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num13=b.num
			where a.date=",bef13_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第14天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef14_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num14=b.num
			where a.date=",bef14_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第15天点击广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",bef15_date,"
				group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_click_num15=b.num
			where a.date=",bef15_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	###############################广告展现数#####################################

	#当天注册的用户当天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",curr_date,"
				group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num=b.num
			where a.date=",curr_date,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第2天展现广告的次数

	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef2_date,"
				group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num2=b.num
			where a.date=",bef2_date,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



  #当天注册的用户第3天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef3_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num3=b.num
			where a.date=",bef3_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	#当天注册的用户第4天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef4_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num4=b.num
			where a.date=",bef4_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	#当天注册的用户第5天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef5_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num5=b.num
			where a.date=",bef5_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;




	#当天注册的用户第6天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef6_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num6=b.num
			where a.date=",bef6_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第7天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef7_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num7=b.num
			where a.date=",bef7_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第8天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef7_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num7=b.num
			where a.date=",bef7_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第9天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef9_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num9=b.num
			where a.date=",bef9_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第10天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef10_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num10=b.num
			where a.date=",bef10_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第11天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef11_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num11=b.num
			where a.date=",bef11_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第12天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef12_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num12=b.num
			where a.date=",bef12_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第13天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef13_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num13=b.num
			where a.date=",bef13_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第14天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef14_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num14=b.num
			where a.date=",bef14_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



	#当天注册的用户第15天展现广告的次数
	set @sqlstr = concat("
			update s_tg_ltv_day as a inner join(
				select user_reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from ",@s_ad_show_log," where add_date=",curr_date," and user_reg_date=",bef15_date," group by plan_id,app_id,agent_pid,agent_id
			) as b on a.date=b.user_reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			set a.ad_show_num15=b.num
			where a.date=",bef15_date,";
	");
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;















END