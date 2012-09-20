@echo off
setlocal enabledelayedexpansion

call _include.bat

if not exist %work%\new_fonts goto eof

:make_dirs
for /f "tokens=1,2" %%a in (%work%\font_list.txt) do (
    set dir=%%a
    set dir=!dir:~0,2!
    if not exist %work%\data\!dir! mkdir %work%\data\!dir!
    set dir=%%b
    set dir=!dir:~0,2!
    if not exist %work%\data\!dir! mkdir %work%\data\!dir!
)

:copy_fonts
for /f "tokens=1,2,3,4" %%a in (%work%\font_list.txt) do (
    echo "%%c -> %%a"
    copy /y "%work%\new_fonts\%%c" "%work%\data\%%a" >NUL
    echo "%%d -> %%b"
    copy /y "%work%\new_fonts\%%d" "%work%\data\%%b" >NUL
)

:copy_lang
if not exist %work%\data\47 mkdir %work%\data\47
copy /y %work%\game_strings.rus.bin %work%\data\47\477f43f763bafe17 >NUL

:eof
pause
