@echo off

call _include.bat

if exist %work%\strings_in_scripts.txt goto skip

echo scan scripts for gui strings...
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

:skip
if not exist %work%\for_translate mkdir %work%\for_translate

title find strings ids...

if not exist %work%\game_strings_%tr_lang%.txt (
    echo.>%work%\game_strings_%tr_lang%.txt
)

%lua% lua\parse.lua %work%\game_strings_%src_lang_num%.txt %src_lang% ^
%work%\for_translate ^
%work%\game_strings_%tr_lang%.txt %tr_lang%

:eof
pause
