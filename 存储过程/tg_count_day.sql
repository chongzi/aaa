label:BEGIN
	###########################  	应用渠道数据统计	######################################
	DECLARE curr_date int DEFAULT 0;


	SET curr_date = mydate;
	#每天执行一次，获取昨天的日期  =====对应事件call_tg_count_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");
	#每10分钟执行一次，获取当前日期 =====对应事件call_tg_count_day_10mins
	elseif curr_date = 1 then
		  SET curr_date = from_unixtime(unix_timestamp(now()), "%Y%m%d");
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
	
	######################################################################################################
	#同步s_ad_show_log表用户相关字段信息
-- 	update s_ad_show_log as a 
-- 	inner join s_user as b on a.user_id=b.id 
-- 	set a.app_id=b.app_id, a.agent_pid=b.agent_pid, a.agent_id=b.agent_id, a.plan_id=b.plan_id, a.user_reg_date=b.reg_date, a.user_reg_hour=b.reg_hour 
-- 	where a.add_date = curr_date and a.user_reg_date=0;
-- 	
-- 
--   #同步s_ad_show_log表广告位相关字段信息
--   update s_ad_show_log as a 
-- 	inner join s_ad as b on a.ad_position=b.position 
-- 	set a.ad_id=b.id, a.ad_name=b.name
-- 	where a.add_date = curr_date and a.ad_id=0;
--   
-- 
-- 	#同步s_ad_click_log表
--   update s_ad_click_log as a 
-- 	inner join s_user as b on a.user_id=b.id 
-- 	set a.app_id=b.app_id, a.agent_pid=b.agent_pid, a.agent_id=b.agent_id, a.plan_id=b.plan_id, a.user_reg_date=b.reg_date, a.user_reg_hour=b.reg_hour 
-- 	where a.add_date = curr_date and a.user_reg_date=0;
-- 
-- 	
-- 
--   #同步s_ad_click_log表广告位相关字段信息
--   update s_ad_click_log as a 
-- 	inner join s_ad as b on a.ad_position=b.position 
-- 	set a.ad_id=b.id, a.ad_name=b.name
-- 	where a.add_date = curr_date and a.ad_id=0;

	
	######################################################################################################
	#向临时表中插入数据
	insert into s_tmp_date(id,date,plan_id,app_id,agent_pid,agent_id)
	select (@i:=@i+1)pm,a.* from (
				select add_date,plan_id,app_id,agent_pid,agent_id from s_user_login_log where add_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	) as a,(select @i:=0)t;

	#插入缺失数据
	insert into s_tg_count_day (date,plan_id,app_id,agent_pid,agent_id)
	select date,plan_id,app_id,agent_pid,agent_id from s_tmp_date where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id from s_tg_count_day where date=curr_date group by plan_id,app_id,agent_pid,agent_id	
			) as a
			inner join (
				select * from s_tmp_date	
			)as b 
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	);
	
-- 	delete from s_tg_count_day where date=curr_date;	
-- 	insert into s_tg_count_day(date,plan_id,app_id,agent_pid,agent_id)
-- 	select date,plan_id,app_id,agent_pid,agent_id from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id;

	#################################################################################################

  #用户注册数
  update s_tg_count_day as a inner join (
		select reg_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from s_user where reg_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	)as b on a.date=b.reg_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.reg_num=b.num
	where a.date=curr_date;
	
	#用户登录数
	update s_tg_count_day as a inner join (
		select add_date,plan_id,app_id,agent_pid,agent_id,count(distinct(user_id)) as num from s_user_login_log where add_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	)as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.login_num=b.num
	where a.date=curr_date;
	
	
	#下载数
	update s_tg_count_day as a inner join (
		select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from s_ad_down_log where add_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	)as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.down_num=b.num
	where a.date=curr_date;
	
	
	#用户微信绑定人数
	update s_tg_count_day as a inner join (
		select wxbind_date,plan_id,app_id,agent_pid,agent_id,count(1) as num from s_user where wxbind_date=curr_date group by plan_id,app_id,agent_pid,agent_id
	)as b on a.date=b.wxbind_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.wxbind_num=b.num
	where a.date=curr_date;
	


  #每日投放支出金额
-- 	update s_tg_count_day as a 
-- 	inner join s_tg_expend as b on a.date=b.date and a.plan_id=b.plan_id
-- 	set a.tg_expend=b.tg_expend
-- 	where a.date=curr_date;



	#当天广告总收入
	update s_tg_count_day as a inner join(
	  select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id
	) as b on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
	set a.ad_income=b.money
	where a.date=curr_date;
	
	
	#当天注册的用户带来的广告收入
	set @sqlstr = concat("
			update s_tg_count_day as c inner join (
					select a.date,a.plan_id,a.app_id,a.agent_pid,a.agent_id, round(a.money/a.num*b.new_click_num,2) as money from 
					(
						select date,plan_id,app_id,agent_pid,agent_id,sum(income) as money,sum(ad_click_num) as num from s_ad_income where date=",curr_date," 
						group by plan_id,app_id,agent_pid,agent_id
					)as a 
					inner join (
						select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as new_click_num from ",@s_ad_click_log," where add_date=",curr_date," and user_reg_date=",curr_date," 
						group by plan_id,app_id,agent_pid,agent_id
					)
						as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id 
			)as d 
			on c.date=d.date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
			set c.new_ad_income = d.money
			where c.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 
	
			
		
		
   #当天显示广告次数 + 当天显示广告用户数	
	 set @sqlstr = concat("
			 update s_tg_count_day as a inner join(
					select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num,count(distinct(user_id)) as user_num from ",@s_ad_show_log," 
					where add_date=",curr_date," 
					group by plan_id,app_id,agent_pid,agent_id
				) as b 
				on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
				set a.ad_show_num=b.num, a.ad_show_user_num=b.user_num
				where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 
	
	
	
	
	#新广告显示数 + 新显示广告用户数
	set @sqlstr = concat("
			 update s_tg_count_day as a inner join(
					select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num,count(distinct(user_id)) as user_num from ",@s_ad_show_log," 
					where add_date=",curr_date," and user_reg_date=",curr_date," 
					group by plan_id,app_id,agent_pid,agent_id
				) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
				set a.new_ad_show_num=b.num, a.new_ad_show_user_num=b.user_num
				where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 
	
	
	
	
	
		
		
  #当天点击广告次数 + 当天点击广告用户数
  set @sqlstr = concat("
			 update s_tg_count_day as a inner join(
					select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num,count(distinct(user_id)) as user_num 
					from ",@s_ad_click_log," 
					where add_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id
				) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
				set a.ad_click_num=b.num, a.ad_click_user_num=b.user_num
				where a.date=",curr_date,";	
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 
		
  
	
	
	#新广告点击数 + 新点击用户数
	set @sqlstr = concat("
			 update s_tg_count_day as a inner join(
					select add_date,plan_id,app_id,agent_pid,agent_id,count(1) as num,count(distinct(user_id)) as user_num 
					from ",@s_ad_click_log," 
					where add_date=",curr_date," and user_reg_date=",curr_date," 
					group by plan_id,app_id,agent_pid,agent_id
				) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id
				set a.new_ad_click_num=b.num, a.new_ad_click_user_num=b.user_num
				where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 
	


  #提现用户数 + 用户提现总金额
	update s_tg_count_day as c inner join (
		select count(distinct(user_id)) as user_num,sum(money) as money,add_date,plan_id,app_id,agent_pid,agent_id 
		from s_cash_out
		where add_date=curr_date and status=1
		group by plan_id,app_id,agent_pid,agent_id
	)as d on c.date=d.add_date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
	set c.cash_out_user_num=d.user_num, c.cash_out=d.money
	where c.date=curr_date;
	
	
	#新提现用户数 + 新用户提现总金额
	update s_tg_count_day as c inner join (
		select count(distinct(user_id)) as user_num,sum(money) as money,add_date,plan_id,app_id,agent_pid,agent_id 
		from s_cash_out
		where user_reg_date=curr_date and add_date=curr_date and status=1
		group by plan_id,app_id,agent_pid,agent_id
	)as d on c.date=d.add_date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
	set c.new_cash_out_user_num=d.user_num, c.new_cash_out=d.money
	where c.date=curr_date;
	

  # 赚取金币的用户数 + 用户赚取的金币数
	update s_tg_count_day as c inner join (
		select count(distinct(user_id)) as user_num,sum(num) as gold_num,add_date,plan_id,app_id,agent_pid,agent_id 
		from s_gold_log
		where add_date=curr_date and type=1
		group by plan_id,app_id,agent_pid,agent_id
	)as d on c.date=d.add_date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
	set c.earn_coin_user_num=d.user_num, c.earn_coin=d.gold_num
	where c.date=curr_date;


	#赚取金币的新用户数 + 新用户赚取的金币数
  update s_tg_count_day as c inner join (
		select count(distinct(user_id)) as user_num,sum(num) as gold_num,add_date,plan_id,app_id,agent_pid,agent_id 
		from s_gold_log
		where user_reg_date=curr_date and add_date=curr_date and type=1
		group by plan_id,app_id,agent_pid,agent_id
	)as d on c.date=d.add_date and c.plan_id=d.plan_id and c.app_id=d.app_id and c.agent_pid=d.agent_pid and c.agent_id=d.agent_id
	set c.new_earn_coin_user_num=d.user_num, c.new_earn_coin=d.gold_num
	where c.date=curr_date;

























END