@echo off

call _include.bat

if not exist %work% mkdir %work%

%lua% lua\cmd_extract_fonts.lua %krater% %work% > %work%\font_list.txt

set /p q=continiue or exit (any key, q)?
if .%q%==.q goto eof

if exist %work%\fonts (
    del /q /s %work%\fonts\*.* >nul
) else (
    mkdir %work%\fonts
)

:copy_files
for /f "tokens=1,2,3,4" %%a in (%work%\font_list.txt) do (
    if exist "%krater%\data\data\%%a" (
        echo "%%a -> %%c"
        copy /y "%krater%\data\data\%%a" "%work%\fonts\%%c" >nul
        echo "%%b -> %%d"
        copy /y "%krater%\data\data\%%b" "%work%\fonts\%%d" >nul
    )
)

:eof
pause
