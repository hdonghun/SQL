--선택 해주지 않으면 기본은 오름차순이다.(가장 오래된 데이터 부터 표시된다.) : ASC
--내림차순 : DESC

SELECT*FROM [Sales].[SalesOrderHeader] WHERE CustomerID='11091' ORDER BY OrderDate DESC