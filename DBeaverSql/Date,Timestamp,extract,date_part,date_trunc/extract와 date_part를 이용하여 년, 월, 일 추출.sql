/********************************************************************
extract와 date_part를 이용하여 Date/Timestamp에서 년,월,일/시간,분,초 추출
*********************************************************************/

-- extract와 date_part를 이용하여 년, 월, 일 추출
select a.* 
	, extract(year from hiredate) as year
	, extract(month from hiredate) as month
	, extract(day from hiredate) as day
from hr.emp a;

select a.hiredate 
	, date_part('year', hiredate) as year
	, date_part('month', hiredate) as month
	, date_part('day', hiredate) as day
	, date_part('hour', hiredate) as hour
from hr.emp a;


select '2022-11-08 16:15:15'::timestamp; 

-- extract와 date_part를 이용하여 시간, 분, 초 추출. 
select date_part('hour', '2022-11-08 16:04:10'::timestamp) as hour
	, date_part('minute', '2022-11-08 16:04:10'::timestamp) as minute
	, date_part('second', '2022-11-08 16:04:10'::timestamp) as second
;

select extract(hour from '2022-02-03 13:04:10'::timestamp) as hour
	, extract(minute from '2022-02-03 13:04:10'::timestamp) as minute
	, extract(second from '2022-02-03 13:04:10'::timestamp) as second