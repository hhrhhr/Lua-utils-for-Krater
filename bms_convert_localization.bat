@echo off

call _include.bat

if exist %lng% del /q /a %lng%\
if not exist %lng% mkdir %lng%

for /r %db%\%lngdir% %%i in (*.lang) do (
    %qbms% %1 bms\localization2txt.bms %%i %lng%
)

:eof
pause
