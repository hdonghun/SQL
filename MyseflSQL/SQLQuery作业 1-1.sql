-- 1-1
CREATE TABLE [guest].[department] (
  [dept_name] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [building] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [budget] int  NULL,
  CONSTRAINT [PK__departme__C7D39AE06090A141] PRIMARY KEY CLUSTERED ([dept_name])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
)  
ON [PRIMARY]
GO

ALTER TABLE [guest].[department] SET (LOCK_ESCALATION = TABLE)