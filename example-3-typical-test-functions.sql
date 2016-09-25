/*
 * Example 3 (a collection of examples, actually)
 * Demonstrate 'typical' test functions
 *
 *
 */

--
--  Compare numeric values
-- 
IF OBJECT_ID('[tSQLtDemo].[Test values are equal]','P') IS NOT NULL
BEGIN
	DROP PROCEDURE [tSQLtDemo].[Test values are equal];
END
GO

CREATE PROCEDURE [tSQLtDemo].[Test values are equal] 
AS BEGIN
    exec tSQLt.Fail 'TODO'
END
GO



EXEC tSQLt.Run '[tSQLtDemo].[Test values are equal]'



select * from Sales.SpecialOffer