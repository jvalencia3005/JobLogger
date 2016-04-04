USE [master]
GO

/****** Object:  Database [bd_joblogger]    Script Date: 04/04/2016 14:36:53 ******/
CREATE DATABASE [bd_joblogger] ON  PRIMARY 
( NAME = N'bd_joblogger', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\bd_joblogger.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bd_joblogger_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\bd_joblogger_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [bd_joblogger] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bd_joblogger].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [bd_joblogger] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [bd_joblogger] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [bd_joblogger] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [bd_joblogger] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [bd_joblogger] SET ARITHABORT OFF 
GO

ALTER DATABASE [bd_joblogger] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [bd_joblogger] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [bd_joblogger] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [bd_joblogger] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [bd_joblogger] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [bd_joblogger] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [bd_joblogger] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [bd_joblogger] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [bd_joblogger] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [bd_joblogger] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [bd_joblogger] SET  DISABLE_BROKER 
GO

ALTER DATABASE [bd_joblogger] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [bd_joblogger] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [bd_joblogger] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [bd_joblogger] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [bd_joblogger] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [bd_joblogger] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [bd_joblogger] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [bd_joblogger] SET  READ_WRITE 
GO

ALTER DATABASE [bd_joblogger] SET RECOVERY FULL 
GO

ALTER DATABASE [bd_joblogger] SET  MULTI_USER 
GO

ALTER DATABASE [bd_joblogger] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [bd_joblogger] SET DB_CHAINING OFF 
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'logger_user')
BEGIN
	CREATE LOGIN [logger_user] WITH PASSWORD='loggeruser',DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	EXEC sys.sp_addsrvrolemember @loginame = N'logger_user', @rolename = N'sysadmin'
END
GO


USE [bd_joblogger]
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageLog]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[MessageLog]
	(
		IdMessageLog INT IDENTITY(1,1) PRIMARY KEY,
		Message VARCHAR(500) NOT NULL,
		MessageType INT NOT NULL,
		FechaCreacion DATETIME NOT NULL
	)
	END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spuMessageLogInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spuMessageLogInsert]
GO

CREATE PROCEDURE spuMessageLogInsert
(
	@Message VARCHAR(500),
	@MessageType INT
)
AS
BEGIN
	INSERT INTO MessageLog (Message, MessageType, FechaCreacion)
	VALUES (@Message,@MessageType, GETDATE())
END
GO
