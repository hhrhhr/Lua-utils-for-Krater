@echo off

call _include.bat

if exist %work%\strings_in_scripts.txt del /q %work%\strings_in_scripts.txt

setlocal enabledelayedexpansion
set /a N=0 & set /a num=0
for /r %script% %%i in (*.lua) do (
    if %%~xi == .lua set /a num+=1
)

for /r %script% %%i in (*.lua) do (
    if %%~xi == .lua (
        set /a N+=1
        title progress: [!N! / %num%] >nul
        %lua% lua\cmd_find_strings_in_scripts.lua %%i find %work%\strings_in_scripts.txt
    )
)

%lua% lua\cmd_find_strings_in_scripts.lua %work%\strings_in_scripts.txt sort

:eof
pause
