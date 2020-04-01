CREATE PROCEDURE `ad_income`(
		IN `mydate` int 
) 
label:BEGIN
	###########################  	应用渠道数据统计	######################################
	DECLARE curr_date int DEFAULT 0;

	SET curr_date = mydate;
	
	#每天执行一次，获取昨天的日期  =====对应事件call_agent_app_count_day
	if curr_date = 0 then
	    SET curr_date = from_unixtime(unix_timestamp(now())-24*3600, "%Y%m%d");
	#每10分钟执行一次，获取当前日期 =====对应事件call_agent_app_count_day_10mins
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

  #################################################################################################
	
		#创建临时表
	CREATE TABLE IF NOT EXISTS s_tmp_income (
		id INT(11) NOT NULL AUTO_INCREMENT,
		date INT(11) NOT NULL DEFAULT 0 COMMENT '日期',
		plan_id INT(11) NOT NULL DEFAULT 0 COMMENT '投放计划ID',
		app_id INT(11) NOT NULL DEFAULT 0 COMMENT '应用编号',
		agent_pid INT(11) NOT NULL DEFAULT 0 COMMENT '一级渠道ID',
		agent_id INT(11) NOT NULL DEFAULT 0 COMMENT '二级渠道ID',
		ad_id INT(11) NOT NULL DEFAULT 0 COMMENT '广告位ID',
		PRIMARY KEY (`id`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='临时数据表(与s_ad_income表关联)';
		
	
	#清空临时表数据
	truncate TABLE s_tmp_income; 
	
	
	#向临时表中插入数据(show_log)
	set @sqlstr = concat("
			insert into s_tmp_income(id,date,plan_id,app_id,agent_pid,agent_id,ad_id)
			select (@i:=@i+1)pm,a.* from (
						select add_date,plan_id,app_id,agent_pid,agent_id,ad_id from ",@s_ad_show_log," where add_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as a,(select @i:=0)t;
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 


-- 	#插入缺失数据(show_log)
	insert into s_ad_income (date,plan_id,app_id,agent_pid,agent_id,ad_id)
	select date,plan_id,app_id,agent_pid,agent_id,ad_id from s_tmp_income where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id,ad_id from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id,ad_id	
			) as a
			inner join (
				select * from s_tmp_income
			)as b 
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
	);
	
	
	
	#清空临时表数据
	truncate TABLE s_tmp_income; 
	
	
	#向临时表中插入数据(click_log)
	set @sqlstr = concat("
			insert into s_tmp_income(id,date,plan_id,app_id,agent_pid,agent_id,ad_id)
			select (@i:=@i+1)pm,a.* from (
						select add_date,plan_id,app_id,agent_pid,agent_id,ad_id from ",@s_ad_click_log," where add_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as a,(select @i:=0)t;
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 


-- 	#插入缺失数据(click_log)
	insert into s_ad_income (date,plan_id,app_id,agent_pid,agent_id,ad_id)
	select date,plan_id,app_id,agent_pid,agent_id,ad_id from s_tmp_income where id not in (
			select b.id from (
				select date,plan_id,app_id,agent_pid,agent_id,ad_id from s_ad_income where date=curr_date group by plan_id,app_id,agent_pid,agent_id,ad_id	
			) as a
			inner join (
				select * from s_tmp_income
			)as b 
			on a.date=b.date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
	);
	
	
	
	#################################################################################################
	# 广告展现数 + 广告展现用户数
	set @sqlstr = concat("
			update s_ad_income as a inner join
			(
				select add_date,plan_id,app_id,agent_pid,agent_id,ad_id,count(1) as num,count(distinct(user_id)) as user_num from ",@s_ad_show_log," 
				where add_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as b on a.date = b.add_date and a.plan_id = b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
			set a.ad_show_num=b.num, a.ad_show_user_num = b.user_num
			where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 


	#广告新展现数 + 广告展现新注册用户数
	set @sqlstr = concat("
			update s_ad_income as a inner join
			(
				select add_date,plan_id,app_id,agent_pid,agent_id,ad_id,count(1) as num, count(distinct(user_id)) as user_num from ",@s_ad_show_log," 
				where add_date=",curr_date," and user_reg_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as b on a.date = b.add_date and a.plan_id = b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
			set a.new_ad_show_num=b.num, a.new_ad_show_user_num = b.user_num
			where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 

	
	
  #广告点击数 + 广告点击用户数
	set @sqlstr = concat("
			update s_ad_income as a inner join
			(
				select add_date,plan_id,app_id,agent_pid,agent_id,ad_id,count(1) as num,count(distinct(user_id)) as user_num from ",@s_ad_click_log," 
				where add_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as b on a.date=b.add_date and a.plan_id=b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
			set a.ad_click_num = b.num, a.ad_click_user_num = b.user_num
			where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt; 


 	
  #广告新点击数 + 广告点击新注册用户数	
	set @sqlstr = concat("
			update s_ad_income as a inner join
			(
				select add_date,plan_id,app_id,agent_pid,agent_id,ad_id,count(1) as num, count(distinct(user_id)) as user_num from ",@s_ad_click_log," 
				where add_date=",curr_date," and user_reg_date=",curr_date," group by plan_id,app_id,agent_pid,agent_id,ad_id
			) as b on a.date = b.add_date and a.plan_id = b.plan_id and a.app_id=b.app_id and a.agent_pid=b.agent_pid and a.agent_id=b.agent_id and a.ad_id=b.ad_id
			set a.new_ad_click_num = b.num, a.new_ad_click_user_num = b.user_num
			where a.date=",curr_date,";
	");
	
	PREPARE stmt from @sqlStr;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


	

























END 