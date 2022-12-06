
/************************************
ga_sess_hits 테이블에서 개별 session 별로 진입 페이지(landing page)와 종료 페이지(exit page), 그리고 해당 page의 종료 페이지 여부 컬럼을 생성.
종료 페이지 여부는 반드시 hit_type이 PAGE일 때만 True임. 
*************************************/

select * from ga_sess_hits;
-- landing_screen_name : 진입페이지
-- exit_screen_name : 종료페이지


with temp_01 
as(
select sess_id, hit_seq, hit_type, page_path
	--, landing_screen_name 찾기
	-- 동일 sess_id 내에서 hit_seq가 가장 처음에 위치한 page_path가 landing page
	, first_value(page_path) over (partition by sess_id order by hit_seq 
									rows between unbounded preceding and current row) as landing_page
	-- 동일 sess_id 내에서 hit_seq가 가장 마지막에 위치한 page_path가 exit page. 
	, last_value(page_path) over (partition by sess_id order by hit_seq 
									rows between unbounded preceding and unbounded following) as exit_page
	--, exit_screen_name
	--, is_exit
	, case when row_number() over (partition by sess_id, hit_type order by hit_seq desc) = 1 and hit_type='PAGE' then 'True' else '' end as is_exit_new
	--, case when row_number() over (partition by sess_id, hit_type order by hit_seq desc) = 1 then 'True' else '' end as is_exit_new
from ga_sess_hits
)
select * 
from temp_01 
--where is_exit_new != is_exit
--where is_exit = 'True' and hit_type = 'EVENT'
--where 'googlemerchandisestore.com'||exit_page != regexp_replace(exit_screen_name, 'shop.|www.', '')

-- 소스 문자열을 조건에 따라 변경. 
select regexp_replace(
		'shop.googlemerchandisestore.com/google+redesign/shop+by+brand/google',
		'shop.|www.',
		'');
