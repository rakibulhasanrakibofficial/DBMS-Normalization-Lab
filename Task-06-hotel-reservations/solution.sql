-- TASK 6: HOTEL RESERVATIONS
CREATE TABLE t06_guest (guest_id VARCHAR(10) PRIMARY KEY, guest_name VARCHAR(100) NOT NULL);
CREATE TABLE t06_hotel (hotel_id VARCHAR(10) PRIMARY KEY, city VARCHAR(100) NOT NULL);
CREATE TABLE t06_hotel_room_rate (hotel_id VARCHAR(10) NOT NULL, room_type VARCHAR(30) NOT NULL, nightly_rate DECIMAL(10,2) NOT NULL, PRIMARY KEY (hotel_id, room_type), FOREIGN KEY (hotel_id) REFERENCES t06_hotel(hotel_id));
CREATE TABLE t06_reservation (booking_id VARCHAR(10) PRIMARY KEY, guest_id VARCHAR(10) NOT NULL, hotel_id VARCHAR(10) NOT NULL, room_type VARCHAR(30) NOT NULL, FOREIGN KEY (guest_id) REFERENCES t06_guest(guest_id), FOREIGN KEY (hotel_id, room_type) REFERENCES t06_hotel_room_rate(hotel_id, room_type));
CREATE TABLE t06_booking_service (booking_id VARCHAR(10) NOT NULL, service VARCHAR(60) NOT NULL, PRIMARY KEY (booking_id, service), FOREIGN KEY (booking_id) REFERENCES t06_reservation(booking_id));
INSERT INTO t06_guest VALUES ('G1','Maliha Khan'),('G2','Arif Billah'),('G3','Tania Rahim');
INSERT INTO t06_hotel VALUES ('H1',CONCAT('Cox',CHAR(39),'s Bazar')),('H2','Sylhet');
INSERT INTO t06_hotel_room_rate VALUES ('H1','Deluxe',8000),('H1','Standard',5000),('H2','Deluxe',6500),('H2','Standard',4200);
INSERT INTO t06_reservation VALUES ('B01','G1','H1','Deluxe'),('B02','G2','H1','Standard'),('B03','G1','H2','Deluxe'),('B04','G3','H2','Standard'),('B05','G2','H1','Deluxe');
INSERT INTO t06_booking_service VALUES ('B01','Breakfast'),('B01','Spa'),('B02','Breakfast'),('B04','Airport Pickup'),('B04','Breakfast');
