-- TASK 4: LIBRARY LOANS
CREATE TABLE t04_member_type (member_type VARCHAR(20) PRIMARY KEY, loan_limit INT NOT NULL);
CREATE TABLE t04_member (member_id VARCHAR(10) PRIMARY KEY, member_name VARCHAR(100) NOT NULL, member_type VARCHAR(20) NOT NULL, FOREIGN KEY (member_type) REFERENCES t04_member_type(member_type));
CREATE TABLE t04_book (isbn VARCHAR(10) PRIMARY KEY, book_title VARCHAR(150) NOT NULL);
CREATE TABLE t04_loan (loan_id VARCHAR(10) PRIMARY KEY, loan_date DATE NOT NULL, member_id VARCHAR(10) NOT NULL, isbn VARCHAR(10) NOT NULL, FOREIGN KEY (member_id) REFERENCES t04_member(member_id), FOREIGN KEY (isbn) REFERENCES t04_book(isbn));
INSERT INTO t04_member_type VALUES ('Student',3),('Faculty',10);
INSERT INTO t04_member VALUES ('M10','Tasnim Ara','Student'),('M11','Dr. Alam','Faculty'),('M12','Kabir Mia','Student'),('M13','Dr. Banu','Faculty');
INSERT INTO t04_book VALUES ('B01','Database Concepts'),('B02','Designing Data Systems'),('B03','Algorithms');
INSERT INTO t04_loan VALUES ('L001','2026-08-01','M10','B01'),('L002','2026-08-02','M11','B01'),('L003','2026-08-03','M10','B02'),('L004','2026-08-05','M12','B02'),('L005','2026-08-07','M13','B03');
