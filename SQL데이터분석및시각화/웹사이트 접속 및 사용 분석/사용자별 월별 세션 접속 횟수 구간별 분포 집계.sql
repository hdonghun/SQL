/************************************
사용자별 월별 세션 접속 횟수 구간별 분포 집계
step 1: 사용자별 월별 접속 횟수, (월말 3일 이전 생성된 사용자 제외) 
step 2: 사용자별 월별 접속 횟수 구간별 분포 . 월별 + 접속 횟수 구간별로 Group by
step 3: gubun 별로 pivot 하여 추출
*************************************/
 
-- user 생성일자가 해당 월의 마지막 일에서 3일전인 user 추출. 
-- 월의 마지막 일자 구하기. 
-- postgresql은 last_day()함수가 없음. 때문에 해당 일자가 속한 달의 첫번째 날짜 가령 10월 5일이면 10월 1일에 1달을 더하고 거기에 1일을 뺌
-- 즉 10월 5일 -> 10월 1일 -> 11월 1일 -> 10월 31일 순으로 계산함.
select user_id, create_time, (date_trunc('month', create_time))::date as date1 from ga.ga_users gu ;
-- 위와 같이 생성하면, 매월의 첫번 쨰 일로 표기되어 , 아래와 같은 로직으로 3일전인 user_id를 추출한다.
select user_id, create_time, (date_trunc('month', create_time) + interval '1 month' - interval '1 day')::date
from ga.ga_users
where create_time <= (date_trunc('month', create_time) + interval '1 month' - interval '1 day')::date - 2;

-- 사용자별 월별 세션접속 횟수, 월말 3일 이전 생성된 사용자 제외 
select a.user_id, date_trunc('month', visit_stime)::date as month
	-- 사용자별 접속 건수. 고유 접속 건수가 아니므로 count(distinct user_id)를 적용하지 않음. 
	, count(*) as monthly_user_cnt  
from ga_sess a 
	join ga_users b on a.user_id = b.user_id 
where b.create_time <= (date_trunc('month', b.create_time) + interval '1 month' - interval '1 day')::date - 2 --월말 3일 이전 생성자 추출하는 조건;
group by a.user_id, date_trunc('month', visit_stime)::date;




-- 사용자별 월별 세션 접속 횟수 구간별 집계, 월말 3일 이전 생성된 사용자 제외 
with temp_01 as (
	select a.user_id, date_trunc('month', visit_stime)::date as month, count(*) as monthly_user_cnt  
	from ga.ga_sess a 
		join ga_users b on a.user_id = b.user_id 
	where b.create_time <= (date_trunc('month', b.create_time) + interval '1 month' - interval '1 day')::date - 2
	group by a.user_id, date_trunc('month', visit_stime)::date 
)
select month
	,case when monthly_user_cnt = 1 then '0_only_first_session'
		  when monthly_user_cnt between 2 and 3 then '2_between_3'
		  when monthly_user_cnt between 4 and 8 then '4_between_8'
		  when monthly_user_cnt between 9 and 14 then '9_between_14'
		  when monthly_user_cnt between 15 and 25 then '15_between_25'
		  when monthly_user_cnt >= 26 then 'over_26' end as gubun
	, count(*) as user_cnt 
from temp_01 
group by month, 
		 case when monthly_user_cnt = 1 then '0_only_first_session'
		  when monthly_user_cnt between 2 and 3 then '2_between_3'
		  when monthly_user_cnt between 4 and 8 then '4_between_8'
		  when monthly_user_cnt between 9 and 14 then '9_between_14'
		  when monthly_user_cnt between 15 and 25 then '15_between_25'
		  when monthly_user_cnt >= 26 then 'over_26' end
order by month, gubun;



-- gubun 별로 pivot 하여 추출 
with temp_01 as (
	select a.user_id, date_trunc('month', visit_stime)::date as month, count(*) as monthly_user_cnt  
	from ga.ga_sess a 
		join ga.ga_users b 
		on a.user_id = b.user_id 
	where b.create_time <= (date_trunc('month', b.create_time) + interval '1 month' - interval '1 day')::date - 2
	group by a.user_id, date_trunc('month', visit_stime)::date 
), 
temp_02 as ( 
	select month
		,case when monthly_user_cnt = 1 then '0_only_first_session'
		      when monthly_user_cnt between 2 and 3 then '2_between_3'
		      when monthly_user_cnt between 4 and 8 then '4_between_8'
		      when monthly_user_cnt between 9 and 14 then '9_between_14'
		      when monthly_user_cnt between 15 and 25 then '15_between_25'
		      when monthly_user_cnt >= 26 then 'over_26' end as gubun
		, count(*) as user_cnt 
	from temp_01 
	group by month, 
			 case when monthly_user_cnt = 1 then '0_only_first_session'
			      when monthly_user_cnt between 2 and 3 then '2_between_3'
			      when monthly_user_cnt between 4 and 8 then '4_between_8'
			      when monthly_user_cnt between 9 and 14 then '9_between_14'
			      when monthly_user_cnt between 15 and 25 then '15_between_25'
			      when monthly_user_cnt >= 26 then 'over_26' end
)
select month, 
	sum(case when gubun='0_only_first_session' then user_cnt else 0 end) as "0_only_first_session"
	,sum(case when gubun='2_between_3' then user_cnt else 0 end) as "2_between_3"
	,sum(case when gubun='4_between_8' then user_cnt else 0 end) as "4_between_8"
	,sum(case when gubun='9_between_14' then user_cnt else 0 end) as "9_between_14"
	,sum(case when gubun='15_between_25' then user_cnt else 0 end) as "15_between_25"
	,sum(case when gubun='over_26' then user_cnt else 0 end) as "over_26"
from temp_02 
group by month order by 1;

