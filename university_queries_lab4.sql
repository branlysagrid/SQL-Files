-- Task 1 : departments in either student or instructor
SELECT dept_name FROM student
UNION
SELECT dept_name FROM instructor
ORDER BY dept_name;

-- Task 2 : departments represented in both tables
SELECT dept_name FROM student
INTERSECT
SELECT dept_name FROM instructor
ORDER BY dept_name;

-- Task 3 : students without an advisor
SELECT id, name
FROM student
WHERE id IN (
    SELECT id FROM student
    EXCEPT
    SELECT s_id FROM advisor
)
ORDER BY id;

-- Task 4 : Enrollments with no recorded grade
SELECT id AS student_id, course_id, semester, year
FROM takes
WHERE grade IS NULL
ORDER BY id, course_id, semester, year;

-- Task 5 : Course credit summary
SELECT COUNT(*) AS total_courses,
       ROUND(AVG(credits), 2) AS average_credits,
       MIN(credits) AS minimum_credits,
       MAX(credits) AS maximum_credits
FROM course;

-- Task 6 : Instructor counts and salary statistics by department
SELECT dept_name,
       COUNT(*) AS instructor_count,
       ROUND(AVG(salary), 2) AS average_salary,
       SUM(salary) AS total_salary
FROM instructor
GROUP BY dept_name
ORDER BY average_salary DESC;

-- Task 7 : Departments offering more than one course
SELECT dept_name, COUNT(*) AS course_count
FROM course
GROUP BY dept_name
HAVING COUNT(*) > 1
ORDER BY dept_name;

-- Task 8 : Distinct student enrollment per course
SELECT c.course_id, c.title,
       COUNT(DISTINCT t.id) AS student_count
FROM course AS c
JOIN takes AS t ON t.course_id = c.course_id
GROUP BY c.course_id, c.title
ORDER BY student_count DESC, c.course_id;

