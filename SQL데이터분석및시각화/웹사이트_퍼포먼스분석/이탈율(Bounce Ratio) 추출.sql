/************************************
이탈율(Bounce Ratio) 추출
최초 접속 후 다른 페이지로 이동하지 않고 바로 종료한 세션 비율
전체 페이지를 기준으로 이탈율을 구할 경우 bounce session 건수/고유 session 건수
*************************************/
select * from ga_sess_hits;


-- bounce session 추출. 
select sess_id, hit_seq ,count(*) from ga_sess_hits
group by sess_id, hit_seq having count(*) = 1;



-- bounce session 대부분은 PAGE이지만 일부는 EVENT도 존재. 
select sess_id, count(*), max(hit_type), min(hit_type) from ga_sess_hits
group by sess_id having count(*) = 1 and (max(hit_type) = 'EVENT' or min(hit_type) = 'EVENT');



-- 전체 페이지에서 이탈율(bounce ratio) 구하기
with 
temp_01 as ( 
select sess_id, count(*) as page_cnt
from ga_sess_hits
group by sess_id
)
select sum(case when page_cnt = 1 then 1 else 0 end) as bounce_sess_cnt -- bounce session 건수 , 이탈율 합계!!
	, count(*) as sess_cnt -- 고유 session 건수 
	, round(100.0*sum(case when page_cnt = 1 then 1 else 0 end)/count(*), 2) as bounce_sess_pct -- 이탈율
from temp_01;




-- 세션당 최대, 평균, 4분위 페이지(이벤트 포함) Hit 수
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


