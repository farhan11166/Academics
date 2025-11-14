SELECT emp_name FROM Employees JOIN Departments ON Employees.dept_id=Departments.dept_id WHERE Departments.dept_name='Marketing';
SELECT emp_name,salary FROM Employees WHERE Employees.salary > (SELECT AVG(salary) FROM Employees);
SELECT emp_name FROM Employees JOIN Assignments ON Employees.emp_id=Assignments.emp_id JOIN Projects ON Assignments.proj_id=Projects.proj_id WHERE Projects.proj_name='Project Phoenix';
SELECT emp_name FROM Employees LEFT  JOIN Assignments ON Employees.emp_id=Assignments.emp_id LEFT  JOIN Projects ON Assignments.proj_id=Projects.proj_id WHERE  Projects.proj_name IS NULL;
SELECT emp_name FROM Employees WHERE Employees.salary > (SELECT MIN(salary) FROM Employees JOIN Departments ON Employees.dept_id=Departments.dept_id WHERE Departments.dept_name='Marketing' );
SELECT emp_name FROM Employees WHERE Employees.salary > (SELECT MAX(salary) FROM Employees JOIN Departments ON Employees.dept_id=Departments.dept_id WHERE Departments.dept_name='Marketing' );
SELECT emp_name,hire_date FROM Employees WHERE strftime('%Y', Hire_date)='2023';
SELECT emp_name FROM Employees WHERE manager_id IS NULL;
SELECT emp_name FROM EMployees WHERE emp_name like '% Smith' UNION SELECT emp_name FROM Employees WHERE emp_name like'% Williams';
SELECT emp_name FROM EMployees WHERE hire_date>=date('now','-2 years');
SELECT e.emp_name FROM Employees e JOIN Departments d ON d.dept_id=e.dept_id WHERE d.dept_name='Engineering' AND e.emp_id NOT IN (SELECT a.emp_id FROM Assignments a JOIN Projects p ON p.proj_id=a.proj_id WHERE p.proj_name='Project Neptune');
SELECT d.dept_name, AVG(e.salary) AS avg_salary FROM Employees e JOIN Departments d ON d.dept_id = e.dept_id GROUP BY d.dept_id, d.dept_name HAVING AVG(e.salary) > (SELECT AVG(salary) FROM Employees);
ALTER  TABLE Employees
ADD COLUMN email TEXT;
UPDATE Employees
SET email= LOWER(emp_name  ||  (SELECT dept_name FROM Employees JOIN Departments ON Employees.dept_id=Departments.dept_id )|| '.com');
CREATE TABLE HighEarners(
emp_id INTEGER PRIMARY KEY,
emp_name TEXT);
INSERT INTO HighEarners(emp_id,emp_name)
SELECT emp_id,emp_name
FROM Employees
WHERE salary>95000;

