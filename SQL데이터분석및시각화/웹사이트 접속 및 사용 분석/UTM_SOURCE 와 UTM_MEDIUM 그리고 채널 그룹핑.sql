select * from ga.ga_sess ;

select  traffic_medium, traffic_source, count(*) 
from ga.ga_sess
group by traffic_medium, traffic_source
order by 1,2;


select channel_grouping , traffic_medium , traffic_source , count(*) 
from ga.ga_sess
group by channel_grouping , traffic_medium , traffic_source
order by 1,2,3;