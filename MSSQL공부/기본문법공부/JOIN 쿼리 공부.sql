--��κ��� ��� ������ ����������, �ܰ������� �ۼ��ϴ� ���� �����ϴ�.
--�ܼ� SELECT �ۼ��ϰ� > �����ϰ� > ����ó�� ������ �ۼ�.

--[Purchasing].[PurchaseOrderHeader]�� [Purchasing].[Vendor] ���̺��� Ȱ���Ͽ� 
--�� ������ �̸���, �� �ֹ� ����, �� �ֹ� �ݾ��� ����Ͻÿ�.

SELECT [VendorID], SUM([TotalDue]) AS ST, COUNT([VendorID]) AS CV FROM [Purchasing].[PurchaseOrderHeader], [Purchasing].[Vendor] WHERE
[VendorID]=[BusinessEntityID] Group by [VendorID] 
--INNER �ϱ�--
SELECT [VendorID], SUM([TotalDue]), COUNT([VendorID]) FROM [Purchasing].[PurchaseOrderHeader], [Purchasing].[Vendor] WHERE [VendorID] = [BusinessEntityID]
