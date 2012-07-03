@echo off
setlocal enabledelayedexpansion

set /a N=0 & set /a num=0
for %%i in (tools\cfg\*.bmfc) do (
    set /a num+=1
)

if exist ready rmdir /s /q ready
mkdir ready

for %%i in (tools\cfg\*.bmfc) do (
    set /a N+=1
    title progress: [!N! / %num%] >nul
    echo %%i converting [!N! / %num%]...

    tools\bmfont.com -c %%i -o ready\%%~ni.fnt >nul
    tools\nvcompress -alpha -nomips -bc3 ready\%%~ni_0.tga ready\%%~ni.dds >nul
    if exist ready\%%~ni_1.tga echo !!! texture not fit in one file !!!
    del /q ready\%%~ni*.tga
    lua.exe cmd_bmfont2krater.lua ready\%%~ni.fnt
    lua.exe cmd_fix_dds.lua ready\%%~ni.dds
    del /q ready\%%~ni.fnt
)

pause
