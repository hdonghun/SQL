/* 1. aggregation analytic 실습 */ 

select * from hr.emp ;


-- 직원 정보 및 부서별로 직원 급여의 hiredate순으로 누적 급여합. 
select empno, ename, deptno, sal, hiredate, sum(sal) over (partition by deptno order by hiredate) cum_sal 
from hr.emp; 


--직원 정보 및 부서별 '평균 급여와 개인 급여와의 차이' 출력
select empno, ename, deptno, sal, avg(sal) over (partition by deptno) dept_avg_sal
	, sal - avg(sal) over (partition by deptno) dept_avg_sal_diff
from hr.emp;

select deptno, sal  , avg(sal) over (partition by deptno) as dept_avg_sal 
	, sal - avg(sal) over (partition by deptno) as dept_sal_avgsal_diff
from hr.emp;


-- analytic을 사용하지 않고 위와 동일한 결과 출력
with
temp_01 as ( 
	select deptno, avg(sal) as avg_sal
	from hr.emp group by deptno
)
select empno, ename, a.deptno, hiredate, sal as 개인sal, avg_sal 
	,sal - avg_sal as deptno_sal_avgsal_diff
from emp a
	join temp_01 b on a.deptno = b.deptno
	order by deptno ;


-- 직원 정보및 부서별 '총 급여 대비 개인 급여의 비율' 출력(소수점 2자리까지로 비율 출력)
select empno, ename, deptno, sal, sum(sal) over (partition by deptno) as dept_sum_sal
	, round(sal/sum(sal) over (partition by deptno), 2) as dept_sum_sal_ratio 
from hr.emp;


-- 직원 정보 및 부서에서 가장 높은 급여 대비 비율 출력(소수점 2자리까지로 비율 출력)
select empno, ename, deptno, sal, max(sal) over (partition by deptno) as dept_max_sal
	, round(sal/max(sal) over (partition by deptno), 2) as dept_max_sal_ratio
from hr.emp;
