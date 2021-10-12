CREATE TABLE [guest].[student] (
  [ID] varchar(31) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [dept_name] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [tot_cred] int  NULL,
  CONSTRAINT [PK__student__3214EC275D6B9FE6] PRIMARY KEY CLUSTERED ([ID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY],
  CONSTRAINT [dept_name] FOREIGN KEY ([dept_name]) REFERENCES[guest].[department] ([dept_name]) ON DELETE NO ACTION ON UPDATE NO ACTION
)  
ON [PRIMARY]
GO

ALTER TABLE [guest].[student] SET (LOCK_ESCALATION = TABLE)
