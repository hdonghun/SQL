--대부분의 모든 쿼리는 순차적으로, 단계적으로 작성하는 것이 좋습니다.
--단순 SELECT 작성하고 > 결합하고 > 집계처리 순으로 작성.

--[Purchasing].[PurchaseOrderHeader]와 [Purchasing].[Vendor] 테이블을 활용하여 
--각 벤더의 이름과, 총 주문 수량, 총 주문 금액을 출력하시요.

SELECT [VendorID], SUM([TotalDue]) AS ST, COUNT([VendorID]) AS CV FROM [Purchasing].[PurchaseOrderHeader], [Purchasing].[Vendor] WHERE
[VendorID]=[BusinessEntityID] Group by [VendorID] 
--INNER 하기--
SELECT [VendorID], SUM([TotalDue]), COUNT([VendorID]) FROM [Purchasing].[PurchaseOrderHeader], [Purchasing].[Vendor] WHERE [VendorID] = [BusinessEntityID]
