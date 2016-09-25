/*
 * Example 6
 * Testing a trigger
 * 
 *
 */

-- (Show Trigger definition)


IF OBJECT_ID('[tSQLtDemo].[Test WorkOrder INSERT triggers TransactionHistory record]','P') IS NOT NULL
BEGIN
	DROP PROCEDURE [tSQLtDemo].[Test WorkOrder INSERT triggers TransactionHistory record]
END

GO

CREATE PROCEDURE [tSQLtDemo].[Test WorkOrder INSERT triggers TransactionHistory record] AS
BEGIN
	
	-- Table on which trigger defined
	exec tSQLt.FakeTable 'Production.WorkOrder'

	-- Trigger predicate table
	exec tSQLt.FakeTable 'Production.TransactionHistory'

	exec tSQLt.ApplyTrigger 'Production.WorkOrder', 'iWorkOrder'

	INSERT INTO Production.WorkOrder (ProductID, WorkOrderID, OrderQty)
			VALUES (1, 2, 3)
	
	select ProductID, ReferenceOrderID, Quantity
	INTO #Actual
	from Production.TransactionHistory

	-- Get type info for expected table, no records
	select top 0 *
	into #Expected
	from #Actual

	INSERT INTO #Expected VALUES (1, 2, 3)

	EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual'

END
GO


exec tSQLt.RunAll

