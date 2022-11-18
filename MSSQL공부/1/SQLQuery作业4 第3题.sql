SELECT name ,course_id FROM [guest].instructor_teaches WHERE year='2009';
SELECT dept_name , AVG(salary ) salary,YEAR FROM(SELECT id,name,dept_name, sum(salary) salary,YEAR FROM[guest].instructor_teaches GROUP BY id,name,dept_name,YEAR ) V GROUP BY dept_name,YEAR;
SELECT dept_name , AVG(salary ) salary,YEAR FROM(SELECT id,name,dept_name, sum(salary) salary,YEAR FROM[guest].instructor_teaches GROUP BY id,name,dept_name,YEAR ) V GROUP BY dept_name,YEAR HAVING  AVG(salary )>60000;


SELECT dept_name , AVG(salary ) salary,YEAR FROM(SELECT id,name,dept_name, sum(salary) salary,YEAR FROM[guest].instructor_teaches WHERE year='2010' GROUP BY id,name,dept_name,YEAR ) V GROUP BY dept_name,YEAR HAVING  AVG(salary ) <=70000;
SELECT course_id FROM [guest].instructor_teaches WHERE year='2010' GROUP BY course_id
SELECT course_id FROM [guest].instructor_teaches GROUP BY course_id HAVING COUNT(course_id) >1 ;
SELECT course_id FROM [guest].instructor_teaches
WHERE course_id NOT in(SELECT course_id FROM [guest].instructor_teaches WHERE year='2009' GROUP BY course_id) GROUP BY course_id;

SELECT ID from [guest].instructor_teaches WHERE salary < (SELECT min(salary) FROM [guest].instructor_teaches WHERE dept_name = 'Comp.Sci.'AND name='老师名字'
);

SELECT name from [guest].instructor_teaches WHERE salary < (SELECT min(salary) FROM [guest].instructor_teaches WHERE dept_name = 'Comp.Sci.' );
