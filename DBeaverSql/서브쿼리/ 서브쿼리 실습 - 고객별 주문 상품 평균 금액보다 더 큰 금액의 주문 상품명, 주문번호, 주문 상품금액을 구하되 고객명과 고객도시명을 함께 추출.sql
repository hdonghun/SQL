/************************************************
 서브쿼리 실습 - 고객별 주문 상품 평균 금액보다 더 큰 금액의 주문 상품명, 주문번호, 주문 상품금액을 구하되 고객명과 고객도시명을 함께 추출
 *************************************************/

-- 고객별 주문상품 평균 금액 
select a.customer_id ,avg(b.amount) avg_amount
from nw.orders a join nw.order_items b on a.order_id =b.order_id
	group by customer_id ;



select a.customer_id, avg(b.amount) avg_amount from nw.orders a
join nw.order_items b
on a.order_id = b.order_id
group by customer_id;



-- 상관 서브쿼리로 구하기
select a.customer_id, a.contact_name, a.city, b.order_id, c.product_id, c.amount, d.product_name
from nw.customers a 
	join nw.orders b on a.customer_id  = b.customer_id 
	join nw.order_items c on b.order_id = c.order_id
	join nw.products d on c.product_id = d.product_id
where c.amount >= (select avg(y.amount) avg_amount 
					from nw.orders x 
						join nw.order_items y on x.order_id = y.order_id
					where x.customer_id = a.customer_id
					group by x.customer_id
					)
order by a.customer_id, amount;




select a.customer_id, a.contact_name, a.city, b.order_id, c.product_id, c.amount, d.product_name
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.order_items c on b.order_id = c.order_id
	join nw.products d on c.product_id = d.product_id
where c.amount >= (select avg(y.amount) avg_amount 
					from nw.orders x
						join nw.order_items y on x.order_id = y.order_id
					where x.customer_id =a.customer_id
					group by x.customer_id
					)
order by a.customer_id, amount;
				
-- Analytic SQL로 구하기 				
select customer_id, contact_name, city, order_id, product_id, amount, product_name
from (
	select a.customer_id, a.contact_name, a.city, b.order_id, c.product_id, c.amount, d.product_name
	, avg(amount) over (partition by a.customer_id rows between unbounded preceding and unbounded following) as avg_amount
	from nw.customers a
		join nw.orders b on a.customer_id = b.customer_id
		join nw.order_items c on b.order_id = c.order_id
		join nw.products d on c.product_id = d.product_id
) a 
where a.amount >= a.avg_amount
order by customer_id, amount;

