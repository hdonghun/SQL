/************************************
일별 세션건수, 일별 방문 사용자(유저), 사용자별 평균 세션 수
*************************************/
select * from ga_sess;
	select to_char(date_trunc('day', visit_stime), 'yyyy-mm-dd') as d_day
		-- ga_sess 테이블에는 sess_id로 unique하므로 count(sess_id)와 동일
		, count(distinct sess_id) as daily_sess_cnt
		, count(sess_id) as daily_sess_cnt_again
		, count(distinct user_id) as daily_user_cnt 
	from ga.ga_sess group by to_char(date_trunc('day', visit_stime), 'yyyy-mm-dd');

with temp_01 as 
(
	select to_char(date_trunc('day', visit_stime), 'yyyy-mm-dd') as d_day
		-- ga_sess 테이블에는 sess_id로 unique하므로 count(sess_id)와 동일
		, count(distinct sess_id) as daily_sess_cnt
		, count(sess_id) as daily_sess_cnt_again
		, count(distinct user_id) as daily_user_cnt 
	from ga.ga_sess group by to_char(date_trunc('day', visit_stime), 'yyyy-mm-dd')
)
select * 
	, 1.0*daily_sess_cnt/daily_user_cnt as avg_user_sessions
	-- 아래와 같이 정수와 정수를 나눌 때 postgresql은 정수로 형변환 함. 1.0을 곱해주거나 명시적으로 float type선언 
	--, daily_sess_cnt/daily_user_cnt
from temp_01;
