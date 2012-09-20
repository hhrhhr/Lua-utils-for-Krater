@echo off

if exist _big_unp rmdir /s /q _big_unp >nul
mkdir _big_unp

for %%i in (_big\*.*) do (
    echo %%i
    tools\quickbms -d bms\unpack.bms %%i _big_unp
)

:eof
pause
