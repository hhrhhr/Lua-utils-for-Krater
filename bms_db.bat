@echo off

call _include.bat

if exist %db% del /q /s %db%\
if not exist %db% mkdir %db%

%qbms% %1 %2 bms\db.bms %krater%\data\exploded_database.db %db%

:eof
pause
