-- DELIVERABLE 1

--Create retirement_titles table 
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
-- Create unique_titles table by using Distinct ON with Orderby to remove duplicate rows 
SELECT DISTINCT ON (emp_no) emp_no, 
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;
-- Create the retiring_titles table
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- DELIVERABLE 2
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no, t.to_date DESC;

-- Additional Queries

-- There are 90398 current employees born between '1952-01-01' AND '1955-12-31' who are retiring.
SELECT SUM (count) 
FROM retiring_titles;

-- Group the retiring employees by department
-- Results indicate that Development, Production, and Sales are the top 3 departments that will have the most number of job vacancies

SELECT DISTINCT ON(ut.emp_no) ut.emp_no, de.dept_no
INTO ret_empno_depno
FROM unique_titles as ut
INNER JOIN dept_emp as de
ON ut.emp_no = de.emp_no
ORDER BY ut.emp_no, de.to_date DESC; 

SELECT d.dept_name, COUNT(red.emp_no)
FROM ret_empno_depno as red
INNER JOIN departments as d
ON red.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY COUNT(red.emp_no) DESC; 

-- Count the number of employees on the mentorship_eligibility table
-- There are 1,549 retirement-ready current employees born between January 1, 1965 and December 31, 1965 who are qualified to mentor the next generation of employees. 
SELECT COUNT(emp_no) 
FROM mentorship_eligibility;

-- Group the mentorship_eligible table by titles
-- The top 3 titles/roles held by these 1,549 qualified mentors are Senior Staff, Senior Engineer and Engineer
SELECT COUNT(emp_no), title
FROM mentorship_eligibility
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Group the qualifying mentors by department
-- Results indicate that Development, Production, and Sales are the top 3 departments that will have the most number of mentors

SELECT DISTINCT ON (me.emp_no) me.emp_no, de.dept_no
INTO ment_empno_depno
FROM mentorship_eligibility as me
INNER JOIN dept_emp as de
ON me.emp_no= de.emp_no 
ORDER BY me.emp_no, de.to_date DESC; 

SELECT d.dept_name, COUNT(med.emp_no)
FROM ment_empno_depno as med
INNER JOIN departments as d
ON med.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY COUNT(med.emp_no) DESC;




