/******************************************************
date_trunc 함수를 이용하여 년/월/일/시간/분/초 단위 절삭 
*******************************************************/

select trunc(99.9999, 2);

--date_trunc는 인자로 들어온 기준으로 주어진 날짜를 절삭(?),
select date_trunc('day', '2022-03-03 14:05:32'::timestamp)

-- date타입을 date_trunc해도 반환값은 timestamp타입임. 
select date_trunc('day', to_date('2022-03-03', 'yyyy-mm-dd')) as date_01;

-- 만약 date 타입을 그대로 유지하려면 ::date로 명시적 형변환 
select date_trunc('day', '2022-03-03'::date)::date as date_01


-- 월, 년으로 절단. 
select date_trunc('month', '2022-03-03'::date)::date as date_01;

-- week의 시작 날짜 구하기. 월요일 기준.
select date_trunc('week', '2022-03-03'::date)::dateㅋ as date_01;

-- week의 마지막 날짜 구하기. 월요일 기준(일요일이 마지막 날짜)
select (date_trunc('week', '2022-03-03'::date) + interval '6 days')::date as date_01;

-- week의 시작 날짜 구하기. 일요일 기준.
select date_trunc('week', '2022-03-03'::date)::date -1 as date_01;

-- week의 마지막 날짜 구하기. 일요일 기준(토요일이 마지막 날짜)
select (date_trunc('week', '2022-03-03'::date)::date - 1 + interval '6 days')::date as date_01;

-- month의 마지막 날짜 
select (date_trunc('month', '2022-03-03'::date) + interval '1 month' - interval '1 day')::date;

-- 시분초도 절삭 가능. 
select date_trunc('hour', now());

--date_trunc는 년, 월, 일 단위로 Group by 적용 시 잘 사용됨.
drop table if exists hr.emp_test;

create table hr.emp_test
as
select a.*, hiredate + current_time
from hr.emp a;

select * from hr.emp_test;

-- 입사월로 group by
select date_trunc('month', hiredate) as hire_month, count(*)
from hr.emp_test
group by date_trunc('month', hiredate);

-- 시분초가 포함된 입사일일 경우 시분초를 절삭한 값으로 group by 
select date_trunc('day', hiredate) as hire_day, count(*)
from hr.emp_test
group by date_trunc('day', hiredate);