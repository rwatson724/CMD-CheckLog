setlocal enabledelayedexpansion
mode con cols=130

REM R.Watson 03APR2024 (Idea to use CMD came from V.Debbeti)
REM To run in batch mode SAS programs by either drag and drop technique over a .BAT icon (ideally add as a right-click menu item)
REM Log and Lst files are sent to corresponding subfolders if it exists, otherwise, left in the same folder as the program
REM Log is scanned for main keywords

REM  --------------- Retrieve start time to generate the elapsed time for execution and log checking ---------------
set sttime=%time%
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

for %%A in (%*) do set pgm=%%~nA

ECHO Detection of active folder = %~d1%~p1
REM Check to see if Logs and Lsts folders are existing as subfolder of main directory, alternatively at same level as main directory or logs and lsts are saved in same directory
if exist "%~d1%~p1\Logs" (set LogFldr=%~d1%~p1\Logs") else if exist "%~d1%~p1..\Logs" (set LogFldr="%~d1%~p1..\Logs) else (set LogFldr=%~d1%~p1)
if exist "%~d1%~p1\Lsts" (set LstFldr=%~d1%~p1\Lsts") else if exist "%~d1%~p1..\Lsts" (set LstFldr="%~d1%~p1..\Lsts) else (set LstFldr=%~d1%~p1)

set LogCk=%LogFldr%

ECHO Batch execution start at %time%                                                                                                                  > "%LogCk%\__logck_summary_%pgm%.txt"

ECHO LOG=%LogFldr%                                                                                                                                    >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO LST=%LstFldr%                                                                                                                                    >> "%LogCk%\__logck_summary_%pgm%.txt"


REM  --------------- Start Batch Submit and Log Checking ---------------

set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\en\sasv9.cfg"
set plog=-log "%LogFldr%"
set plst=-print "%LstFldr%"

ECHO SAS=%sas%


ECHO Program:     %pgm%                                                                                                                               >> "%LogCk%\__logck_summary_%pgm%.txt" 

%sas% -sysin "%~d1%~p1%pgm%.sas" %plog% %plst% -icon -nosplash -rsasuser

ECHO '%pgm%' Execution completed at !date! !time!                                                                                                     >> %LogCk%\__logck_summary_%pgm%.txt" 
ECHO.                                                                                                                                                 > "%LogCk%\__logck_%pgm%.txt"
ECHO --- Log scanning - messages are displayed by decreasing order of criticality:                                                                    >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:4F /n /OFFLINE "ERROR" "%LogFldr%\%pgm%.log"                                                                                               >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:4F /n /OFFLINE /i "FATAL" "%LogFldr%\%pgm%.log"                                                                                            >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:2F /n /OFFLINE "WARNING" "%LogFldr%\%pgm%.log"                                                                                             >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:2F /n /OFFLINE /i "uninitialized unequal ILLEGAL" "%LogFldr%\%pgm%.log"                                                                    >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"SAS went to a new line when" "%LogFldr%\%pgm%.log"                                                                   >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"THE SAS SYSTEM STOPPED PROCESSING" "%LogFldr%\%pgm%.log"                                                             >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"NOTE: DATA STEP STOPPED" "%LogFldr%\%pgm%.log"                                                                       >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"STATEMENT NOT EXECUTED" "%LogFldr%\%pgm%.log"                                                                        >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"values have been converted" "%LogFldr%\%pgm%.log"                                                                    >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /c:"MERGE statement has more than" "%LogFldr%\%pgm%.log"                                                                    >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"MISSING VALUES WERE GENERATED" "%LogFldr%\%pgm%.log"                                                                 >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"Invalid argument" "%LogFldr%\%pgm%.log"                                                                              >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"INVALID DATA" "%LogFldr%\%pgm%.log"                                                                                  >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"INVALID NUMERIC DATA" "%LogFldr%\%pgm%.log"                                                                          >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"NOTE: LOST CARD" "%LogFldr%\%pgm%.log"                                                                               >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"DOES NOT EXIST" "%LogFldr%\%pgm%.log"                                                                                >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"COULD NOT BE LOADED" "%LogFldr%\%pgm%.log"                                                                           >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /c:"W.D format too small" "%LogFldr%\%pgm%.log"                                                                             >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /c:"variables not in" "%LogFldr%\%pgm%.log"                                                                                 >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"ONE OR MORE LINES WERE TRUNCATED" "%LogFldr%\%pgm%.log"                                                              >> "%LogCk%\__logck_%pgm%.txt" 
findstr /A:1F /n /OFFLINE /i /c:"variables have conflicting" "%LogFldr%\%pgm%.log"                                                                    >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"Division by zero detected" "%LogFldr%\%pgm%.log"                                                                     >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"operations could not be performed" "%LogFldr%\%pgm%.log"                                                             >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"Interactivity disabled with" "%LogFldr%\%pgm%.log"                                                                   >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"duplicate key values were deleted" "%LogFldr%\%pgm%.log"                                                             >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"INFO: The variable" "%LogFldr%\%pgm%.log"                                                                            >> "%LogCk%\__logck_%pgm%.txt"  
findstr /A:1F /n /OFFLINE /i /c:"WHERE CLAUSE HAS BEEN REPLACED" "%LogFldr%\%pgm%.log"                                                                >> "%LogCk%\__logck_%pgm%.txt"  

ECHO.                                                                                                                                                 >> "%LogCk%\__logck_%pgm%.txt"  


REM --------------- Compute the cumulative number of ERROR, WARNING or INFO messsages in the log ---------------

set /A TtlNumErr=0
for /f %%j in ('findstr "ERROR" "%LogFldr%\%pgm%.log"') do @set /A TtlNumErr+=1

set /A TtlNumWrn=0
for /f %%j in ('findstr "WARNING" "%LogFldr%\%pgm%.log"') do @set /A TtlNumWrn+=1

set /A TtlNumUni=0
for /f %%j in ('findstr "uninitialized" "%LogFldr%\%pgm%.log"') do @set /A TtlNumUni+=1

set /A TtlNumInf=0   
for /f %%j in ('findstr "INFO:" "%LogFldr%\%pgm%.log"') do @set /A TtlNumInf+=1

set /A TtlNumCvt=0
for /f %%j in ('findstr /i /c:"values have been converted" "%LogFldr%\%pgm%.log"') do @set /A TtlNumCvt+=1

set /A TtlNumMrg=0
for /f %%j in ('findstr /c:"MERGE statement has more than" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMrg+=1

set /A TtlNumMis=0
for /f %%j in ('findstr /i /c:"MISSING VALUES WERE GENERATED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMis+=1

set /A TtlNumMsc=0
for /f %%j in ('findstr /i "FATAL" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i "unequal ILLEGAL" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"SAS went to a new line when" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"THE SAS SYSTEM STOPPED PROCESSING" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"NOTE: DATA STEP STOPPED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"STATEMENT NOT EXECUTED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"Invalid argument" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"INVALID DATA" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"INVALID NUMERIC DATA" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"NOTE: LOST CARD" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"DOES NOT EXIST" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1 
for /f %%j in ('findstr /i /c:"COULD NOT BE LOADED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /c:"W.D format too small" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /c:"variables not in" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /c:"ONE OR MORE LINES WERE TRUNCATED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"variables have conflicting" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"Division by zero detected" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"Interactivity disabled with" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"duplicate key values were deleted" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1
for /f %%j in ('findstr /i /c:"WHERE CLAUSE HAS BEEN REPLACED" "%LogFldr%\%pgm%.log"') do @set /A TtlNumMsc+=1


ECHO.                                                                                                                                                 >> "%LogCk%\__logck_%pgm%.txt"
ECHO =========================================================== batch END ===========================================================                >> "%LogCk%\__logck_%pgm%.txt"

REM --------------- Compute Time of Execution ---------------

set entime=%time%
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

set /A "elapsed=end-start"
set /A "hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100"
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%

ECHO. _______________________________________                                                                                                         >> "%LogCk%\__logck_summary_%pgm%.txt" 
ECHO.                                                                                                                                                 >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO.            Time of Execution                                                                                                                    >> "%LogCk%\__logck_summary_%pgm%.txt" 
ECHO. _______________________________________                                                                                                         >> "%LogCk%\__logck_summary_%pgm%.txt"  
ECHO.                                                                                                                                                 >> "%LogCk%\__logck_summary_%pgm%.txt" 
ECHO.                   HH:MN:SC,CS                                                                                                                   >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO.   Start         : %sttime%                                                                                                                      >> "%LogCk%\__logck_summary_%pgm%.txt"  
ECHO.   End           : %entime%                                                                                                                      >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO. ---------------------------------------                                                                                                         >> "%LogCk%\__logck_summary_%pgm%.txt"  
ECHO.   Elapsed time  : %hh%:%mm%:%ss%,%cc%                                                                                                           >> "%LogCk%\__logck_summary_%pgm%.txt"  
ECHO. _______________________________________                                                                                                         >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO.                                                                                                                                                 >> "%LogCk%\__logck_summary_%pgm%.txt"
ECHO.                                                                                                                                                 >> "%LogCk%\__logck_summary_%pgm%.txt"

REM --------------- Summary Report of Log Messages ---------------
if "!TtlNumERR!" gtr "0" (
   ECHO. Total number of ERROR messages in the log file: !TtlNumERR!                                                                                  >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No ERROR message found in the log file.                                                                                                      >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumWrn!" gtr "0" (
   ECHO. Total number of WARNING messages in the log file: !TtlNumWrn!                                                                                >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No WARNING message found in the log file.                                                                                                    >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumUni!" gtr "0" (
   ECHO. Total number of uninitialized messages in the log file: !TtlNumUni!                                                                          >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No uninitialized message found in the log file.                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumMrg!" gtr "0" (
   ECHO. Total number of MERGE messages in the log file: !TtlNumMrg!                                                                                  >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No MERGE message found in the log file.                                                                                                      >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumMis!" gtr "0" (
   ECHO. Total number of MISSING VALUES messages in the log file: !TtlNumMis!                                                                         >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No MISSING VALUES message found in the log file.                                                                                             >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumCvt!" gtr "0" (
   ECHO. Total number of CONVERT messages in the log file: !TtlNumCvt!                                                                                >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No CONVERT message found in the log file.                                                                                                    >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumInf!" gtr "0" (
   ECHO. Total number of INFO messages in the log file: !TtlNumInf!                                                                                   >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No INFO message found in the log file.                                                                                                       >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)

if "!TtlNumMsc!" gtr "0" (
   ECHO. Total number of miscellaneous unwanted messages in the log file: !TtlNumMsc!                                                                 >> "%LogCk%\__logck_summary_%pgm%.txt"
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
) else (
   ECHO. No miscellaneous unwanted message found in the log file.                                                                                     >> "%LogCk%\__logck_summary_%pgm%.txt" 
   ECHO.                                                                                                                                              >> "%LogCk%\__logck_summary_%pgm%.txt"
)


REM --------------- Combine log summary and all unwanted log messages with log file ---------------
REM --------------- temporarily copy the log to a different file ---------------

COPY "%LogFldr%\%pgm%.log"                     "%LogFldr%\__TEMP_%pgm%.log"
COPY "%LogCk%\__logck_summary_%pgm%.txt"  + "%LogCk%\__logck_%pgm%.txt" +  "%LogFldr%\__TEMP_%pgm%.log"    "%LogFldr%\%pgm%.log"

DEL "%LogFldr%\__TEMP_%pgm%.log"
DEL "%LogCk%\__logck_summary_%pgm%.txt"
DEL "%LogCk%\__logck_%pgm%.txt"

ECHO.
exit /B
