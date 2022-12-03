/************************************
채널별 고유 사용자 건수와 매출금액 및 비율, 주문 사용자 건수와 주문 매출 금액 및 비율
채널별로 고유 사용자 건수와 매출 금액을 구하고 고유 사용자 건수 대비 매출 금액 비율을 추출. 
또한 고유 사용자 중에서 주문을 수행한 사용자 건수를 추출 후 주문 사용자 건수 대비 매출 금액 비율을 추출
*************************************/

--단계: 0
select * from order_items; --prod_revenue 매출 금액
select * from orders; --sess_id 세션 아이디
select * from ga_sess; --channel_grouping 채널 

--단계: 1
with temp_01 as(
	select a.sess_id , a.user_id , a.channel_grouping , b.order_id , b.order_time , c.product_id , c.prod_revenue  
	from ga_sess a
		left join orders b on a.sess_id = b.sess_id
		left join order_items c on b.order_id = c.order_id 
	where a.visit_stime >=(:current_date - interval '30 days') and a.visit_stime < :current_date 
)
select * from temp_01;


--단계: 2
with temp_01 as(
	select a.sess_id , a.user_id , a.channel_grouping , b.order_id , b.order_time , c.product_id , c.prod_revenue  
	from ga_sess a
		left join orders b on a.sess_id = b.sess_id
		left join order_items c on b.order_id = c.order_id 
	where a.visit_stime >=(:current_date - interval '30 days') and a.visit_stime < :current_date 
)
select channel_grouping
	, sum(prod_revenue) as ch_amt --채널별 매출
	, count(distinct user_id) as ch_user_cnt --채널별 (고유) 사용자 수, 중복이 있어 distinct해준다.
	, count(distinct case when order_id is not null then user_id end) as ch_ord_user_cnt -- 각 채널의 주문을 한 사용자수, order_id가 not null이라는 것은 order_id가 존재한다, 즉 주문을 했다.
	, sum(prod_revenue)/count(distinct user_id ) as ch_amt_per_user	--접속 고유 사용자별 주문 매출 금액 : (각 채널별로 한 사람들 얼마정도의 매출을 나타내는지, 채널별 인당 평균 매출),(주문을 하지 않은 사용자까지 포함하게 된다.)
	, sum(prod_revenue)/count(distinct case when order_id is not null then user_id end) as ch_ord_amt_per_user -- 주문 고유 사용자별 매출 금액 : (위에서의 주문을 하지 않은 사용자까지 포함하게 되는것을 방지, 즉 각 채널별로 주문을 했었던 각 사람들의 평균 매출)
from temp_01
group by channel_grouping order by ch_user_cnt;



