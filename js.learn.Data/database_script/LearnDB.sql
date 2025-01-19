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






