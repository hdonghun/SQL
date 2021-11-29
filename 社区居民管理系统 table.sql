--1）小区信息表的建立：
Create Table Neighborhood(
	N_id char(10) Primary Key,
	N_name varchar(50),
	N_area float,
	N_btime datetime,
	local varchar(50),
	N_ppl varchar(50),
	N_remark text
)

--2）楼宇信息表的建立：
Create Table Building(
	B_id char(10) Primary Key,
	B_type varchar(50),
	B_orn varchar(50),
	B_high int Constraint C_bhigh Check (B_high>=1 and B_high<=100),
	B_area int Constraint C_barea Check (B_area>=500 and B_area<=5000),
	B_btime datetime,
	B_ppl varchar(50),
	B_nid char(10) Constraint C_bf Foreign Key References Neighborhood(N_id)
)

--3）房间信息表的建立：
Create Table Room(
	R_id char(10) Primary Key,
	R_no char(10) Constraint C_rf Foreign Key References Building(B_id),
	R_type varchar(50),
	R_area int Constraint C_rbarea Check (R_area>=50 and R_area<=300),
	R_btime datetime,
)

--4）住户信息表的建立：
Create Table Owner(
	O_id char(10) Primary Key,
	O_name varchar(50) unique,
	O_sex nchar(1) Constraint C_osex Check (O_sex='男' or O_sex='女'),
	O_idcard char(18),
	O_wook varchar(50),
	O_phone char(11) unique,
	O_rid char(10) Constraint C_Of Foreign Key References Room(R_id)
)

--5）车位信息表的建立：
Create Table Stall(
	S_id char(10) Primary Key,
	S_area int Constraint C_sarea Check (S_area>=4 and S_area<=8),
	S_ctype varchar(50),
	S_cno varchar(50),
	S_nid char(10) Constraint C_sf Foreign Key References Owner(O_id)
)

--6）收费信息表的建立：
Create Table Charge(
	C_id char(10) Primary Key,
	C_name varchar(50),
	C_num float Constraint C_cnum Check (C_num>0),
	C_tg varchar(50),
)

--7）设备信息表的建立：
Create Table Equipment(
	E_id char(10) Primary Key,
	E_name varchar(50),
	E_num int Constraint C_enum Check (E_num>0),
	E_mtime datetime,
	E_period varchar(50),
	E_ppl varchar(50),
	E_nid char(10) Constraint C_ef Foreign Key References Neighborhood(N_id)
)

--8）清洁信息表的建立：
Create Table Clean(
	Cl_area_id char(10) Primary Key Constraint C_clf Foreign Key References Neighborhood(N_id),
	Cl_name varchar(50),
	Cl_time datetime,
	Cl_ppl varchar(50)
)


--9）缴纳信息表的建立：
Create Table Payment(
	P_cid char(10) Constraint C_pcf Foreign Key References Charge(C_id),
	P_oid char(10) Constraint C_pof Foreign Key References Owner(O_id),
	P_time datetime,
)

