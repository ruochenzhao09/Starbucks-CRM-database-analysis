CREATE database STARBUCKS_DB;
USE STARBUCKS_DB;
CREATE TABLE STBX_CUSTOMER (
  Customer_ID CHAR(10) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(255) UNIQUE, 
  DateofBirth DATE NOT NULL,
  Street VARCHAR(255),
  City VARCHAR(50),
  PostalCode VARCHAR(20),
  Province VARCHAR(50),
  MembershipDate DATE,
  PRIMARY KEY (Customer_ID),
  CONSTRAINT chk_Customer_ID check (Customer_ID REGEXP '^C[0-9]{9}$')
);

DELIMITER $$

CREATE TRIGGER CheckDateOfBirthBeforeInsert
BEFORE INSERT ON STBX_CUSTOMER
FOR EACH ROW
BEGIN
  IF NEW.DateofBirth > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Date of Birth cannot be in the future.';
  END IF;
END$$

CREATE TRIGGER CheckMembershipDateBeforeInsert
BEFORE INSERT ON STBX_CUSTOMER
FOR EACH ROW
BEGIN
  IF NEW.MembershipDate > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Membership Date cannot be in the future.';
  END IF;
END$$

DELIMITER ;


CREATE TABLE CUSTOMERPHONE_NUMBER (
  Customer_ID CHAR(10) NOT NULL,
  Phone_Number BIGINT NOT NULL,
  PRIMARY KEY (Phone_Number),
  FOREIGN KEY (Customer_ID) REFERENCES STBX_CUSTOMER (Customer_ID)
);

DELIMITER $$

CREATE TRIGGER CheckPhoneNumberLengthBeforeInsert
BEFORE INSERT ON CUSTOMERPHONE_NUMBER
FOR EACH ROW
BEGIN
  IF NEW.Phone_Number < 10000000000 OR NEW.Phone_Number > 99999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Phone number must be exactly 11 digits.';
  END IF;
END$$

DELIMITER ;


CREATE TABLE STBX_ORDER (
Order_ID	  CHAR(10) NOT NULL, 
Customer_ID CHAR(10) NOT NULL,	 
TotalAmount DECIMAL(6,2) NOT NULL CHECK(TotalAmount >=0),
PaymentMethod VARCHAR(20) NOT NULL, 
Date DATE DEFAULT (CURRENT_DATE()),
PRIMARY KEY (Order_ID),
FOREIGN KEY (Customer_ID) REFERENCES STBX_CUSTOMER (Customer_ID),
CONSTRAINT chk_Order_ID check (Order_ID REGEXP '^O[0-9]{9}$')
);


CREATE TABLE REGCX_PARTICIPATE_INLPROG (
  Program_ID CHAR(10) NOT NULL,
  Customer_ID CHAR(10) NOT NULL,
  TotalPoint INT NOT NULL,
  ParticipateDate DATE NOT NULL,
  PRIMARY KEY (Program_ID),
  FOREIGN KEY (Customer_ID) REFERENCES STBX_CUSTOMER (Customer_ID),
  CHECK (TotalPoint >= 0),
  CONSTRAINT chk_Program_ID check (Program_ID REGEXP '^P[0-9]{9}$')
);

DELIMITER $$

CREATE TRIGGER CheckParticipateDateBeforeInsert
BEFORE INSERT ON REGCX_PARTICIPATE_INLPROG
FOR EACH ROW
BEGIN
  IF NEW.ParticipateDate > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Participate Date cannot be in the future.';
  END IF;
END$$

DELIMITER ;


CREATE TABLE CONNECTWITH (
  Order_ID CHAR(10) NOT NULL,
  Program_ID CHAR(10) NOT NULL,
  PointEarned INT CHECK (PointEarned >= 0),
  RewardsRedeemed INT CHECK (RewardsRedeemed >= 0),
  PRIMARY KEY (Order_ID),
  FOREIGN KEY (Program_ID) REFERENCES REGCX_PARTICIPATE_INLPROG (Program_ID)
);



CREATE TABLE NONREGISTERED_CUSTOMER (
Customer_ID  CHAR(10) NOT NULL,
PRIMARY KEY (Customer_ID),
FOREIGN KEY (Customer_ID) REFERENCES STBX_CUSTOMER (Customer_ID)
);

CREATE TABLE STBX_FEEDBACK (
Feedback_ID CHAR(10) NOT NULL,
Date DATE NOT NULL,
Rating INT CHECK (Rating >= 1 AND Rating <= 5),
Comment VARCHAR(255),
Customer_ID CHAR(10) NOT NULL,
Product_ID CHAR(10) NOT NULL,
PRIMARY KEY (Feedback_ID),
FOREIGN KEY (Customer_ID) REFERENCES STBX_CUSTOMER (Customer_ID),
CONSTRAINT chk_Feedback_ID CHECK (Feedback_ID REGEXP '^F[0-9]{9}$')
);

DELIMITER $$

CREATE TRIGGER CheckFeedbackDateBeforeInsert
BEFORE INSERT ON STBX_FEEDBACK
FOR EACH ROW
BEGIN
  IF NEW.Date > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Date cannot be in the future.';
  END IF;
END$$

DELIMITER ;


CREATE TABLE STBX_PRODUCT(
Product_ID CHAR(10) NOT NULL,
Product_Name VARCHAR(20) Unique,
Product_Type VARCHAR(50) NOT NULL,
PRIMARY KEY (Product_ID),
CONSTRAINT chk_Product_ID CHECK (Product_ID REGEXP '^PD[0-9]{8}$')
);


CREATE TABLE FEEDBACKIMPROVE_PRODUCT(
Feedback_ID	CHAR(10) NOT NULL,
Product_ID  CHAR(10) NOT NULL,
PRIMARY KEY (Feedback_ID, Product_ID),
FOREIGN KEY (Feedback_ID) REFERENCES STBX_FEEDBACK (Feedback_ID),
FOREIGN KEY (Product_ID) REFERENCES STBX_PRODUCT (Product_ID)
);


CREATE TABLE STBXAPP_ORDER(
Order_ID CHAR(10) NOT NULL,
PRIMARY KEY  (Order_ID),
FOREIGN KEY (Order_ID) REFERENCES STBX_ORDER (Order_ID)
);


CREATE TABLE INSTORE_ORDER (
Order_ID  CHAR(10)  NOT NULL,
PRIMARY KEY (Order_ID),
FOREIGN KEY (Order_ID) REFERENCES STBX_ORDER (Order_ID)
);


CREATE TABLE THIRDPARTY_ORDER(
Order_ID  CHAR(10)  NOT NULL,
PRIMARY KEY  (Order_ID),
FOREIGN KEY (Order_ID) REFERENCES STBX_ORDER (Order_ID)
);


CREATE TABLE CXPAYMENT_INFO(
Payment_Method_ID CHAR(20) NOT NULL,
TotalAmount	DECIMAL(6,2) NOT NULL CHECK  (TotalAmount >=0),
Order_ID CHAR(10) NOT NULL,
PRIMARY KEY  (Payment_Method_ID),
FOREIGN KEY (Order_ID) REFERENCES STBX_ORDER (Order_ID),
CONSTRAINT chk_Payment_Method_ID CHECK (Payment_Method_ID REGEXP '^PM[0-9]{8}$')
);

CREATE TABLE CX_TRANSACTIONS(
Transaction_ID CHAR(10) NOT NULL,
Order_ID CHAR(10) NOT NULL,
Product_Name VARCHAR(20) Unique,
TotalAmount DECIMAL(6,2) NOT NULL CHECK  (TotalAmount >=0),	
Quantity INT CHECK (Quantity >= 0),
PRIMARY KEY  (Transaction_ID),
FOREIGN KEY (Order_ID) REFERENCES STBX_ORDER (Order_ID),
CONSTRAINT chk_Transaction_ID CHECK (Transaction_ID REGEXP '^T[0-9]{9}$')
);


CREATE TABLE TRAN_CONTAINS(
Product_ID CHAR(10) NOT NULL,
Transaction_ID CHAR(10) NOT NULL,
PRIMARY KEY  (Product_ID, Transaction_ID),
FOREIGN KEY (Product_ID) REFERENCES STBX_PRODUCT (Product_ID),
FOREIGN KEY (Transaction_ID) REFERENCES CX_TRANSACTIONS (Transaction_ID)
);

INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) VALUES 
('C000000001', 'John Doe', 'john.doe@email.com', '1990-01-01', '123 Main St', 'Anytown', 'A1B2C3', 'ProvinceX', '2022-01-01'),
('C000000002', 'Jane Smith', 'jane.smith@email.com', '1992-02-02', '456 Oak St', 'Othertown', 'B2C3D4', 'ProvinceY', '2022-01-02'),
('C000000003', 'Jim Bean', 'jim.bean@email.com', '1994-03-03', '789 Pine St', 'Sometown', 'C3D4E5', 'ProvinceZ', '2022-01-03'),
('C000000004', 'Alice Johnson', 'alice.johnson@email.com', '1985-04-04', '1010 Maple St', 'Lakeview', 'A4B5C6', 'ProvinceA', '2022-02-01'),
('C000000005', 'Bob Brown', 'bob.brown@email.com', '1978-05-05', '2020 Birch St', 'Hilltown', 'B5C6D7', 'ProvinceB', '2022-02-02'),
('C000000006', 'Carol White', 'carol.white@email.com', '1991-06-06', '3030 Cedar St', 'Rivertown', 'C6D7E8', 'ProvinceC', '2022-02-03'),
('C000000007', 'David Wilson', 'david.wilson@email.com', '1988-07-07', '4040 Oak St', 'Coastcity', 'D7E8F9', 'ProvinceD', '2022-02-04'),
('C000000008', 'Eve Black', 'eve.black@email.com', '1993-08-08', '5050 Pine St', 'Mountainview', 'E8F9G1', 'ProvinceE', '2022-02-05'),
('C000000009', 'Frank Green', 'frank.green@email.com', '1970-09-09', '6060 Elm St', 'Lakeside', 'F9G1H2', 'ProvinceF', '2022-02-06'),
('C000000010', 'Grace Hall', 'grace.hall@email.com', '1982-10-10', '7070 Spruce St', 'Beachside', 'G1H2I3', 'ProvinceG', '2022-02-07'),
('C000000011', 'Henry Ford', 'henry.ford@email.com', '1995-11-11', '8080 Ash St', 'Clifftown', 'H2I3J4', 'ProvinceH', '2022-02-08'),
('C000000012', 'Ivy Gold', 'ivy.gold@email.com', '1980-12-12', '9090 Willow St', 'Sunsettown', 'I3J4K5', 'ProvinceI', '2022-02-09'),
('C000000013', 'Jake Silver', 'jake.silver@email.com', '1996-06-13', '1011 Maple St', 'Newtown', 'J4K5L6', 'ProvinceJ', '2022-02-10'),
('C000000014', 'Kara Blue', 'kara.blue@email.com', '1987-07-14', '1212 Birch St', 'Oldtown', 'K5L6M7', 'ProvinceK', '2022-02-11'),
('C000000015', 'Liam Night', 'liam.night@email.com', '1983-08-15', '1313 Cedar St', 'Easttown', 'L6M7N8', 'ProvinceL', '2022-02-12'),
('C000000016', 'Elena Gilbert', 'elena.gilbert@example.com', '1992-06-22', '404 Mystic Falls', 'Clifftown', 'H2I3J4', 'ProvinceH','2023-01-04'),
('C000000017', 'Damon Salvatore', 'damon.salvatore@example.com', '1991-05-21', '405 Mystic Falls', 'Sunsettown', 'I3J4K5', 'ProvinceI', '2023-01-05'),
('C000000018', 'Stefan Salvatore', 'stefan.salvatore@example.com', '1990-04-20', '406 Mystic Falls', 'Clifftown', 'H2I3J4', 'ProvinceH', '2023-01-06'),
('C000000019', 'Klaus Mikaelson', 'klaus.mikaelson@example.com', '1989-03-19', '407 flower st', 'Sunsettown', 'I3J4K5', 'ProvinceI', '2023-01-07'),
('C000000020', 'Caroline Forbes', 'caroline.forbes@example.com', '1988-02-18', '408 waterfall st', 'Easttown', 'L6M7N8', 'ProvinceL', '2023-01-08'),
('C000000021', 'Bonnie Bennett', 'bonnie.bennett@example.com', '1987-01-17', '409 Mystic Falls', 'Clifftown', 'H2I3J4', 'ProvinceH', '2023-01-09'),
('C000000022', 'Jeremy Gilbert', 'jeremy.gilbert@example.com', '1986-12-16', '410 Javis st', 'Sunsettown', 'I3J4K5', 'ProvinceI', '2023-01-10'),
('C000000023', 'Tyler Lockwood', 'tyler.lockwood@example.com', '1985-11-15', '411 waterfall st', 'Easttown', 'L6M7N8', 'ProvinceL', '2023-01-11'),
('C000000024', 'Matt Donovan', 'matt.donovan@example.com', '1984-10-14', '412 Mystic Falls', 'Mystic Falls', '10009', 'ProvinceI', '2023-01-12'),
('C000000025', 'Alaric Saltzman', 'alaric.saltzman@example.com', '1983-09-13', '413 Bluejay st', 'Sunsettown', 'I3J4K5', 'ProvinceI', '2023-01-13'),
('C000000026', 'Lily Brown', 'lbrown@example.com', '1997-08-12', '1011 Maple St', 'Newtown', 'J4K5L6', 'ProvinceJ','2023-01-14'),
('C000000027', 'Mary Craig', 'Mary.C@example.com', '1989-08-22', '414 Mystic Falls', 'Mystic Falls', 'F9G1H2', 'ProvinceA', '2023-01-01'),
('C000000028', 'Angela Mad', 'Angela.Mad@example.com', '2010-08-12', '212 Birch St', 'Oldtown', 'K5L6M7', 'ProvinceK', '2023-01-14'),
('C000000029', 'Kisten Gilbery', 'Kisten.G@example.com', '1999-10-24', '1012 Maple St', 'Newtown', 'J4K5L6', 'ProvinceJ','2023-01-14'),
('C000000030', 'Leo Brenden', 'leo.Brenden@example.com', '1982-01-31', '414 Mystic Falls', 'Mystic Falls', '10014', 'ProvinceK', '2023-01-14');


INSERT INTO CUSTOMERPHONE_NUMBER (Customer_ID, Phone_Number) VALUES 
('C000000001', 10000000001),
('C000000002', 10000000002),
('C000000003', 10000000003),
('C000000004', 10000000004),
('C000000005', 10000000005),
('C000000006', 10000000006),
('C000000007', 10000000007),
('C000000008', 10000000008),
('C000000009', 10000000009),
('C000000010', 10000000010),
('C000000011', 10000000011),
('C000000012', 10000000012),
('C000000013', 10000000013),
('C000000014', 10000000014),
('C000000015', 10000000015),
('C000000016', 10000000016),
('C000000017', 10000000017),
('C000000018', 10000000018);


INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) VALUES 
('O000000001', 'C000000001', 15.99, 'Credit Card', '2022-01-01'),
('O000000002', 'C000000002', 9.99, 'Debit Card', '2022-01-02'),
('O000000003', 'C000000003', 4.99, 'Cash', '2022-01-03'),
('O000000004', 'C000000004', 12.99, 'Credit Card', '2022-01-04'),
('O000000005', 'C000000005', 7.99, 'Credit Card', '2022-01-05'),
('O000000006', 'C000000006', 3.50, 'Cash', '2022-01-06'),
('O000000007', 'C000000007', 6.75, 'Credit Card', '2022-01-07'),
('O000000008', 'C000000008', 11.25, 'Debit Card', '2022-01-08'),
('O000000009', 'C000000009', 5.50, 'Credit Card', '2022-01-09'),
('O000000010', 'C000000010', 8.40, 'Cash', '2022-01-10'),
('O000000011', 'C000000011', 14.20, 'Debit Card', '2022-01-11'),
('O000000012', 'C000000012', 5.60, 'Credit Card', '2022-01-12'),
('O000000013', 'C000000013', 9.80, 'Credit Card', '2022-01-13'),
('O000000014', 'C000000014', 10.99, 'Cash', '2022-01-14'),
('O000000015', 'C000000015', 20.00, 'Debit Card', '2022-01-15'),
('O000000016', 'C000000016', 5.60, 'Credit Card', '2022-01-15'),
('O000000017', 'C000000017', 20.00, 'Debit Card', '2022-01-15'),
('O000000018', 'C000000018', 20.78, 'Cash', '2022-01-16'),
('O000000019', 'C000000019', 40.87, 'Cash', '2022-01-17'),
('O000000020', 'C000000020', 20.00, 'Debit Card', '2022-01-18'),
('O000000021', 'C000000021', 29.10, 'Debit Card', '2022-01-19'),
('O000000022', 'C000000022', 24.50, 'Cash', '2022-01-20'),
('O000000023', 'C000000023', 22.10, 'Debit Card', '2022-01-21'),
('O000000024', 'C000000024', 11.15, 'Cash', '2022-01-22'),
('O000000025', 'C000000025', 17.10, 'Debit Card', '2022-01-23'),
('O000000026', 'C000000026', 29.80, 'Credit Card', '2022-01-23'),
('O000000027', 'C000000027', 21.10, 'Debit Card', '2022-01-24'),
('O000000028', 'C000000028', 5.75, 'Credit Card', '2022-01-24'),
('O000000029', 'C000000029', 8.10, 'Cash', '2022-01-25'),
('O000000030', 'C000000030', 27.80, 'Credit Card', '2022-01-26');



INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) VALUES 
('P000000001', 'C000000001', 100, '2022-01-01'),
('P000000002', 'C000000002', 200, '2022-01-02'),
('P000000003', 'C000000003', 300, '2022-01-03'),
('P000000004', 'C000000004', 400, '2022-01-04'),
('P000000005', 'C000000005', 500, '2022-01-05'),
('P000000006', 'C000000006', 600, '2022-01-06'),
('P000000007', 'C000000007', 700, '2022-01-07'),
('P000000008', 'C000000008', 800, '2022-01-08'),
('P000000009', 'C000000009', 900, '2022-01-09'),
('P000000010', 'C000000010', 1000, '2022-01-10'),
('P000000011', 'C000000011', 1100, '2022-01-11'),
('P000000012', 'C000000012', 1200, '2022-01-12'),
('P000000013', 'C000000013', 1300, '2022-01-13'),
('P000000014', 'C000000014', 1400, '2022-01-14'),
('P000000015', 'C000000015', 1500, '2022-01-15');



INSERT INTO NONREGISTERED_CUSTOMER (Customer_ID) VALUES 
('C000000016'),
('C000000017'),
('C000000018'),
('C000000019'),
('C000000020'),
('C000000021'),
('C000000022'),
('C000000023'),
('C000000024'),
('C000000025'),
('C000000026');

INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) VALUES 
('O000000001', 'P000000001', 50, 10),
('O000000002', 'P000000002', 30, 5),
('O000000003', 'P000000003', 20, 3),
('O000000004', 'P000000004', 40, 8),
('O000000005', 'P000000005', 35, 7),
('O000000006', 'P000000006', 25, 4),
('O000000007', 'P000000007', 45, 9),
('O000000008', 'P000000008', 55, 11),
('O000000009', 'P000000009', 60, 12),
('O000000010', 'P000000010', 70, 14),
('O000000011', 'P000000011', 65, 13),
('O000000012', 'P000000012', 75, 15),
('O000000013', 'P000000013', 80, 16),
('O000000014', 'P000000014', 85, 17),
('O000000015', 'P000000015', 90, 18);

INSERT INTO STBX_PRODUCT (Product_ID, Product_Name, Product_Type) VALUES 
('PD00000001', 'Coffee', 'Beverage'),
('PD00000002', 'Tea', 'Beverage'),
('PD00000003', 'Croissant', 'Food'),
('PD00000004', 'Muffin', 'Food'),
('PD00000005', 'Sandwich', 'Food'),
('PD00000006', 'Cake', 'Dessert'),
('PD00000007', 'Cookie', 'Dessert'),
('PD00000008', 'Salad', 'Food'),
('PD00000009', 'Wrap', 'Food'),
('PD00000010', 'Smoothie', 'Beverage'),
('PD00000011', 'Scone', 'Food'),
('PD00000012', 'Bagel', 'Food'),
('PD00000013', 'Latte', 'Beverage'),
('PD00000014', 'Cappuccino', 'Beverage'),
('PD00000015', 'Espresso', 'Beverage'),
('PD00000016', 'Frappe', 'Beverage'),
('PD00000017', 'Iced Tea', 'Beverage'),
('PD00000018', 'Hot Chocolate', 'Beverage');

INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID) VALUES 
('F000000001', '2022-01-01', 5, 'Great service!', 'C000000001', 'PD00000001'),
('F000000002', '2022-01-02', 4, 'Good experience overall.', 'C000000002', 'PD00000002'),
('F000000003', '2022-01-03', 3, 'Average.', 'C000000003', 'PD00000003'),
('F000000004', '2022-01-04', 5, 'Excellent product quality.', 'C000000004', 'PD00000004'),
('F000000005', '2022-01-05', 2, 'Needs improvement.', 'C000000005', 'PD00000005'),
('F000000006', '2022-01-06', 4, 'Fast delivery.', 'C000000006', 'PD00000006'),
('F000000007', '2022-01-07', 5, 'Very satisfied!', 'C000000007', 'PD00000007'),
('F000000008', '2022-01-08', 3, 'Could be better.', 'C000000008', 'PD00000008'),
('F000000009', '2022-01-09', 4, 'Nice atmosphere.', 'C000000009', 'PD00000009'),
('F000000010', '2022-01-10', 5, 'Love it!', 'C000000010', 'PD00000010'),
('F000000011', '2022-01-11', 1, 'Terrible experience.', 'C000000011', 'PD00000011'),
('F000000012', '2022-01-12', 4, 'Great customer service.', 'C000000012', 'PD00000012'),
('F000000013', '2022-01-13', 5, 'Amazing product!', 'C000000013', 'PD00000013'),
('F000000014', '2022-01-14', 3, 'Okay.', 'C000000014', 'PD00000014'),
('F000000015', '2022-01-15', 4, 'It is good.', 'C000000015', 'PD00000002');

INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID) VALUES 
('F000000001', 'PD00000001'),
('F000000002', 'PD00000002'),
('F000000003', 'PD00000003'),
('F000000004', 'PD00000004'),
('F000000005', 'PD00000005'),
('F000000006', 'PD00000006'),
('F000000007', 'PD00000007'),
('F000000008', 'PD00000008'),
('F000000009', 'PD00000009'),
('F000000010', 'PD00000010'),
('F000000011', 'PD00000011'),
('F000000012', 'PD00000012'),
('F000000013', 'PD00000013'),
('F000000014', 'PD00000014'),
('F000000015', 'PD00000002');


INSERT INTO STBXAPP_ORDER (Order_ID) VALUES 
('O000000001'),
('O000000002'),
('O000000003'),
('O000000004'),
('O000000005'),
('O000000006'),
('O000000007'),
('O000000008'),
('O000000009'),
('O000000010');

INSERT INTO INSTORE_ORDER (Order_ID) VALUES
('O000000011'),
('O000000012'),
('O000000013'),
('O000000014'),
('O000000015'),
('O000000016'),
('O000000017'),
('O000000018'),
('O000000019'),
('O000000020');

INSERT INTO THIRDPARTY_ORDER (Order_ID) VALUES
('O000000021'),
('O000000022'),
('O000000023'),
('O000000024'),
('O000000025'),
('O000000026'),
('O000000027'),
('O000000028'),
('O000000029'),
('O000000030');

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) VALUES 
('T000000001', 'O000000001', 'Coffee', 3.99, 1),
('T000000002', 'O000000002', 'Tea', 2.49, 1),
('T000000003', 'O000000003', 'Croissant', 1.99, 2),
('T000000004', 'O000000004', 'Muffin', 2.99, 1),
('T000000005', 'O000000005', 'Sandwich', 5.99, 1),
('T000000006', 'O000000006', 'Cake', 4.50, 1),
('T000000007', 'O000000007', 'Cookie', 1.75, 3),
('T000000008', 'O000000008', 'Salad', 6.99, 1),
('T000000009', 'O000000009', 'Wrap', 5.50, 2),
('T000000010', 'O000000010', 'Smoothie', 7.40, 1),
('T000000011', 'O000000011', 'Scone', 3.20, 2),
('T000000012', 'O000000012', 'Bagel', 2.80, 1),
('T000000013', 'O000000013', 'Latte', 4.80, 1),
('T000000014', 'O000000014', 'Cappuccino', 4.50, 1),
('T000000015', 'O000000015', 'Espresso', 3.00, 2);

INSERT INTO TRAN_CONTAINS (Product_ID, Transaction_ID) VALUES 
('PD00000001', 'T000000001'),
('PD00000002', 'T000000002'),
('PD00000003', 'T000000003'),
('PD00000004', 'T000000004'),
('PD00000005', 'T000000005'),
('PD00000006', 'T000000006'),
('PD00000007', 'T000000007'),
('PD00000008', 'T000000008'),
('PD00000009', 'T000000009'),
('PD00000010', 'T000000010'),
('PD00000011', 'T000000011'),
('PD00000012', 'T000000012'),
('PD00000013', 'T000000013'),
('PD00000014', 'T000000014'),
('PD00000015', 'T000000015');

INSERT INTO CXPAYMENT_INFO (Payment_Method_ID, TotalAmount, Order_ID) VALUES
('PM00000001', 15.99, 'O000000001'),
('PM00000002', 9.99, 'O000000002'),
('PM00000003', 4.99, 'O000000003'),
('PM00000004', 12.99,'O000000004'),
('PM00000005', 7.99, 'O000000005'),
('PM00000006', 3.5, 'O000000006'),
('PM00000007', 6.75, 'O000000007'), 
('PM00000008', 11.25, 'O000000008'),
('PM00000009', 5.50, 'O000000009'),
('PM00000010', 8.4, 'O000000010');


INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) VALUES 
('C000000032', 'Olivia Wilde', 'olivia.wilde@example.com', '1984-03-10', '616 Maple Ave', 'Greentown', 'N2O3P4', 'ProvinceN', '2023-04-02'),
('C000000033', 'Parker Posey', 'parker.posey@example.com', '1975-04-08', '717 Cedar Ln', 'Blueville', 'O3P4Q5', 'ProvinceO', '2023-05-03'),
('C000000034', 'Quentin Tarantino', 'quentin.tarantino@example.com', '1963-05-27', '818 Oak Dr', 'Redcity', 'P4Q5R6', 'ProvinceP', '2023-06-04'),
('C000000035', 'Rachel McAdams', 'rachel.mcadams@example.com', '1978-11-17', '919 Pine Pl', 'Whitetown', 'Q5R6S7', 'ProvinceQ', '2023-07-05'),
('C000000036', 'Seth Rogen', 'seth.rogen@example.com', '1982-04-15', '202 Birch Rd', 'Blacktown', 'R6S7T8', 'ProvinceR', '2023-08-06'),
('C000000037', 'Tina Fey', 'tina.fey@example.com', '1970-05-18', '303 Elm St', 'Yellowcity', 'S7T8U9', 'ProvinceS', '2023-09-07'),
('C000000038', 'Uma Thurman', 'uma.thurman@example.com', '1970-04-29', '404 Spruce Way', 'Orangetown', 'T8U9V1', 'ProvinceT', '2023-10-08'),
('C000000039', 'Vince Vaughn', 'vince.vaughn@example.com', '1970-03-28', '505 Walnut St', 'Purpleville', 'U9V1W2', 'ProvinceU', '2023-11-09'),
('C000000040', 'Willow Smith', 'willow.smith@example.com', '2000-10-31', '606 Chestnut Ave', 'Rainbow City', 'V1W2X3', 'ProvinceV', '2023-12-10'),
('C000000041', 'Xander Berkeley', 'xander.berkeley@example.com', '1955-12-16', '707 Palm Rd', 'Silver Springs', 'W2X3Y4', 'ProvinceW', '2023-03-11'),
('C000000042', 'Yara Shahidi', 'yara.shahidi@example.com', '2000-02-10', '808 Magnolia Blvd', 'Goldtown', 'X3Y4Z5', 'ProvinceX', '2023-04-12'),
('C000000043', 'Zoe Saldana', 'zoe.saldana@example.com', '1978-06-19', '909 Cherry Ln', 'Copperville', 'Y4Z5A6', 'ProvinceY', '2023-05-13'),
('C000000044', 'Amanda Seyfried', 'amanda.seyfried@example.com', '1985-12-03', '111 Acacia Ave', 'Bronzetown', 'Z5A6B7', 'ProvinceZ', '2023-06-14'),
('C000000045', 'Bruce Wayne', 'bruce.wayne@example.com', '1983-09-19', '1313 Mockingbird Ln', 'Gotham', 'A6B7C8', 'ProvinceA', '2023-07-15'),
('C000000046', 'Clark Kent', 'clark.kent@example.com', '1986-07-12', '1938 Sullivan Ln', 'Metropolis', 'B7C8D9', 'ProvinceB', '2023-08-16');


insert into STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate)
values 
-- ("C000100050", "James Smith", "j.smith@example.com", date("1984-03-02"), "123 Maple Drive", "Springfield", "V9S 1N3", "British Columbia", date("2019-06-01")),
('C000100051', 'Maria Garcia', 'm.garcia@example.com', '1979-07-22', '456 Oak Lane', 'Anytown', 'T5K 2L8', 'Alberta', '2020-07-15'),
('C000100052', 'Brian Johnson', 'b.johnson@example.com', '1992-11-08', '789 Pine Street', 'Centerville', 'R2D 4S2', 'Manitoba', '2018-10-20'),
('C000100053', 'Sophia Martinez', 's.martinez@example.com', '1988-12-30', '101 Birch Avenue', 'Lakeside', 'A1B 3C4', 'Newfoundland', '2019-12-05'),
('C000100054', 'David Lee', 'd.lee@example.com', '1975-05-16', '202 Cedar Blvd', 'Metroville', 'H3Z 2Y7', 'Quebec', '2021-02-18'),
('C000100055', 'Emma Gonzalez', 'e.gonzalez@example.com', '1981-04-25', '404 Spruce Court', 'Rivertown', 'B3K 5L8', 'Nova Scotia', '2019-08-22'),
('C000100056', 'Michael Brown', 'm.brown@example.com', '1990-01-14', '606 Elm Way', 'Hill Valley', 'V5N 1P3', 'British Columbia', '2021-05-30'),
('C000100057', 'Chloe Davis', 'c.davis@example.com', '1965-09-09', '707 Palm Street', 'Cliffside', 'S4P 3Y2', 'Saskatchewan', '2017-03-15'),
('C000100058', 'William Garcia', 'w.garcia@example.com', '2000-06-21', '808 Cedar Path', 'Brookfield', 'L2R 8N4', 'Ontario', '2020-09-23'),
('C000100059', 'Elizabeth Lee', 'e.lee@example.com', '1998-02-11', '909 Willow Lane', 'South Park', 'X1A 2B3', 'Northwest Territories', '2021-11-11');

INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) VALUES 
('O000000032', 'C000000008', 5.20, 'Debit Card', '2022-02-15'),
('O000000033', 'C000000009', 22.75, 'Cash', '2022-02-25'),
('O000000034', 'C000000010', 12.00, 'Credit Card', '2022-03-01'),
('O000000035', 'C000000011', 3.99, 'Cash', '2022-03-11'),
('O000000036', 'C000000012', 8.30, 'Debit Card', '2022-03-21'),
('O000000037', 'C000000013', 18.50, 'Credit Card', '2022-03-31'),
('O000000038', 'C000000014', 7.65, 'Cash', '2022-04-04'),
('O000000039', 'C000000015', 9.95, 'Debit Card', '2022-04-14'),
('O000000040', 'C000000016', 23.40, 'Credit Card', '2022-04-24'),
('O000000041', 'C000000017', 15.75, 'Cash', '2022-05-04'),
('O000000042', 'C000000018', 4.50, 'Debit Card', '2022-05-14'),
('O000000043', 'C000000019', 19.20, 'Credit Card', '2022-05-24'),
('O000000044', 'C000000020', 8.95, 'Cash', '2022-06-03'),
('O000000045', 'C000000021', 27.00, 'Debit Card', '2022-06-13'),
('O000000046', 'C000000022', 13.50, 'Credit Card', '2022-06-23'),
('O000000047', 'C000000023', 18.25, 'Cash', '2022-07-03'),
('O000000048', 'C000000024', 5.10, 'Debit Card', '2022-07-13'),
('O000000049', 'C000000025', 16.45, 'Credit Card', '2022-07-23'),
('O000000050', 'C000000026', 11.00, 'Cash', '2022-08-02'),
('O000000051', 'C000000027', 24.75, 'Debit Card', '2022-08-12'),
('O000000052', 'C000000028', 6.50, 'Credit Card', '2022-08-22'),
('O000000053', 'C000000029', 17.80, 'Cash', '2022-09-01'),
('O000000054', 'C000000030', 12.25, 'Debit Card', '2022-09-11'),
('O000000055', 'C000000030', 14.90, 'Credit Card', '2022-09-21'),
('O000000056', 'C000000032', 20.15, 'Cash', '2022-10-01'),
('O000000057', 'C000000033', 8.60, 'Debit Card', '2022-10-11'),
('O000000058', 'C000000034', 22.35, 'Credit Card', '2022-10-21'),
('O000000059', 'C000000035', 7.20, 'Cash', '2022-11-10'),
('O000000060', 'C000000036', 9.80, 'Debit Card', '2022-11-20'),
('O000000061', 'C000000037', 18.45, 'Credit Card', '2022-11-30'),
('O000000062', 'C000000038', 10.99, 'Cash', '2022-12-10'),
('O000000063', 'C000000039', 23.70, 'Debit Card', '2022-12-20');
