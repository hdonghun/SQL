# ADD
use test;
create table alpaco(
student_id int not null primary key,
student_name varchar(20) not null
);

/* 테이블명 컬럼 데이터 타입 제약조건 */

alter table alpaco add email varchar(30) not null;

select *
from alpaco;

alter table alpaco drop column email;

select *
from alpaco;

### 여기까지
# 단위 변경은 modify
alter table alpaco modify student_name varchar(100);

# 이름 변경은 rename to
alter table alpaco rename column student_name to s_name;

select * from alpaco;

# 제약 조건 삭제
alter table alpaco_lecture drop constraint alpaco_lecture_PK;

# ADD

# drop vs TRUNCATE TABLE
# TRUNCATE TABLE : 테이블 구조 유지, 데이터만 삭제
# DROP : 테이블 , 데이터 모두 삭제

## 데이터 조작어 DML	 DATA MANIPULATION LANGUAGE
insert into alpaco (student_id, s_name)
values(0, '홀길동');

insert into alpaco (student_id, email)
values(1, 'toyou4203@naver.com');

select * from alpaco;

alter table alpaco add email varchar(30);
# alter table alpaco add s_name varchar(20);

select * from alpaco;

select * from player;

# 정상수 
update player set position = 'FW' where player_id = 2000002;

set SQL_SAFE_UPDATES = 0;

delete from player where player_id = '2000002';

select * from player;

select player_name, height, weight from player where weight > 80;

insert into player ( player_id,team_id, player_name, height, weight)
values(2000005, 'K10','김가은', 162, 80);

select distinct position from player where weight > 75;

select player_name, weight, height, weight/(height*height) as BMI from player;


select player_name, concat(height,'cm') from player;
select player_name, concat(weight,'kg') from player;

################################################################################################

## TCL - Transaction Control Language
# commit -> setAutoCommit = 0; (1은 활성화)
# rollback
# savepoint

commit;

set AUTOCOMMIT = 0;

delete from player where player_id = '2000001';

select * from player;

savepoint A;

select* from player;

delete from player where player_id = '2000003';

savepoint B;

select * from player;

rollback to A;

select * from player;

# AutoCommit이 활성화 되어 있으면, Rollback을 사용 할 수 없다.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

###############################################################################################
## Where 절 
select * from player where height between 170 and 190;
select * from player where weight between 70 and 80;

select * from player where position in ("FW", "DF");

###############################################################################################
# 내장 함수
select player_name, lower(position), abs(weight-height), height from player;

select player_name, weight, case 
when height > 185 then 'high'
when height > 175 then 'mid'
when height > 160 then 'small'
else 'other'
end as 키분류
from player;

###############################################################################################
# 집계함수
# Group by 할떄는, 집계함수를 사용해야 된다.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# GRoup by에 대한 조건은 having을 사용한다!!!!!!!!!!!!!!!!!!!!!11
select team_id, count(*), max(height), min(weight), AVG(height) from player where height > 180 
																group by team_id having avg(height)>180;
select player_name, height, weight from player order by height asc, weight desc;

/*  키가 큰 상위 10명만 출력 */
select player_name, height, weight from player order by height desc limit 10;

# join
select * from player;
select * from team;
# 선수들마다 팀 아이디의 팀 이름을 같이 출력해보자!
select p.player_name, p.team_id, t.team_name 
from player p, team t where p.team_id = t.team_id;

# 서브쿼리
select p.player_name, t.team_name from player p, (select team_id, team_name from team) t;

select player_name, team_id, height, weight from player where height > 180 and team_id in 
(select team_id from team where team_id in ('K01','K02'));
