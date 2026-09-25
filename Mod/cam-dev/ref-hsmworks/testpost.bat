@echo off

rem HSMWorks - http://www.hsmworks.com

rem Just drop your post configuration file on this batch file from Windows Explorer to run the test.
rem This file must be located in the HSMWorks installation folder.

set PROGRAM_NAME=65
set PROGRAM_COMMENT=65
set ARGUMENTS=--property programName %PROGRAM_NAME% --property programComment %PROGRAM_COMMENT% --verbose --nointeraction --nobackup --noheader

set FOLDER=%0%
set FOLDER=%FOLDER:testpost.bat=%
cd /d %FOLDER%

:run1000
echo ------------------------------------------------------------
echo Running program 1000...
echo ------------------------------------------------------------
post.exe %ARGUMENTS% %1% cnc\1000.cnc
if not errorlevel 0 (
echo Failed to post. (ERROR %ERRORLEVEL%)
) else (
echo Successfully posted.
)

:run2000
echo ------------------------------------------------------------
echo Running program 2000...
echo ------------------------------------------------------------
post.exe %ARGUMENTS% %1% cnc\2000.cnc
if not errorlevel 0 (
echo Failed to post. (ERROR %ERRORLEVEL%)
) else (
echo Successfully posted.
)

:run3000
echo ------------------------------------------------------------
echo Running program 3000...
echo ------------------------------------------------------------
post.exe %ARGUMENTS% %1% cnc\3000.cnc
if not errorlevel 0 (
echo Failed to post. (ERROR %ERRORLEVEL%)
) else (
echo Successfully posted.
)

:run3100
echo ------------------------------------------------------------
echo Running program 3100...
echo ------------------------------------------------------------
post.exe %ARGUMENTS% %1% cnc\3100.cnc
if not errorlevel 0 (
echo Failed to post. (ERROR %ERRORLEVEL%)
) else (
echo Successfully posted.
)

:end

pause
