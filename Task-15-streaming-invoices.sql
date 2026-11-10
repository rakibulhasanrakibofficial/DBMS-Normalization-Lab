-- TASK 15: STREAMING INVOICES
CREATE TABLE t15_country (country VARCHAR(50) PRIMARY KEY, tax_pct DECIMAL(5,2) NOT NULL);
CREATE TABLE t15_subscriber (sub_id VARCHAR(10) PRIMARY KEY, country VARCHAR(50) NOT NULL, FOREIGN KEY (country) REFERENCES t15_country(country));
CREATE TABLE t15_subscriber_device (sub_id VARCHAR(10) NOT NULL, device VARCHAR(50) NOT NULL, PRIMARY KEY (sub_id,device), FOREIGN KEY (sub_id) REFERENCES t15_subscriber(sub_id));
CREATE TABLE t15_invoice (invoice_id VARCHAR(10) PRIMARY KEY, sub_id VARCHAR(10) NOT NULL, FOREIGN KEY (sub_id) REFERENCES t15_subscriber(sub_id));
CREATE TABLE t15_item (item_code VARCHAR(20) PRIMARY KEY, item_desc VARCHAR(100) NOT NULL);
CREATE TABLE t15_invoice_line (invoice_id VARCHAR(10) NOT NULL, item_code VARCHAR(20) NOT NULL, qty INT NOT NULL, PRIMARY KEY (invoice_id,item_code), FOREIGN KEY (invoice_id) REFERENCES t15_invoice(invoice_id), FOREIGN KEY (item_code) REFERENCES t15_item(item_code));
INSERT INTO t15_country VALUES ('Bangladesh',5),('India',18);
INSERT INTO t15_subscriber VALUES ('S1','Bangladesh'),('S2','India');
INSERT INTO t15_subscriber_device VALUES ('S1','TV-01'),('S1','Phone-07'),('S2','Laptop-02');
INSERT INTO t15_invoice VALUES ('INV-1','S1'),('INV-2','S2'),('INV-3','S1');
INSERT INTO t15_item VALUES ('PLAN-STD','Standard Plan'),('ADD-4K','4K Upgrade'),('PLAN-BAS','Basic Plan'),('ADD-MEM','Extra Member');
INSERT INTO t15_invoice_line VALUES ('INV-1','PLAN-STD',1),('INV-1','ADD-4K',1),('INV-2','PLAN-BAS',1),('INV-3','PLAN-STD',1),('INV-3','ADD-MEM',2);