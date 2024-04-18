-- 1.4.1 Testing the SQL Schema Constraints
------------------ CONNECTWITH
-- Test Inserting Valid Data
INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) 
VALUES 
('O00000001', 'P000000016', 100, 20);

-- Test Inserting Duplicate Order_ID
INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) VALUES 
('O000000001', 'P000000016', 30, 15);
-- Error Code: 1062. Duplicate entry 'O000000001' for key 'CONNECTWITH.PRIMARY'

-- Test Inserting NULL Program_ID
INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) VALUES
('O000000017', NULL, 30, 15);
-- Error Code: 1048. Column 'Program_ID' cannot be null

-- Test Inserting Invalid Data (Negative PointEarned)
INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) 
VALUES 
('O000000017', 'P000000017', -10, 5);
-- Error Code: 3819. Check constraint 'CONNECTWITH_chk_1' is violated.

-- Test Inserting Invalid Data (Negative RewardsRedeemed)
INSERT INTO CONNECTWITH (Order_ID, Program_ID, PointEarned, RewardsRedeemed) 
VALUES 
('O000000018', 'P000000018', 50, -5);
-- Error Code: 3819. Check constraint 'CONNECTWITH_chk_2' is violated.

-- Test Updating Invalid Data (Negative PointEarned)
UPDATE CONNECTWITH
SET PointEarned = -10
WHERE Order_ID = 'O000000017';
-- Error Code: 3819. Check constraint 'CONNECTWITH_chk_1' is violated.

-- Test Deleting Data
DELETE FROM CONNECTWITH
WHERE Order_ID = 'O000000002';


---------------- CUSTOMERPHONE_NUMBER
-- Test Inserting Valid Data
INSERT INTO CUSTOMERPHONE_NUMBER (Customer_ID, Phone_Number) 
VALUES 
('C000000019', 10000000019); 
-- 1 row(s) affected

-- Test Inserting Null Customer_ID
INSERT INTO CUSTOMERPHONE_NUMBER (Customer_ID, Phone_Number) 
VALUES 
(null, 10000000001); 
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Inserting Duplicate Phone_Number
INSERT INTO CUSTOMERPHONE_NUMBER (Customer_ID, Phone_Number) 
VALUES 
('C000000020', 10000000001); 
-- Error Code: 1062. Duplicate entry '10000000001' for key 'CUSTOMERPHONE_NUMBER.PRIMARY'


--------------------- STBX_CUSTOMER
-- Test Inserting Valid Data
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000031', 'Test User', 'test.user@example.com', '1990-01-01', '123 Test St', 'Testcity', 'T1E2S3', 'Testprovince', '2022-01-01'); 

-- Test Inserting Duplicate Customer_ID
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000001', 'Duplicate User', 'duplicate.user@example.com', '1990-01-01', '123 Duplicate St', 'Duplicatecity', 'D1U2P3', 'Duplicateprovince', '2022-01-01'); 
-- Error Code: 1062. Duplicate entry 'C000000001' for key 'STBX_CUSTOMER.PRIMARY'

-- Test Inserting Null Customer_ID
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
(null, 'Duplicate User', 'duplicate.user@example.com', '1990-01-01', '123 Duplicate St', 'Duplicatecity', 'D1U2P3', 'Duplicateprovince', '2022-01-01'); 
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Inserting Duplicate Email
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000033', 'Invalid Email User', 'alice.johnson@email.com', '1990-01-01', '123 Invalid St', 'Invalidcity', 'I1N2V3', 'Invalidprovince', '2022-01-01');
-- Error Code: 1062. Duplicate entry 'alice.johnson@email.com' for key 'STBX_CUSTOMER.Email'

-- Test Inserting Null DateofBirth
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000035', 'Invalid Email User', 'gooday.good@email.com', null, '126 Invalid St', 'Invalidcity', 'I1N2V3', 'Invalidprovince', '2022-01-04');
-- Error Code: 1048. Column 'DateofBirth' cannot be null

-- Test Inserting null name
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000037', NULL, 'null@example.com', '1990-01-01', '456 Oak St', 'NullCity', 'N1U2L3', 'NullProvince', '2022-01-01');
-- Error Code: 1048. Column 'Name' cannot be null

-- Test Updating Name to NULL
UPDATE STBX_CUSTOMER
SET Name = NULL
WHERE Customer_ID = 'C000000030';
-- Error Code: 1048. Column 'Name' cannot be null

-- Test Updating Customer_ID to NULL
UPDATE STBX_CUSTOMER
SET Customer_ID = NULL
WHERE Customer_ID = 'C000000030';
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Deleting Data
DELETE FROM STBX_CUSTOMER
WHERE Customer_ID = 'C000000030';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`STBX_ORDER`, CONSTRAINT `STBX_ORDER_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Testing Inserting Data for City with Maximum Length
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) 
VALUES 
('C000000039', 'Max Length Test', 'max@example.com', '1990-01-01', 'This is a very long street name exceeding the maximum allowed length of 255 charactersThis is a very long street name exceeding the maximum allowed length of 255 charactersThis is a very long street name exceeding the maximum allowed length of 255 charactersThis is a very long street name exceeding the maximum allowed length of 255 characters', 'City with a very long name exceeding the maximum allowed length of 50 characters', '12345678901234567890', 'Province with a very long name exceeding the maximum allowed length of 50 charactersProvince with a very long name exceeding the maximum allowed length of 50 characters', '2022-01-01');
-- Error Code: 1406. Data too long for column 'City' at row 1

---------------------- STBX_ORDER
-- Test Inserting Valid Data
INSERT INTO STBX_CUSTOMER (Customer_ID, Name, Email, DateofBirth, Street, City, PostalCode, Province, MembershipDate) VALUES 
('C000000031', 'Brain Wang', 'B.W@example.com', '1982-02-7', '414 Mystic Falls', 'Mystic Falls', '10015', 'ProvinceK', '2023-01-15');

INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000031', 'C000000031', 18.50, 'Credit Card', '2022-01-27');

-- Test Inserting Duplicate Order_ID
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000001', 'C000000001', 15.99, 'Credit Card', '2022-01-28');
-- Error Code: 1062. Duplicate entry 'O000000001' for key 'STBX_ORDER.PRIMARY'

-- Test Inserting Null Order_ID
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
(null, 'C0000000031', 15.99, 'Credit Card', '2022-01-28');
-- Error Code: 1048. Column 'Order_ID' cannot be null

-- Test Inserting Non-existent Customer_ID
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000032', 'C000000034', 25.00, 'Debit Card', '2022-01-28');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`STBX_ORDER`, CONSTRAINT `STBX_ORDER_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Test Inserting NULL Customer_ID
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000033', NULL, 15.00, 'Cash', '2022-01-29'); 
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Inserting Negative TotalAmount
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000032', 'C000000032', -5.00, 'Credit Card', '2022-01-29');
-- Error Code: 3819. Check constraint 'STBX_ORDER_chk_1' is violated.

-- Test Inserting Invalid PaymentMethod
INSERT INTO STBX_ORDER (Order_ID, Customer_ID, TotalAmount, PaymentMethod, Date) 
VALUES 
('O000000033', 'C000000033', 10.00, NULL, '2022-01-30'); 
-- Error Code: 1048. Column 'PaymentMethod' cannot be null

-- Test Updating Customer_ID to Non-existent value
UPDATE STBX_ORDER
SET Customer_ID = 'C000000034'
WHERE Order_ID = 'O000000031';
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`STBX_ORDER`, CONSTRAINT `STBX_ORDER_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Test Updating TotalAmount to Negative
UPDATE STBX_ORDER
SET TotalAmount = -10.00
WHERE Order_ID = 'O000000031';
-- Error Code: 3819. Check constraint 'STBX_ORDER_chk_1' is violated.

-- Test Updating PaymentMethod to NULL
UPDATE STBX_ORDER
SET PaymentMethod = NULL
WHERE Order_ID = 'O000000031';
-- Error Code: 1048. Column 'PaymentMethod' cannot be null

-- Test Deleting Existing Data
DELETE FROM STBX_ORDER
WHERE Order_ID = 'O000000030'; 
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`THIRDPARTY_ORDER`, CONSTRAINT `THIRDPARTY_ORDER_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `STBX_ORDER` (`Order_ID`))


------------------- REGCX_PARTICIPATE_INPROG
-- Test Inserting Valid Data
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000016', 'C000000016', 1600, '2022-01-16');

-- Test Inserting Duplicate Program_ID
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000001', 'C000000017', 1700, '2022-01-17');
-- Error Code: 1062. Duplicate entry 'P000000001' for key 'REGCX_PARTICIPATE_INLPROG.PRIMARY'

-- Test Inserting Null Program_ID
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
(null, 'C000000017', 1700, '2022-01-17');
-- Error Code: 1048. Column 'Program_ID' cannot be null

-- Test Inserting Invalid Program_ID Format
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('INVALID_PROGRAM_ID', 'C000000017', 1700, '2022-01-17');
-- Error Code: 1406. Data too long for column 'Program_ID' at row 1

-- Test Inserting Non-existent Customer_ID
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000021', 'C000000999', 2100, '2022-01-21');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`REGCX_PARTICIPATE_INLPROG`, CONSTRAINT `REGCX_PARTICIPATE_INLPROG_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Test Inserting Null Customer_ID
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000021', null, 2100, '2022-01-21');
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Inserting Negative TotalPoint
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000017', 'C000000018', -1800, '2022-01-18');
-- Error Code: 3819. Check constraint 'REGCX_PARTICIPATE_INLPROG_chk_1' is violated.

-- Test Inserting Future ParticipateDate (Trigger)
INSERT INTO REGCX_PARTICIPATE_INLPROG (Program_ID, Customer_ID, TotalPoint, ParticipateDate) 
VALUES 
('P000000018', 'C000000019', 1900, DATE_ADD(CURDATE(), INTERVAL 1 DAY)); 
-- Error Code: 1644. Participate Date cannot be in the future.

-- Test Updating TotalPoint to Negative
UPDATE REGCX_PARTICIPATE_INLPROG
SET TotalPoint = -2000
WHERE Program_ID = 'P000000016';
-- Error Code: 3819. Check constraint 'REGCX_PARTICIPATE_INLPROG_chk_1' is violated.

-- Test Updating Customer_ID to Invalid Format
UPDATE REGCX_PARTICIPATE_INLPROG
SET Customer_ID = 'INVALID_CUSTOMER_ID'
WHERE Program_ID = 'P000000016';
-- Error Code: 1406. Data too long for column 'Customer_ID' at row 1

-- Test Deleting Existing Data
DELETE FROM REGCX_PARTICIPATE_INLPROG
WHERE Program_ID = 'P000000015';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`CONNECTWITH`, CONSTRAINT `CONNECTWITH_ibfk_1` FOREIGN KEY (`Program_ID`) REFERENCES `REGCX_PARTICIPATE_INLPROG` (`Program_ID`))

------------------- NONREGISTERED_CUSTOMER
-- Test Inserting Valid Data
INSERT INTO NONREGISTERED_CUSTOMER (Customer_ID) VALUES 
('C000000027');

-- Test Inserting Duplicate Customer_ID
INSERT INTO NONREGISTERED_CUSTOMER (Customer_ID) VALUES 
('C000000016');
-- Error Code: 1062. Duplicate entry 'C000000016' for key 'NONREGISTERED_CUSTOMER.PRIMARY'

-- Test Inserting Non-existent Customer_ID
INSERT INTO NONREGISTERED_CUSTOMER (Customer_ID) VALUES 
('C000000999');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`NONREGISTERED_CUSTOMER`, CONSTRAINT `NONREGISTERED_CUSTOMER_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Test Updating Customer_ID
UPDATE NONREGISTERED_CUSTOMER
SET Customer_ID = 'C000000018'
WHERE Customer_ID = 'C000000019'
-- Error Code: 1062. Duplicate entry 'C000000018' for key 'NONREGISTERED_CUSTOMER.PRIMARY'

------------------ STBX_FEEDBACK
-- Insert Test: Valid Feedback_ID
-- INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID) VALUES 
('F000000016', '2022-01-16', 4, 'Impressed with the service.', 'C000000016', 'PD00000016');

INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID) VALUES 
('F000000016', '2022-01-16', 4, 'Impressed with the service.', 'C000000016', 'PD00000016');

-- Test Insert: Attempt to Insert a Feedback with an Invalid Feedback ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F126789', '2022-01-16', 3, 'Test comment', 'C000000016', 'PD00000016');
-- Error Code: 3819. Check constraint 'chk_Feedback_ID' is violated.

-- Test Insert: Attempt to Insert a Feedback with an Existing Feedback ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000001', '2022-01-17', 4, 'Another comment', 'C000000017', 'PD00000017');
-- Error Code: 1062. Duplicate entry 'F000000001' for key 'STBX_FEEDBACK.PRIMARY'

-- Test Insert: Attempt to Insert a Feedback with a Null Feedback ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES (null,'2022-01-18', 5, 'Null ID comment', 'C000000018', 'PD00000018');
-- Error Code: 1048. Column 'Feedback_ID' cannot be null

-- Test Inserting a Future Date
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000020', '2024-03-20', 4, 'Future date comment', 'C000000020', 'PD00000020');
-- Error Code: 1644. Date cannot be in the future.

-- Test Inserting a Feedback with a Null Date
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000021', NULL, '3', 'Null date comment', 'C000000021', 'PD00000021');
-- Error Code: 1048. Column 'Date' cannot be null

-- Inserting a new feedback with a invalid rating
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000020', '2022-01-16', 8, 'Fair', 'C000000016', 'PD00000016');
-- Error Code: 3819. Check constraint 'STBX_FEEDBACK_chk_1' is violated.

-- Inserting a new feedback with an invalid comment (exceeding maximum length)
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000017', '2022-01-17', 4, 'This is an excessively long comment that exceeds the maximum allowed length. This comment should be truncated.This is an excessively long comment that exceeds the maximum allowed length. This comment should be truncated.This is an excessively long comment that exceeds the maximum allowed length. This comment should be truncated.', 'C000000017', 'PD00000017');
-- Error Code: 1406. Data too long for column 'Comment' at row 1

-- Inserting a new feedback with a non-existent customer ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000044', '2022-01-18', 3, 'Fair service', 'C000000999', 'PD00000018');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`STBX_FEEDBACK`, CONSTRAINT `STBX_FEEDBACK_ibfk_1` FOREIGN KEY (`Customer_ID`) REFERENCES `STBX_CUSTOMER` (`Customer_ID`))

-- Inserting a new feedback with a NULL customer ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000019', '2022-01-19', 4, 'Excellent experience', NULL, 'PD00000019');
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Inserting a new feedback with a NULL product ID
INSERT INTO STBX_FEEDBACK (Feedback_ID, Date, Rating, Comment, Customer_ID, Product_ID)
VALUES ('F000000021', '2022-01-21', 4, 'Excellent experience', 'C000000002', NULL);
-- Error Code: 1048. Column 'Product_ID' cannot be null

-- Test Update: Attempt to Update the Feedback ID with Existing Feedback_ID
UPDATE STBX_FEEDBACK
SET Feedback_ID = 'F000000016'
WHERE Feedback_ID = 'F000000001'; 
-- Error Code: 1048. Column 'Feedback_ID' cannot be null

-- Test Updating a date to future date
UPDATE STBX_FEEDBACK
SET Date = '2022-03-25'
WHERE Feedback_ID = 'F000000006';
-- Error Code: 1644. Date cannot be in the future.

-- Updating the rating of an existing feedback to an invalid rating
UPDATE STBX_FEEDBACK
SET Rating = 6
WHERE Feedback_ID = 'F000000014';
-- Error Code: 3819. Check constraint 'STBX_FEEDBACK_chk_1' is violated.

-- Updating the customer ID of an existing feedback to NULL
UPDATE STBX_FEEDBACK
SET Customer_ID = NULL
WHERE Feedback_ID = 'F000000014';
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Updating the customer ID of an existing feedback to a non-existent customer ID
UPDATE STBX_FEEDBACK
SET Customer_ID = 'C000000999'
WHERE Feedback_ID = 'F000000015';
-- Error Code: 1048. Column 'Customer_ID' cannot be null

-- Test Delete=: Attempt to Delete a Feedback
DELETE FROM STBX_FEEDBACK
WHERE Feedback_ID = 'F000000001'; 
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_1` FOREIGN KEY (`Feedback_ID`) REFERENCES `STBX_FEEDBACK` (`Feedback_ID`))

-- test Deleting a Feedback with a Null Date
DELETE FROM STBX_FEEDBACK
WHERE Date IS NULL;
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- Deleting a feedback with an invalid rating
DELETE FROM STBX_FEEDBACK
WHERE Feedback_ID = 'F000000011';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_1` FOREIGN KEY (`Feedback_ID`) REFERENCES `STBX_FEEDBACK` (`Feedback_ID`))

------------------ STBX_PRODUCT
INSERT INTO STBX_PRODUCT (Product_ID, Product_Name, Product_Type) 
VALUES ('PD12345678', 'Flatwhite', 'Beverage'); 

INSERT INTO STBX_PRODUCT (Product_ID, Product_Name, Product_Type) 
VALUES ('P123456789', 'Espresso', 'Beverage'); 
-- Error Code: 3819. Check constraint 'chk_Product_ID' is violated.

INSERT INTO STBX_PRODUCT (Product_ID, Product_Name, Product_Type) 
VALUES ('PD87654321', 'Latte', 'Beverage'); 
-- Error Code: 1062. Duplicate entry 'Latte' for key 'STBX_PRODUCT.Product_Name'


INSERT INTO STBX_PRODUCT (Product_ID, Product_Name) 
VALUES ('PD11223344', 'Cappuccino');
-- Error Code: 1364. Field 'Product_Type' doesn't have a default value

-- Inserting data violating Product_Name uniqueness constraint
INSERT INTO STBX_PRODUCT (Product_ID, Product_Name, Product_Type) VALUES 
('PD00000019', 'Coffee', 'Beverage');
-- Error Code: 1062. Duplicate entry 'Coffee' for key 'STBX_PRODUCT.Product_Name'

-- Updating Product_ID to violate format constraint
UPDATE STBX_PRODUCT SET Product_ID = 'PDX00000002' WHERE Product_Name = 'Tea';
-- Error Code: 1406. Data too long for column 'Product_ID' at row 1

-- Updating Product_Name to violate uniqueness constraint
UPDATE STBX_PRODUCT SET Product_Name = 'Coffee' WHERE Product_ID = 'PD00000002';
-- Error Code: 1062. Duplicate entry 'Coffee' for key 'STBX_PRODUCT.Product_Name'

-- Updating Product_Type to NULL
UPDATE STBX_PRODUCT SET Product_Type = NULL WHERE Product_ID = 'PD00000003';
-- Error Code: 1048. Column 'Product_Type' cannot be null

-- Deleting a row
DELETE FROM STBX_PRODUCT WHERE Product_ID = 'PD00000014';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `STBX_PRODUCT` (`Product_ID`))

-------------------------------------------------------------
------------- FEEDBACKIMPROVE_PRODUCT
-- Inserting valid data
INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID) VALUES 
('F000000016', 'PD00000015');

-- Inserting a duplicate record
INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID) VALUES 
('F000000015', 'PD00000002');
-- Error Code: 1062. Duplicate entry 'F000000015-PD00000002' for key 'FEEDBACKIMPROVE_PRODUCT.PRIMARY'

INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID)
VALUES ('F000000016', 'PD00000088');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `STBX_PRODUCT` (`Product_ID`))

INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID)
VALUES ('F999999999', 'P000000001');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_1` FOREIGN KEY (`Feedback_ID`) REFERENCES `STBX_FEEDBACK` (`Feedback_ID`))

INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID)
VALUES ('null', 'PD00000025');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_1` FOREIGN KEY (`Feedback_ID`) REFERENCES `STBX_FEEDBACK` (`Feedback_ID`))

INSERT INTO FEEDBACKIMPROVE_PRODUCT (Feedback_ID, Product_ID)
VALUES ('F000000017', 'null'); -- fail due to foreign key constraint on product_ID
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`FEEDBACKIMPROVE_PRODUCT`, CONSTRAINT `FEEDBACKIMPROVE_PRODUCT_ibfk_2` FOREIGN KEY (`Product_ID`) REFERENCES `STBX_PRODUCT` (`Product_ID`))

-- Updating Feedback_ID to violate foreign key constraint
UPDATE FEEDBACKIMPROVE_PRODUCT SET Feedback_ID = 'F000000016' WHERE Product_ID = 'PD00000002';

-- Updating Feedback_ID to NULL
UPDATE FEEDBACKIMPROVE_PRODUCT SET Feedback_ID = NULL WHERE Product_ID = 'PD00000001';
-- Error Code: 1048. Column 'Feedback_ID' cannot be null

-- Updating Product_ID to NULL
UPDATE FEEDBACKIMPROVE_PRODUCT SET Product_ID = NULL WHERE Feedback_ID = 'F000000003'; 
-- Error Code: 1048. Column 'Product_ID' cannot be null


------------------ STBXAPP_ORDER
-- Attempting to insert a duplicate Order_ID
INSERT INTO STBXAPP_ORDER (Order_ID) VALUES ('O000000001');
-- Error Code: 1062. Duplicate entry 'O000000001' for key 'STBXAPP_ORDER.PRIMARY'

-- Attempting to insert a valid Order_ID
INSERT INTO STBXAPP_ORDER (Order_ID) VALUES ('O000000050');

-- Attempting to update the Order_ID
UPDATE STBXAPP_ORDER SET Order_ID = 'O000000011' WHERE Order_ID = 'O000000001'; 

-- Attempting to insert a null Order_ID
INSERT INTO STBXAPP_ORDER (Order_ID) VALUES (null);
-- Error Code: 1048. Column 'Order_ID' cannot be null

-- Fail to insert into STBXAPP_ORDER with non-existing Order_ID
INSERT INTO STBXAPP_ORDER (Order_ID) 
VALUES ('O999999999');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`STBXAPP_ORDER`, CONSTRAINT `STBXAPP_ORDER_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `STBX_ORDER` (`Order_ID`))

-- Fail to insert duplicate Order_ID into STBXAPP_ORDER
INSERT INTO STBXAPP_ORDER (Order_ID) 
VALUES ('O000000003');
-- Error Code: 1062. Duplicate entry 'O000000003' for key 'STBXAPP_ORDER.PRIMARY'

-- Test Updating the Order_ID to NULL
UPDATE STBXAPP_ORDER SET Order_ID = NULL
WHERE Order_ID = 'O000000001';
-- Error Code: 1048. Column 'Order_ID' cannot be null

-- Attempting to delete a record
DELETE FROM STBXAPP_ORDER WHERE Order_ID = 'O000000003';


--------------- INSTORE_ORDER

-- Insert a valid Order_ID
INSERT INTO INSTORE_ORDER (Order_ID) VALUES
('O000000031');
-- Insert a duplicate Order_ID
INSERT INTO INSTORE_ORDER (Order_ID) VALUES
('O000000011');
-- Error Code: 1062. Duplicate entry 'O000000011' for key 'INSTORE_ORDER.PRIMARY'

-- Insert with null Order_ID
INSERT INTO INSTORE_ORDER (Order_ID) 
VALUES ('null');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`INSTORE_ORDER`, CONSTRAINT `INSTORE_ORDER_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `STBX_ORDER` (`Order_ID`))

-- Insert with non-existing Order_ID
INSERT INTO INSTORE_ORDER (Order_ID) 
VALUES ('O999999999');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`INSTORE_ORDER`, CONSTRAINT `INSTORE_ORDER_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `STBX_ORDER` (`Order_ID`))

-- Attempting to update the Order_ID to NULL
UPDATE INSTORE_ORDER SET Order_ID = NULL WHERE Order_ID = 'O000000011';
-- Error Code: 1048. Column 'Order_ID' cannot be null

-- Deleting a record with a non-existing Order_ID
DELETE FROM INSTORE_ORDER WHERE Order_ID = 'O000000077';


--------------------- ThirdParty_order
-- Inserting a record without violating any constraints
INSERT INTO THIRDPARTY_ORDER (Order_ID) VALUES ('O000000034');

INSERT INTO THIRDPARTY_ORDER (Order_ID) 
VALUES ('null');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`THIRDPARTY_ORDER`, CONSTRAINT `THIRDPARTY_ORDER_ibfk_1` FOREIGN KEY (`Order_ID`) REFERENCES `STBX_ORDER` (`Order_ID`))

INSERT INTO THIRDPARTY_ORDER (Order_ID) 
VALUES ('O999999999');

INSERT INTO THIRDPARTY_ORDER (Order_ID) 
VALUES ('O000000023');

-- Attempting to update the Order_ID to NULL
UPDATE THIRDPARTY_ORDER SET Order_ID = NULL WHERE Order_ID = 'O000000021';
-- Error Code: 1048. Column 'Order_ID' cannot be null

------------------ PAYMENT INFO
INSERT INTO CXPAYMENT_INFO (Payment_Method_ID, TotalAmount, Order_ID) 
VALUES ('PM12345678', 5.00, 'O000000017'); 

INSERT INTO CXPAYMENT_INFO (Payment_Method_ID, TotalAmount, Order_ID) 
VALUES ('PMINVALIDID', 5.00, 'O000000001');

INSERT INTO CXPAYMENT_INFO (Payment_Method_ID, TotalAmount, Order_ID) 
VALUES ('PM12345679', -1.00, 'O000000002'); 

INSERT INTO CXPAYMENT_INFO (Payment_Method_ID, TotalAmount, Order_ID) 
VALUES ('PM12345680', 5.00, 'O999999999'); 

---------- CX_TRANSCATION

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) VALUES ('TX0000016', 'O000000001', 'coffee', 9.99, 1); 
-- Error Code: 3819. Check constraint 'chk_Transaction_ID' is violated.

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('null', 'O000000001', 'coffee', 9.99, 1); -- fail due to CHECK constraint on Transaction_ID

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('T000000020', 'O999999999', 'coffee', 9.99, 1); -- fail due to FOREIGN KEY constraint on Order_ID

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('T000000018', 'null', 'ice_cofeee', 9.99, 1); -- fail due to FOREIGN KEY constraint on Order_ID

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) VALUES ('T000000042', 'O000000042', 'bread', 20.00, 1); 

INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('T000000022', 'O000000001', 'ice-coffee', -20.00, 1);

-- Test Case: Successfully insert with a positive Quantity
INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('T000000023', 'O000000001', 'Positive Quantity', 9.99, 1); 

-- Test Case: Fail to insert with a negative Quantity
INSERT INTO CX_TRANSACTIONS (Transaction_ID, Order_ID, Product_Name, TotalAmount, Quantity) 
VALUES ('T000000024', 'O000000001', 'Negative Quantity', 9.99, -1); -- Should fail due to CHECK constraint on Quantity

-- Updating the TotalAmount of an existing transaction to a negative value
UPDATE CX_TRANSACTIONS
SET TotalAmount = -4.50
WHERE Transaction_ID = 'T000000002';
-- Error Code: 3819. Check constraint 'CX_TRANSACTIONS_chk_1' is violated.

-- Deleting transactions with TotalAmount less than 0
DELETE FROM CX_TRANSACTIONS
WHERE TotalAmount < 0;
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- Deleting transactions related to a specific Order_ID
DELETE FROM CX_TRANSACTIONS
WHERE Order_ID = 'O000000005';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`STARBUCKS_DB`.`TRAN_CONTAINS`, CONSTRAINT `TRAN_CONTAINS_ibfk_2` FOREIGN KEY (`Transaction_ID`) REFERENCES `CX_TRANSACTIONS` (`Transaction_ID`))

------- Transcontain
-- Invalid Insert: Adding a duplicate product in the same transaction
INSERT INTO TRAN_CONTAINS (Product_ID, Transaction_ID)
VALUES ('PD00000001', 'T000000001');
-- Error Code: 1062. Duplicate entry 'PD00000001-T000000001' for key 'TRAN_CONTAINS.PRIMARY'

-- Invalid Insert: Adding a product with a non-existent transaction
INSERT INTO TRAN_CONTAINS (Product_ID, Transaction_ID)
VALUES ('PD00000017', 'T000000999');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`TRAN_CONTAINS`, CONSTRAINT `TRAN_CONTAINS_ibfk_2` FOREIGN KEY (`Transaction_ID`) REFERENCES `CX_TRANSACTIONS` (`Transaction_ID`))

-- Invalid Update: Attempting to modify the product ID which is part of the primary key
UPDATE TRAN_CONTAINS
SET Product_ID = 'PD00000020'
WHERE Transaction_ID = 'T000000010';
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`STARBUCKS_DB`.`TRAN_CONTAINS`, CONSTRAINT `TRAN_CONTAINS_ibfk_1` FOREIGN KEY (`Product_ID`) REFERENCES `STBX_PRODUCT` (`Product_ID`))

-- Invalid Delete: Attempting to delete a transaction that does not exist
DELETE FROM TRAN_CONTAINS
WHERE Transaction_ID = 'T000000999';

INSERT INTO TRAN_CONTAINS (Transaction_ID, Product_ID)
VALUES ('null', 'PD00000025');

INSERT INTO TRAN_CONTAINS (Transaction_ID, Product_ID)
VALUES ('T000000017', 'null'); 

-- 1.4.2 Identifying Complex Constraints
-- LOYALTY POINTS CONSTRAINTS

-- Check for duplicate customer records
USE STARBUCKS_DB;
SELECT email, COUNT(*) as duplicate_count
FROM STBX_CUSTOMER
GROUP BY email
HAVING COUNT(*) > 1;

-- Check for orders with invalid customer IDs
USE STARBUCKS_DB;
SELECT order_id, customer_id
FROM STBX_ORDER
WHERE customer_id NOT IN (SELECT customer_id FROM STBX_CUSTOMER);

-- Check for orders with invalid payment methods (assuming a list of valid methods)
USE STARBUCKS_DB;
SELECT order_id, paymentmethod
FROM STBX_ORDER
WHERE paymentmethod NOT IN ('Cash', 'Credit Card', 'Debit Card');

-- Check for orders with negative values
USE STARBUCKS_DB;
SELECT order_id, TotalAmount
FROM STBX_ORDER
WHERE TotalAmount < 0;
