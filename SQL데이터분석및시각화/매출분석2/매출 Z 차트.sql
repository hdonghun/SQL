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
