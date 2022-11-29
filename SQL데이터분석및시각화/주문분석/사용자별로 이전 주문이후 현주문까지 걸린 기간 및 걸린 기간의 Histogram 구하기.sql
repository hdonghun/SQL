/************************************
사용자별로 이전 주문이후 현주문까지 걸린 기간 및 걸린 기간의 Histogram 구하기
*************************************/

-- 주문 테이블에서 사용자별로 이전 주문 이후 걸린 기간 구하기. 
with
temp_01 as (
select order_id, customer_id, order_date
	, lag(order_date) over (partition by customer_id order by order_date) as prev_ord_date
from nw.orders
), 
temp_02 as (
select order_id, customer_id, order_date
	, order_date - prev_ord_date as days_since_prev_order
from temp_01 
where prev_ord_date is not null
)
select * from temp_02;






-- 이전 주문이후 걸린 기간의 Histogram 구하기
with
temp_01 as (
select order_id, customer_id, order_date
	, lag(order_date) over (partition by customer_id order by order_date) as prev_ord_date
from nw.orders
), 
temp_02 as (
select order_id, customer_id, order_date
	, order_date - prev_ord_date as days_since_prev_order
from temp_01 
where prev_ord_date is not null
)
-- bin의 간격을 10으로 설정. 
select floor(days_since_prev_order/10.0)*10 as bin, count(*) bin_cnt
from temp_02 group by floor(days_since_prev_order/10.0)*10 order by 1 
;



with
temp_01 as (
select order_id, user_id, order_time
	, lag(order_time) over (partition by user_id order by order_time) as prev_ord_time
from ga.orders
),
temp_02 as (
select order_id, user_id, date_trunc('day', order_time)::date as order_date
	, date_trunc('day', prev_ord_time)::date as prev_ord_date
	, date_trunc('day', order_time)::date - date_trunc('day', prev_ord_time)::date as days_since_prev_order
from temp_01 
where prev_ord_time is not null
)
select floor(days_since_prev_order/10.0)*10 as bin, count(*) bin_cnt
from temp_02 group by floor(days_since_prev_order/10.0)*10 order by 1 
;


with
temp_01 as (
select order_id, user_id, order_time
	, lag(order_time) over (partition by user_id order by order_time) as prev_ord_time
from ga.orders
),
temp_02 as (
select order_id, user_id, date_trunc('day', order_time)::date as order_date
	, date_trunc('day', prev_ord_time)::date as prev_ord_date
	, date_trunc('day', order_time)::date - date_trunc('day', prev_ord_time)::date as days_since_prev_order
from temp_01 
where prev_ord_time is not null
)
select width_bucket(days_since_prev_order, 0, 90, 10) as buckets, count(*) as cnt
from temp_02
group by buckets
order by buckets;

with
temp_01 as (
select order_id, user_id, order_time
	, lag(order_time) over (partition by user_id order by order_time) as prev_ord_time
from ga.orders
),
temp_02 as (
select order_id, user_id, date_trunc('day', order_time)::date as order_date
	, date_trunc('day', prev_ord_time)::date as prev_ord_date
	, date_trunc('day', order_time)::date - date_trunc('day', prev_ord_time)::date as days_since_prev_order
from temp_01 
where prev_ord_time is not null
),
temp_03 as (
select min(days_since_prev_order) as min_days,
	max(days_since_prev_order) as max_days
from temp_02
),
temp_04 as (
select width_bucket(days_since_prev_order, min_days, max_days, 10) as bucket, count(*) as cnt
, int4range(min(days_since_prev_order), max(days_since_prev_order), '[]') as range
from temp_02 a
	cross join temp_03 b
group by bucket
order by bucket
)
select * from temp_04;





/************************************
월별 사용자 평균 주문 건수 
*************************************/
with
temp_01 as (
select customer_id, date_trunc('month', order_date)::date as month_day, count(*) as order_cnt 
from orders
group by customer_id, date_trunc('month', order_date)::date
)
select month_day, avg(order_cnt), max(order_cnt), min(order_cnt) -- , count(*)
from temp_01 group by month_day
order by month_day;



select customer_id, date_trunc('month', order_date)::date as month_day, count(*) as order_cnt 
from orders
group by customer_id, date_trunc('month', order_date)::date;