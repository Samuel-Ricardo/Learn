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

