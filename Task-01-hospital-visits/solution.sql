-- TASK 1: HOSPITAL VISITS
CREATE TABLE t01_patient (patient_id VARCHAR(10) PRIMARY KEY, patient_name VARCHAR(100) NOT NULL);
CREATE TABLE t01_department (dept VARCHAR(50) PRIMARY KEY, building VARCHAR(50) NOT NULL);
CREATE TABLE t01_doctor (doctor_id VARCHAR(10) PRIMARY KEY, dept VARCHAR(50) NOT NULL, FOREIGN KEY (dept) REFERENCES t01_department(dept));
CREATE TABLE t01_visit (visit_id VARCHAR(10) PRIMARY KEY, visit_date DATE NOT NULL, patient_id VARCHAR(10) NOT NULL, doctor_id VARCHAR(10) NOT NULL, FOREIGN KEY (patient_id) REFERENCES t01_patient(patient_id), FOREIGN KEY (doctor_id) REFERENCES t01_doctor(doctor_id));
CREATE TABLE t01_visit_diagnosis (visit_id VARCHAR(10) NOT NULL, diagnosis VARCHAR(100) NOT NULL, PRIMARY KEY (visit_id, diagnosis), FOREIGN KEY (visit_id) REFERENCES t01_visit(visit_id));
INSERT INTO t01_patient VALUES ('P01','Rahim Uddin'),('P02','Nusrat Jahan'),('P03','Tanvir Hasan');
INSERT INTO t01_department VALUES ('Cardiology','Block A'),('Neurology','Block B');
INSERT INTO t01_doctor VALUES ('D10','Cardiology'),('D11','Neurology'),('D12','Cardiology');
INSERT INTO t01_visit VALUES ('V101','2026-03-02','P01','D10'),('V102','2026-03-02','P02','D11'),('V103','2026-03-05','P01','D10'),('V104','2026-03-06','P03','D12');
INSERT INTO t01_visit_diagnosis VALUES ('V101','Hypertension'),('V101','Diabetes'),('V102','Migraine'),('V103','Hypertension'),('V104','Heart disease'),('V104','Hypertension');
