select * from ga.ga_sess;
select * from ga.ga_sess_hits;
select * from ga.ga_sess_hits where sess_id = 'S0000505' order by hit_seq;
select hit_type, count(*) from ga.ga_sess_hits group by hit_type;

select action_type, count(*) from ga_sess_hits group by action_type;

-- action_type별 hit_type에 따른 건수
select action_type, count(*) action_cnt
	,sum(case when hit_type='PAGE' then 1 else 0 end) as page_action_cnt
	,sum(case when hit_type='EVENT' then 1 else 0 end) as event_action_cnt
from ga.ga_sess_hits gsh 
group by action_type;