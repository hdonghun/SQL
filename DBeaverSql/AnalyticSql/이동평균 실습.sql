/************************************************
이동평균 실습
 *************************************************/

-- 3일 이동 평균 매출
with
temp_01 as (
	select date_trunc('day', b.order_date)::date as ord_date , sum(amount) as daily_sum
	from order_items a 
		join orders b on a.order_id = b.order_id 
		group by date_trunc('day', b.order_date)::date
)
select ord_date, daily_sum
	,avg(daily_sum) over (order by ord_date rows between 2 preceding and current row)ma_3days 
from temp_01;



-- 3일 중앙 평균 매출
with
temp_01 as (
select date_trunc('day', b.order_date)::date as ord_date, sum(amount) as daily_sum
from order_items a
	join orders b on a.order_id = b.order_id
group by date_trunc('day', b.order_date)::date 
)
select ord_date, daily_sum
	, avg(daily_sum) over (order by ord_date 
	                              rows between 1 preceding and 1 following) as ca_3days
from temp_01;



-- N 이동 평균에서 맨 처음 N-1 개의 데이터의 경우 정확히 N이동 평균을 구할 수 없을 때 Null 처리 하기. 
with
temp_01 as (
select date_trunc('day', b.order_date)::date as ord_date, sum(amount) as daily_sum
from order_items a
	join orders b on a.order_id = b.order_id
group by date_trunc('day', b.order_date)::date 
)
select ord_date, daily_sum
	, avg(daily_sum) over (order by ord_date 
	                              rows between 2 preceding and current row) as ma_3days_01
	, case when  row_number() over (order by ord_date) <= 2 then null 
	             else avg(daily_sum) over (order by ord_date 
	                              rows between 2 preceding and current row) 
	             end as ma_3days_02
from temp_01;





select generate_series('1996-07-04'::date, '1996-07-23'::date, '1day'::interval)::date as ord_date; 

-- 연속된 매출 일자에서 매출이 Null일때와 그렇지 않을 때의 Aggregate Analytic 결과 차이
with ref_days
as( 
	select generate_series('1996-07-04'::date, '1996-07-23'::date, '1day'::interval)::date as ord_date 
),
temp_01 as(
	select date_trunc('day', b.order_date)::date as ord_date, sum(amount) as daily_sum
	from order_items a
		join orders b on a.order_id  = b.order_id 
	group by date_trunc('day', b.order_date)::date 
),
temp_02 as (
	select a.ord_date, b.daily_sum as daily_sum	
	from ref_days a
		left join temp_01 b on a.ord_date = b.ord_date
)
select ord_date, daily_sum
	, avg(daily_sum) over (order by ord_date rows between 2 preceding and current row) as ma_3days
	, avg(coalesce(daily_sum, 0)) over (order by ord_date rows between 2 preceding and current row) as ma_3days_coalesce
from temp_02;



