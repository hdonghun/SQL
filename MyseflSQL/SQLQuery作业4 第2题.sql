SELECT AVG([department].[budget]),[department].building FROM [guest].department GROUP BY [department].building
SELECT 'MAX'AS 'type',MAX([department].[budget]) AS 'budget',[department].building FROM [guest].department GROUP BY [department].building
UNION
SELECT 'MIN' AS 'type', min([department].[budget])AS 'budget',[department].building FROM [guest].department GROUP BY [department].building
;


SELECT AVG([student].tot_cred) AS 'avg_cred',SUM([student].tot_cred) AS 'sum_cred',[student].dept_name FROM [guest].student GROUP BY [student].dept_name
ORDER BY avg_cred DESC;

SELECT AVG([student].tot_cred) AS 'avg_cred',SUM([student].tot_cred) AS 'sum_cred',[student].dept_name FROM [guest].student GROUP BY [student].dept_name
  HAVING AVG([student].tot_cred)  > 50 ORDER BY avg_cred DESC ;

