/************************************************
               스칼라 서브쿼리 이해 
 *************************************************/

-- 직원의 부서명을 스칼라 서브쿼리로 추출
select a.*,
	(select dname from hr.dept x where x.deptno=a.deptno) as dname
from hr.emp a;

-- 아래는 수행 오류 발생. 스칼라 서브쿼리는 단 한개의 결과 값만 반환해야 함. 
select a.*
	, (select ename from hr.emp x where x.deptno=a.deptno) as ename
from hr.dept a;

-- 아래는 수행 오류 발생. 스칼라 서브쿼리는 단 한개의 열값만 반환해야 함. 
select a.*,
	(select dname, deptno from hr.dept x where x.deptno=a.deptno) as dname
from hr.emp a;


-- case when 절에서 스칼라 서브쿼리 사용
select a.*,
	(case when a.deptno = 10 then (select dname from hr.dept x where x.deptno=20)
		  else (select dname from hr.dept x where x.deptno=a.deptno)
		  end
	) as dname
from hr.emp a;

-- 스칼라 서브쿼리는 일반 select와 동일하게 사용. group by 적용 무방. 
select a.*,
	(select avg(sal) from hr.emp x where x.deptno = a.deptno) dept_avg_sal
from hr.emp a;

-- 조인으로 변경. 
select a.*, b.avg_sal 
from hr.emp a
	join (select deptno, avg(sal) as avg_sal from hr.emp x group by deptno) b 
	on a.deptno = b.deptno;

/************************************************
               스칼라 서브쿼리 실습 
 *************************************************/

-- 직원 정보와 해당 직원을 관리하는 매니저의 이름 추출
select a.*,
	(select ename from hr.emp x where x.empno=a.mgr) as mgr_name
from hr.emp a;

select a.*, b.ename as mgr_name
from hr.emp a
	left join hr.emp b on a.mgr=b.empno;

-- 주문정보와 ship_country가 France이면 주문 고객명을, 아니면 직원명을 new_name으로 출력 
select a.order_id, a.customer_id, a.employee_id, a.order_date, a.ship_country
	, (select contact_name from nw.customers x where x.customer_id = a.customer_id) as customer_name
	, (select first_name||' '||last_name from nw.employees x where x.employee_id = a.employee_id) as employee_name
	, case when a.ship_country = 'France' then 
	            (select contact_name from nw.customers x where x.customer_id = a.customer_id)
	       else (select first_name||' '||last_name from nw.employees x where x.employee_id = a.employee_id)
	  end as new_name
from nw.orders a;

-- 조인으로 변경. 
select a.order_id, a.customer_id, a.employee_id, a.order_date, a.ship_country
	, b.contact_name, c.first_name||' '||c.last_name
	, case when a.ship_country = 'France' then b.contact_name
		   else c.first_name||' '||c.last_name end as new_name
from nw.orders a
	left join nw.customers b on a.customer_id = b.customer_id
	left join nw.employees c on a.employee_id = c.employee_id
;

-- 고객정보와 고객이 처음 주문한 일자의 주문 일자 추출.
select a.customer_id, a.contact_name
	, (select min(order_date) from nw.orders x where x.customer_id = a.customer_id) as first_order_date
from nw.customers a;

-- 조인으로 변경 
select a.customer_id, a.contact_name, b.last_order_date
from nw.customers a
	left join (select customer_id, min(order_date) as first_order_date from nw.orders x group by customer_id) b
	on a.customer_id = b.customer_id;

-- 고객정보와 고객이 처음 주문한 일자의 주문 일자와 그때의 배송 주소, 배송 일자 추출
select a.customer_id, a.contact_name
	, (select min(order_date) from nw.orders x where x.customer_id = a.customer_id) as first_order_date
	, (select x.ship_address from nw.orders x where x.customer_id=a.customer_id and x.order_date = 
	          (select min(order_date) from nw.orders y where y.customer_id = x.customer_id)
	  ) as first_ship_address
	, (select x.shipped_date from nw.orders x where x.customer_id=a.customer_id and x.order_date = 
	          (select min(order_date) from nw.orders y where y.customer_id = x.customer_id)
      ) as first_shipped_date
from nw.customers a
order by a.customer_id;

-- 조인으로 변경.
select a.customer_id, a.contact_name
	, b.order_date, b.ship_address, b.shipped_date
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	and b.order_date = (select min(order_date) from nw.orders x 
						  where a.customer_id = x.customer_id
						  )
order by a.customer_id;


-- 고객정보와 고객이 마지막 주문한 일자의 주문 일자와 그때의 배송 주소, 배송 일자 추출
-- 현재 데이터가 고객이 하루에 주문을 두번한 경우가 있음. max(order_date) 시 고객이 하루에 주문을 두번한 일자가 나오고 있음
-- 때문에 반드시 1개의 값만 스칼라 서브쿼리에서 반환하도록 limit 1 추가
select a.customer_id, a.contact_name
	, (select max(order_date) from nw.orders x where x.customer_id = a.customer_id) as last_order_date
	, (select x.ship_address from nw.orders x where x.customer_id=a.customer_id and x.order_date = 
	          (select max(order_date) from nw.orders y where y.customer_id = x.customer_id)
	          limit 1
	  ) as last_ship_address
	, (select x.shipped_date from nw.orders x where x.customer_id=a.customer_id and x.order_date = 
	          (select max(order_date) from nw.orders y where y.customer_id = x.customer_id)
	          limit 1) as last_shipped_date
from nw.customers a
order by a.customer_id;

-- 조인으로 변경
select a.customer_id, a.contact_name
	, b.order_date, b.ship_address, b.shipped_date
	--, row_number() over (partition by a.customer_id order by b.order_date desc) as rnum
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	and b.order_date = (select max(order_date) from nw.orders x 
						  where a.customer_id = x.customer_id
					   )
	--where a.customer_id = 'ALFKI'
	--limit 1
;

