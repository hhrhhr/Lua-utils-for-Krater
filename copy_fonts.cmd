@echo off

set input=f:\steam\steamapps\common\krater\data
set backup=backup
set output=output

if exist %output% rmdir /q /s %output%
mkdir %output%
lua cmd_extract_fonts.lua "%input%" > %output%\parsed_fonts.csv

if not exist %backup% goto make_backup
goto copy_files

:make_backup
mkdir %backup%
for /f "tokens=1,2,3,4" %%a in (%output%\parsed_fonts.csv) do (
    copy /y "%input%\%%a" "%backup%\%%~na" >nul
    copy /y "%input%\%%b" "%backup%\%%~nb" >nul
)

:copy_files
for /f "tokens=1,2,3,4" %%a in (%output%\parsed_fonts.csv) do (
    echo "%%a -> %%c"
    copy /y "%input%\%%a" "%output%\%%c" >nul
    echo "%%b -> %%d"
    copy /y "%input%\%%b" "%output%\%%d" >nul
)

:eof
