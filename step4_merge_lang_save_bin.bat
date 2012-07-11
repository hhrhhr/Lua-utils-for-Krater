@echo off

call _include.bat

%lua% lua\cmd_merge_lang_made_bin.lua ^
%work%\game_strings_%src_lang_num%.txt ^
%work%\game_strings_%tr_lang%.txt ^
%work%\game_strings.%tr_lang%.bin

:eof
pause
