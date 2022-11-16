/************************************************
              비상관(non-correlated) 서브쿼리
 *************************************************/

-- in 연산자는 괄호내에 한개 이상의 값을 상수값 또는 서브쿼리 결과 값으로 가질 수 있으며 개별값의 = 조건들의 or 연산을 수행
select * from hr.emp where deptno in (20, 30);

select * from hr.emp where deptno = 20 or deptno=30;

-- 여러개의 중복된 값을 괄호 내에 가질 경우 중복을 제거하고 unique한 값을 가짐. 
select * from hr.dept where deptno in (select deptno from hr.emp where sal < 1300);

-- 단일 컬럼 뿐 아니라 여러컬럼을 가질 수 있음. 
select * from hr.dept where (deptno, loc) in (select deptno, 'DALLAS' from hr.emp where sal < 1300);

-- 고객이 가장 최근에 주문한 주문 정보 추출
select * from nw.orders where (customer_id, order_date) in (select customer_id, max(order_date) 
from nw.orders group by customer_id);

-- 메인쿼리-서브쿼리의 연결 연산자가 단순 비교 연산자일 경우 서브쿼리는 단 한개의 값을 반환해야 함. 
select * from hr.emp where sal <= (select avg(sal) from hr.emp);

-- 메인쿼리-서브쿼리의 연결 연산자가 = 인데 서브쿼리의 반환값이 여러개이므로 수행 안됨
select * from hr.dept where deptno = (select deptno from hr.emp where sal < 1300);

-- 단순 비교 연산자로 서브쿼리를 연결하여도 여러 컬럼 조건을 가질 수 있음.
select * from nw.orders where (customer_id, order_date) = (select customer_id, max(order_date)
from nw.orders where customer_id='VINET' group by customer_id);
