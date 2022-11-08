/************************************
   조인 실습 - 2
*************************************/
select * from nw.customers ;
select * from nw.orders ;
select * from nw.employees;
select *from nw.shippers ;


-- 고객명 Antonio Moreno이 1997년에 주문한 주문 정보를 주문 아이디, 주문일자, 배송일자, 배송 주소를 고객 주소와 함께 구할것.  
select a.contact_name , a.address , b.order_id , b.order_date , b.shipped_date , b.ship_address 
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
where a.contact_name = 'Antonio Moreno'
and b.order_date between to_date('19970101','yyyymmdd') and to_date('19971231','yyyymmdd');


-- Berlin에 살고 있는 고객이 주문한 주문 정보를 구할것
-- 고객명, 주문id = contact_name, 주문일자, 주문접수 직원명, 배송업체명을 구할것. 

select a.customer_id , a.contact_name , b.order_id , b.order_date ,
		c.first_name || c.last_name as employee_name, d.company_name as shipper_name
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.employees c on b.employee_id = c.employee_id
	join nw.shippers d on d.shipper_id = b.ship_via 
where a.city = 'Berlin'


--Beverages 카테고리에 속하는 모든 상품아이디와 상품명, 그리고 이들 상품을 제공하는 supplier 회사명 정보 구할것 

-- categoryies
-- product
-- spplier
select c.category_id ,c.category_name , p.product_id , p.product_name , s.supplier_id , s.company_name 
from nw.categories c
	join nw.products p on c.category_id = p.category_id 
	join nw.suppliers s on p.supplier_id = s.supplier_id 
where c.category_name  = 'Beverages'
order by 1,2,3







-- 고객명 Antonio Moreno이 1997년에 주문한 주문 상품정보를 고객 주소, 주문 아이디, 주문일자, 배송일자, 배송 주소 및
-- 주문 상품아이디, 주문 상품명, 주문 상품별 금액, 주문 상품이 속한 카테고리명, supplier명을 구할 것. 

-- customers 
-- orders
-- products
-- order_items
-- categories
-- spplier

select c.contact_name ,c.address, o.order_id  , o.order_date , o.shipped_date , o.ship_address , p.product_id , p.product_name , p.unit_price , c2.category_name , s.company_name 
from nw.customers c 
	join nw.orders o on c.customer_id = c.customer_id 
	join nw.order_items oi on o.order_id = oi.order_id 
	join nw.products p on oi.product_id = p.product_id
	join nw.categories c2 on p.category_id = c2.category_id 
	join nw.suppliers s on p.supplier_id = s.supplier_id 
where c.contact_name  = 'Antonio Moreno'
and o.order_date between to_date('19970101','yyyymmdd') and to_date('19971231','yyyymmdd')  









