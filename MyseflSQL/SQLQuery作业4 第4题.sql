UPDATE [guest].instructor_teaches SET salary=salary*0.9
UPDATE [guest].instructor_teaches SET salary=salary*0.95 WHERE salary>70000
DELETE FROM [guest].instructor_teaches WHERE salary>70000