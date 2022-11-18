CREATE TABLE [guest].[instructor_teaches] (
  [id] int  NOT NULL,
  [name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [dept_name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [salary] money  NULL,
  [course_id] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [sec_id] char(2) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [semester] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [year] char(4) COLLATE Chinese_PRC_CI_AS  NULL,
  CONSTRAINT [PK__instruct__3213E83F25F9F389] PRIMARY KEY CLUSTERED ([id], [course_id], [sec_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
)  
ON [PRIMARY]
GO

ALTER TABLE [guest].[instructor_teaches] SET (LOCK_ESCALATION = TABLE)

INSERT INTO [guest].[instructor_teaches] ( [id], [name], [dept_name], [salary], [course_id], [sec_id], [semester], [year] )
VALUES
 	( 10101, 'Srinivasan', 'Comp.Sci.', 65000, 'CS-101', 1, 'Fall', '2009' ),
	( 10101, 'Srinivasan', 'Comp.Sci.', 65000, 'CS-315', 1, 'Spring', '2010' ),
	( 10101, 'Srinivasan', 'Comp.Sci.', 65000, 'CS-347', 1, 'Fall', '2009' ),
	( 12121, 'Wu', 'Finance', 90000, 'FIN-201', 1, 'Spring', '2010' ),
	( 15151, 'Mozart', 'Music', 40000, 'Mu-199', 1, 'Spring', '2010' ),
	( 22222, 'Einstein', 'Physice', 95000, 'PHY-101', 1, 'Fall', '2009' ),
	( 32343, 'ElSaid', 'History', 60000, 'HIS-351', 1, 'Spring', '2010' ),
	( 45565, 'Katz', 'Comp.Sci.', 75000, 'CS-101', 1, 'Spring', '2010' ),
	( 45565, 'Katz', 'Comp.Sci.', 75000, 'CS-319', 1, 'Spring', '2010' ),
	( 76766, 'Crick', 'Biology', 72000, 'BIO-101', 1, 'Summer', '2009' ),
	( 76766, 'Crick', 'Biology', 72000, 'BIO-301', 1, 'Summer', '2010' ),
	( 83821, 'Brandt', 'Comp.Sci.', 92000, 'CS-190', 1, 'Spring', '2009' ),
	( 83821, 'Brandt', 'Comp.Sci.', 92000, 'CS-190', 2, 'Spring', '2009' ),
	( 83821, 'Brandt', 'Comp.Sci.', 92000, 'CS-319', 2, 'Spring', '2010' ),
	( 98345, 'Kim', 'Elec.Eng.', 80000, 'EE-181', 1, 'Spring', '2009' ) 
