-- TASK 9: BANK LOANS
-- Question: Normalize LOAN_MASTER into 1NF, 2NF and 3NF.
--
-- BUSINESS RULES:
-- A loan belongs to one customer, is issued by one branch,
-- and has one loan type and one principal amount.
-- A customer has one name; a branch is in one city.
-- Each loan type has one standard interest rate.
--
-- FUNCTIONAL DEPENDENCIES:
-- LoanID -> CustID, BranchCode, LoanType, Principal
-- CustID -> CustName
-- BranchCode -> BranchCity
-- LoanType -> InterestRate
--
-- LoanID is a single-attribute primary key.
-- 1NF: All values are atomic.
-- 2NF: Already satisfied because the primary key has only one attribute;
--      no partial dependency can exist.
-- 3NF: Separate Customer, Branch and LoanType to remove transitive
--      dependencies from LoanID.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

DROP TABLE IF EXISTS t9_loan;
DROP TABLE IF EXISTS t9_customer;
DROP TABLE IF EXISTS t9_branch;
DROP TABLE IF EXISTS t9_loan_type;
DROP TABLE IF EXISTS t9_2nf_loan_master;
DROP TABLE IF EXISTS t9_1nf_loan_master;

-- ===================== 1NF =====================
CREATE TABLE t9_1nf_loan_master (
    loan_id INT PRIMARY KEY,
    cust_id VARCHAR(10) NOT NULL,
    cust_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(10) NOT NULL,
    branch_city VARCHAR(100) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    principal DECIMAL(15,2) NOT NULL
);

INSERT INTO t9_1nf_loan_master VALUES
(1,'CU1','Farzana Karim','BR1','Dhaka','Home',9.0,4500000),
(2,'CU2','Habib Rahman','BR2','Chattogram','Car',10.5,1800000),
(3,'CU2','Habib Rahman','BR2','Chattogram','Home',9.0,3200000),
(4,'CU3','Rubel Mia','BR1','Dhaka','Personal',12.0,500000),
(5,'CU1','Farzana Karim','BR1','Dhaka','Home',9.0,2000000);

SELECT * FROM t9_1nf_loan_master;

-- ===================== 2NF =====================
-- No decomposition is needed: LoanID is a single-column primary key.
-- The 2NF relation therefore has the same attributes as the 1NF relation.
-- Transitive dependencies are removed in the 3NF stage.
CREATE TABLE t9_2nf_loan_master (
    loan_id INT PRIMARY KEY,
    cust_id VARCHAR(10) NOT NULL,
    cust_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(10) NOT NULL,
    branch_city VARCHAR(100) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    principal DECIMAL(15,2) NOT NULL
);

INSERT INTO t9_2nf_loan_master VALUES
(1,'CU1','Farzana Karim','BR1','Dhaka','Home',9.0,4500000),
(2,'CU2','Habib Rahman','BR2','Chattogram','Car',10.5,1800000),
(3,'CU2','Habib Rahman','BR2','Chattogram','Home',9.0,3200000),
(4,'CU3','Rubel Mia','BR1','Dhaka','Personal',12.0,500000),
(5,'CU1','Farzana Karim','BR1','Dhaka','Home',9.0,2000000);

SELECT * FROM t9_2nf_loan_master;

-- ===================== 3NF =====================
-- Remove transitive dependencies:
-- LoanID -> CustID -> CustName
-- LoanID -> BranchCode -> BranchCity
-- LoanID -> LoanType -> InterestRate
CREATE TABLE t9_customer (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL
);

CREATE TABLE t9_branch (
    branch_code VARCHAR(10) PRIMARY KEY,
    branch_city VARCHAR(100) NOT NULL
);

CREATE TABLE t9_loan_type (
    loan_type VARCHAR(50) PRIMARY KEY,
    interest_rate DECIMAL(5,2) NOT NULL
);

CREATE TABLE t9_loan (
    loan_id INT PRIMARY KEY,
    cust_id VARCHAR(10) NOT NULL,
    branch_code VARCHAR(10) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    principal DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES t9_customer(cust_id),
    FOREIGN KEY (branch_code) REFERENCES t9_branch(branch_code),
    FOREIGN KEY (loan_type) REFERENCES t9_loan_type(loan_type)
);

INSERT INTO t9_customer VALUES
('CU1','Farzana Karim'),
('CU2','Habib Rahman'),
('CU3','Rubel Mia');

INSERT INTO t9_branch VALUES
('BR1','Dhaka'),
('BR2','Chattogram');

INSERT INTO t9_loan_type VALUES
('Home',9.0),
('Car',10.5),
('Personal',12.0);

INSERT INTO t9_loan VALUES
(1,'CU1','BR1','Home',4500000),
(2,'CU2','BR2','Car',1800000),
(3,'CU2','BR2','Home',3200000),
(4,'CU3','BR1','Personal',500000),
(5,'CU1','BR1','Home',2000000);

-- Verify final 3NF tables and reconstruct source rows.
SELECT * FROM t9_customer;
SELECT * FROM t9_branch;
SELECT * FROM t9_loan_type;
SELECT * FROM t9_loan;

SELECT l.loan_id, c.cust_id, c.cust_name, b.branch_code, b.branch_city,
       lt.loan_type, lt.interest_rate, l.principal
FROM t9_loan AS l
JOIN t9_customer AS c ON l.cust_id = c.cust_id
JOIN t9_branch AS b ON l.branch_code = b.branch_code
JOIN t9_loan_type AS lt ON l.loan_type = lt.loan_type
ORDER BY l.loan_id;
