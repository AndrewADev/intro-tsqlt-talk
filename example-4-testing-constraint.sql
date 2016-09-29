/*
 * Example 5
 * Testing a constraint
 *
 */

-- (Show constraint)
--select * from Production.WorkOrder


IF OBJECT_ID('[tSQLtDemo].[Test EndDate cannot be before StartDate]','P') IS NOT NULL
BEGIN
	DROP PROCEDURE [tSQLtDemo].[Test EndDate cannot be before StartDate];
END
GO
	
CREATE PROCEDURE [tSQLtDemo].[Test EndDate cannot be before StartDate] AS BEGIN
	
	-- Can be falsely triggered by other exceptions	
	--EXEC tSQLt.ExpectException

	EXEC tSQLt.FakeTable 'Production.WorkOrder', @Identity = 0, @ComputedColumns = 1
	
	EXEC tSQLt.ApplyConstraint 'Production.WorkOrder','CK_WorkOrder_EndDate'

	DECLARE @ErrorMessage VARCHAR(MAX);

	begin try
		INSERT INTO Production.WorkOrder (StartDate, EndDate)
											VALUES ('2016-12-31', '2016-09-25' )
	end try
	begin catch
		SET @ErrorMessage = ERROR_MESSAGE()
	end catch

	-- Make sure our constraint is the reason for the error message
	IF @ErrorMessage is NULL or @ErrorMessage NOT LIKE '%CK_WorkOrder_EndDate%'
    BEGIN
		select @ErrorMessage

		EXEC tSQLt.Fail 'Expected error message containing ''CK_WorkOrder_EndDate'' but got: ',@ErrorMessage,'!';
    END



END;
GO



 