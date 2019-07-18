/***********************************************************/
--Data Analysis Queries
/***********************************************************/


/***********************************************************/
-- 1. List the following details of each employee: 
--		employee number, last name, first name, gender, and salary.
/***********************************************************/
SELECT
	e.emp_no AS employee_number,
	e.last_name,
	e.first_name,
	e.gender,
	s.salary
FROM
	employees e
	
	LEFT JOIN salaries s
	ON e.emp_no = s.emp_no
;


/***********************************************************/
-- 2. List employees who were hired in 1986.
/***********************************************************/
SELECT
	emp_no,
	first_name,
	last_name,
	hire_date
FROM
	employees
WHERE
	hire_date BETWEEN '1986-01-01' AND '1986-12-31'
;


/***********************************************************/
-- 3. List the manager of each department with the following information: 
--		department number, department name, the manager's employee number, 
--		last name, first name, and start and end employment dates.
/***********************************************************/
SELECT
	dm.dept_no,
	d.dept_name,
	dm.emp_no AS manager_emp_no,
	e.last_name,
	e.first_name,
	dm.from_date AS start_date,
	dm.to_date AS end_date
FROM
	dept_manager dm
	
	INNER JOIN employees e
	ON e.emp_no = dm.emp_no
	
	LEFT JOIN departments d
	ON dm.dept_no = d.dept_no
;


/***********************************************************/
-- 4. List the department of each employee with the following information: 
--		employee number, last name, first name, and department name.
/***********************************************************/
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	
	LEFT JOIN dept_emp de
	ON e.emp_no = de.emp_no
	
	LEFT JOIN departments d
	ON de.dept_no = d.dept_no
;


/***********************************************************/
-- 5. List all employees whose first name is "Hercules" 
--		and last names begin with "B."
/***********************************************************/
SELECT
	e.emp_no,
	e.last_name,
	e.first_name
FROM
	employees e
WHERE
	LOWER(e.first_name) = 'hercules'
	AND LOWER(e.last_name) LIKE 'b%'
;


/***********************************************************/
-- 6. List all employees in the Sales department, including their 
--		employee number, last name, first name, and department name.
/***********************************************************/
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	
	INNER JOIN dept_emp de
	ON e.emp_no = de.emp_no
	
	INNER JOIN departments d
	ON de.dept_no = d.dept_no

WHERE
	LOWER(d.dept_name) = 'sales' 
;


/***********************************************************/
-- 7. List all employees in the Sales and Development departments, 
--		including their employee number, last name, first name, and department name.
/***********************************************************/
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	
	INNER JOIN dept_emp de
	ON e.emp_no = de.emp_no
	
	INNER JOIN departments d
	ON de.dept_no = d.dept_no

WHERE
	LOWER(d.dept_name) = 'sales' 
	OR LOWER(d.dept_name) = 'development'
;


/***********************************************************/
-- 8. In descending order, list the frequency count of employee last names, 
--	i.e., how many employees share each last name.
/***********************************************************/
SELECT
	e.last_name,
	COUNT(e.last_name) AS count_lastname
FROM
	employees e
	
GROUP BY e.last_name

ORDER BY COUNT(e.last_name) DESC


/***********************************************************/