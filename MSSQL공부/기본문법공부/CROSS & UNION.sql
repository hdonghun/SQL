--#�⺻Ű PRIMARY KEY
--�����ͺ��̽�(���̺�) = { ��ü(ENTITIY), ����(RELATIONSHIP)�� ����}
	--�⺻Ű primary key ��ü�� �ĺ��ϴ� ������ ��--��� ���̺��� �⺻Ű ���� �����ϴ� �ʵ�(�Ӽ�)�� �޵�� ����
--CROSS JION 
SELECT * FROM [HumanResources].[Department] CROSS JOIN [Person].[AddressType]

--UNION -- �ΰ��� ���̺��� ��ģ��.( �� ���̺��� �ʵ��� ������ �����Ͽ��� �մϴ�. )
SELECT [BusinessEntityID], [LoginID]  FROM [HumanResources].[Employee]
UNIOM
SELECT [DepartmentID], [Name] FROM [HumanResources].[Department]
