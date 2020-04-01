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
	#DECLARE bef45_date int DEFAULT 0;#前45天
  DECLARE bef60_date int DEFAULT 0;#前60天
	DECLARE bef90_date int DEFAULT 0;#前90天
  DECLARE bef120_date int DEFAULT 0;#前120天
	#DECLARE bef150_date int DEFAULT 0;#前150天
	DECLARE bef180_date int DEFAULT 0;#前180天

	SET curr_date = mydate;
	#每天执行一次，获取昨天的日期  =====对应事件call_agent_app_count_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");
	#每10分钟执行一次，获取当前日期 =====对应事件call_agent_app_count_day_10mins
	elseif curr_date = 1 then
			#IF (hour(now())>=0 and hour(now())<7 ) then leave label; # 0点到7点间不执行
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
	#SET bef45_date = from_unixtime(unix_timestamp(curr_date)-24*3600*44, "%Y%m%d");
	SET bef60_date = from_unixtime(unix_timestamp(curr_date)-24*3600*59, "%Y%m%d");
	SET bef90_date = from_unixtime(unix_timestamp(curr_date)-24*3600*89, "%Y%m%d");
	SET bef120_date = from_unixtime(unix_timestamp(curr_date)-24*3600*119, "%Y%m%d");
	#SET bef150_date = from_unixtime(unix_timestamp(curr_date)-24*3600*149, "%Y%m%d");
	SET bef180_date = from_unixtime(unix_timestamp(curr_date)-24*3600*179, "%Y%m%d");



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

	#################################################################################################

	#清空临时表数据
	truncate TABLE s_tmp_date;

	#向临时表中插入数据
	insert into s_tmp_date(id,date,plan_id,app_id,agent_pid,agent_id)
	select (@i:=@i+1)pm,a.* from (
				select add_date,plan_id,app_id,agent_pid,agent_id from s_user_login_log where add_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	) as a,(select @i:=0)t;

	#插入缺失数据
	insert into s_tg_stay_day (date,plan_id,app_id,agent_pid,agent_id)
	select date,plan_id,app_id,agent_pid,agent_id from s_tmp_date where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id from s_tg_stay_day where date=curr_date group by plan_id,app_id,agent_pid,agent_id
			) as a
			inner join (
				select * from s_tmp_date
			)as b
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	);

-- 	delete from s_tg_stay_day where date=curr_date;
-- 	insert into s_tg_stay_day(date,plan_id,app_id,agent_pid,agent_id)
-- 	select date,plan_id,app_id,agent_pid,agent_id from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id;

  #################################################################################################

	 #用户注册数
  update s_tg_stay_day as a inner join (
		select reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from s_user where reg_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	)as b on a.date=b.reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg_num=b.num
	where a.date=curr_date;


	#当天注册，第2天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef2_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg2_login_num=b.num
	where a.date=bef2_date;

	#当天注册，第3天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef3_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg3_login_num=b.num
	where a.date=bef3_date;

 #当天注册，第4天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef4_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg4_login_num=b.num
	where a.date=bef4_date;

 #当天注册，第5天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef5_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg5_login_num=b.num
	where a.date=bef5_date;


 #当天注册，第6天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef6_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg6_login_num=b.num
	where a.date=bef6_date;

	#当天注册，第7天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef7_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg7_login_num=b.num
	where a.date=bef7_date;

	#当天注册，第8天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef8_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg8_login_num=b.num
	where a.date=bef8_date;

	#当天注册，第9天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef9_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg9_login_num=b.num
	where a.date=bef9_date;


	#当天注册，第10天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef10_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg10_login_num=b.num
	where a.date=bef10_date;


	#当天注册，第11天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef11_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg11_login_num=b.num
	where a.date=bef11_date;


	#当天注册，第12天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef12_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg12_login_num=b.num
	where a.date=bef12_date;

	#当天注册，第13天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef13_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg13_login_num=b.num
	where a.date=bef13_date;

	#当天注册，第14天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef14_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg14_login_num=b.num
	where a.date=bef14_date;

	#当天注册，第15天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef15_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg15_login_num=b.num
	where a.date=bef15_date;

	#当天注册，第30天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef30_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg30_login_num=b.num
	where a.date=bef30_date;

	#当天注册，第60天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef60_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg60_login_num=b.num
	where a.date=bef60_date;

	#当天注册，第90天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef90_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg90_login_num=b.num
	where a.date=bef90_date;

	#当天注册，第120天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef120_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg120_login_num=b.num
	where a.date=bef120_date;

	#当天注册，第180天登录的人数
	update s_tg_stay_day as a inner join (
		select plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log
		where user_reg_date=bef180_date and add_date=curr_date
		group by plan_id,app_id,agent_pid,agent_id
	) b on a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg180_login_num=b.num
	where a.date=bef180_date;












END