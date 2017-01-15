/*
 * Example 3
 * Faking tables - a keystone test procedure
 *
 */

IF OBJECT_ID('Sales.GetEmailList','P') IS NOT NULL
BEGIN 
	DROP PROCEDURE Sales.GetEmailList
END
GO 

CREATE PROCEDURE Sales.GetEmailList
AS
BEGIN
	select  FirstName, ea.EmailAddress
	from Person.Person as p
	join Person.EmailAddress as ea on ea.BusinessEntityID = p.BusinessEntityID
	WHERE p.EmailPromotion = 1
END 
GO


EXEC tSQLt.NewTestClass 'AdventureWorksTests'



RETURN; 

--
-- Consider, naive attempt at insert:
-- 
INSERT INTO Person.Person (FirstName, MiddleName, LastName, EmailPromotion)
			VALUES ('Marcus', NULL, 'Aurelius', 1)


--
-- Add the column it's complaining about, but
--
INSERT INTO Person.Person (BusinessEntityID, FirstName, MiddleName, LastName, EmailPromotion)
			VALUES (456789,'Marcus', NULL, 'Aurelius', 1)

GO

--
-- To demonstrate results of FakeTable
--
BEGIN TRAN

	EXEC tSQLt.FakeTable 'Person.Person'

	select * from Person.Person

ROLLBACK TRAN


BEGIN TRAN

	EXEC tSQLt.FakeTable 'Person.Person'

	INSERT INTO Person.Person (FirstName, MiddleName, LastName, EmailPromotion)
			VALUES ('Marcus', NULL, 'Aurelius', 1)

	select * from Person.Person

ROLLBACK TRAN


IF OBJECT_ID('[AdventureWorksTests].[Test GetEmailList returns no data for empty tables]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [AdventureWorksTests].[Test GetEmailList returns no data for empty tables]
END
GO

CREATE PROCEDURE [AdventureWorksTests].[Test GetEmailList returns no data for empty tables]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Person.Person'

	CREATE TABLE #Results (
		FirstName varchar(100),
		EmailAddress varchar(100)
	)

	--select *
	INSERT INTO #Results 
	EXEC Sales.GetEmailList


	EXEC tSQLt.AssertEmptyTable #Results
END

go

EXEC tSQLt.Run '[AdventureWorksTests].[Test GetEmailList returns no data for empty tables]'


IF OBJECT_ID('[AdventureWorksTests].[Test GetEmailList retrieves a single record from table]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [AdventureWorksTests].[Test GetEmailList retrieves a single record from table]
END
GO

CREATE PROCEDURE [AdventureWorksTests].[Test GetEmailList retrieves a single record from table]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Person.Person'

	EXEC tSQLt.FakeTable 'Person.EmailAddress'

	INSERT INTO Person.Person (BusinessEntityID, FirstName , EmailPromotion)
		VALUES (42, 'Arthur', 1)

	INSERT INTO Person.EmailAddress (BusinessEntityID, EmailAddress)
		VALUES (42, 'ex@mple.com')

	CREATE TABLE #Results (
		FirstName varchar(100),
		EmailAddress varchar(100)
	)

	--select *
	INSERT INTO #Results 
	EXEC Sales.GetEmailList

	select top 0 *
	into #Expected
	from #Results

	INSERT INTO #Expected(FirstName, EmailAddress)
	VALUES ('Arthur', 'ex@mple.com')

	EXEC tSQLt.AssertEqualsTable @Expected =  #Expected,  @Actual = #Results, @Message = 'GetEmailsList should return a single record when single record exists'
END
GO

EXEC tSQLt.Run '[AdventureWorksTests].[Test GetEmailList retrieves a single record from table]'

IF OBJECT_ID('[AdventureWorksTests].[Test GetEmailList retrieves several records from the table]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [AdventureWorksTests].[Test GetEmailList retrieves several records from the table]
END
GO

CREATE PROCEDURE [AdventureWorksTests].[Test GetEmailList retrieves several records from the table]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Person.Person'

	EXEC tSQLt.FakeTable 'Person.EmailAddress'

	INSERT INTO Person.Person (BusinessEntityID, FirstName, EmailPromotion)
		VALUES (42, 'Arthur', 1), (1919, 'Jurgen', 1), (1984, 'Winston',1)

	INSERT INTO Person.EmailAddress (BusinessEntityID, EmailAddress)
		VALUES (42, 'ex@mple.com'), (1919, 'why@mple.com'), (1984,'zee@mple.com')

	CREATE TABLE #Results (
		FirstName varchar(100),
		EmailAddress varchar(100)
	)

	INSERT INTO #Results 
	EXEC Sales.GetEmailList

	DECLARE @TableCount INT;
	select @TableCount = count (*) from #Results

	select top 0 *
	into #Expected
	from #Results

	INSERT INTO #Expected (FirstName, EmailAddress)
	VALUES ('Arthur', 'ex@mple.com'), ('Jurgen', 'why@mple.com'), ('Winston','zee@mple.com')

	EXEC tSQLt.AssertEqualsTable #Expected, #Results
END
GO

exec tSQLt.Run '[AdventureWorksTests].[Test GetEmailList retrieves several records from the table]'
