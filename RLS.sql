USE GOT
GO

Select * from dbo.Kings


--View security Demo

   Create VIEW dbo.vKings
    WITH SCHEMABINDING
    AS
        SELECT KingdomId, KingName, YearFrom, YearTo, Duration
        FROM   dbo.Kingdoms
        WHERE  Kingdom = USER_NAME() OR USER_NAME() = 'Pelayo';
    GO

    GRANT SELECT ON dbo.[Reign] TO Public;

	    
 	EXECUTE AS USER = 'Pelayo';
    SELECT *, 'Seen as Pelayo' AS Who FROM dbo.vKings;
    REVERT; -- Go back to connection default user

    EXECUTE AS USER = 'Tolosano';
    SELECT *, 'Seen as Tolosano' AS Who FROM dbo.vKings; -- Returns 7 reigns
    REVERT;

    EXECUTE AS USER = 'Arriano';
    SELECT *, 'Seen as Arriano' AS Who FROM dbo.vKings; -- Returns 9 missions
    REVERT;

    EXECUTE AS USER = 'Agila';
    SELECT *, 'Seen as Agila' AS Who FROM dbo.vKings; -- Returns nothing, "need to know" only!
    REVERT; 

    GO


--Row Level Scurity

	ALTER ROLE [db_datareader] ADD MEMBER Agila
	ALTER ROLE [db_datareader] ADD MEMBER Arriano
	ALTER ROLE [db_datareader] ADD MEMBER Tolosano
	ALTER ROLE [db_datareader] ADD MEMBER Visigodo
	ALTER ROLE [db_datareader] ADD MEMBER Pelayo
	
	--Create a specific sche for this kind of rules

	CREATE SCHEMA GodosAccess;
    GO

	CREATE FUNCTION GodosAccess.ViewValidation (@Kingdom AS SYSNAME)
    RETURNS TABLE
    WITH SCHEMABINDING
    AS
        RETURN SELECT 1 AS ValidationResult 
        WHERE @Kingdom = USER_NAME() OR USER_NAME() = 'Pelayo';
    GO


	CREATE SECURITY POLICY KingValidation
    ADD FILTER PREDICATE GodosAccess.ViewValidation (Kingdom)
    -- "ADD BLOCK PREDICATE" also exists
    ON dbo.Kingdoms
    WITH (STATE = ON);

    GO
 	EXECUTE AS USER = 'Pelayo';
    SELECT *, 'Seen as Pelayo + RLS' AS Who FROM dbo.Kingdoms;
    REVERT; -- Go back to connection default user

    EXECUTE AS USER = 'Tolosano';
    SELECT *, 'Seen as Tolosano + RLS' AS Who FROM dbo.Kingdoms; -- Returns 7 reigns
    REVERT;

    EXECUTE AS USER = 'Arriano';
    SELECT *, 'Seen as Arriano + RLS' AS Who FROM dbo.Kingdoms; -- Returns 9 missions
    REVERT;

    EXECUTE AS USER = 'Agila';
    SELECT *, 'Seen as Agila + RLS' AS Who FROM dbo.Kingdoms; -- Returns nothing, "need to know" only!
    REVERT; 

	ALTER SECURITY POLICY KingValidation
    WITH (STATE = OFF);
    GO


; 
