label:BEGIN
	###########################  	修正数据	######################################
	DECLARE curr_date int DEFAULT 0;
	DECLARE appId int DEFAULT 0;

	SET curr_date = mydate;
	set appId = myAppId;

	 #传入日期，应用，广告id
	if curr_date=0 then
			select '没有选择日期';
			LEAVE label; # 退出存储过程
	END if;

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
				select add_date,plan_id,app_id,agent_pid,agent_id from s_user_login_log where add_date=curr_date and app_id=appId group by plan_id,app_id,agent_pid,agent_id
	) as a,(select @i:=0)t;


	#插入缺失数据
	insert into s_tg_count_day (date,plan_id,app_id,agent_pid,agent_id)
	select date,plan_id,app_id,agent_pid,agent_id from s_tmp_date where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id from s_tg_count_day where date=curr_date and app_id=appId group by plan_id,app_id,agent_pid,agent_id
			) as a
			inner join (
				select * from s_tmp_date
			)as b
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	);





	#当天广告总收入
	update s_tg_count_day as a inner join(
	  select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money from s_ad_income where date=curr_date and app_id=appId group by plan_id,app_id,agent_pid,agent_id
	) as b on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.ad_income=b.money
	where a.date=curr_date and a.app_id=appId;



	#当天注册的用户产生的收入
	set @sqlstr = concat("
			 update s_tg_count_day as c inner join (
					select a.date,a.plan_id,a.app_id,a.agent_pid,a.agent_id, round(a.money/a.num*b.new_click_num,2) as money from
					(
						select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money,sum(ad_click_num) as num from s_ad_income where date=",curr_date," and app_id=",appId," group by plan_id,app_id,agent_pid,agent_id
					)as a
					inner join (
						select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as new_click_num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",curr_date," and app_id=",appId," group by plan_id,app_id,agent_pid,agent_id)
						as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
			)as d
			on c.date=d.date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
			set c.new_ad_income = d.money
			where c.date=",curr_date," and c.app_id=",appId,";
	");

	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;














END