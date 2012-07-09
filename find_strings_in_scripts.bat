@echo off

call _include.bat

if exist %work%\strings_in_scripts.txt del /q %work%\strings_in_scripts.txt

for /R %script% %%i in (*.lua) do (
    echo %%~ni
    %lua% lua\cmd_find_strings_in_scripts.lua %%i find %work%\strings_in_scripts.txt
)

%lua% lua\cmd_find_strings_in_scripts.lua %work%\strings_in_scripts.txt sort

:eof
pause
