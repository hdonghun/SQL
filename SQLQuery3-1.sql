Use [Mysefl_Practices]
SELECT * FROM [HumanResources].[Department]

INSERT INTO [HumanResources].[Department](Name,GroupName,ModifiedDate) VALUES
('DATA SCIENCE', 'Research and Development', '2020-09-30')
--받는 필드가 3개이면, 입력 값도 3개를 충족 시켜줘야 한다.