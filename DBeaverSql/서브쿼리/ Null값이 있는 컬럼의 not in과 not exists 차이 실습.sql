/************************************************
 Null값이 있는 컬럼의 not in과 not exists 차이 실습
 *************************************************/

select * from hr.emp where deptno in (20, 30, null);

select * from hr.emp where deptno = 20 or deptno=30 or deptno = null;


-- 테스트를 위한 임의의 테이블 생성. 
drop table if exists nw.region;

create table nw.region
as
select ship_region as region_name from nw.orders 
group by ship_region 
;

-- 새로운 XX값을 region테이블에 입력. 
insert into nw.region values('XX');

commit;

select * from nw.region;

-- null값이 포함된 컬럼을 서브쿼리로 연결할 시 in과 exists는 모두 동일. 
select a.*
from nw.region a 
where a.region_name in (select ship_region from nw.orders x);

select a.*
from nw.region a 
where exists (select ship_region from nw.orders x where x.ship_region = a.region_name
             );

-- null값이 포함된 컬럼을 서브쿼리로 연결 시 not in과 not exists의 결과는 서로 다름. 
select a.*
from nw.region a 
where a.region_name not in (select ship_region from nw.orders x);

select a.*
from nw.region a 
where not exists (select ship_region from nw.orders x where x.ship_region = a.region_name
                 );
;

-- true
select 1=1;

-- false
select 1=2;

-- null
select null = null;

-- null
select 1=1 and null;

-- null
select 1=1 and (null = null);

-- true
select 1=1 or null;

-- false
select not 1=1;

-- null
select not null;

-- not in을 사용할 경우 null인 값은 서브쿼리내에서 is not null로 미리 제거해야 함. 
select a.*
from nw.region a 
where a.region_name not in (select ship_region from nw.orders x where x.ship_region is not null);

-- not exists의 경우 null 값을 제외하려면 서브쿼리가 아닌 메인쿼리 영역에서 제외
select a.*
from nw.region a 
where not exists (select ship_region from nw.orders x where x.ship_region = a.region_name --and a.region_name is not null
                 );
--and a.region_name is not null


