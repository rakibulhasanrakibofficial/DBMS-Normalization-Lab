-- TASK 9: BANK LOANS
CREATE TABLE t09_customer (customer_id VARCHAR(10) PRIMARY KEY, customer_name VARCHAR(100) NOT NULL);
CREATE TABLE t09_branch (branch_code VARCHAR(10) PRIMARY KEY, branch_city VARCHAR(50) NOT NULL);
CREATE TABLE t09_loan_type (loan_type VARCHAR(30) PRIMARY KEY, interest_rate DECIMAL(5,2) NOT NULL);
CREATE TABLE t09_loan (loan_id INT PRIMARY KEY, customer_id VARCHAR(10) NOT NULL, branch_code VARCHAR(10) NOT NULL, loan_type VARCHAR(30) NOT NULL, principal DECIMAL(15,2) NOT NULL, FOREIGN KEY (customer_id) REFERENCES t09_customer(customer_id), FOREIGN KEY (branch_code) REFERENCES t09_branch(branch_code), FOREIGN KEY (loan_type) REFERENCES t09_loan_type(loan_type));
INSERT INTO t09_customer VALUES ('CU1','Farzana Karim'),('CU2','Habib Rahman'),('CU3','Rubel Mia');
INSERT INTO t09_branch VALUES ('BR1','Dhaka'),('BR2','Chattogram');
INSERT INTO t09_loan_type VALUES ('Home',9.0),('Car',10.5),('Personal',12.0);
INSERT INTO t09_loan VALUES (1,'CU1','BR1','Home',4500000),(2,'CU2','BR2','Car',1800000),(3,'CU2','BR2','Home',3200000),(4,'CU3','BR1','Personal',500000),(5,'CU1','BR1','Home',2000000);