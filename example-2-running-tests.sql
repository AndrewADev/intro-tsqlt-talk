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
	EXEC tSQLt.AssertEquals 42, 42
END


--
-- Similar to the test classes, tests are stored in a like-named view
--
select * from tSQLt.Tests


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
