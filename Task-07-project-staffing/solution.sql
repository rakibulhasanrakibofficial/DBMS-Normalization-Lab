-- TASK 7: PROJECT STAFFING
CREATE TABLE t07_department (dept_id VARCHAR(10) PRIMARY KEY, dept_name VARCHAR(50) NOT NULL);
CREATE TABLE t07_employee (emp_id VARCHAR(10) PRIMARY KEY, emp_name VARCHAR(100) NOT NULL, dept_id VARCHAR(10) NOT NULL, FOREIGN KEY (dept_id) REFERENCES t07_department(dept_id));
CREATE TABLE t07_project (project_id VARCHAR(10) PRIMARY KEY, project_name VARCHAR(100) NOT NULL);
CREATE TABLE t07_project_assignment (emp_id VARCHAR(10) NOT NULL, project_id VARCHAR(10) NOT NULL, role_name VARCHAR(50) NOT NULL, hours INT NOT NULL, PRIMARY KEY (emp_id, project_id), FOREIGN KEY (emp_id) REFERENCES t07_employee(emp_id), FOREIGN KEY (project_id) REFERENCES t07_project(project_id));
INSERT INTO t07_department VALUES ('D1','Engineering'),('D2','QA');
INSERT INTO t07_employee VALUES ('E01','Sabbir Ahmed','D1'),('E02','Rima Sultana','D2'),('E03','Zahid Hasan','D1');
INSERT INTO t07_project VALUES ('P10','Payment Gateway'),('P12','Mobile App');
INSERT INTO t07_project_assignment VALUES ('E01','P10','Developer',120),('E01','P12','Tech Lead',80),('E02','P10','Tester',95),('E03','P12','Developer',150),('E03','P10','Developer',60);
