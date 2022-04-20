--（3）缴纳项目查询
Create View P_R_C(O_name,O_rid,C_id,C_num,C_tg,O_phone,P_time)
As Select O_name,O_rid,C_id,C_num,C_tg,O_phone,P_time
From  Payment P,Charge C,Owner O
Where P_cid=C_id and P_oid=O.O_id
