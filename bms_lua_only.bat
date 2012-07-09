@echo off

call _include.bat

if exist %script% del /q /s %script%\
if not exist %script% mkdir %script%

%qbms% %1 %2 bms\only_lua.bms %krater%\data\exploded_database.db %script%

:eof
pause
