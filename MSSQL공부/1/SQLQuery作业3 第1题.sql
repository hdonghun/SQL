	SELECT [building] FROM [guest].[student] s LEFT JOIN [guest].[department] d ON s.[dept_name] = d.[dept_name] 	;
		SELECT [building] FROM [guest].[student] s LEFT JOIN [guest].[department] d ON s.[dept_name] = d.[dept_name] 	;
		SELECT dept_name FROM [guest].[department] WHERE [department].budget >= 90000;
		SELECT dept_name,building FROM [guest].[department] WHERE building LIKE '%r'
		SELECT * FROM [guest].[student] WHERE [dept_name]='Comp.Sci.' AND [tot_cred] =102;

		SELECT * FROM [guest].[student] WHERE [dept_name]='Comp.Sci.';