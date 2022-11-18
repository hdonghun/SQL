SELECT [EmailAddress], 
REPLACE ([EmailAddress],'@','/') AS RE_TEST,
LEN([EmailAddress]) AS LEN_TEST, CHARINDEX('@',[EmailAddress]) AS CHAR_TEST,
LEFT([EmailAddress],LEN([EmailAddress])-CHARINDEX('@',[EmailAddress])-1) AS L_TEST,
RIGHT([EmailAddress],LEN([EmailAddress])-CHARINDEX('@',[EmailAddress])) AS R_TEST
FROM[Production].[ProductReview]

