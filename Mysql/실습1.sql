create table dept(
dept_no int not null,
dept_name varchar(20),
constraint dept_PK primary key (dept_no)
);

create table emp(
emp_no int not null,
emp_name varchar(20) not null,
dept_no int not null,
constraint emp_PK primary key (emp_no),
constraint emp_FK foreign key (dept_no) references dept(dept_no)
);

# ---------------------------------------------실습--------------------------------------------------#

# 테이블 1
# 테이블 이름 alpaco_lecture
# 컬럼 - alpaco_lecture_no, lecture_nmae
create table alpaco_lecture(
alpaco_lecture_no int not null,
lecture_nmae varchar(15),
constraint alpaco_lecture_PK primary key(alpaco_lecture_no)
);

# 테이블2
# 테이블 이름 alpaco_student
# 컬럼 - alpaco_student_no, alpaco_student_name, alpaco_lecture_no
create table alpaco_student(
alpaco_student_no int not null,
alpaco_student_name varchar(20) not null,
alpaco_lecture_no int not null,
constraint alpaco_student_PK primary key (alpaco_student_no),
constraint alpaco_student_FK foreign key (alpaco_lecture_no) references alpaco_lecture(alpaco_lecture_no)
);

# 테이블1 과 테이블2 는 서로 alpaco_lecture_no으로 이루어져 있다.