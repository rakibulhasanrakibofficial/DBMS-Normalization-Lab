-- TASK 12: CAR RENTAL
CREATE TABLE t12_customer (customer_id VARCHAR(10) PRIMARY KEY, customer_name VARCHAR(100) NOT NULL);
CREATE TABLE t12_car_class (car_class VARCHAR(30) PRIMARY KEY, daily_rate DECIMAL(10,2) NOT NULL);
CREATE TABLE t12_model (model VARCHAR(50) PRIMARY KEY, car_class VARCHAR(30) NOT NULL, FOREIGN KEY (car_class) REFERENCES t12_car_class(car_class));
CREATE TABLE t12_car (car_id VARCHAR(10) PRIMARY KEY, model VARCHAR(50) NOT NULL, FOREIGN KEY (model) REFERENCES t12_model(model));
CREATE TABLE t12_rental (car_id VARCHAR(10) NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL, customer_id VARCHAR(10) NOT NULL, PRIMARY KEY (car_id,start_date), FOREIGN KEY (car_id) REFERENCES t12_car(car_id), FOREIGN KEY (customer_id) REFERENCES t12_customer(customer_id));
INSERT INTO t12_customer VALUES ('C1','Tahsin Ali'),('C2','Mina Das'),('C3','Joy Barua');
INSERT INTO t12_car_class VALUES ('Compact',1800),('SUV',3500);
INSERT INTO t12_model VALUES ('Zen 5','Compact'),('Terra 7','SUV'),('Vela 3','Compact');
INSERT INTO t12_car VALUES ('CAR1','Zen 5'),('CAR2','Terra 7'),('CAR3','Vela 3');
INSERT INTO t12_rental VALUES ('CAR1','2026-09-01','2026-09-04','C1'),('CAR1','2026-09-10','2026-09-12','C2'),('CAR2','2026-09-02','2026-09-06','C1'),('CAR3','2026-09-03','2026-09-05','C3'),('CAR2','2026-09-12','2026-09-15','C2');