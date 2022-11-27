/************************************
카테고리 별 기준 월 대비 매출 비율 추이(aka 매출 팬 차트)
step 1: 상품 카테고리 별 월별 매출액 추출
step 2: step 1의 집합에서 기준 월이 되는 첫월의 매출액을 동일 카테고리에 모두 복제한 뒤 매출 비율을 계산
*************************************/
with 
temp_01 as (
select d.category_name, to_char(date_trunc('month', order_date), 'yyyymm') as month_day
	, sum(amount) as sum_amount
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
	join nw.products c on b.product_id = c.product_id 
    join nw.categories d on c.category_id = d.category_id
where order_date between to_date('1996-07-01', 'yyyy-mm-dd') and to_date('1997-06-30', 'yyyy-mm-dd')
group by d.category_name, to_char(date_trunc('month', order_date), 'yyyymm')
)
select category_name, month_day, sum_amount
	, first_value(sum_amount) over (partition by category_name order by month_day) as base_amount 
	, round(100.0 * sum_amount/first_value(sum_amount) over (partition by category_name order by month_day), 2) as base_ratio 
from temp_01;


/************************************************
 * 매출 Z 차트
 *************************************************/
with 
temp_01 as (
	select to_char(a.order_date, 'yyyymm') as year_month
		, sum(b.amount) as sum_amount
	from nw.orders a
		join nw.order_items b
			on a.order_id = b.order_id
	group by to_char(a.order_date, 'yyyymm')
), 
temp_02 as (
select year_month, substring(year_month, 1, 4) as year
	, sum_amount
	, sum(sum_amount) over (partition by substring(year_month, 1, 4) order by year_month) as acc_amount
	, sum(sum_amount) over (order by year_month rows between 11 preceding and current row) as year_ma_amount
from temp_01 -- where year_month between '199706' and '199805' 와 같이 사용하면 안됨. where절이 먼저 수행되므로 sum() analytics가 제대로 동작하지 않음.
)
select * from temp_02 
/* where year_month >= '199801' and year_month <= '199804'
 * where year = '1997'
 */
