--OUT JOIN ½Ç½À
SELECT * FROM 
(SELECT [CustomerID] FROM [Sales].[SalesOrderHeader]
) AS CUST 
LEFT OUTER JOIN 
(SELECT [CustomerID] , COUNT([CustomerID]) AS COUTN_CUST, SUM([TotalDue]) AS TOTAL_AMT 
FROM [Sales].[SalesOrderHeader] GROUP BY [CustomerID]
) AS BUY_LIST
ON CUST.[CustomerID] = BUY_LIST.[CustomerID]




