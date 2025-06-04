-- �������� ���� ������
CREATE DATABASE TechInspectionDB;
GO

USE TechInspectionDB;
GO

-- ������� �������������
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL,
    Role NVARCHAR(10) NOT NULL CHECK (Role IN ('Tech', 'Client'))
);

-- ������� ��������
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY FOREIGN KEY REFERENCES Users(UserID),
    FullName NVARCHAR(100) NOT NULL
);

-- ������� �����
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL CHECK (Cost >= 0)
);

-- ������� ��������� ����� ��������
CREATE TABLE ClientServices (
    ClientServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL FOREIGN KEY REFERENCES Clients(ClientID) ON DELETE CASCADE,
    ServiceID INT NOT NULL FOREIGN KEY REFERENCES Services(ServiceID) ON DELETE CASCADE,
    DateProvided DATETIME NOT NULL DEFAULT GETDATE()
);

-- ���������� �������

-- ������������
INSERT INTO Users (UserName, Password, Role) VALUES
('t1', '123', 'Tech'),
('t2', '123', 'Tech'),
('c1', '123', 'Client'),
('c2', '123', 'Client'),
('c3', '123', 'Client');

-- �������
INSERT INTO Clients (ClientID, FullName) VALUES
((SELECT UserID FROM Users WHERE UserName='c1'), '���� ��������'),
((SELECT UserID FROM Users WHERE UserName='c2'), '����� ��������'),
((SELECT UserID FROM Users WHERE UserName='c3'), '������ ��������');

-- ������
INSERT INTO Services (ServiceName, Cost) VALUES
('����������� ���������', 1500.00),
('������ �����', 800.00),
('�������� ��������� �������', 1200.00);

-- ��������� ������
INSERT INTO ClientServices (ClientID, ServiceID) VALUES
((SELECT ClientID FROM Clients WHERE FullName='���� ��������'), (SELECT ServiceID FROM Services WHERE ServiceName='����������� ���������')),
((SELECT ClientID FROM Clients WHERE FullName='����� ��������'), (SELECT ServiceID FROM Services WHERE ServiceName='������ �����')),
((SELECT ClientID FROM Clients WHERE FullName='������ ��������'), (SELECT ServiceID FROM Services WHERE ServiceName='�������� ��������� �������'));
