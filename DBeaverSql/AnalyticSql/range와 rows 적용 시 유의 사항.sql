/************************************************
range와 rows 적용 시 유의 사항
 *************************************************/
-- range와 rows의 차이: order by 시 동일 row 처리 차이 - 1
select empno, deptno, sal
	, avg(sal) over (partition by deptno order by sal) as avg_default
	, avg(sal) over (partition by deptno order by sal range between unbounded preceding and current row) as avg_range
	, avg(sal) over (partition by deptno order by sal rows between unbounded preceding and current row) as avg_rows
	, sum(sal) over (partition by deptno order by sal) as sum_default
	, sum(sal) over (partition by deptno order by sal rows between unbounded preceding and current row) as sum_rows
from hr.emp;

-- range와 rows의 차이: order by 시 동일 row 처리 차이 - 2
select empno, deptno, sal, date_trunc('month', hiredate)::date as hiremonth
	, avg(sal) over (partition by deptno order by date_trunc('month', hiredate)) as avg_default
	, avg(sal) over (partition by deptno order by date_trunc('month', hiredate) range between unbounded preceding and current row) as avg_range
	, avg(sal) over (partition by deptno order by date_trunc('month', hiredate) rows between unbounded preceding and current row) as avg_rows
	, sum(sal) over (partition by deptno order by date_trunc('month', hiredate)) as sum_default
	, sum(sal) over (partition by deptno order by date_trunc('month', hiredate) rows between unbounded preceding and current row) as sum_rows
from hr.emp;
