--[Purchasing].[PurchaseOrderHeader] �� [Purchasing].[ProductVendor] ���̺���
--Ȱ���Ͽ� �� ������ �̸��� �� �ֹ� ����, �� �ֹ� �ݾ��� ��� 

SELECT*FROM
(SELECT [VendorID], COUNT([VendorID]) AS VC, SUM([TotalDue]) AS VT FROM [Purchasing].[PurchaseOrderHeader] GROUP BY [VendorID]) AS PC INNER JOIN
(SELECT [BusinessEntityID], [Name] FROM [Purchasing].[Vendor]) AS VD ON PC.[VendorID] = VD.[BusinessEntityID]
