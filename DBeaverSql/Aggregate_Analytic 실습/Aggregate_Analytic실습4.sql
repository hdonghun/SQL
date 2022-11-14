-- 상품별 매출합을 구하되, 상품 카테고리별 매출합의 5% 이상이고, 동일 카테고리에서 상위 3개 매출의 상품 정보 추출. 
-- 1. 상품별 + 상품 카테고리별 총 매출 계산. (상품별 + 상품 카테고리별 총 매출은 결국 상품별 총 매출임)
-- 2. 상품 카테고리별 총 매출 계산 및 동일 카테고리에서 상품별 랭킹 구함
-- 3. 상품 카테고리 매출의 5% 이상인 상품 매출과 매출 기준 top 3 상품 추출.  
with
temp_01 as (
	select a.product_id, max(b.category_id) as category_id , sum(amount) sum_by_prod
	from  order_items a
		join products b 
			on a.product_id = b.product_id 
	group by  a.product_id
), 
temp_02 as (
select product_id, category_id, sum_by_prod
	, sum(sum_by_prod) over (partition by category_id) as sum_by_cat
	, row_number() over (partition by category_id order by sum_by_prod desc) as top_prod_ranking
from temp_01
)
select * from temp_02 where sum_by_prod >= 0.05 * sum_by_cat and top_prod_ranking <=3;