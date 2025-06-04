-- Создание базы данных
CREATE DATABASE TechInspectionDB;
GO

USE TechInspectionDB;
GO

-- Таблица пользователей
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL,
    Role NVARCHAR(10) NOT NULL CHECK (Role IN ('Tech', 'Client'))
);

-- Таблица клиентов
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY FOREIGN KEY REFERENCES Users(UserID),
    FullName NVARCHAR(100) NOT NULL
);

-- Таблица услуг
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL CHECK (Cost >= 0)
);

-- Таблица оказанных услуг клиентам
CREATE TABLE ClientServices (
    ClientServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL FOREIGN KEY REFERENCES Clients(ClientID) ON DELETE CASCADE,
    ServiceID INT NOT NULL FOREIGN KEY REFERENCES Services(ServiceID) ON DELETE CASCADE,
    DateProvided DATETIME NOT NULL DEFAULT GETDATE()
);

-- Заполнение данными

-- Пользователи
INSERT INTO Users (UserName, Password, Role) VALUES
('t1', '123', 'Tech'),
('t2', '123', 'Tech'),
('c1', '123', 'Client'),
('c2', '123', 'Client'),
('c3', '123', 'Client');

-- Клиенты
INSERT INTO Clients (ClientID, FullName) VALUES
((SELECT UserID FROM Users WHERE UserName='c1'), 'Юлия Рязанова'),
((SELECT UserID FROM Users WHERE UserName='c2'), 'Сания Маисовна'),
((SELECT UserID FROM Users WHERE UserName='c3'), 'Богдан Игоревич');

-- Услуги
INSERT INTO Services (ServiceName, Cost) VALUES
('Диагностика двигателя', 1500.00),
('Замена масла', 800.00),
('Проверка тормозной системы', 1200.00);

-- Оказанные услуги
INSERT INTO ClientServices (ClientID, ServiceID) VALUES
((SELECT ClientID FROM Clients WHERE FullName='Юлия Рязанова'), (SELECT ServiceID FROM Services WHERE ServiceName='Диагностика двигателя')),
((SELECT ClientID FROM Clients WHERE FullName='Сания Маисовна'), (SELECT ServiceID FROM Services WHERE ServiceName='Замена масла')),
((SELECT ClientID FROM Clients WHERE FullName='Богдан Игоревич'), (SELECT ServiceID FROM Services WHERE ServiceName='Проверка тормозной системы'));
