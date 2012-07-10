@echo off

call _include.bat

if not exist %work% mkdir %work%

%lua% lua\cmd_convert_localization_to_txt.lua %krater% %work%

:eof
pause
