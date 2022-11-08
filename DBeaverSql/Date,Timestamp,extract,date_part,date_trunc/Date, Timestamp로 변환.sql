/******************************************************
to_date, to_timestamp 로 문자열을 Date, Timestamp로 변환.
to_char로 Date, Timestamp를 문자열로 변환. 
*******************************************************/

-- 문자열을 formating에 따라 Date, Timestamp로 변환. 
select to_date('2022-01-01', 'yyyy-mm-dd');

select to_timestamp('2022-01-01', 'yyyy-mm-dd');

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss')

-- Date를 Timestamp로 변환
select to_date('2022-01-01', 'yyyy-mm-dd')::timestamp;

-- Timestamp를 Text로 변환
select to_timestamp('2022-01-01', 'yyyy-mm-dd')::text;

-- Timestamp를 Date로 변환. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss')::date


-- to_date, to_timestamp, to_char 실습-1
with
temp_01 as (
select a.*
	  , to_char(hiredate, 'yyyy-mm-dd') as hiredate_str
from hr.emp a
)
select empno, ename, hiredate, hiredate_str
	, to_date(hiredate_str, 'yyyy-mm-dd') as hiredate_01
	, to_timestamp(hiredate_str, 'yyyy-mm-dd') as hiretime_01
	--, to_timestamp(hiredate_str, 'yyyy-mm-dd hh24:mi:ss') as hiretime_02
	, to_char(hiredate, 'yyyymmdd hh24:mi:ss') as hiredate_str_01
	, to_char(hiredate, 'month dd yyyy') as hiredate_str_02
	, to_char(hiredate, 'MONTH dd yyyy') as hiredate_str_03
	, to_char(hiredate, 'yyyy month') as hiredate_str_04
	-- w 는 해당 달의 week, d는 일요일(1) 부터 토요일(7)
	, to_char(hiredate, 'MONTH w d') as hiredate_str_05
	-- day는 요일을 문자열로 나타냄. 
	, to_char(hiredate, 'Month, Day') as hiredate_str_06
from temp_01;

-- to_date, to_timestamp, to_char 실습-2 
with
temp_01 as (
select a.*
	  , to_char(hiredate, 'yyyy-mm-dd') as hire_date_str
	  , hiredate::timestamp as hiretime
from hr.emp a
)
select empno, ename, hiredate, hire_date_str, hiretime
	, to_char(hiretime, 'yyyy/mm/dd hh24:mi:ss') as hiretime_01
	, to_char(hiretime, 'yyyy/mm/dd PM hh12:mi:ss') as hiretime_02
	, to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss') as timestamp_01
	, to_char(to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss'), 'yyyy/mm/dd AM hh12:mi:ss') as timestr_01
from temp_01;  
