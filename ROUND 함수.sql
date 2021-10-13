--SELECT ROUND(123.456,1) AS '첫번쨰 자리 반올림'

SELECT ROUND([ListPrice],1) FROM [Production].[Product] WHERE [ListPrice]>0