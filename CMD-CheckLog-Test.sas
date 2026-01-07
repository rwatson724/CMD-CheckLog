data class;
   set SASHELP.CLASS;
   where AGE <= 14;
run;

proc print data = class;
run;