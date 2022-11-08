/************************************
   Group by 실습 - 01 
*************************************/	

-- emp 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구할것. 
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
;

-- emp 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구하되 평균 급여가 2000 이상인 경우만 추출. 
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
having avg(sal) >= 2000
;

-- emp 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구하되 평균 급여가 2000 이상인 경우만 추출(with 절을 이용)
with
temp_01 as (
select deptno, max(sal) as max_sal, min(sal) as min_sal, round(avg(sal), 2) as avg_sal
from hr.emp
group by deptno
)
select * from temp_01 where avg_sal >= 2000;


-- 부서명 SALES와 RESEARCH 소속 직원별로 과거부터 현재까지 모든 급여를 취합한 평균 급여
--dept
--emp
--emp_salary_hist
select d.dname , avg(e.sal) as avg_sal , max(e.sal) , min(e.sal)
from hr.dept d 
	join hr.emp e on d.deptno = e.deptno
	join hr.emp_salary_hist esh on e.empno = esh.empno 
where d.dname in ('SALES', 'RESEARCH')
group by d.dname  ;


-- 부서명 SALES와 RESEARCH 소속 직원별로 과거부터 현재까지 모든 급여를 취합한 평균 급여(with 절로 풀기)
with 
temp_01 as 
(
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate
)
select * from temp_01

with
temp_01 as
(
select a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where a.dname in ('SALES', 'RESEARCH')
order by a.dname , b.empno, c.fromdate 
)
select empno, max(ename) as ename, avg(sal) as avg_sal
from temp_01
group by empno;


-- 부서명 SALES와 RESEARCH 부서별 평균 급여를 소속 직원들의 과거부터 현재까지 모든 급여를 취합하여 구할것. 
select a.deptno, max(a.dname) as dname, avg(c.sal) as avg_sal, count(*) as cnt 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
group by a.deptno
order by 1;

-- 부서명 SALES와 RESEARCH 부서별 평균 급여를 소속 직원들의 과거부터 현재까지 모든 급여를 취합하여 구할것(with절로 풀기)
with 
temp_01 as 
(
select a.deptno, a.dname, b.empno, b.ename, b.job, c.fromdate, c.todate, c.sal 
from hr.dept a
	join hr.emp b on a.deptno = b.deptno
	join hr.emp_salary_hist c on b.empno = c.empno
where  a.dname in('SALES', 'RESEARCH')
order by a.dname, b.empno, c.fromdate
)
select deptno, max(dname) as dname, avg(sal) as avg_sal
from temp_01 
group by deptno
order by 1; 

-----------------------------------------------------------------------------------------------------------------------------------------------


/************************************
   Group by 실습 - 02(집계함수와 count(distinct))
*************************************/
-- 추가적인 테스트 테이블 생성. 
drop table if exists hr.emp_test;

create table hr.emp_test
as
select * from hr.emp;

insert into hr.emp_test
select 8000, 'CHMIN', 'ANALYST', 7839, TO_DATE('19810101', 'YYYYMMDD'), 3000, 1000, 20
;

select * from hr.emp_test;

-- Aggregation은 Null값을 처리하지 않음. 
select deptno, count(*) as cnt
	, sum(comm), max(comm), min(comm), avg(comm)
from hr.emp_test
group by deptno;

select mgr, count(*), sum(comm)
from hr.emp
group by mgr;

-- max, min 함수는 숫자열 뿐만 아니라, 문자열,날짜/시간 타입에도 적용가능. 
select deptno, max(job), min(ename), max(hiredate), min(hiredate) --, sum(ename) --, avg(ename)
from hr.emp
group by deptno;

-- count(distinct 컬럼명)은 지정된 컬럼명으로 중복을 제거한 고유한 건수를 추출
select count(distinct job) from hr.emp_test;

select deptno, count(*) as cnt, count(distinct job) from hr.emp_test group by deptno;


/************************************
   Group by 실습 - 03(Group by절에 가공 컬럼 및 case when 적용)
*************************************/
-- emp 테이블에서 입사년도별 평균 급여 구하기.  
select to_char(hiredate, 'yyyy') as hire_year, avg(sal) as avg_sal --, count(*) as cnt
from hr.emp
group by to_char(hiredate, 'yyyy')
order by 1;


-- 1000미만, 1000-1999, 2000-2999와 같이 1000단위 범위내에 sal이 있는 레벨로 group by 하고 해당 건수를 구함. 
select floor(sal/1000)*1000, count(*) from hr.emp
group by floor(sal/1000)*1000;

select *, floor(sal/1000)*1000 as bin_range --, sal/1000, floor(sal/1000)
from hr.emp; 

-- job이 SALESMAN인 경우와 그렇지 않은 경우만 나누어서 평균/최소/최대 급여를 구하기. 
select case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end as job_gubun
	   , avg(sal) as avg_sal, max(sal) as max_sal, min(sal) as min_sal --, count(*) as cnt
from hr.emp
group by case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end ;

/************************************
   Group by 실습 - 04(Group by와 Aggregate 함수의 case when 을 이용한 pivoting)
*************************************/

select job, sum(sal) as sales_sum
from hr.emp a
group by job;


-- deptno로 group by하고 job으로 pivoting 
select sum(case when job = 'SALESMAN' then sal end) as sales_sum
	, sum(case when job = 'MANAGER' then sal end) as manager_sum
	, sum(case when job = 'ANALYST' then sal end) as analyst_sum
	, sum(case when job = 'CLERK' then sal end) as clerk_sum
	, sum(case when job = 'PRESIDENT' then sal end) as president_sum
from emp;


-- deptno + job 별로 group by 		     
select deptno, job, sum(sal) as sal_sum
from hr.emp
group by deptno, job;


-- deptno로 group by하고 job으로 pivoting 
select deptno, sum(sal) as sal_sum
	, sum(case when job = 'SALESMAN' then sal end) as sales_sum
	, sum(case when job = 'MANAGER' then sal end) as manager_sum
	, sum(case when job = 'ANALYST' then sal end) as analyst_sum
	, sum(case when job = 'CLERK' then sal end) as clerk_sum
	, sum(case when job = 'PRESIDENT' then sal end) as president_sum
from emp
group by deptno;

-- group by Pivoting시 조건에 따른 건수 계산 유형(count case when then 1 else null end)
select deptno, count(*) as cnt
	, count(case when job = 'SALESMAN' then 1 end) as sales_cnt
	, count(case when job = 'MANAGER' then 1 end) as manager_cnt
	, count(case when job = 'ANALYST' then 1 end) as analyst_cnt
	, count(case when job = 'CLERK' then 1 end) as clerk_cnt
	, count(case when job = 'PRESIDENT' then 1 end) as president_cnt
from emp
group by deptno;

-- group by Pivoting시 조건에 따른 건수 계산 시 잘못된 사례(count case when then 1 else null end)
select deptno, count(*) as cnt
	, count(case when job = 'SALESMAN' then 1 else 0 end) as sales_cnt
	, count(case when job = 'MANAGER' then 1 else 0 end) as manager_cnt
	, count(case when job = 'ANALYST' then 1 else 0 end) as analyst_cnt
	, count(case when job = 'CLERK' then 1 else 0 end) as clerk_cnt
	, count(case when job = 'PRESIDENT' then 1 else 0 end) as president_cnt
from emp
group by deptno;

-- group by Pivoting시 조건에 따른 건수 계산 시 sum()을 이용
select deptno, count(*) as cnt
	, sum(case when job = 'SALESMAN' then 1 else 0 end) as sales_cnt
	, sum(case when job = 'MANAGER' then 1 else 0 end) as manager_cnt
	, sum(case when job = 'ANALYST' then 1 else 0 end) as analyst_cnt
	, sum(case when job = 'CLERK' then 1 else 0 end) as clerk_cnt
	, sum(case when job = 'PRESIDENT' then 1 else 0 end) as president_cnt
from emp
group by deptno;

/************************************
   Group by rollup 
*************************************/

--deptno + job레벨 외에 dept내의 전체 job 레벨(결국 dept레벨), 전체 Aggregation 수행. 
select deptno, job, sum(sal)
from hr.emp
group by rollup(deptno, job)
order by 1, 2;


-- 상품 카테고리 + 상품별 매출합 구하기
select c.category_name, b.product_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
group by c.category_name, b.product_name
order by 1, 2
;

-- 상품 카테고리 + 상품별 매출합 구하되, 상품 카테고리 별 소계 매출합 및 전체 상품의 매출합을 함께 구하기 
select c.category_name, b.product_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
group by rollup(c.category_name, b.product_name)
order by 1, 2
;

-- 년+월+일별 매출합 구하기
-- 월 또는 일을 01, 02와 같은 형태로 표시하려면 to_char()함수, 1, 2와 같은 숫자값으로 표시하려면 date_part()함수 사용. 
select to_char(b.order_date, 'yyyy') as year
	, to_char(b.order_date, 'mm') as month
	, to_char(b.order_date, 'dd') as day
	, sum(a.amount) as sum_amount
from nw.order_items a
	join nw.orders b on a.order_id = b.order_id
group by to_char(b.order_date, 'yyyy'), to_char(b.order_date, 'mm'), to_char(b.order_date, 'dd')
order by 1, 2, 3;

-- 년+월+일별 매출합 구하되, 월별 소계 매출합, 년별 매출합, 전체 매출합을 함께 구하기
with 
temp_01 as (
select to_char(b.order_date, 'yyyy') as year
	, to_char(b.order_date, 'mm') as month
	, to_char(b.order_date, 'dd') as day
	, sum(a.amount) as sum_amount
from nw.order_items a
	join nw.orders b on a.order_id = b.order_id
group by rollup(to_char(b.order_date, 'yyyy'), to_char(b.order_date, 'mm'), to_char(b.order_date, 'dd'))
)
select case when year is null then '총매출' else year end as year
	, case when year is null then null
		else case when month is null then '년 총매출' else month end
	  end as month
	, case when year is null or month is null then null
		else case when day is null then '월 총매출' else day end
	  end as day
	, sum_amount
from temp_01
order by year, month, day
;


/************************************
   Group by cube
*************************************/

-- deptno, job의 가능한 결합으로 Group by 수행. 
select deptno, job, sum(sal)
from hr.emp
group by cube(deptno, job)
order by 1, 2;

-- 상품 카테고리 + 상품별 + 주문처리직원별 매출
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by c.category_name, b.product_name, e.last_name||e.first_name
order by 1, 2, 3
;

--상품 카테고리, 상품별, 주문처리직원별 가능한 결합으로 Group by 수행
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by cube(c.category_name, b.product_name, e.last_name||e.first_name)
order by 1, 2, 3
;