--（2）房间信息查询
Create View R_N_B(R_id,R_area,R_btime,N_name,B_id,local)
As Select R_id,R_area,R_btime,N_name,B_id,local
From Neighborhood N,Building B,Room R
Where N.N_id=B.B_nid and B.B_nid=R_no
