/************************************
MAU를 신규 사용자, 기존 사용자(재 방문) 건수로 분리하여 추출(세션 건수도 함께 추출)
*************************************/

select a.sess_id , a.user_id , max(a.visit_stime) , b.create_time
from ga.ga_sess a
	join ga.ga_users b on a.user_id = b.user_id
group by a.sess_id , a.user_id, b.create_time
	;

with
temp_01 as (
select a.sess_id, a.user_id, a.visit_stime, b.create_time
	, case when b.create_time >= (:current_date - interval '30 days') and b.create_time < :current_date then 1
	     else 0 end as is_new_user
from ga.ga_sess a
	join ga.ga_users b on a.user_id = b.user_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
)
select is_new_user, count(*) from temp_01 group by is_new_user


with
temp_01 as (
select a.sess_id, a.user_id, a.visit_stime, b.create_time
	, case when b.create_time >= (:current_date - interval '30 days') and b.create_time < :current_date then 1
	     else 0 end as is_new_user
from ga.ga_sess a
	join ga.ga_users b on a.user_id = b.user_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
)
select count(distinct user_id) as user_cnt
	, count(distinct case when is_new_user = 1 then user_id end) as new_user_cnt
	, count(distinct case when is_new_user = 0 then user_id end) as repeat_user_cnt
	, count(*) as sess_cnt
from temp_01;	
