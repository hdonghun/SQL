--INNER JOIN�� ����ؼ�, �ۼ�
SELECT * FROM [Production].[Product] AS PP INNER JOIN [Production].[ProductDescription] AS PD
ON PP.PRODUCTID=PD.ProductDescriptionID
--Ư���� JOIN�� ���ص�, �⺻������ INNER JOIN�� �ȴ�. > INNER JOIN�� ������� �ʰ� ,(��ǥ)�� ��Ÿ����, �׿� ���� ON�� �ƴ϶� WHERE ������ ����Ѵ�.
SELECT * FROM [Production].[Product] AS PP , [Production].[ProductDescription] AS PD
WHERE PP.PRODUCTID=PD.ProductDescriptionID
