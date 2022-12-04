
/************************************
 과거 한달간 페이지별 조회수와 순 페이지(세션 고유 페이지) 조회수
*************************************/
-- 페이지별 조회수와 순페이지 조회수
select distinct sess_id ,page_path, count(*) as page_cnt
	from ga.ga_sess_hits 
	where hit_type = 'PAGE'
	group by sess_id , page_path
order by 3 desc;



with
temp_01 as (
	select page_path, count(*) as page_cnt
	from ga.ga_sess_hits 
	where hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct sess_id, page_path
		from ga.ga_sess_hits 
		where hit_type = 'PAGE'
	) a group by page_path
)
select a.page_path, page_cnt, unique_page_cnt
from temp_01 a
	join temp_02 b on a.page_path = b.page_path
order by 2 desc;

/*
 * 아래와 같이 temp_02 를 구성해도 됨. 단 대용량 데이터의 경우 시간이 좀 더 걸릴 수 있음. 
 * temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select sess_id, page_path
			, row_number() over (partition by sess_id, page_path order by page_path) as rnum
		from ga.ga_sess_hits 
		where hit_type = 'PAGE'
	) a 
	where rnum = 1 
    group by page_path
)
 */

-- 아래는 과거 한달간 페이지별 조회수와 순 페이지(세션 고유 페이지) 조회수
with
temp_01 as (
	select a.page_path, count(*) as page_cnt
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	where hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct a.sess_id, a.page_path
		from ga.ga_sess_hits a
			join ga.ga_sess b on a.sess_id = b.sess_id 
		where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
		where hit_type = 'PAGE'
	) a group by page_path
)
select a.page_path, page_cnt, unique_page_cnt
from temp_01 a
	join temp_02 b on a.page_path = b.page_path
order by 2 desc;


