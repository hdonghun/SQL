	--SELECT * FROM[HumanResources].[Department]
	--AS�� ���ؼ� �÷��� �̸��� �������ְų� �������ش�.
	--SELECT 100+100 AS A_SUM, 100-100 AS A_MIN, 100*100 AS A_MUL, 100/100 AS A_DIV
	--Ư�� ����� AS�� �÷��� ��Ī�� �������ش�.
	SELECT NAME,ListPrice,LISTPRICE*1.1 AS U_PRICE FROM [Production].[Product] WHERE ListPrice>999