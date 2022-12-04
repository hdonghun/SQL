/************************************
Hit수가 가장 많은 상위 5개 페이지(이벤트 포함)와 세션당 최대, 평균, 4분위 페이지/이벤트 Hit수
*************************************/
select * from ga_sess_hits;
select sess_id, page_path , hit_type  from ga_sess_hits group by sess_id, page_path , hit_type ;

-- hit수가 가장 많은 상위 5개 페이지(이벤트 포함)
select page_path, count(*) as hits_by_page 
from ga_sess_hits
group by page_path order by 2 desc
FETCH FIRST 10 ROW only;

-- 세션당 최대, 평균, 4분위 페이지(이벤트 포함) Hit 수
select sess_id, count(*) as hits_by_sess
from ga_sess_hits
group by sess_id ;


with 
temp_01 as (
select sess_id, count(*) as hits_by_sess
from ga_sess_hits
group by sess_id 
)
select max(hits_by_sess), avg(hits_by_sess), min(hits_by_sess), count(*) as cnt
	, percentile_disc(0.25) within group(order by hits_by_sess) as percentile_25
	, percentile_disc(0.50) within group(order by hits_by_sess) as percentile_50
	, percentile_disc(0.75) within group(order by hits_by_sess) as percentile_75
	, percentile_disc(0.80) within group(order by hits_by_sess) as percentile_80
	, percentile_disc(1.0) within group(order by hits_by_sess) as percentile_100
from temp_01;
