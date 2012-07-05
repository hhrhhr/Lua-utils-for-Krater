@echo off

call _include.bat

echo.
set /p arg=show log on screen or save it to file (Enter, f)?

if .%arg%==.f goto file

:run
%lua% lua\cmd_analize_localization.lua %krater%
goto eof

:file
echo analize start...
if not exist %work% mkdir %work%
%lua% lua\cmd_analize_localization.lua %krater% > %work%\strings_info.txt
echo.
echo log saved in %work%\strings_info.txt

:eof
set arg=
