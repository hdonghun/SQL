/************************************
   조인 실습 - Outer 조인. 
*************************************/	

-- 주문이 단 한번도 없는 고객 정보 구하기. 
--customers
--orders
select *from customers c ;
select *from orders o ;
select c.*, o.*
from nw.customers c 
	left outer join nw.orders o on c.customer_id = o.customer_id
where o.order_id  is null ;




-- 부서정보와 부서에 소속된 직원명 정보 구하기. 
-- 부서가 직원을 가지고 있지 않더라도 부서정보는 표시되어야 함. 

select * from hr.dept d;
select * from hr.emp e ; 
select d.*, e.empno ,e.ename 
from hr.dept d 
	left join hr.emp e on e.deptno = d.deptno ;





-- Madrid에 살고 있는 고객이 주문한 주문 정보를 구할것.
-- 고객명, 주문id, 주문일자, 주문접수 직원명, 배송업체명을 구하되, 
-- 만일 고객이 주문을 한번도 하지 않은 경우라도 고객정보는 빠지면 안됨. 이경우 주문 정보가 없으면 주문id를 0으로 나머지는 Null로 구할것. 
--orders
--employee
--customers
--shippers

select  c.city , c.contact_name, coalesce(o.order_id,0) as order_id , o.order_date , e.first_name || e.last_name as employee_name, s.company_name as shipper_name   
from nw.customers c 
	left join nw.orders o on o.customer_id = c.customer_id 
	left join nw.employees e on o.employee_id = e.employee_id 
	left join nw.shippers s on o.ship_via = s.shipper_id 
where c.city = 'Madrid';
	





-- 만일 아래와 같이 중간에 연결되는 집합을 명확히 left outer join 표시하지 않으면 원하는 집합을 가져 올 수 없음.  
select a.customer_id, a.contact_name, coalesce(b.order_id, 0) as order_id, b.order_date
	, c.first_name||' '||c.last_name as employee_name, d.company_name as shipper_name  
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	join nw.employees c on b.employee_id = c.employee_id
	join nw.shippers d on b.ship_via = d.shipper_id
where a.city = 'Madrid';






-- orders_items에 주문번호(order_id)가 없는 order_id를 가진 orders 데이터 찾기 
--orders_items
--orders
select *
from nw.orders a
	left join nw.order_items b on a.order_id = b.order_id
where b.order_id is null;





-- orders 테이블에 없는 order_id가 있는 order_items 데이터 찾기. 
select * 
from nw.order_items a 
	left join nw.orders b on a.order_id = b.order_id
where b.order_id is null;





