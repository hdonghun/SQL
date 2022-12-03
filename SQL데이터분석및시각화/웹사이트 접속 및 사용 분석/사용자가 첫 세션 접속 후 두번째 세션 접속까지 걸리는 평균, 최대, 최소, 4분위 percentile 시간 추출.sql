--사용자가 첫 세션 접속 후 두번쨰 세션 접속까지 걸리는 평균, 최대, 최소, 4분위 percentile 시간 구하기
-- 사용자가 첫 번속 후에 얼마나 빨리 두번쨰 접석을 수행하는 지의 경향을 파악할 수 있도록 첫 접속 후 두번째 접속까지 걸리는 시간의 평균, 최대, 최소, 그리고 4분위 percentile 시간을 구함.

/************************************
사용자가 첫 세션 접속 후 두번째 세션 접속까지 걸리는 평균, 최대, 최소, 4분위 percentile 시간 추출 
step 1: 사용자 별로 접속 시간에 따라 session 별 순서 매김. 
step 2: session 별 순서가 첫번째와 두번째 인것 추출
step 3: 사용자 별로 첫번째 세션의 접속 이후 두번째 세션의 접속 시간 차이를 가져 오기
step 4: step 3의 데이터를 전체 평균, 최대, 최소, 4분위 percentile 시간 구하기 
*************************************/

-- 사용자 별로 접속 시간에 따라 session 별 순서 매김.
select user_id
	, row_number() over (partition by user_id order by visit_stime) as session_rnum
	, count(*) over(partition by user_id) as session_cnt -- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, visit_stime 
from ga.ga_sess
order by user_id, session_rnum;





-- 첫번째와 두번쨰 세션의 접속 시간 차이를 구하기!!
--session 별 순서가 첫번째와 두번째 인것 추출하고 사용자 별로 첫번째 세션의 접속 이후 두번째 세션의 접속 시간 차이를 가져 오기
with temp_01 as(
select user_id
	, row_number() over (partition by user_id order by visit_stime) as session_rnum
	, count(*) over(partition by user_id) as session_cnt -- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, visit_stime 
from ga.ga_sess
)
select user_id 
	, row_number() over (partition by user_id order by visit_stime) as session_rnum
	, count(*) over(partition by user_id) as session_cnt -- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, visit_stime  
from temp_01 where session_rnum <= 2 and session_cnt >1; --Where절에 윈도우 함수를 사용할 수 없어서, with temp_01로 만들어줘서 사용한다.
-- session_rnum의 첫번째와 두번째를 구할 수 있으니깐, 여기서 visit_stime을 서로 뺴면 차이를 알 수 있다.
-- 아래와 같이

with
temp_01 as (
	select user_id, row_number() over (partition by user_id order by visit_stime) as session_rnum 
	, visit_stime
	-- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, count(*) over (partition by user_id) as session_cnt
from ga_sess
)
select user_id
	-- 사용자별로 첫번째 세션, 두번째 세션만 있으므로 max(visit_stime)이 두번째 세션 접속 시간, min(visit_stime)이 첫번째 세션 접속 시간.
	, max(visit_stime) - min(visit_stime) as sess_time_diff
from temp_01 where session_rnum <= 2 and session_cnt > 1 -- 첫번째 두번째 세션만 가져오되 첫번째 접속만 있는 사용자를 제외하기 
group by user_id;





-- step 3의 데이터를 전체 평균, 최대값, 최소값, 4분위 percentile  구하기. 
with
temp_01 as (
	select user_id, row_number() over (partition by user_id order by visit_stime) as session_rnum 
		, visit_stime
		-- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
		, count(*) over (partition by user_id) as session_cnt
	from ga_sess
), 
temp_02 as (
	select user_id
		-- 사용자별로 첫번째 세션, 두번째 세션만 있으므로 max(visit_stime)이 두번째 세션 접속 시간, min(visit_stime)이 첫번째 세션 접속 시간.	
		, max(visit_stime) - min(visit_stime) as sess_time_diff
	from temp_01 where session_rnum <= 2 and session_cnt > 1
	group by user_id
)
-- postgresql avg(time)은 interval이 제대로 고려되지 않음. justify_inteval()을 적용해야 함. 
select justify_interval(avg(sess_time_diff)) as avg_time
    , max(sess_time_diff) as max_time
    , min(sess_time_diff) as min_time 
	, percentile_disc(0.25) within group (order by sess_time_diff) as percentile_1
	, percentile_disc(0.5) within group (order by sess_time_diff)	as percentile_2
	, percentile_disc(0.75) within group (order by sess_time_diff)	as percentile_3
	, percentile_disc(1.0) within group (order by sess_time_diff)	as percentile_4
from temp_02
where sess_time_diff::interval > interval '0 second';


