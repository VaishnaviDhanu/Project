CREATE DATABASE blooddonar;
USE blooddonar;
CREATE TABLE Donor (
   DonorID INT PRIMARY KEY,
   FirstName VARCHAR(50),
   LastName VARCHAR(50),
   Age INT,
   Gender CHAR(6),
   bloodtypeID INT,
   ContactNumber VARCHAR(15),
   Address VARCHAR(100),
   FOREIGN KEY  (bloodtypeID) REFERENCES bloodtype( bloodtypeID )
);
CREATE TABLE BloodBank (
BloodBankID INT PRIMARY KEY,
BankName VARCHAR(50),
Location VARCHAR(100)
); 
CREATE TABLE BloodType (
BloodTypeID INT PRIMARY KEY,
BloodGroup VARCHAR(5),
RhFactor CHAR(1)
);
CREATE TABLE Donation (
    DonationID INT PRIMARY KEY,
    DonorID INT,
    BloodBankID INT,
    DateOfDonation DATE,
    FOREIGN KEY (DonorID) REFERENCES Donor(DonorID),
    FOREIGN KEY (BloodBankID) REFERENCES BloodBank(BloodBankID)
);
CREATE TABLE Recipient (
   RecipientID INT PRIMARY KEY,
   FirstName VARCHAR(50),
   LastName VARCHAR(50),
   Age INT,
   Gender CHAR(1),
   BloodTypeID INT,
   ContactNumber VARCHAR(15),
   Address VARCHAR(100),
   FOREIGN KEY (BloodTypeID) REFERENCES BloodType(BloodTypeID)
);
CREATE TABLE Transfusion (
TransfusionID INT PRIMARY KEY,
RecipientID INT,
DonationID INT,
DateOfTransfusion DATE,
FOREIGN KEY (RecipientID) REFERENCES Recipient(RecipientID),
FOREIGN KEY (DonationID) REFERENCES Donation(DonationID)
);
INSERT INTO BloodType (BloodTypeID,BloodGroup, RhFactor)
VALUES 
(1,'A', '+'),
(2,'A', '-'),
(3,'B', '+'),
(4,'B', '-'),
(5,'AB', '+'),
(6,'AB', '-'),
(7,'O', '+'),
(8,'O', '-');
INSERT INTO Donor (DonorID,FirstName, LastName, Age, Gender, BloodTypeID, ContactNumber, Address) VALUES 
(1,'John', 'Doe', 25, 'M', 1, '1234567890', '123 Elm St'),
(2,'Jane', 'Smith', 30, 'F', 2, '0987654321', '456 Oak St'),
(3,'Jeya', 'Shree', 31, 'F', 3, '8906543210', '234 sastri St'),
(4,'Ajma', 'Peter', 34, 'M', 2, '9876543213', '678 Thiru St'),
(5,'Sheik', 'Malu', 36, 'M', 4, '8321456892', '843 Perungudi St'),
(6,'Bob', 'Johnson', 40, 'M', 3, '5551112222', '789 Oak St'),
(7,'Alice', 'Williams', 28, 'F', 4, '4442221111', '321 Maple St'),
(8,'Mike', 'Davis', 35, 'M', 1, '6663338888', '901 Park Ave');

INSERT INTO BloodBank (BloodBankID,BankName, Location)
VALUES 
(1,'City Blood Bank', 'Downtown'),
(2,'LifeStream', 'Los Angeles'),
(3,'St. Mary Blood Bank', 'Chicago'),
(4,'Blood Donation Center', 'Houston'),
(5,'United Blood Services', 'Phoenix'),
(6,'Valley Hospital Blood Bank', 'Las Vegas'),
(7,'Red Cross Blood Bank', 'Philadelphia'),
(8,'Regional Blood Center', 'London');
INSERT INTO Donation (DonationID, BloodBankID, DateOfDonation)
 VALUES
(1, 1, '2024-10-01'),
(2, 2, '2024-10-05'),
(3, 1, '2024-09-07'),
(4, 3, '2024-02-05'),
(5, 2, '2024-08-01'),
(6, 4, '2024-02-02'),
(7, 2, '2024-09-07'),
(8, 1, '2024-08-02');
INSERT INTO Recipient ( RecipientID,FirstName, LastName, Age, Gender, BloodTypeID, ContactNumber, Address) 
VALUES
(1,'Alice', 'Johnson', 40, 'F', 3, '2233445566', '789 Pine St'),
(2,'Bob', 'Lee', 50, 'M', 2, '3344556677', '101 Maple St'),
(3,'Emily', 'Patel', 25, 'F', 2, '9876543210', '1234 Oak St'),
(4,'Ryan', 'Lee', 30, 'M', 1, '5551112222', '5678 Maple St'),
(5,'Sophia', 'Garcia', 28, 'F', 3, '4442221111', '9012 Pine St'),
(6,'Jackson', 'Brown', 35, 'M', 4, '6663338888', '3456 Cedar St'),
(7,'Ava', 'Wang', 22, 'F', 1, '7890123456', '7890 Elm St'),
(8,'Sweety', 'Laura', 24, 'F', 1, '8765432194', '567 gury St');
INSERT INTO Transfusion (TransfusionID,RecipientID, DonationID, DateOfTransfusion) 
VALUES
(1,1, 1, '2022-01-05'),
(2,2, 2, '2022-01-20'),
(3,3, 3, '2022-02-01'),
(4,4, 4, '2022-03-01'),
(5,5, 5, '2022-04-20'),
(6,6, 6, '2022-10-01'),
(7,7, 7, '2022-10-20'),
(8,8, 8, '2022-10-02');
SELECT * FROM Donor;
SELECT DonationID, Donor.FirstName, Donor.LastName, BloodBank.BankName, DateOfDonation  
FROM Donation   
JOIN Donor ON Donation.DonorID = Donor.DonorID 
JOIN BloodBank ON Donation.BloodBankID = BloodBank.BloodBankID;  

SELECT Donor.FirstName, Donor.LastName, BloodType.BloodGroup, BloodType.RhFactor, BloodBank.BankName, Donation. DateOfDonation
FROM Donation
JOIN Donor ON Donation.DonorID = Donor.DonorID  
JOIN BloodType ON  Donor.BloodTypeID = BloodType.BloodTypeID 
JOIN BloodBank ON Donation.BloodBankID = BloodBank.BloodBankID; 

SELECT Recipient.FirstName AS RecipientName, Donor.FirstName AS DonorName, Donation.DateOfDonation, Transfusion.DateOfTransfusion
FROM Transfusion
JOIN Recipient ON Transfusion.RecipientID = Recipient.RecipientID
JOIN Donation ON Transfusion.DonationID = Donation.DonationID
JOIN Donor ON Donation.DonorID = Donor.DonorID
WHERE Recipient.FirstName = 'Alice';

SELECT FirstName, LastName
FROM Recipient
WHERE RecipientID IN (
SELECT Transfusion.RecipientID
FROM Transfusion
JOIN Donation ON Transfusion.DonationID = Donation.DonationID
WHERE Donation.DonorID = 1
);

SELECT FirstName, LastName
FROM Donor
WHERE DonorID IN (
SELECT DISTINCT DonorID
FROM Donation
WHERE DonorID IN (
SELECT DonorID
FROM Donation
GROUP BY DonorID
HAVING COUNT(*)
)
);
CREATE VIEW DonationDetails AS
SELECT DonationID, Donor.FirstName, Donor.LastName, BloodBank.BankName, DateOfDonation
FROM Donation
JOIN Donor ON Donation.DonorID = Donor.DonorID
JOIN BloodBank ON Donation.BloodBankID = BloodBank.BloodBankID;

SELECT * FROM DonationDetails;
DELIMITER $$
CREATE PROCEDURE AddDonation (
    IN p_DonorID INT,
    IN p_BloodBankID INT,
    IN p_DateOfDonation DATE
)
BEGIN
    INSERT INTO Donation (DonorID, BloodBankID, DateOfDonation)
    VALUES (p_DonorID, p_BloodBankID, p_DateOfDonation);
END $$

DELIMITER ;

