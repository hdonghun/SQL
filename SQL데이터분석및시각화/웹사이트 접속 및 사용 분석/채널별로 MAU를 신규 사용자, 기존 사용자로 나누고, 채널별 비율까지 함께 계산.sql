/************************************
채널별로 MAU를 신규 사용자, 기존 사용자로 나누고, 채널별 비율까지 함께 계산. 
*************************************/
select channel_grouping, count(distinct user_id) 
from ga.ga_sess 
group by channel_grouping;



with
temp_01 as (
select a.sess_id, a.user_id, a.visit_stime, b.create_time, channel_grouping
	, case when b.create_time >= (:current_date - interval '30 days') and b.create_time < :current_date then 1
	     else 0 end as is_new_user
from ga.ga_sess a
	join ga.ga_users b on a.user_id = b.user_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
),
temp_02 as (
select channel_grouping
	, count(distinct case when is_new_user = 1 then user_id end) as new_user_cnt
	, count(distinct case when is_new_user = 0 then user_id end) as repeat_user_cnt
	, count(distinct user_id) as channel_user_cnt
	, count(*) as sess_cnt
from temp_01
group by rollup(channel_grouping)
)
select * from TEMP_02;







with
temp_01 as (
select a.sess_id, a.user_id, a.visit_stime, b.create_time, channel_grouping
	, case when b.create_time >= (:current_date - interval '30 days') and b.create_time < :current_date then 1
	     else 0 end as is_new_user
from ga.ga_sess a
	join ga.ga_users b on a.user_id = b.user_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
),
temp_02 as (
select channel_grouping
	, count(distinct case when is_new_user = 1 then user_id end) as new_user_cnt
	, count(distinct case when is_new_user = 0 then user_id end) as repeat_user_cnt
	, count(distinct user_id) as channel_user_cnt
	, count(*) as sess_cnt
from temp_01
group by channel_grouping
)
select channel_grouping, new_user_cnt, repeat_user_cnt, channel_user_cnt, sess_cnt
	, 100.0*new_user_cnt/sum(new_user_cnt) over () as new_user_cnt_by_channel
	, 100.0*repeat_user_cnt/sum(repeat_user_cnt) over () as repeat_user_cnt_by_channel
from temp_02;

