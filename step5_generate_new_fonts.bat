@echo off

call _include.bat

if not exist %work% mkdir %work%

if exist %work%\new_fonts (
    del /q /s %work%\new_fonts\*.* >nul
) else (
    mkdir %work%\new_fonts
)

if not exist %work%\utf8_char_list.txt (
    %lua% lua\cmd_analize_localization.lua %krater% %work%
)

%lua% lua\cmd_generate_new_fonts.lua %krater% %work%\new_fonts

:eof
pause
