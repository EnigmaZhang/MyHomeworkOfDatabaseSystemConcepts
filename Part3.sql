-- Coder: Enigma Zhang --

USE SCHOOL;

-- 3.1 --
SELECT title
FROM course
WHERE credits = 3
  AND dept_name = "Comp. Sci.";

SELECT DISTINCT takes.ID
FROM takes,
     teaches,
     instructor
WHERE (takes.course_id, takes.sec_id, takes.semester, takes.year) =
      (teaches.course_id, takes.sec_id, teaches.semester, teaches.year)
  AND teaches.ID = instructor.ID
  AND instructor.name = "Einstein";

SELECT MAX(salary)
FROM instructor;

SELECT *
FROM instructor
WHERE salary = (
    SELECT MAX(salary)
    FROM instructor
);

SELECT DISTINCT section.course_id, section.sec_id, COUNT(takes.ID) AS enrollment
FROM section,
     takes
WHERE (section.course_id, section.sec_id, section.year, section.semester) =
      (takes.course_id, takes.sec_id, takes.year, takes.semester)
  AND section.year = 2017
  AND section.semester = "Fall"
GROUP BY section.course_id, section.sec_id;

WITH E AS
         (SELECT DISTINCT section.course_id, section.sec_id, COUNT(takes.ID) AS enrollment
          FROM section,
               takes
          WHERE (section.course_id, section.sec_id, section.year, section.semester) =
                (takes.course_id, takes.sec_id, takes.year, takes.semester)
            AND section.year = 2017
            AND section.semester = "Fall"
          GROUP BY section.course_id, section.sec_id
         )
SELECT MAX(E.enrollment)
FROM E;

WITH E AS
         (SELECT DISTINCT section.course_id, section.sec_id, COUNT(takes.ID) AS enrollment
          FROM section,
               takes
          WHERE (section.course_id, section.sec_id, section.year, section.semester) =
                (takes.course_id, takes.sec_id, takes.year, takes.semester)
            AND section.year = 2017
            AND section.semester = "Fall"
          GROUP BY section.course_id, section.sec_id
         )
SELECT course_id, sec_id
FROM E
WHERE enrollment = (SELECT MAX(enrollment) FROM E)

-- 3.2 --
-- DDL --
DROP TABLE grade_points;
CREATE TABLE grade_points
(
    grade  VARCHAR(2)    NULL,
    points DECIMAL(2, 1) NOT NULL
);
INSERT INTO grade_points
VALUES ("A", 4.0),
       ("B+", 3.7),
       ("B", 3.4),
       ("B-", 3.0),
       ("C+", 2.7),
       ("C", 2.4),
       ("C-", 2.1),
       ("D+", 1.8),
       ("D", 1.5),
       ("D-", 1.2),
       ("E", 0);

(
    SELECT SUM(course.credits * G.points)
    FROM takes,
         course,
         grade_points AS G
    WHERE takes.ID = "12345"
      AND takes.course_id = course.course_id
      AND takes.grade = G.grade
)
UNION
-- When student does not take any course.
(
    SELECT 0
    FROM student
    WHERE ID = "12345"
      AND NOT EXISTS(SELECT * FROM takes WHERE ID = "12345")
);

(
    SELECT SUM(course.credits * G.points) / SUM(course.credits) AS GPA
    FROM takes,
         course,
         grade_points AS G
    WHERE takes.ID = "12345"
      AND takes.course_id = course.course_id
      AND takes.grade = G.grade
)
UNION
-- When student does not take any course.
(
    SELECT NULL
    FROM student
    WHERE ID = "12345"
      AND NOT EXISTS(SELECT * FROM takes WHERE ID = "12345")
);

(
    SELECT takes.ID, UM(course.credits * G.points) / SUM(course.credits) AS GPA
    FROM takes,
         course,
         grade_points AS G
    WHERE takes.course_id = course.course_id
      AND takes.grade = G.grade
    GROUP BY takes.ID
)
UNION
-- When student does not take any course.
(
    SELECT student.ID, NULL
    FROM student,
         takes
    WHERE NOT EXISTS(SELECT * FROM takes WHERE student.ID = takes.ID)
);

UPDATE instructor
SET salary = salary * 1.1
WHERE instructor.dept_name = "Comp. Sci.";

DELETE
FROM course
WHERE course_id NOT IN (SELECT course_id FROM section);

INSERT INTO instructor
SELECT student.ID, student.name, student.dept_name, 30000
FROM student
WHERE student.tot_cred > 100;

-- 3.6 --
SELECT dept_name
FROM department
WHERE LOWER(dept_name) LIKE "%sci%";

