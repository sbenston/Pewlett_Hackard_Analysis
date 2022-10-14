SELECT * FROM employees;

-- Selecting retirement range
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Select retirement based on age AND hire date
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table based on selection
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Recreate table with emp-no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments d
INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no;

-- Join retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info ri
LEFT JOIN dept_emp de ON ri.emp_no = de.emp_no;

-- Gets current employees into a table
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
INTO current_emp
FROM retirement_info ri
LEFT JOIN dept_emp de ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by dept no
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retirement
FROM current_emp ce
LEFT JOIN dept_emp de ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees e
INNER JOIN salaries s ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp de ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per dept
SELECT dm.dept_no, d.dept_name, dm.emp_no, ce.last_name, ce.first_name,
	dm.from_date, dm.to_date
INTO manager_info
FROM dept_manager dm
	INNER JOIN departments d ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp ce ON (dm.emp_no = ce.emp_no);
	
-- Dept retirees
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO dept_info
FROM current_emp ce
	INNER JOIN dept_emp de ON (ce.emp_no = de.emp_no)
	INNER JOIN departments d ON (de.dept_no = d.dept_no);
	
-- Retirees from Sales
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
FROM current_emp ce
	INNER JOIN dept_emp de ON (ce.emp_no = de.emp_no)
	INNER JOIN departments d ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

-- Retirees from Sales and Development
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
FROM current_emp ce
	INNER JOIN dept_emp de ON (ce.emp_no = de.emp_no)
	INNER JOIN departments d ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');