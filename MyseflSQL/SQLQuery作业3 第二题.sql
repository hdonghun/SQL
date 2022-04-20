CREATE TABLE [guest].[department] ([dept_name] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL, [building] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL, [budget] int  NULL, CONSTRAINT [PK__departme__C7D39AE06090A141] PRIMARY KEY CLUSTERED ([dept_name])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
)  
ON [PRIMARY]
GO

ALTER TABLE [guest].[department] SET (LOCK_ESCALATION = TABLE)

CREATE TABLE [guest].[student] (
  [ID] varchar(31) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [dept_name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [tot_cred] int  NULL,
  CONSTRAINT [PK__student__3214EC275D6B9FE6] PRIMARY KEY CLUSTERED ([ID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY],
  CONSTRAINT [dept_name] FOREIGN KEY ([dept_name]) REFERENCES [guest].[department] ([dept_name]) ON DELETE NO ACTION ON UPDATE NO ACTION
)  
ON [PRIMARY]
GO
ALTER TABLE [guest].[student] SET (LOCK_ESCALATION = TABLE)

INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Biology', 'Watson', 90000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Comp.Sci.', 'Taylor', 100000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Elec.Eng.', 'Taylor', 85000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Finance', 'Painter', 120000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('History', 'Painter', 50000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Music', 'Packard', 80000);
INSERT INTO [guest].[department]([dept_name], [building], [budget]) VALUES ('Physice', 'Watson', 90000);

INSERT INTO [guest].[student] ( [ID], [name], [dept_name], [tot_cred] )
VALUES
	( '00128', 'Zhang', 'Comp.Sci.', 102 ),
	( '12345', 'Shangkar', 'Comp.Sci.', 32 ),
	( '19991', 'Brandt', 'History', 80 ),
	( '23121', 'Chavez', 'Finance', 110 ),
	( '44553', 'Peltier', 'Physice', 56 ),
	( '45678', 'Levy', 'Physice', 46 ),
	( '54321', 'Williams', 'Comp.Sci.', 54 ),
	( '55739', 'Sanchez', 'Music', 38 ),
	( '70557', 'Snow', 'Physice', 0 ),
	( '76543', 'Brown', 'Comp.Sci.', 58 ),
	( '76653', 'Aoi', 'Elec.Eng.', 60 ),
	( '98765', 'Bourikas', 'Elec.Eng.', 98 ),
	( '98988', 'Tanaka', 'Biology', 120 )
	;

