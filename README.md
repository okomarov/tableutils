# tableutils
#### MATLAB utilities for table type

* *renameVarNames()* - Renames variable names of a table
* *convertColumn()* - Convert type of variable names in a table

In the *tbextend.** package 
* *varfun()* - Extends table method with the option `'RenameVariables', false` (true by default)

#### Generic utility
* *isstring()* - Determine whether input is a string (1 by N char)

#### Calling package functions
There two ways:

1. Call with package extesion (preferred)

   ```matlab
   tbextend.varfun(...)
   ```
2. Import the package and call the function directly:

   ```matlab
   import tbextend.*
   varfun(...)
   ```
