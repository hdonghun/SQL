/************************************************
percentile_disc/percentile_cont 실습
 *************************************************/

-- 4분위별 sal 값을 반환. 
select percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp;  

-- percentile_disc는 cume_dist의 inverse 값을 반환. 
-- percentile_disc는 0 ~ 1 사이의 분위수값을 입력하면 해당 분위수 값 이상인 것 중에서 최소 cume_dist 값을 가지는 값을 반환
with
temp_01 as 
(
	select percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp
)
select a.empno, ename, sal
	, cume_dist() over (order by sal) as cume_dist
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from hr.emp a
	cross join temp_01 b
order by sal;


-- products 테이블에서 category별 percentile_disc 구하기 
with
temp_01 as 
(
	select a.category_id, max(b.category_name) as category_name 
	, percentile_disc(0.25) within group (order by unit_price) as qt_1
	, percentile_disc(0.5) within group (order by unit_price) as qt_2
	, percentile_disc(0.75) within group (order by unit_price) as qt_3
	, percentile_disc(1.0) within group (order by unit_price) as qt_4
from nw.products a
	join nw.categories b on a.category_id = b.category_id
group by a.category_id
)
select * from temp_01;

-- percentile_disc와 cume_dist 비교하기 
with
temp_01 as 
(
	select a.category_id, max(b.category_name) as category_name 
	, percentile_disc(0.25) within group (order by unit_price) as qt_1
	, percentile_disc(0.5) within group (order by unit_price) as qt_2
	, percentile_disc(0.75) within group (order by unit_price) as qt_3
	, percentile_disc(1.0) within group (order by unit_price) as qt_4
from nw.products a
	join nw.categories b on a.category_id = b.category_id
group by a.category_id
)
select product_id, product_name, a.category_id, b.category_name
	, unit_price
	, cume_dist() over (partition by a.category_id order by unit_price) as cume_dist_by_cat
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from nw.products a 
	join temp_01 b on a.category_id = b.category_id;



--입력 받은 분위수가 특정 로우를 정확하게 지정하지 못하고, 두 로우 사이일때 
--percentile_cont는 보간법을 이용하여 보정하며, percentile_cont는 두 로우에서 작은 값을 반환
select 'cont' as gubun 
	, percentile_cont(0.25) within group (order by sal) as qt_1
	, percentile_cont(0.5) within group (order by sal) as qt_2
	, percentile_cont(0.75) within group (order by sal) as qt_3
	, percentile_cont(1.0) within group (order by sal) as qt_4
from hr.emp
union all
select 'disc' as gubun 
	, percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp;

-- percentile_cont와 percentile_disc를 cume_dist와 비교. 
with 
temp_01 as ( 
select 'cont' as gubun 
	, percentile_cont(0.25) within group (order by sal) as qt_1
	, percentile_cont(0.5) within group (order by sal) as qt_2
	, percentile_cont(0.75) within group (sorder by sal) as qt_3
	, percentile_cont(1.0) within group (order by sal) as qt_4
from hr.emp
union all
select 'disc' as gubun 
	, percentile_disc(0.25) within group (order by sal) as qt_1
	, percentile_disc(0.5) within group (order by sal) as qt_2
	, percentile_disc(0.75) within group (order by sal) as qt_3
	, percentile_disc(1.0) within group (order by sal) as qt_4
from hr.emp
)
select a.empno, ename, sal
	, cume_dist() over (order by sal)
	, b.qt_1, b.qt_2, b.qt_3, b.qt_4
from hr.emp a
	cross join temp_01 b
where b.gubun = 'disc'
;
