rem @echo off
setlocal enabledelayedexpansion

call _include.bat

if not exist %work% mkdir %work%
if not exist %script% mkdir %script%

:firsttry
if exist %work%\unlua_errors.log del /q /f %work%\unlua_errors.log

echo.
echo start decompile...
echo.
set cur=%~dp0%
set cur=%cur%%db%\%luadir%

for /r %db%\%luadir% %%i in (*.luac) do (
    set S=%%i
    set O="!S:%cur%=%script%!"
    set O=!O:~1,-2!
    set S=%%~dpi
    set D="!S:%cur%=%script%!"
    if not exist !D! mkdir !D!
    echo !O!
    "%java%" -jar %unluac% "%%i" > "!O!"
    if ERRORLEVEL 1 echo %%i >> %work%\unlua_errors.log
)

if not exist %work%\unlua_errors.log goto eof

echo.
echo failed files:
type %work%\unlua_errors.log
echo.
echo try another tool (set extension to .lua2)...
echo.

:secondtry
for /f %%i in (%work%\unlua_errors.log) do (
    set S=%%i
    set O="!S:%cur%=%script%!"
    set O=!O:~1,-2!
    echo !O!2
    %luadec% "%%i" > "!O!2"
)

:eof
echo.
echo all done.
echo.
pause
