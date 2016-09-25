/*
 * Create the demo class
 * This might live at the beginning of the file for all tests of a certain area/module.
 * It has been broken out for didactic reasons. 
 */


 -- No side effects if already exists
 EXEC tSQLt.DropClass 'tSQLtDemo'

 EXEC tSQLt.NewTestClass 'tSQLtDemo'
 GO