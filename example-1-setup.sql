/*
 * Create the demo class
 * This might live at the beginning of the file for all tests of a certain area/module.
 * It has been broken out for didactic reasons. 
 */


 -- No side effects if already exists
 EXEC tSQLt.DropClass 'tSQLtDemo'

 EXEC tSQLt.NewTestClass 'tSQLtDemo'
 GO

 -- Q: What is a "test class"?

 -- A: tSQLt's way of grouping tests, analogous to test classes
 --  They are schemas, under the hood (note schema_id column)
 select * from tSQLt.TestClasses

 -- ...and presence of our newly created test class here:
 select * from INFORMATION_SCHEMA.SCHEMATA

