-- 과거 30일간 일별 페이지 조회수 및 30일 평균 일별 페이지 조회수

/************************************
과거 30일간 일별 page hit 건수 및 30일 평균 일별 page hit
*************************************/
with temp_01 as (
select date_trunc('day', visit_stime)::date, count(*) as page_cnt
from ga_sess_hits a
	join ga_sess b on a.sess_id = b.sess_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date 
and hit_type = 'PAGE'
group by date_trunc('day', visit_stime)::date
),
temp_02 as (
select avg(page_cnt) as month_avg_page_cnt from temp_01
)
select a.*, b.*
from temp_01 a 
	cross join temp_02 b;



-- 다른 방법!
select date_trunc('day', b.visit_stime)::date as d_day, count(*) as page_cnt
	  -- group by가 적용된 결과 집합에 analytic avg()가 적용됨. 
	, round(avg(count(*)) over (), 2) as avg_page_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
where b.visit_stime >= (:current_date - interval '30 days') and b.visit_stime < :current_date
and a.hit_type = 'PAGE'
group by date_trunc('day', b.visit_stime)::date;
