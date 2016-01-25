## Description
This set of Matlab functions fixes some methods of the `table()` class and extends it with additional features.

## Installation
1. Unzip the archive;
2. With Matlab, `cd` into the unzipped folder
3. run `install_tableutils` (or to disinstall `install_tableutils 'uninstall'` or `install_tableutils 'fulluninstall'`).
 
:exclamation:**warning**:exclamation:: requires write permissions to `matlabroot/toolbox/local`.

## List of features
* `disp()` - implements a **buffered** version of the native display method. Now, your pc will not freeze until the dawn of time if you forget a `;` in the command window after `t = table(1e7,1)`, which is only a 76 MB variable;
* `unstack()` - significantly **speeds up** the native method with a minimalistic change between lines 240 and 250 (original code left commented out);
* `varfun()` - **adds** a Name/Value pair to the original method, i.e. `'RenameVariables' - false/true(default)`. Does not force you to change the variable names as the native version;
* `renameVarNames()` - **new** method that renames variable names;
* `convertColumn()` - **new** method that changes the class of each column (variable);
* `classVarName` - **new** method that returns the class name of each column (variable).
* `transpose()` - **allows** the transpose of a matrix-like table, i.e. `t'` or `t.'` (takes simple transpose).
* `ismatrixlike()` - **new** method that returns `TRUE` if the table has one element per cell and all variables have the same class. 

## Other methods
Some general purpose utilities for the new table methods.

* `isrowchar()` - Determines whether input is a string (1 by N char);
* `in()` - Test for inclusion, i.e. `[]`,`[),``(]` or `()`, within some bounds;
* `xstr2num()` - Converts the digit-part from an `'xNumber'` to a numeric type. Especially useful to quickly recover the original values after unstacking a table, i.e. `x32443` becomes 32443.

For detailed descriptions, syntax and examples, see the help within each `.m` file.  
