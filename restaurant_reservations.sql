create database restaurant_reservations;
use restaurant_reservations;
CREATE TABLE Customers (
    customerId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerName VARCHAR(45) NOT NULL,
    contactInfo VARCHAR(200),
    PRIMARY KEY (customerId)
);
CREATE TABLE Reservations (
    reservationId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    reservationTime DATETIME NOT NULL,
    numberOfGuests INT NOT NULL,
    specialRequests VARCHAR(200),
    PRIMARY KEY (reservationId),
    FOREIGN KEY (customerId)
        REFERENCES Customers (customerId)
);
CREATE TABLE DiningPreferences (
    preferenceId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    favoriteTable VARCHAR(45),
    dietaryRestrictions VARCHAR(200),
    PRIMARY KEY (preferenceId),
    FOREIGN KEY (customerId)
        REFERENCES Customers (customerId)
);
INSERT INTO Customers (customerName, contactInfo) VALUES
('Marla Hernandez', 'marla.h@example.com'),
('john Smith', 'john.smith@example.com'),
('Marcos Garcia', 'marcos.garcia@example.com'),
('Alaia Lugo', 'alaia_lugo@example.com'),
('David Mendez', 'david0123@example.com');

INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES
(1, '2024-06-01 19:00:00', 4, 'Window view'),
(2, '2024-06-02 20:00:00', 2, 'Quiet table'),
(3, '2024-06-03 18:00:00', 3, 'Birthday cake'),
(4, '2024-05-21 20:00:00', 4, 'No Apple'),
(5, '2024-05-23 19:45:00', 5, 'toddler chair');

INSERT INTO DiningPreferences (customerId, favoriteTable, dietaryRestrictions) VALUES
(1, 'Table 5', 'None'),
(2, 'Table 3', 'Vegetarian'),
(3, 'Table 7', 'Gluten-Free'),
(4, 'Table 15', 'dairy-free'),
(5, 'Table 1', 'Vegan');
DELIMITER //
CREATE PROCEDURE FindReservations(IN custId INT)
BEGIN
    SELECT * FROM Reservations WHERE customerId = custId;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE AddSpecialRequest(IN resId INT, IN req VARCHAR(200))
BEGIN
    UPDATE Reservations SET specialRequests = req WHERE reservationId = resId;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE AddReservation(
    IN custName VARCHAR(45),
    IN contact VARCHAR(200),
    IN resTime DATETIME,
    IN numGuests INT,
    IN specRequests VARCHAR(200)
)
BEGIN
    DECLARE custId INT;
    
	SELECT customerId INTO custId FROM Customers WHERE customerName = custName AND contactInfo = contact;

    IF custId IS NULL THEN
		INSERT INTO Customers (customerName, contactInfo) VALUES (custName, contact);
		SET custId = last_insert_id();
    END IF;
    
    INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
    VALUES (custId, resTime, numGuests, specRequests);
END //
DELIMITER ;

CALL FindReservations(1);

CALL AddSpecialRequest(2, 'quiet table');

CALL Addreservation('Marla Hernandez', 'marla.h@example.com', '2024-06-02 20:00:00', 2, 'quiet table');