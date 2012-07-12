@echo off

call _include.bat

set out=
echo.
set /p arg=show log on screen or save it to file (Enter, f)?
if .%arg%==.f set out=%work%

echo analize start...
if not exist %work% mkdir %work%
%lua% lua\cmd_analize_localization.lua %krater% %out%

:eof
pause
