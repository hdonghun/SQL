/************************************
고객별 RFM 구하기
*************************************/

select *from orders ;
select max(order_time) from orders; -- 2016년10월31일이 마지막 주문일자
-- 11월 1일을 기준으로 작업해보기.

select *from order_items ; --가격, revenue, 주문개수 확인가능

-- recency, frequency, monetary 각각에 5 ntile을 적용하여 고객별 RFM 구하기

-- recency 구하기, 기준 날짜를 오늘로 가정하고, 
-- to_date('20161101', 'yyyymmdd') 이렇게 표현함, 이것을 max(date_trunc('day', order_time)와 뻄 으로써 
-- recency를 구할 수 있음.

-- frequency 구하기, 횟수, count로 order_id를 구하면 됨. 

-- monetary 구하기, sum(revenue) 해주면 끝
-- group by만 user_id로 해주면 됨.

select a.user_id, max(date_trunc('day', order_time))::date as max_ord_date
, to_date('20161101', 'yyyymmdd') - max(date_trunc('day', order_time))::date  as recency언제
, count(distinct a.order_id) as freq횟수
, sum(prod_revenue) as money얼마나
from orders a
	join order_items b on a.order_id = b.order_id
group by a.user_id;




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
	-- recency, frequency, money 각각을 5개 등급으로 나눔(ntitle이용). 1등급이 가장 높고, 5등급이 가장 낮음. 
	, ntile(5) over (order by recency asc rows between unbounded preceding and unbounded following) as recency_rank --전체 데이터기준으로 작업
	, ntile(5) over (order by freq desc rows between unbounded preceding and unbounded following) as freq_rank --내림차순으로 해야한다(높을 수록 좋기 떄문에), desc
	, ntile(5) over (order by money desc rows between unbounded preceding and unbounded following) as money_rank
from temp_01;
-- ntile로 나눌때 1의 개수가 너무 많다.... 정규분포형이 아니기 때문에, 이렇게 분석하는데에는 문제가 있다...

