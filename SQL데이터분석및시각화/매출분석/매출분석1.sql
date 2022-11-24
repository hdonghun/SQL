/************************************
   일/주/월/분기별 매출액 및 주문 건수
*************************************/
--orders
--orderItems
select date_trunc('month', order_date)::date as month , 
			sum(amount), count(distinct a.order_id) as monthly_ord_cnt
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
group by date_trunc('month', order_date)::date ;


select date_trunc('day', order_date)::date as day , 
			sum(amount), count(distinct a.order_id) as daily_ord_cnt
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
group by date_trunc('day', order_date)::date ;





/************************************
   일/주/월/분기별 상품별 매출액 및 주문 건수
*************************************/
select date_trunc('day', order_date)::date as day, b.product_id
	, sum(amount) as sum_amount, count(distinct a.order_id) as daily_ord_cnt
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
group by date_trunc('day', order_date)::date, b.product_id
order by 1, 2;
