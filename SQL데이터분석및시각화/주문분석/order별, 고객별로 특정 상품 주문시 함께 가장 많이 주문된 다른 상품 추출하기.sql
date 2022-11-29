/************************************
order별/고객별로 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기
*************************************/

-- 테스트용 테이블 기반에서 order별 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기
with 
temp_01 as (
select 'ord001' as order_id, 'A' as product_id
union all
select 'ord001', 'B'
union all
select 'ord001', 'C'
union all
select 'ord002', 'B'
union all 
select 'ord002', 'D'
union all
select 'ord003', 'A'
union all
select 'ord003', 'B'
union all
select 'ord003', 'D'
), 
temp_02 as (
select a.order_id, a.product_id as prod_01, b.product_id as prod_02 
from temp_01 a 
	join temp_01 b on a.order_id = b.order_id
where a.product_id != b.product_id
order by 1, 2, 3
),
temp_03 as (
select prod_01, prod_02, count(*) as cnt
from temp_02
group by prod_01, prod_02
order by 1, 2, 3
),
temp_04 as (
select *
	, row_number() over (partition by prod_01 order by cnt desc) as rnum
from temp_03
)
select * from temp_04 where rnum=1;








-- order별 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기
with 
-- order_items와 order_items를 order_id로 조인하면 M:M 조인되면서 개별 order_id별 주문 상품별로 연관된 주문 상품 집합을 생성
temp_01 as (
select a.order_id, a.product_id as prod_01, b.product_id as prod_02 
from order_items a
	join order_items b on a.order_id = b.order_id
where a.product_id != b.product_id -- 동일 order_id로 동일 주문상품은 제외
),
-- prod_01 + prod_02 레벨로 group by 건수를 추출. 
temp_02 as (
select prod_01, prod_02, count(*) as cnt
from temp_01 
group by prod_01, prod_02
), 
temp_03 as (
select prod_01, prod_02, cnt
	-- prod_01별로 가장 많은 건수를 가지는 prod_02를 찾기 위해 cnt가 높은 순으로 순위추출. 
    , row_number() over (partition by prod_01 order by cnt desc) as rnum
from temp_02
)
-- 순위가 1인 데이터만 별도 추출. 
select prod_01, prod_02, cnt 
from temp_03
where rnum = 1;

-- 사용자별 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기
with 
-- user_id는 order_items에 없으므로 order_items와 orders를 조인하여 user_id 추출. 
temp_00 as (
select b.user_id,a.order_id, a.product_id
from order_items a
	join orders b on a.order_id = b.order_id
), 
-- temp_00을 user_id로 셀프 조인하면 M:M 조인되면서 개별 user_id별 주문 상품별로 연관된 주문 상품 집합을 생성
temp_01 as
(
select a.user_id, a.product_id as prod_01, b.product_id as prod_02 
from temp_00 a
	join temp_00 b on a.user_id = b.user_id
where a.product_id != b.product_id
), 
-- prod_01 + prod_02 레벨로 group by 건수를 추출. 
temp_02 as (
select prod_01, prod_02, count(*) as cnt
from temp_01 
group by prod_01, prod_02
), 
temp_03 as (
select prod_01, prod_02, cnt
	-- prod_01별로 가장 많은 건수를 가지는 prod_02를 찾기 위해 cnt가 높은 순으로 순위추출. 
    , row_number() over (partition by prod_01 order by cnt desc) as rnum
from temp_02
)
-- 순위가 1인 데이터만 별도 추출. 
select prod_01, prod_02, cnt, rnum
from temp_03
where rnum = 1
;

select b.user_id, a.* 
from order_items a
join orders b on a.order_id = b.order_id 
where product_id in ('GGOEA0CH077599', 'GGOEYAQB073215')
order by 1, order_id, item_seq;


/************************************
고객별 RFM 구하기
*************************************/

-- recency, frequency, monetary 각각에 5 ntile을 적용하여 고객별 RFM 구하기
with 
temp_01 as ( 
select a.user_id, max(date_trunc('day', order_time))::date as max_ord_date
, to_date('20161101', 'yyyymmdd') - max(date_trunc('day', order_time))::date  as recency
, count(distinct a.order_id) as freq
, sum(prod_revenue) as money
from orders a
	join order_items b on a.order_id = b.order_id
group by a.user_id
)
select *
	-- recency, frequency, money 각각을 5개 등급으로 나눔. 1등급이 가장 높고, 5등급이 가장 낮음. 
	, ntile(5) over (order by recency asc rows between unbounded preceding and unbounded following) as recency_rank
	, ntile(5) over (order by freq desc rows between unbounded preceding and unbounded following) as freq_rank
	, ntile(5) over (order by money desc rows between unbounded preceding and unbounded following) as money_rank
from temp_01;

--  recency, frequency, monetary 각각에 대해서 범위를 설정하고 이 범위에 따라 RFM 등급 할당. 
with
temp_01 as (
	select 'A' as grade, 1 as fr_rec, 14 as to_rec, 5 as fr_freq, 9999 as to_freq, 100.0 as fr_money, 999999.0 as to_money
	union all
	select 'B', 15, 50, 3, 4, 50.0, 99.999
	union all
	select 'C', 51, 99999, 1, 2, 0.0, 49.999
)
select * from temp_01;


with 
temp_01 as ( 
select a.user_id, max(date_trunc('day', order_time))::date as max_ord_date
, to_date('20161101', 'yyyymmdd') - max(date_trunc('day', order_time))::date  as recency
, count(distinct a.order_id) as freq
, sum(prod_revenue) as money
from orders a
	join order_items b on a.order_id = b.order_id
group by a.user_id
), 
temp_02 as (
	select 'A' as grade, 1 as fr_rec, 14 as to_rec, 5 as fr_freq, 9999 as to_freq, 300.0 as fr_money, 999999.0 as to_money
	union all
	select 'B', 15, 50, 3, 4, 50.0, 299.999
	union all
	select 'C', 51, 99999, 1, 2, 0.0, 49.999
), 
temp_03 as (
select a.*
	, b.grade as recency_grade, c.grade as freq_grade, d.grade as money_grade
from temp_01 a
	left join temp_02 b on a.recency between b.fr_rec and b.to_rec
	left join temp_02 c on a.freq between c.fr_freq and c.to_freq
	left join temp_02 d on a.money between d.fr_money and d.to_money
)
select * 
	, case when recency_grade = 'A' and freq_grade in ('A', 'B') and money_grade = 'A' then 'A'
	       when recency_grade = 'B' and freq_grade = 'A' and money_grade = 'A' then 'A'
	       when recency_grade = 'B' and freq_grade in ('A', 'B', 'C') and money_grade = 'B' then 'B'
	       when recency_grade = 'C' and freq_grade in ('A', 'B') and money_grade = 'B' then 'B'
	       when recency_grade = 'C' and freq_grade = 'C' and money_grade = 'A' then 'B'
	       when recency_grade = 'C' and freq_grade = 'C' and money_grade in ('B', 'C') then 'C'
	       when recency_grade in ('B', 'C') and money_grade = 'C' then 'C'
	       else 'C' end as total_grade
from temp_03

/*
select * from temp_03;
select freq_grade, count(*)
from temp_03 group by freq_grade
*/


###### 여기서부터는 트리맵 시각화를 위한 SQL입니다. SQL실습에서는 사용하지 않습니다. 

-- ### 시각화를 위한 RFM SQL
with 
temp_01 as ( 
select a.user_id, max(date_trunc('day', order_time))::date as max_ord_date
, to_date('20161101', 'yyyymmdd') - max(date_trunc('day', order_time))::date  as recency
, count(distinct a.order_id) as freq
, sum(prod_revenue) as money
from orders a
	join order_items b on a.order_id = b.order_id
group by a.user_id
), 
temp_02 as (
	select 'A' as grade, 1 as fr_rec, 14 as to_rec, 5 as fr_freq, 9999 as to_freq, 300.0 as fr_money, 999999.0 as to_money
	union all
	select 'B', 15, 50, 3, 4, 50.0, 299.999
	union all
	select 'C', 51, 99999, 1, 2, 0.0, 49.999
), 
temp_03 as (
select a.*
	, b.grade as recency_grade, c.grade as freq_grade, d.grade as money_grade
from temp_01 a
	left join temp_02 b on a.recency between b.fr_rec and b.to_rec
	left join temp_02 c on a.freq between c.fr_freq and c.to_freq
	left join temp_02 d on a.money between d.fr_money and d.to_money
),
temp_04 as (
select * 
	, case when recency_grade = 'A' and freq_grade in ('A', 'B') and money_grade = 'A' then 'A'
	       when recency_grade = 'B' and freq_grade = 'A' and money_grade = 'A' then 'A'
	       when recency_grade = 'B' and freq_grade in ('A', 'B', 'C') and money_grade = 'B' then 'B'
	       when recency_grade = 'C' and freq_grade in ('A', 'B') and money_grade = 'B' then 'B'
	       when recency_grade = 'C' and freq_grade = 'C' and money_grade = 'A' then 'B'
	       when recency_grade = 'C' and freq_grade = 'C' and money_grade in ('B', 'C') then 'C'
	       when recency_grade in ('B', 'C') and money_grade = 'C' then 'C'
	       else 'C' end as total_grade
from temp_03
)
select total_grade, 'rfm_grade_'||recency_grade||freq_grade||money_grade as rfm_gubun
	, count(*) as grade_cnt
from temp_04 
group by total_grade, 'rfm_grade_'||recency_grade||freq_grade||money_grade order by 1
;
