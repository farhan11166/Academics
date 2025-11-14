/*q1*/
CREATE TABLE enrolled(student_id TEXT,course_id TEXT,grade TEXT, PRIMARY KEY(student_id,course_id));
/*q2)*/NSERT INTO enrolled (student_id,course_id,grade ) SELECT student_id,course_id,grade FROM Enrollments;

/*q3)*/
UPDATE students
   SET department='Philosophy' WHERE name LIKE '%i%';
/*q4)*/ALTER TABLE Students ADD COLUMN email TEXT;
/*q5)*/UPDATE Students SET email =name||'@iitbhilai.ac.in';  
/*q6)*/
 SELECT * FROM students WHERE department='Computer Science';
/*q7)*/
SELECT name FROM Students JOIN Enrollments ON Students.student_id=Enrollments.student_id JOIN Courses  ON Enrollments.course_id=Courses.course_id WHERE Students.name=Courses.course_id;
/*q8)*/
 SELECT name,course_name FROM Students JOIN Enrollments ON Students.student_id=Enrollments.student_id JOIN Courses  ON Enrollments.course_id=Courses.course_id ORDER BY course_name ASC ;
/*q9)*/
SELECT  name,course_name FROM Students LEFT  JOIN Enrollments ON Students.student_id=Enrollments.student_id LEFT JOIN Courses  ON Enrollments.course_id=Courses.course_id ;

/*q 10)*/SELECT name FROM students where name  LIKE  'a%';
/*q11)*/ SELECT name,course_name FROM Students JOIN Enrollments ON Students.student_id=Enrollments.student_id JOIN Courses  ON Enrollments.course_id=Courses.course_id WHERE credits>3 ;
/*q12)*/SELECT  name,course_name FROM Students LEFT  JOIN Enrollments ON Students.student_id=Enrollments.student_id LEFT JOIN Courses  ON Enrollments.course_id=Courses.course_id WHERE course_name IS NULL;
