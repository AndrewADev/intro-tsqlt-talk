/*
 * Example 7 Test spying on procedures
 *
 *
 */

IF OBJECT_ID('Purchasing.GetDetailsForSalesShipment', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE Purchasing.GetDetailsForSalesShipment;
END
GO

CREATE PROCEDURE Purchasing.GetDetailsForSalesShipment (
	@SalesOrderID decimal
)AS	
BEGIN
	select @SalesOrderID [OrderID], 
		'SALES' [OrderReference],  
		CONCAT(p.LastName, ', ', p.LastName) [name],
		 ship.Name [shipment_method], 
		 soh.ShipDate [ship_date]
	from Sales.SalesPerson sp
	join Sales.SalesOrderHeader soh on soh.SalesPersonID = sp.BusinessEntityID
				AND soh.SalesOrderID = @SalesOrderID
	join Person.Person p on p.BusinessEntityID = sp.BusinessEntityID
	join Purchasing.ShipMethod ship on ship.ShipMethodID = soh.ShipMethodID
END
GO


IF OBJECT_ID('Purchasing.GetDetailsForPurchaseShipment', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE Purchasing.GetDetailsForPurchaseShipment;
END
GO

CREATE PROCEDURE Purchasing.GetDetailsForPurchaseShipment (
	@PurchaseOrderID decimal
)AS	
BEGIN
	select @PurchaseOrderID [OrderID], 
		'PURCHASE' [OrderReference],  
		CONCAT(emp.LastName, ', ', emp.LastName) [name],
		 ship.Name [shipment_method], 
		 poh.ShipDate [ship_date]
	from Person.Person emp
	join Purchasing.PurchaseOrderHeader poh on poh.EmployeeID = emp.BusinessEntityID
				AND poh.PurchaseOrderID = @PurchaseOrderID
	join Purchasing.ShipMethod ship on ship.ShipMethodID = poh.ShipMethodID
END
GO

IF OBJECT_ID('Purchasing.GetDetailsForShipment', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE Purchasing.GetDetailsForShipment;
END
GO

CREATE PROCEDURE Purchasing.GetDetailsForShipment (
	@OrderID decimal = 0,
	@IsInternalOrder Bit = 0
)AS	
BEGIN
	IF @IsInternalOrder <> 0
		EXEC Purchasing.GetDetailsForPurchaseShipment @OrderID;
	ELSE	
		EXEC Purchasing.GetDetailsForSalesShipment @OrderID;
END 
GO

IF OBJECT_ID('[AdventureWorksTests].[Test GetDetailsForShipment calls GetDetailsForPurchaseShipment for internal orders]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [AdventureWorksTests].[Test GetDetailsForShipment calls GetDetailsForPurchaseShipment for internal orders]
END
GO

CREATE PROCEDURE [AdventureWorksTests].[Test GetDetailsForShipment calls GetDetailsForPurchaseShipment for internal orders]
AS
BEGIN
	
		EXEC tSQLt.SpyProcedure 'Purchasing.GetDetailsForSalesShipment'

		EXEC tSQLt.SpyProcedure 'Purchasing.GetDetailsForPurchaseShipment'

		EXEC Purchasing.GetDetailsForShipment 42, 1

		select PurchaseOrderID
		INTO #Actual
		FROM Purchasing.GetDetailsForPurchaseShipment_SpyProcedureLog

		CREATE TABLE #Expected (
			PurchaseOrderID decimal
		)

		insert into #expected values (42)


		EXEC tSQLt.AssertEqualsTable #Expected, #Actual
		

	    IF EXISTS (SELECT 1 FROM Purchasing.GetDetailsForSalesShipment_SpyProcedureLog)
       EXEC tSQLt.Fail 'GetDetailsForShipment should not check sales tables for internal orders'
END

GO

EXEC tSQLt.Run '[AdventureWorksTests].[Test GetDetailsForShipment calls GetDetailsForPurchaseShipment for internal orders]'


