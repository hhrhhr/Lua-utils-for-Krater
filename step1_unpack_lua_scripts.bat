@echo off

call _include.bat

if not exist %work% mkdir %work%
if exist %script% (
    del /q /s %script%\ >nul
) else (
    mkdir %script%
)

title unpack lua scripts...
%qbms% %1 %2 bms\only_lua.bms %krater%\data\exploded_database.db %script%

:firsttry
if exist %work%\unlua_errors.log del /q /f %work%\unlua_errors.log

echo.
echo start decompile...
echo.

setlocal enabledelayedexpansion
set /a N=0 & set /a num=0
for /r %script% %%i in (*.luac) do (
    set /a num+=1
)

for /r %script% %%i in (*.luac) do (
    set /a N+=1
    title progress: [!N! / %num%] >nul
    rem echo %%i decompiling [!N! / %num%]...

    "%java%" -jar %unluac% "%%i" > "%%~dpni.lua"
    if ERRORLEVEL 1 (
        echo %%i >> %work%\unlua_errors.log
        ren %%~dpni.lua %%~dpni.bad
    )
)

if not exist %work%\unlua_errors.log goto eof

:secondtry
echo.
echo.
echo failed files:
type %work%\unlua_errors.log
echo.
echo trying another tool (set extension to .2.lua)...
echo.

for /f %%i in (%work%\unlua_errors.log) do (
    %luadec% "%%i" > "%%~dpni.2.lua"
)

echo.
echo change some scripts...
echo.
copy /y lua\error.fixed %script%\foundation\scripts\util\error.lua

echo.
echo all done
echo.

:eof
pause
