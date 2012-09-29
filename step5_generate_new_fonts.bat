@echo off

call _include.bat

if not exist %work% mkdir %work%

if exist %work%\new_fonts (
    del /q /s %work%\new_fonts\*.* >nul
) else (
    mkdir %work%\new_fonts
)

rem %lua% lua\cmd_analize_localization.lua %krater% %work% %work%\game_strings.%tr_lang%.bin

%lua% lua\cmd_generate_new_fonts.lua %krater% %work%\new_fonts

:eof
pause
