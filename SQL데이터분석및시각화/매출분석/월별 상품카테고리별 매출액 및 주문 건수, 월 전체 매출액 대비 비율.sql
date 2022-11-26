
/************************************
월별 상품카테고리별 매출액 및 주문 건수, 월 전체 매출액 대비 비율
step 1: 상품 카테고리 별 월별 매출액 추출
step 2: step 1의 집합에서 전체 매출액을 analytic으로 구한 뒤에 매출액 비율 계산. 
*************************************/
with 
temp_01 as (
select d.category_name, to_char(date_trunc('month', order_date), 'yyyymm') as month_day
	, sum(amount) as sum_amount, count(distinct a.order_id) as monthly_ord_cnt
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
	join nw.products c on b.product_id = c.product_id 
    join nw.categories d on c.category_id = d.category_id
group by d.category_name, to_char(date_trunc('month', order_date), 'yyyymm')
)
select *
	, sum(sum_amount) over (partition by month_day) as month_tot_amount
	, round(sum_amount / sum(sum_amount) over (partition by month_day), 3) as month_ratio
from temp_01;



/************************************
상품별 전체 매출액 및 해당 상품 카테고리 전체 매출액 대비 비율, 해당 상품카테고리에서 매출 순위
step 1: 상품별 전체 매출액을 구함
step 2: step 1의 집합에서 상품 카테고리별 전체 매출액을 구하고, 비율과 매출 순위를 계산. 
*************************************/
with
temp_01 as ( 
	select a.product_id, max(product_name) as product_name, max(category_name) as category_name
		, sum(amount) as sum_amount
	from nw.order_items a
		join nw.products b on a.product_id = b.product_id
		join nw.categories c on b.category_id = c.category_id
	group by a.product_id
)
select product_name, sum_amount as product_sales
	, category_name
	, sum(sum_amount) over (partition by category_name) as category_sales
	, sum_amount / sum(sum_amount) over (partition by category_name) as product_category_ratio
	, row_number() over (partition by category_name order by sum_amount desc) as product_rn
from temp_01
order by category_name, product_sales desc;

