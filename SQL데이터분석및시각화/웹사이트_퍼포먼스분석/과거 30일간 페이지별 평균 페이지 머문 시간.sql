
/************************************
과거 30일간 페이지별 평균 페이지 머문 시간.
세션별 마지막 페이지(탈출 페이지)는 평균 시간 계산에서 제외.  
세션 시작 시 hit_seq=1이면(즉 입구 페이지) 무조건 hit_time이 0 임. 
*************************************/

select * from ga.ga_sess_hits order by 1,2 ;


select * 
from ga_sess_hits
where hit_seq = 1 and hit_time != 0;

with 
temp_01 as (
select sess_id, page_path, hit_seq, hit_time
	, lead(hit_time) over (partition by sess_id order by hit_seq) as next_hit_time
from ga.ga_sess_hits 
where hit_type = 'PAGE'
)
select page_path, count(*) as page_cnt
	, round(avg(next_hit_time - hit_time)/1000, 2) as avg_elapsed_sec
from temp_01
group by page_path order by 2 desc;


-- 페이지별 조회 건수와 순수 조회(세션별 unique 페이지), 평균 머문 시간(초)를 한꺼번에 구하기
-- 개별적인 집합을 각각 만든 뒤 이를 조인
with
temp_01 as (
	select a.page_path, count(*) as page_cnt
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct a.sess_id, a.page_path
		from ga.ga_sess_hits a
			join ga.ga_sess b on a.sess_id = b.sess_id 
		where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
		and a.hit_type = 'PAGE'
	) a group by page_path
), 
temp_03 as (
	select a.sess_id, page_path, hit_seq, hit_time
		, lead(hit_time) over (partition by a.sess_id order by hit_seq) as next_hit_time
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
), 
temp_04 as (
select page_path, count(*) as page_cnt
	, round(avg(next_hit_time - hit_time)/1000.0, 2) as avg_elapsed_sec
from temp_03
group by page_path
)
select a.page_path, a.page_cnt, b.unique_page_cnt, c.avg_elapsed_sec
from temp_01 a
	left join temp_02 b on a.page_path = b.page_path
	left join temp_04 c on a.page_path = c.page_path
order by 2 desc;


-- 아래와 같이 공통 중간집합으로 보다 간단하게 추출할 수 있습니다. 
with
temp_01 as (
	select a.sess_id, a.page_path, hit_seq, hit_time
		, lead(hit_time) over (partition by a.sess_id order by hit_seq) as next_hit_time
		-- 세션내에서 동일한 page_path가 있을 경우 rnum은 2이상이 됨. 추후에 1값만 count를 적용. 
		, row_number() over (partition by a.sess_id, page_path order by hit_seq) as rnum
	from ga.ga_sess_hits a
		join ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
)
select page_path, count(*) as page_cnt
	, count(case when rnum = 1 then '1' else null end) as unique_page_cnt
	, round(avg(next_hit_time - hit_time)/1000.0, 2) as avg_elapsed_sec
from temp_01
group by page_path order by 2 desc;


