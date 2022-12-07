
/************************************
과거 30일간 광고 채널(channel_grouping) 별 이탈율(bounce rate) 및 광고 채널(channel_grouping) + 페이지별 이탈율(bounce rate)
광고 채널별 이탈율을 구할 경우에는 채널별 bounce 세션 건수 / 채널별 고유 세션 건수 
광고 채널 + 페이지별 이탈율을 구할 경우에는 채널+페이지별 bounce 세션 건수/ 채널+페이지별에서 현재 페이지가 세션별 첫페이지와 동일한 경우의 고유세션 
*************************************/

-- 광고 채널(channel_grouping)별 세션 건수 
select * from ga_sess;
select channel_grouping, count(*) from ga_sess group by channel_grouping;


-- 과거 30일간 광고 채널(channel_grouping) 별 이탈율(bounce rate)
select a.page_path, b.sess_id, b.channel_grouping, hit_seq, hit_type, action_type
	-- 세션별 페이지 건수를 구함.
	, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE';




with 
temp_01 as ( 
select a.page_path, b.sess_id, b.channel_grouping, hit_seq, hit_type, action_type
	-- 세션별 페이지 건수를 구함.
	, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
)
select channel_grouping, count(*) as page_cnt
	 --세션별 페이지 건수가 1일때만 bounce session이므로 채널별 bounce session 건수를 구함. 
	, sum(case when sess_cnt = 1 then 1 else 0 end) as bounce_sess_cnt
	-- 채널별로 고유 세션 건수를 구함.
	, count(distinct sess_id) as sess_cnt
	, round(100.0 * sum(case when sess_cnt = 1 then 1 else 0 end)/count(distinct sess_id), 2) as bounce_pct
from temp_01
group by channel_grouping
order by page_cnt desc; 

select
from ga.ga_sess_hits;


-- 광고 채널(channel_grouping) + 페이지별 이탈율(bounce rate)
with 
temp_01 as ( 
select a.page_path, b.sess_id, b.channel_grouping, hit_seq, hit_type, action_type
	-- 세션별 페이지 건수를 구함. 
	, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
	-- 세션별 첫페이지를 구해서 추후에 현재 페이지와 세션별 첫페이지가 같은지 비교하기 위한 용도. 
	, first_value(page_path) over (partition by b.sess_id order by hit_seq) as first_page_path
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
-- and page_path='/home'
), 
temp_02 as (
select channel_grouping, page_path, count(*) as page_cnt
	--세션별 페이지 건수가 1일때만 bounce session이므로 페이지별 bounce session 건수를 구함. 
	, sum(case when sess_cnt = 1 then 1 else 0 end) as bounce_cnt_per
	-- path_page와 세션별 첫번째 페이지가 동일한 경우에만 고유 세션 건수를 구함. 
	, count(distinct case when first_page_path = page_path then sess_id else null end) as sess_cnt_per
	from temp_01
--where page_path='/home'
group by channel_grouping, page_path
--having page_path = '/home'
)
select *
	-- 이탈율 계산. sess_cnt_01이 0 일 경우 0으로 나눌수 없으므로 Null값 처리. sess_cnt_01이 0이면 bounce session이 없으므로 이탈율은 0임. 
	, coalesce(round(100.0 * bounce_cnt_per / (case when sess_cnt_per = 0 then null else sess_cnt_per end), 2), 0) as bounce_pct
from temp_02
order by page_cnt desc, page_path, channel_grouping;

-- 신규방문자/재방문자 이탈율, Device별 이탈율도 함께 적용해 볼것. 

