/*
 * Creating tests - create some basic tests.
 * 
 *
 */


--
-- NOTE: Make sure the first part starts with "test" or it won't run!
--
IF OBJECT_ID('[tSQLtDemo].[This will not be recognized as a test!]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [tSQLtDemo].[This will not be recognized as a test!]
END
go

CREATE PROCEDURE [tSQLtDemo].[This will not be recognized as a test!] AS
BEGIN 
	EXEC tSQLt.Fail 'We won''t get here anyway'
END
GO


--
-- This one will be recognized as a test
--
IF OBJECT_ID('[tSQLtDemo].[Test the answer equals the answer]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [tSQLtDemo].[Test the answer equals the answer];
END
go

CREATE PROCEDURE [tSQLtDemo].[Test the answer equals the answer] AS
BEGIN 
	EXEC tSQLt.AssertEquals 42, 42, 'The answer is not the answer - gasp!'
END
GO



IF OBJECT_ID('[tSQLtDemo].[Test that empty table is empty]', 'P') IS NOT NULL
BEGIN 
	DROP PROCEDURE [tSQLtDemo].[Test that empty table is empty]
END
GO

CREATE PROCEDURE [tSQLtDemo].[Test that empty table is empty] AS
BEGIN
	CREATE TABLE #Expected ( some_key decimal )
	
	EXEC tSQLt.AssertEmptyTable #Expected, 'Empty table is not empty!'
END
GO


EXEC tSQLt.NewTestClass 'classForDidacticReasons'

IF OBJECT_ID('[classForDidacticReasons].[Test that NULL equals NULL]', 'P') IS NOT NULL
BEGIN 
	DROP PROCEDURE [classForDidacticReasons].[Test that NULL equals NULL]
END
GO

CREATE PROCEDURE [classForDidacticReasons].[Test that NULL equals NULL] AS
BEGIN
	CREATE TABLE #Expected ( some_key decimal )
	
	EXEC tSQLt.AssertEquals NULL, NULL, 'NULL is not equal to NULL!'
END
GO


--EXEC tSQLt.DropClass 'tSQLtDemo'

--
-- Similar to the test classes, tests are stored in a like-named view
--
SET NOCOUNT ON

select * from tSQLt.Tests

SET NOCOUNT OFF

/*
 *
 * Running Tests
 *
 *
 */

-- Run them all.
EXEC tSQLt.RunAll

-- Run them just for one class
EXEC tSQLt.Run 'tSQLtDemo'

-- Run just one test
EXEC tSQLt.Run '[tSQLtDemo].[Test the answer equals the answer]'

-- Repeat the last test we ran
EXEC tSQLt.Run
