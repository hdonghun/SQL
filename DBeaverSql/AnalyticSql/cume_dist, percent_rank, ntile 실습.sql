/************************************************
cume_dist, percent_rank, ntile 실습
 *************************************************/

-- cume_dist는 percentile을 파티션내의 건수로 적용하고 0 ~ 1 사이 값으로 변환. 
-- 파티션내의 자신을 포함한 이전 로우수/ 파티션내의 로우 건수로 계산될 수 있음. 
select a.empno, ename, job, sal
	, rank() over(order by sal desc) as rank 
	, cume_dist() over (order by sal desc) as cume_dist
	, cume_dist() over (order by sal desc)*12.0 as xxtile
from hr.emp a;

select * from nw.order_items;

select a.order_id 
	, rank() over(order by amount desc) as rank 
	, cume_dist() over (order by amount desc) as cume_dist
from nw.order_items a;


-- percent_rank는 rank를 0 ~ 1 사이 값으로 정규화 시킴. 
-- (파티션내의 rank() 값 - 1) / (파티션내의 로우 건수 - 1)
select a.empno, ename, job, sal
    , rank() over(order by sal desc) as rank 
	, percent_rank() over (order by sal desc) as percent_rank
	, 1.0 * (rank() over(order by sal desc) -1 )/11 as percent_rank_calc
from hr.emp a;

-- ntile은 지정된 숫자만큼의 분위를 정하여 그룹핑하는데 사용. 
select a.empno, ename, job, sal
	, ntile(5) over (order by sal desc) as ntile
from hr.emp a;


-- 상품 매출 순위 상위 10%의 상품 및 매출액
with
temp_01 as (
	select product_id, sum(amount) as sum_amount
	from nw.orders a 
		join nw.order_items b on a.order_id =b.order_id
	group by product_id
)
select * from (
	select a.product_id, b.product_name, a.sum_amount
		, cume_dist() over (order by sum_amount) as percentile_norm
		, 1.0 * row_number() over (order by sum_amount)/count(*) over () as rnum_norm
	from temp_01 a
		join nw.products b on a.product_id = b.product_id
) a where percentile_norm >= 0.9;
