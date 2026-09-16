IF DB_ID('TourismBookingDB') IS NULL
    CREATE DATABASE TourismBookingDB;
GO
USE TourismBookingDB;
GO

CREATE TABLE Town (
    Town_ID      INT IDENTITY(1,1) PRIMARY KEY,
    Town_Name    VARCHAR(60)  NOT NULL,
    Province     VARCHAR(40)  NOT NULL
);

CREATE TABLE Business (
    Business_ID     INT IDENTITY(1,1) PRIMARY KEY,
    Business_Name   VARCHAR(100) NOT NULL,
    Business_Type   VARCHAR(50)  NOT NULL,
    Contact_Email   VARCHAR(100) NOT NULL,
    Contact_Phone   VARCHAR(20)  NOT NULL,
    Town_ID         INT NOT NULL,
    CONSTRAINT FK_Business_Town FOREIGN KEY (Town_ID)
        REFERENCES Town(Town_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Attraction (
    Attraction_ID   INT IDENTITY(1,1) PRIMARY KEY,
    Attraction_Name VARCHAR(100) NOT NULL,
    Description     VARCHAR(500) NULL,
    Category        VARCHAR(50)  NOT NULL,
    Price           DECIMAL(8,2) NOT NULL DEFAULT 0,
    Business_ID     INT NOT NULL,
    Town_ID         INT NOT NULL,
    CONSTRAINT FK_Attraction_Business FOREIGN KEY (Business_ID)
        REFERENCES Business(Business_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_Attraction_Town FOREIGN KEY (Town_ID)
        REFERENCES Town(Town_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE AttractionContact (
    Contact_ID     INT IDENTITY(1,1) PRIMARY KEY,
    Contact_Name   VARCHAR(80)  NOT NULL,
    Contact_Phone  VARCHAR(20)  NOT NULL,
    Contact_Email  VARCHAR(100) NOT NULL,
    Attraction_ID  INT NOT NULL,
    CONSTRAINT FK_Contact_Attraction FOREIGN KEY (Attraction_ID)
        REFERENCES Attraction(Attraction_ID)
        ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE Tourist (
    Tourist_ID     INT IDENTITY(1,1) PRIMARY KEY,
    First_Name     VARCHAR(50)  NOT NULL,
    Last_Name      VARCHAR(50)  NOT NULL,
    Email          VARCHAR(100) NOT NULL UNIQUE,
    Phone          VARCHAR(20)  NOT NULL,
    Password_Hash  VARCHAR(255) NOT NULL
);

CREATE TABLE Booking (
    Booking_ID      INT IDENTITY(1,1) PRIMARY KEY,
    Tourist_ID      INT NOT NULL,
    Attraction_ID   INT NOT NULL,
    Booking_Date    DATE NOT NULL,
    Booking_Time    TIME NOT NULL,
    Participants    INT NOT NULL DEFAULT 1 CHECK (Participants BETWEEN 1 AND 20),
    Status          VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Confirmed','Changed','Cancelled','Attended')),
    Attended_YN     CHAR(1) NOT NULL DEFAULT 'N' CHECK (Attended_YN IN ('Y','N')),
    CONSTRAINT FK_Booking_Tourist FOREIGN KEY (Tourist_ID)
        REFERENCES Tourist(Tourist_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_Booking_Attraction FOREIGN KEY (Attraction_ID)
        REFERENCES Attraction(Attraction_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = 'Participants' AND Object_ID = OBJECT_ID('Booking'))
    ALTER TABLE Booking ADD Participants INT NOT NULL DEFAULT 1 CHECK (Participants BETWEEN 1 AND 20);

CREATE TABLE Review (
    Review_ID     INT IDENTITY(1,1) PRIMARY KEY,
    Booking_ID    INT NOT NULL UNIQUE,
    Tourist_ID    INT NOT NULL,
    Attraction_ID INT NOT NULL,
    Rating        TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment       VARCHAR(500) NULL,
    Review_Date   DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Booking FOREIGN KEY (Booking_ID)
        REFERENCES Booking(Booking_ID)
        ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_Review_Tourist FOREIGN KEY (Tourist_ID)
        REFERENCES Tourist(Tourist_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_Review_Attraction FOREIGN KEY (Attraction_ID)
        REFERENCES Attraction(Attraction_ID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE SystemUser (
    User_ID       INT IDENTITY(1,1) PRIMARY KEY,
    Username      VARCHAR(50)  NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Role          VARCHAR(20)  NOT NULL CHECK (Role IN ('Administrator','Assistant'))
);
GO

INSERT INTO Town (Town_Name, Province) VALUES
('Stellenbosch','Western Cape'),('Hazyview','Mpumalanga'),('Clarens','Free State');

INSERT INTO Business (Business_Name, Business_Type, Contact_Email, Contact_Phone, Town_ID) VALUES
('Kruger National Zoo','Wildlife','info@krugerzoo.co.za','0131234567',2),
('Stellenbosch Wine Estates','Wine Tasting','info@sbwines.co.za','0219876543',1);

INSERT INTO Attraction (Attraction_Name, Description, Category, Price, Business_ID, Town_ID) VALUES
('Big Five Safari Tour','Guided game drive','Wildlife',850.00,1,2),
('Vineyard Wine Tasting','Tasting of 6 local wines','Wine Tasting',250.00,2,1);

INSERT INTO AttractionContact (Contact_Name, Contact_Phone, Contact_Email, Attraction_ID) VALUES
('Khanyane Malawe','0827001234','khanyane@krugerzoo.co.za',1),
('Elmien Roux','0836547890','elmien@sbwines.co.za',2);

INSERT INTO Tourist (First_Name, Last_Name, Email, Phone, Password_Hash) VALUES
('Johnny','Depp','johnny.depp@example.com','0741234567','4b385df5630c6c24a7b7994f8ff9e672c763dc8ccf645a080a8a6145ecf92ae3');

INSERT INTO SystemUser (Username, Password_Hash, Role) VALUES
('admin1','e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7','Administrator'),
('assist1','ea2f22d3e9a550763208911a65cdc7efdc03812df0bbe6944ab7c30c76827727','Assistant');
GO

UPDATE Attraction SET Price = 900.00 WHERE Attraction_ID = 1;
DELETE FROM AttractionContact WHERE Contact_ID = 2;
GO

SELECT
    a.Attraction_Name,
    t.Town_Name,
    COUNT(b.Booking_ID)        AS Total_Bookings,
    SUM(a.Price)                AS Total_Revenue
FROM Attraction a
JOIN Town t          ON a.Town_ID = t.Town_ID
LEFT JOIN Booking b  ON b.Attraction_ID = a.Attraction_ID
                     AND b.Status <> 'Cancelled'
GROUP BY a.Attraction_Name, t.Town_Name
ORDER BY Total_Revenue DESC;

SELECT
    b.Booking_ID, a.Attraction_Name, b.Booking_Date, b.Booking_Time, b.Status
FROM Booking b
JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
JOIN Tourist tr   ON b.Tourist_ID = tr.Tourist_ID
WHERE tr.Email = 'johnny.depp@example.com'
  AND b.Booking_Date BETWEEN '2026-01-01' AND '2026-12-31'
ORDER BY b.Booking_Date;
GO

CREATE OR ALTER PROCEDURE usp_MakeBooking
    @Tourist_ID    INT,
    @Attraction_ID INT,
    @Booking_Date  DATE,
    @Booking_Time  TIME,
    @Participants  INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Booking (Tourist_ID, Attraction_ID, Booking_Date, Booking_Time, Participants, Status, Attended_YN)
    VALUES (@Tourist_ID, @Attraction_ID, @Booking_Date, @Booking_Time, @Participants, 'Confirmed', 'N');

    SELECT SCOPE_IDENTITY() AS New_Booking_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_ChangeBooking
    @Booking_ID   INT,
    @New_Date     DATE,
    @New_Time     TIME,
    @Participants INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Booking
    SET Booking_Date = @New_Date,
        Booking_Time = @New_Time,
        Participants = CASE WHEN @Participants IS NULL THEN Participants ELSE @Participants END,
        Status = 'Changed'
    WHERE Booking_ID = @Booking_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_CancelBooking
    @Booking_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Booking
    SET Status = 'Cancelled'
    WHERE Booking_ID = @Booking_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_AttendBooking
    @Booking_ID  INT,
    @Attended_YN CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Booking
    SET Attended_YN = @Attended_YN,
        Status = CASE WHEN @Attended_YN = 'Y' THEN 'Attended' ELSE Status END
    WHERE Booking_ID = @Booking_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainAttraction
    @Action         VARCHAR(10),
    @Attraction_ID  INT = NULL,
    @Attraction_Name VARCHAR(100) = NULL,
    @Description    VARCHAR(500) = NULL,
    @Category       VARCHAR(50) = NULL,
    @Price          DECIMAL(8,2) = NULL,
    @Business_ID    INT = NULL,
    @Town_ID        INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO Attraction (Attraction_Name, Description, Category, Price, Business_ID, Town_ID)
        VALUES (@Attraction_Name, @Description, @Category, @Price, @Business_ID, @Town_ID);
    ELSE IF @Action = 'UPDATE'
        UPDATE Attraction
        SET Attraction_Name = @Attraction_Name, Description = @Description,
            Category = @Category, Price = @Price, Business_ID = @Business_ID, Town_ID = @Town_ID
        WHERE Attraction_ID = @Attraction_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM Attraction WHERE Attraction_ID = @Attraction_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTowns AS
BEGIN SET NOCOUNT ON; SELECT * FROM Town ORDER BY Town_Name; END
GO

CREATE OR ALTER PROCEDURE usp_GetBusinesses AS
BEGIN SET NOCOUNT ON; SELECT * FROM Business ORDER BY Business_Name; END
GO

CREATE OR ALTER PROCEDURE usp_GetAttractions AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.Attraction_ID, a.Attraction_Name, a.Description, a.Category, a.Price,
           a.Business_ID, b.Business_Name, a.Town_ID, t.Town_Name,
           (SELECT AVG(CAST(r.Rating AS DECIMAL(3,1))) FROM Review r WHERE r.Attraction_ID = a.Attraction_ID) AS Avg_Rating
    FROM Attraction a
    JOIN Business b ON a.Business_ID = b.Business_ID
    JOIN Town t ON a.Town_ID = t.Town_ID
    ORDER BY a.Attraction_Name;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTourists AS
BEGIN SET NOCOUNT ON; SELECT * FROM Tourist ORDER BY Last_Name; END
GO

CREATE OR ALTER PROCEDURE usp_MaintainTourist
    @Action     VARCHAR(10),
    @Tourist_ID INT = NULL,
    @First_Name VARCHAR(50) = NULL,
    @Last_Name  VARCHAR(50) = NULL,
    @Email      VARCHAR(100) = NULL,
    @Phone      VARCHAR(20) = NULL,
    @Password_Hash VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO Tourist (First_Name, Last_Name, Email, Phone, Password_Hash)
        VALUES (@First_Name, @Last_Name, @Email, @Phone, @Password_Hash);
    ELSE IF @Action = 'UPDATE'
        UPDATE Tourist
        SET First_Name = @First_Name, Last_Name = @Last_Name,
            Email = @Email, Phone = @Phone,
            Password_Hash = CASE WHEN @Password_Hash IS NULL THEN Password_Hash ELSE @Password_Hash END
        WHERE Tourist_ID = @Tourist_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM Tourist WHERE Tourist_ID = @Tourist_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_ValidateTouristLogin
    @Email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Tourist_ID, First_Name, Last_Name, Email, Password_Hash FROM Tourist WHERE Email = @Email;
END
GO

CREATE OR ALTER PROCEDURE usp_ValidateSystemUserLogin
    @Username VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT User_ID, Username, Password_Hash, Role FROM SystemUser WHERE Username = @Username;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTouristBookings
    @Tourist_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT b.Booking_ID, a.Attraction_Name, b.Booking_Date, b.Booking_Time,
           b.Participants, a.Price, (a.Price * b.Participants) AS Total,
           b.Status, b.Attended_YN
    FROM Booking b JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
    WHERE b.Tourist_ID = @Tourist_ID
    ORDER BY b.Booking_Date DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_Report_RevenueByAttraction AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.Attraction_Name, t.Town_Name,
           COUNT(b.Booking_ID) AS Total_Bookings, SUM(a.Price) AS Total_Revenue
    FROM Attraction a
    JOIN Town t ON a.Town_ID = t.Town_ID
    LEFT JOIN Booking b ON b.Attraction_ID = a.Attraction_ID AND b.Status <> 'Cancelled'
    GROUP BY a.Attraction_Name, t.Town_Name
    ORDER BY Total_Revenue DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_Report_BookingsByDateRange
    @Tourist_ID INT,
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT b.Booking_ID, a.Attraction_Name, b.Booking_Date, b.Booking_Time, b.Status
    FROM Booking b
    JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
    WHERE b.Tourist_ID = @Tourist_ID AND b.Booking_Date BETWEEN @FromDate AND @ToDate
    ORDER BY b.Booking_Date;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainTown
    @Action    VARCHAR(10),
    @Town_ID   INT = NULL,
    @Town_Name VARCHAR(60) = NULL,
    @Province  VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO Town (Town_Name, Province) VALUES (@Town_Name, @Province);
    ELSE IF @Action = 'UPDATE'
        UPDATE Town SET Town_Name = @Town_Name, Province = @Province WHERE Town_ID = @Town_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM Town WHERE Town_ID = @Town_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainBusiness
    @Action         VARCHAR(10),
    @Business_ID    INT = NULL,
    @Business_Name  VARCHAR(100) = NULL,
    @Business_Type  VARCHAR(50) = NULL,
    @Contact_Email  VARCHAR(100) = NULL,
    @Contact_Phone  VARCHAR(20) = NULL,
    @Town_ID        INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO Business (Business_Name, Business_Type, Contact_Email, Contact_Phone, Town_ID)
        VALUES (@Business_Name, @Business_Type, @Contact_Email, @Contact_Phone, @Town_ID);
    ELSE IF @Action = 'UPDATE'
        UPDATE Business
        SET Business_Name = @Business_Name, Business_Type = @Business_Type,
            Contact_Email = @Contact_Email, Contact_Phone = @Contact_Phone, Town_ID = @Town_ID
        WHERE Business_ID = @Business_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM Business WHERE Business_ID = @Business_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainAttractionContact
    @Action        VARCHAR(10),
    @Contact_ID    INT = NULL,
    @Contact_Name  VARCHAR(80) = NULL,
    @Contact_Phone VARCHAR(20) = NULL,
    @Contact_Email VARCHAR(100) = NULL,
    @Attraction_ID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO AttractionContact (Contact_Name, Contact_Phone, Contact_Email, Attraction_ID)
        VALUES (@Contact_Name, @Contact_Phone, @Contact_Email, @Attraction_ID);
    ELSE IF @Action = 'UPDATE'
        UPDATE AttractionContact
        SET Contact_Name = @Contact_Name, Contact_Phone = @Contact_Phone,
            Contact_Email = @Contact_Email, Attraction_ID = @Attraction_ID
        WHERE Contact_ID = @Contact_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM AttractionContact WHERE Contact_ID = @Contact_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_GetAttractionContacts AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.Contact_ID, c.Contact_Name, c.Contact_Phone, c.Contact_Email,
           c.Attraction_ID, a.Attraction_Name
    FROM AttractionContact c
    JOIN Attraction a ON c.Attraction_ID = a.Attraction_ID
    ORDER BY a.Attraction_Name, c.Contact_Name;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainReview
    @Action       VARCHAR(10),
    @Review_ID    INT = NULL,
    @Booking_ID   INT = NULL,
    @Tourist_ID   INT = NULL,
    @Attraction_ID INT = NULL,
    @Rating       TINYINT = NULL,
    @Comment      VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO Review (Booking_ID, Tourist_ID, Attraction_ID, Rating, Comment, Review_Date)
        VALUES (@Booking_ID, @Tourist_ID, @Attraction_ID, @Rating, @Comment, GETDATE());
    ELSE IF @Action = 'UPDATE'
        UPDATE Review SET Rating = @Rating, Comment = @Comment WHERE Review_ID = @Review_ID;
    ELSE IF @Action = 'DELETE'
        DELETE FROM Review WHERE Review_ID = @Review_ID;
END
GO

CREATE OR ALTER PROCEDURE usp_GetReviews AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.Review_ID, r.Booking_ID, r.Tourist_ID,
           tr.First_Name + ' ' + tr.Last_Name AS Tourist_Name,
           r.Attraction_ID, a.Attraction_Name, r.Rating, r.Comment, r.Review_Date
    FROM Review r
    JOIN Tourist tr    ON r.Tourist_ID = tr.Tourist_ID
    JOIN Attraction a  ON r.Attraction_ID = a.Attraction_ID
    ORDER BY r.Review_Date DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTouristReviews
    @Tourist_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.Review_ID, r.Booking_ID, r.Attraction_ID, a.Attraction_Name,
           r.Rating, r.Comment, r.Review_Date
    FROM Review r
    JOIN Attraction a ON r.Attraction_ID = a.Attraction_ID
    WHERE r.Tourist_ID = @Tourist_ID
    ORDER BY r.Review_Date DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTouristReviewableBookings
    @Tourist_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT b.Booking_ID, b.Attraction_ID, a.Attraction_Name, b.Booking_Date
    FROM Booking b
    JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
    WHERE b.Tourist_ID = @Tourist_ID AND b.Attended_YN = 'Y'
      AND NOT EXISTS (SELECT 1 FROM Review r WHERE r.Booking_ID = b.Booking_ID);
END
GO

CREATE OR ALTER PROCEDURE usp_IsBookingOwnedByTourist
    @Booking_ID INT,
    @Tourist_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM Booking WHERE Booking_ID = @Booking_ID AND Tourist_ID = @Tourist_ID
    ) THEN 1 ELSE 0 END AS IsOwner;
END
GO

CREATE OR ALTER PROCEDURE usp_GetHomeStats AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM Tourist)    AS Total_Tourists,
        (SELECT COUNT(*) FROM Attraction) AS Total_Attractions,
        (SELECT COUNT(*) FROM Booking WHERE Status <> 'Cancelled') AS Active_Bookings,
        (SELECT ISNULL(SUM(a.Price), 0)
         FROM Booking b JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
         WHERE b.Status <> 'Cancelled') AS Total_Revenue;
END
GO

CREATE OR ALTER PROCEDURE usp_GetFeaturedAttractions AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 5 a.Attraction_ID, a.Attraction_Name, a.Category, a.Price, t.Town_Name
    FROM Attraction a
    JOIN Town t ON a.Town_ID = t.Town_ID
    ORDER BY a.Attraction_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE usp_GetTouristUpcomingBookings
    @Tourist_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 5 b.Booking_ID, a.Attraction_Name, b.Booking_Date, b.Booking_Time,
           b.Participants, (a.Price * b.Participants) AS Total, b.Status
    FROM Booking b
    JOIN Attraction a ON b.Attraction_ID = a.Attraction_ID
    WHERE b.Tourist_ID = @Tourist_ID
      AND b.Booking_Date >= CAST(GETDATE() AS DATE)
      AND b.Status <> 'Cancelled'
    ORDER BY b.Booking_Date;
END
GO

CREATE OR ALTER PROCEDURE usp_GetSystemUsers AS
BEGIN
    SET NOCOUNT ON;
    SELECT User_ID, Username, Role FROM SystemUser ORDER BY Username;
END
GO

CREATE OR ALTER PROCEDURE usp_MaintainSystemUser
    @Action        VARCHAR(10),
    @User_ID       INT = NULL,
    @Username      VARCHAR(50) = NULL,
    @Password_Hash VARCHAR(255) = NULL,
    @Role          VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @Action = 'INSERT'
        INSERT INTO SystemUser (Username, Password_Hash, Role)
        VALUES (@Username, @Password_Hash, @Role);
    ELSE IF @Action = 'UPDATE'
    BEGIN
        IF @Password_Hash IS NULL
            UPDATE SystemUser SET Username = @Username, Role = @Role WHERE User_ID = @User_ID;
        ELSE
            UPDATE SystemUser SET Username = @Username, Password_Hash = @Password_Hash, Role = @Role
            WHERE User_ID = @User_ID;
    END
    ELSE IF @Action = 'DELETE'
        DELETE FROM SystemUser WHERE User_ID = @User_ID;
END
GO
