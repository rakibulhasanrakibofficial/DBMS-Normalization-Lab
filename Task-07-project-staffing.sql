-- TASK 7: PROJECT STAFFING
-- Source relation: PROJECT_STAFFING
-- Question: Normalize PROJECT_STAFFING into 1NF, 2NF and 3NF.
--
-- BUSINESS RULES:
-- 1. An employee can work on many projects and a project has many employees.
--    For each employee-project pair, record Role and Hours.
-- 2. An employee has one name and belongs to one department.
--    A department has one name.
-- 3. A project has one name.
--
-- FUNCTIONAL DEPENDENCIES:
-- EmpID -> EmpName, DeptID
-- DeptID -> DeptName
-- ProjectID -> ProjectName
-- (EmpID, ProjectID) -> Role, Hours
--
-- Candidate key of the original relation: (EmpID, ProjectID)
-- 1NF: All values are atomic; one row represents one employee-project pair.
-- 2NF: Remove partial dependencies on EmpID and ProjectID.
-- 3NF: Remove the transitive dependency EmpID -> DeptID -> DeptName.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop Task 7 tables in child-to-parent order.
DROP TABLE IF EXISTS t7_staffing;
DROP TABLE IF EXISTS t7_project;
DROP TABLE IF EXISTS t7_employee;
DROP TABLE IF EXISTS t7_department;

DROP TABLE IF EXISTS t7_2nf_staffing;
DROP TABLE IF EXISTS t7_2nf_project;
DROP TABLE IF EXISTS t7_2nf_employee;

DROP TABLE IF EXISTS t7_1nf_project_staffing;

-- =========================================================
-- FIRST NORMAL FORM (1NF)
-- =========================================================
-- All columns contain atomic values.
-- One row represents one employee working on one project.
-- Composite primary key: (EmpID, ProjectID).

CREATE TABLE t7_1nf_project_staffing (
    emp_id VARCHAR(10) NOT NULL,
    project_id VARCHAR(10) NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    dept_name VARCHAR(100) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (emp_id, project_id)
);

INSERT INTO t7_1nf_project_staffing VALUES
('E01','P10','Sabbir Ahmed','D1','Engineering','Payment Gateway','Developer',120),
('E01','P12','Sabbir Ahmed','D1','Engineering','Mobile App','Tech Lead',80),
('E02','P10','Rima Sultana','D2','QA','Payment Gateway','Tester',95),
('E03','P12','Zahid Hasan','D1','Engineering','Mobile App','Developer',150),
('E03','P10','Zahid Hasan','D1','Engineering','Payment Gateway','Developer',60);

SELECT * FROM t7_1nf_project_staffing;

-- =========================================================
-- SECOND NORMAL FORM (2NF)
-- =========================================================
-- Remove partial dependencies from the composite key:
-- EmpID -> EmpName, DeptID, DeptName
-- ProjectID -> ProjectName
-- (EmpID, ProjectID) -> Role, Hours
--
-- DeptName is intentionally retained with employee in this 2NF stage.
-- The transitive dependency DeptID -> DeptName is removed in 3NF.

CREATE TABLE t7_2nf_employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE t7_2nf_project (
    project_id VARCHAR(10) PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL
);

CREATE TABLE t7_2nf_staffing (
    emp_id VARCHAR(10) NOT NULL,
    project_id VARCHAR(10) NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES t7_2nf_employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES t7_2nf_project(project_id)
);

INSERT INTO t7_2nf_employee VALUES
('E01','Sabbir Ahmed','D1','Engineering'),
('E02','Rima Sultana','D2','QA'),
('E03','Zahid Hasan','D1','Engineering');

INSERT INTO t7_2nf_project VALUES
('P10','Payment Gateway'),
('P12','Mobile App');

INSERT INTO t7_2nf_staffing VALUES
('E01','P10','Developer',120),
('E01','P12','Tech Lead',80),
('E02','P10','Tester',95),
('E03','P12','Developer',150),
('E03','P10','Developer',60);

SELECT * FROM t7_2nf_employee;
SELECT * FROM t7_2nf_project;
SELECT * FROM t7_2nf_staffing;

-- =========================================================
-- THIRD NORMAL FORM (3NF)
-- =========================================================
-- Remove the transitive dependency:
-- EmpID -> DeptID -> DeptName
--
-- Final 3NF relations:
-- DEPARTMENT(DeptID, DeptName)
-- EMPLOYEE(EmpID, EmpName, DeptID)
-- PROJECT(ProjectID, ProjectName)
-- STAFFING(EmpID, ProjectID, Role, Hours)

CREATE TABLE t7_department (
    dept_id VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE t7_employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES t7_department(dept_id)
);

CREATE TABLE t7_project (
    project_id VARCHAR(10) PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL
);

CREATE TABLE t7_staffing (
    emp_id VARCHAR(10) NOT NULL,
    project_id VARCHAR(10) NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES t7_employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES t7_project(project_id)
);

INSERT INTO t7_department VALUES
('D1','Engineering'),
('D2','QA');

INSERT INTO t7_employee VALUES
('E01','Sabbir Ahmed','D1'),
('E02','Rima Sultana','D2'),
('E03','Zahid Hasan','D1');

INSERT INTO t7_project VALUES
('P10','Payment Gateway'),
('P12','Mobile App');

INSERT INTO t7_staffing VALUES
('E01','P10','Developer',120),
('E01','P12','Tech Lead',80),
('E02','P10','Tester',95),
('E03','P12','Developer',150),
('E03','P10','Developer',60);

-- Verify all final 3NF tables.
SELECT * FROM t7_department;
SELECT * FROM t7_employee;
SELECT * FROM t7_project;
SELECT * FROM t7_staffing;

-- Reconstruct the original staffing details using JOINs.
SELECT
    e.emp_id,
    s.project_id,
    e.emp_name,
    d.dept_id,
    d.dept_name,
    p.project_name,
    s.role_name,
    s.hours
FROM t7_staffing AS s
JOIN t7_employee AS e ON s.emp_id = e.emp_id
JOIN t7_department AS d ON e.dept_id = d.dept_id
JOIN t7_project AS p ON s.project_id = p.project_id
ORDER BY e.emp_id, s.project_id;
