/***********************************************************/
--PREP THE TABLE CREATION: DROP JUST IN CASE THEY PRE-EXIST:
/***********************************************************/
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;


/***********************************************************/
--CREATE TABLES BEFORE IMPORTING:
/***********************************************************/
CREATE TABLE departments (
	dept_no VARCHAR(5) PRIMARY KEY,
	dept_name VARCHAR(25)
);

CREATE TABLE dept_emp (
	emp_no INT,
	dept_no VARCHAR(5),
	from_date DATE,
	to_date DATE
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(5),
	emp_no INT,
	from_date DATE,
	to_date DATE
);

CREATE TABLE employees (
	emp_no INT PRIMARY KEY,
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	gender VARCHAR(1),
	hire_date DATE
);

CREATE TABLE salaries (
	emp_no INT PRIMARY KEY,
	salary INT,
	from_date DATE,
	to_date DATE
);

CREATE TABLE titles (
	emp_no INT,
	title VARCHAR,
	from_date DATE,
	to_date DATE
);


/***********************************************************/
--USE GUI TO IMPORT CSV FILES INTO ABOVE TABLES
/***********************************************************/




/***********************************************************/
--CONFIRM IMPORTS:
/***********************************************************/
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

