USE MASTER 
GO
IF  EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME='GOT')
	DROP DATABASE GOT
GO

--Drop Objects
IF EXISTS (SELECT * FROM SYSUSERS WHERE NAME='Tolosano')
	DROP USER Tolosano;
GO
IF EXISTS (SELECT * FROM SYSUSERS WHERE NAME='Arriano')
    DROP USER Arriano;		
GO
IF EXISTS (SELECT * FROM SYSUSERS WHERE NAME='Visigodo')
    DROP USER Visigodo;    
GO
IF EXISTS (SELECT * FROM SYSUSERS WHERE NAME='Agila')
    DROP USER Agila;
GO
IF EXISTS (SELECT * FROM SYSUSERS WHERE NAME='Pelayo')
    DROP USER Pelayo;	
GO
IF EXISTS (SELECT * FROM SYS.security_policies WHERE NAME='KingValidation')
	DROP SECURITY POLICY KingValidation
GO
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME='ViewValidation')
	DROP FUNCTION GodosAccess.ViewValidation
GO
IF EXISTS (SELECT * FROM SYS.SCHEMAS WHERE NAME='GodosAccess')
	DROP SCHEMA GodosAccess
GO
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME='vKings')
	DROP view vKings
GO
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME='Kingdoms')
	DROP TABLE Kingdoms
GO
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME='CryptedKingdoms')
	DROP TABLE CryptedKingdoms
GO
CREATE DATABASE GOT
GO
USE GOT
GO

--Users Creation

	CREATE USER Tolosano	WITHOUT LOGIN;
    CREATE USER Arriano		WITHOUT LOGIN;
    CREATE USER Visigodo    WITHOUT LOGIN;
    CREATE USER Agila		WITHOUT LOGIN; --Jefe Trival y caudillo bárbaro
    CREATE USER Pelayo		WITHOUT LOGIN; --Primer Rey no Godo (astures)

--Create and populate Base table

iF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME='KingDoms')
	DROP TABLE KingDoms
GO
Create table KingDoms
( KingDomId int , Kingdom nvarchar(25), KingName nvarchar(25), Reign nvarchar(25),  YearFrom int , YearTo int ,Duration int)
GO

INSERT [dbo].[KingDoms] ([KingDomId], [Kingdom], [KingName], [Reign], [YearFrom], [YearTo], [Duration]) 
VALUES
(1, N'Tolosano', N'Ataúlfo', N'Ataúlfo - Tolosano', 410, 415, 5),
(2, N'Tolosano', N'Sigérico', N'Sigérico - Tolosano', 415, 415, 1),
(3, N'Tolosano', N'Walia', N'Walia - Tolosano', 415, 418, 3),
(4, N'Tolosano', N'Teodorico I', N'Teodorico I - Tolosano', 418, 451, 33),
(5, N'Tolosano', N'Turismundo ', N'Turismundo  - Tolosano', 451, 453, 2),
(6, N'Tolosano', N'Teodorico II ', N'Teodorico II  - Tolosano', 453, 466, 13), 
(7, N'Tolosano', N'Alarico II ', N'Alarico II  - Tolosano', 484, 507, 23),
(8, N'Arriano', N'Gesaleico ', N'Gesaleico  - Arriano', 507, 510, 3),
(9, N'Arriano', N'Amalarico', N'Amalarico - Arriano', 510, 534, 24),
(10, N'Arriano', N'Theudis ', N'Theudis  - Arriano', 534, 548, 14),
(11, N'Arriano', N'Theudiselo ', N'Theudiselo  - Arriano', 548, 549, 1),
(12, N'Arriano', N'Agila ', N'Agila  - Arriano', 549, 555, 6),
(13, N'Arriano', N'Atanagildo ', N'Atanagildo  - Arriano', 555, 567, 12),
(14, N'Arriano', N'Liuva I ', N'Liuva I  - Arriano', 567, 571, 4),
(16, N'Arriano', N'Leovigildo ', N'Leovigildo  - Arriano', 571, 586, 15),
(17, N'Visigodo', N'Recaredo ', N'Recaredo  - Visigodo', 586, 601, 15),
(18, N'Visigodo', N'Liuva II ', N'Liuva II  - Visigodo', 601, 603, 2),
(19, N'Visigodo', N'Witérico ', N'Witérico  - Visigodo', 603, 610, 7),
(20, N'Visigodo', N'Gundemaro ', N'Gundemaro  - Visigodo', 610, 612, 2),
(21, N'Visigodo', N'Sisebuto ', N'Sisebuto  - Visigodo', 612, 621, 9),
(22, N'Visigodo', N'Recaredo II ', N'Recaredo II  - Visigodo', 621, 621, 1),
(23, N'Visigodo', N'Suínthila ', N'Suínthila  - Visigodo', 621, 631, 10),
(24, N'Visigodo', N'Sisenando ', N'Sisenando  - Visigodo', 631, 636, 5),
(25, N'Visigodo', N'Khíntila ', N'Khíntila  - Visigodo', 636, 639, 3),
(26, N'Visigodo', N'Tulga ', N'Tulga  - Visigodo', 639, 642, 3),
(27, N'Visigodo', N'Khindasvinto', N'Khindasvinto - Visigodo', 642, 649, 7),
(28, N'Visigodo', N'Recesvinto', N'Recesvinto - Visigodo', 653, 672, 19),
(29, N'Visigodo', N'Wamba ', N'Wamba  -  Visigodo', 672, 680, 8),
(30, N'Visigodo', N'Ervigio ', N'Ervigio - Visigodo', 680, 687, 7),
(31, N'Visigodo', N'Egica', N'Egica -  Visigodo', 687, 700, 13),
(33, N'Visigodo', N'Witiza', N'Witiza - Visigodo', 702, 710, 8),
(34, N'Visigodo', N'Rodrigo ', N'Rodrigo - Visigodo', 710, 711, 1)
GO

	Select Kingdom AS Kingdom_Uncrypted, Kingdom as Kingdom_Deterministic, Kingdom as Kingdom_Random, KingName, Reign  into CryptedKingdoms from dbo.KingDoms

GO

