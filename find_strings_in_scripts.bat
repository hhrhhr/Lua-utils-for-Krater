@echo off

call _include.bat

if not exist %work%\langs mkdir %work%\langs

%lua% lua\parse.lua %krater% %work%\langs

:eof
pause
