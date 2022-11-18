--[Purchasing].[PurchaseOrderHeader] 와 [Purchasing].[ProductVendor] 테이블을
--활용하여 각 벤더의 이름과 총 주문 수량, 총 주문 금액을 출력 

SELECT*FROM
(SELECT [VendorID], COUNT([VendorID]) AS VC, SUM([TotalDue]) AS VT FROM [Purchasing].[PurchaseOrderHeader] GROUP BY [VendorID]) AS PC INNER JOIN
(SELECT [BusinessEntityID], [Name] FROM [Purchasing].[Vendor]) AS VD ON PC.[VendorID] = VD.[BusinessEntityID]
