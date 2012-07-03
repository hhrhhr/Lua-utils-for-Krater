@echo off

set krater=f:\steam\steamapps\common\krater\data

:copy_files
for /f "tokens=1,2,3,4" %%a in (output\parsed_fonts.csv) do (
    echo "%%c -> %%a"
    copy /y ready\%%c "%krater%\%%a" >nul
    echo "%%~nc.bin -> %%b"
    copy /y ready\%%~nc.bin "%krater%\%%b" >nul
)

:eof
pause
