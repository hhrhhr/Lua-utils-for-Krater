@echo off

call _include.bat

if not exist %work% mkdir %work%

%lua% lua\cmd_convert_db_to_txt.lua %krater% %work%

:eof
pause
