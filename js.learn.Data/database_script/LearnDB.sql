IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'LearnDB')
BEGIN
	CREATE DATABASE LearnDB;
END

ELSE BEGIN
	DROP DATABASE LearnDB;
END

GO
USE LearnDB
GO

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
	CREATE TABLE [__EFMigrationsHistory] (
		[MigrationId] nvarchar(150) NOT NULL,
		[ProductVersion] nvarchar(32) NOT NULL,
		CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
	);
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE UserProfile (
	UserId INT IDENTITY(1,1),
	DisplayName NVARCHAR(100) NOT NULL CONSTRAINT DF_UserProfile_DisplayName DEFAULT 'Guest',
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	AdObjId NVARCHAR(128) NOT NULL,
    CONSTRAINT PK_UserProfile_UserId PRIMARY KEY (UserId)
);

CREATE TABLE Roles (
	RoleId INT IDENTITY (1,1),
	RoleName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Roles_RoleId PRIMARY KEY (RoleId)
)

CREATE TABLE SmartApp (
	SmartAppId INT IDENTITY(1,1),
	AppName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_SmartApp_SmartAppId PRIMARY KEY (SmartAppId)
);

CREATE TABLE UserRole (
	UserRoleId INT IDENTITY(1,1),
	RoleId INT NOT NULL,
	UserId INT NOT NULL,
	SmartAppId INT NOT NULL,

	CONSTRAINT PK_UserRole_UserRoleId PRIMARY KEY (UserRoleId),
    CONSTRAINT FK_UserRole_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId),
    CONSTRAINT FK_UserRole_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
	CONSTRAINT FK_UserRole_SmartApp FOREIGN KEY (SmartAppId) REFERENCES SmartApp(SmartAppId)
)

CREATE TABLE CourseCategory (
	CategoryId INT IDENTITY(1,1),
	CategoryName NVARCHAR(50) NOT NULL,
	Description NVARCHAR(250),
    CONSTRAINT PK_CourseCategory_CategoryId PRIMARY KEY (CategoryId)
);

CREATE TABLE Instructor (
	InstructorId INT IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
    Bio NVARCHAR(MAX),
	UserId INT NOT NULL,  
    CONSTRAINT PK_Instructor_InstructorId PRIMARY KEY (InstructorId),
	CONSTRAINT FK_Instructor_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

CREATE TABLE Course (
    CourseId INT IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    CourseType NVARCHAR(10) NOT NULL CHECK (CourseType IN ('Online', 'Offline')),
    SeatsAvailable INT CHECK (SeatsAvailable >= 0),
    Duration DECIMAL(5, 2) NOT NULL, -- Duration in hours
    CategoryId INT NOT NULL,
    InstructorId INT NOT NULL,
    StartDate DATETIME, -- Applicable for Online courses
    EndDate DATETIME, -- Applicable for Online courses
  
	CONSTRAINT PK_Course_CourseId PRIMARY KEY (CourseId),
    CONSTRAINT FK_Course_CourseCategory FOREIGN KEY (CategoryId) REFERENCES CourseCategory(CategoryId),
    CONSTRAINT FK_Course_Instructor FOREIGN KEY (InstructorId) REFERENCES Instructor(InstructorId)
);







