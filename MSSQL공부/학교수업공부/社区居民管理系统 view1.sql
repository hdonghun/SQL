--（1）小区所属楼宇查询
Create View N_B(N_name,B_id,local)
As Select N_name,B_id,local
From Neighborhood N,Building B
Where N.N_id=B.B_nid
--