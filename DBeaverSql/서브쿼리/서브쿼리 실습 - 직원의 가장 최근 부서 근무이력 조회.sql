/************************************************
     서브쿼리 실습 - 직원의 가장 최근 부서 근무이력 조회
 *************************************************/

drop table if exists hr.emp_dept_hist_01;

-- todate가 99991231가 아닌 경우를 한개 레코드로 생성하기 위해 임시 테이블 생성
create table hr.emp_dept_hist_01
as
select * from hr.emp_dept_hist;


update hr.emp_dept_hist_01
set todate=to_date('1983-12-24', 'yyyy-mm-dd') 
where empno = 7934 and todate=to_date('99991231', 'yyyymmdd');

select * from hr.emp_dept_hist_01;

-- 직원의 가장 최근 부서 근무이력 조회. 비상관 서브쿼리
select * from hr.emp_dept_hist_01 a where (empno, todate) in (select empno, max(todate) from hr.emp_dept_hist_01 x
group by empno);

-- 상관 서브쿼리
select * from hr.emp_dept_hist_01 a where todate = (select max(todate) from hr.emp_dept_hist_01 x where x.empno=a.empno);

-- Analytic SQL
select *
from (
select * 
	, row_number() over (partition by empno order by todate desc) as rnum
from hr.emp_dept_hist_01
)a where rnum = 1;


/************************************************
 서브쿼리 실습 - 고객의 첫번째 주문일의 주문정보와 고객 정보를 함께 추출
 *************************************************/

-- 고객의 첫번째 주문일의 order_id, order_date, shipped_date와 함께 고객명(contact_name), 고객거주도시(city) 정보를 함께 추출
select a.order_id, a.order_date, a.shipped_date, b.contact_name, b.city 
from nw.orders a
	join nw.customers b on a.customer_id = b.customer_id
where a.order_date = (select min(order_date) from nw.orders x where x.customer_id = a.customer_id);

-- Analytic SQL
select a.order_id, a.order_date, a.shipped_date, b.contact_name, b.city,
	row_number() over (partition by a.customer_id order by a.order_date) as rnum
from nw.orders a
	join nw.customers b on a.customer_id = b.customer_id;


select order_id, order_date, shipped_date, contact_name, city
from
(
select a.order_id, a.order_date, a.shipped_date, b.contact_name, b.city,
	row_number() over (partition by a.customer_id order by a.order_date) as rnum
from nw.orders a
	join nw.customers b on a.customer_id = b.customer_id
)a where rnum = 1;
