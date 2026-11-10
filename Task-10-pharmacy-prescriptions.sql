-- TASK 10: PHARMACY PRESCRIPTIONS
CREATE TABLE t10_patient (patient_id VARCHAR(10) PRIMARY KEY, patient_name VARCHAR(100) NOT NULL);
CREATE TABLE t10_patient_allergy (patient_id VARCHAR(10) NOT NULL, allergy VARCHAR(100) NOT NULL, PRIMARY KEY (patient_id,allergy), FOREIGN KEY (patient_id) REFERENCES t10_patient(patient_id));
CREATE TABLE t10_medicine (med_id VARCHAR(10) PRIMARY KEY, med_name VARCHAR(100) NOT NULL);
CREATE TABLE t10_prescription (rx_id VARCHAR(10) PRIMARY KEY, patient_id VARCHAR(10) NOT NULL, FOREIGN KEY (patient_id) REFERENCES t10_patient(patient_id));
CREATE TABLE t10_prescription_medicine (rx_id VARCHAR(10) NOT NULL, med_id VARCHAR(10) NOT NULL, dose VARCHAR(20) NOT NULL, days INT NOT NULL, PRIMARY KEY (rx_id,med_id), FOREIGN KEY (rx_id) REFERENCES t10_prescription(rx_id), FOREIGN KEY (med_id) REFERENCES t10_medicine(med_id));
INSERT INTO t10_patient VALUES ('P1','Rina Sen'),('P2','Jamal Uddin');
INSERT INTO t10_patient_allergy VALUES ('P1','Penicillin'),('P1','Dust');
INSERT INTO t10_medicine VALUES ('M1','Paracetamol 500'),('M2','Azithromycin 250'),('M3','Omeprazole 20');
INSERT INTO t10_prescription VALUES ('RX1','P1'),('RX2','P2'),('RX3','P1');
INSERT INTO t10_prescription_medicine VALUES ('RX1','M1','1-1-1',5),('RX1','M2','1-0-0',3),('RX2','M1','1-0-1',4),('RX3','M3','1-0-0',14),('RX3','M1','0-0-1',3);