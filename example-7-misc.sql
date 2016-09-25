/* 
 * Example 7
 * demonstrate AssertStringEquals 
 *
 */


IF OBJECT_ID('tSQLtDemo.[Test Leading zeros pads to correct number]', 'P') IS NOT NULL
	DROP PROCEDURE tSQLtDemo.[Test Leading zeros pads to correct number]
GO
CREATE PROCEDURE tSQLtDemo.[Test Leading zeros pads to correct number]
AS BEGIN

	DECLARE @testValue INT = 55;
	DECLARE @expectedReturn VARCHAR (10) = '00000055'
	DECLARE @actualValue VARCHAR(10);

	EXEC @actualValue = dbo.ufnLeadingZeros @Value = @testValue;

	EXEC tSQLt.AssertEqualsString @expectedReturn, @actualValue, 'Did not pad to correct number of zeros'

END;
GO


exec tSQLt.RunTestClass @TestClassName = 'tSQLtDemo'

