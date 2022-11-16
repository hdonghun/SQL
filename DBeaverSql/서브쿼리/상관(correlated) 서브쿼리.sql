/************************************************
              상관(correlated) 서브쿼리
 *************************************************/

-- 상관 서브쿼리, 주문에서 상품 금액이 100보다 큰 주문을 한 주문 정보 
select * from nw.orders a 
where exists (select order_id from nw.order_items x where a.order_id = x.order_id and x.amount > 100);

-- 비상관 서브쿼리, 상품 금액이 100보다 큰 주문을 한 주문 정보
select * from nw.orders a where order_id in (select order_id from nw.order_items where amount > 100);


-- 2건 이상 주문을 한 고객 정보
select * from nw.customers a 
where exists (select 1 from nw.orders x where x.customer_id = a.customer_id 
              group by customer_id having count(*) >=2);


-- 1997년 이후에 한건이라도 주문을 한 고객 정보
select * from nw.customers a 
where exists (select 1 from nw.orders x where x.customer_id = a.customer_id
                                        and x.order_date >= to_date('19970101', 'yyyymmdd'));

--1997년 이후에 단 한건도 주문하지 않은 고객 정보
select * from nw.customers a 
where not exists (select 1 from nw.orders x where x.customer_id = a.customer_id
                                        and x.order_date >= to_date('19970101', 'yyyymmdd'));
-- 조인으로 변환
select * 
from nw.customers a
	left join (select customer_id from nw.orders 
	      where order_date >= to_date('19970101', 'yyyymmdd') 
	      group by customer_id
	      ) b on a.customer_id = b.customer_id 
where b.customer_id is null;


-- 직원의 급여이력에서 가장 최근의 급여이력
select * from hr.emp_salary_hist a where todate = (select max(todate) from hr.emp_salary_hist x 
						   where x.empno = a.empno);

-- 아래는 메인쿼리의 개별 레코드 별로 empno 연결조건으로 단 한건이 아닌 여러건을 반환하므로 수행 오류
select * from hr.emp_salary_hist a where todate = (select todate from hr.emp_salary_hist x
						   where x.empno = a.empno);
