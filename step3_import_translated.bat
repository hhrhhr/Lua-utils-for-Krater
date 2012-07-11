@echo off
setlocal enabledelayedexpansion

call _include.bat

if not exist %work%\translated goto error

set null=%work%\translated\null.txt
echo.>%null%
set txt=/b null.txt
for /r %work%\translated %%i in (*.txt) do (
    set txt=!txt! + /b "%%~nxi"
)

pushd %work%\translated
copy %txt% /b ..\merged.txt
popd
del /q %null%

%lua% lua\cmd_parse_save_txt_lang.lua ^
%work%\merged.txt ^
%work%\game_strings_%tr_lang%.txt

rem del /q %work%\merged.txt
goto eof

:error
echo put your working copy in "%work%\translated" directory
echo then run this file again

:eof
pause