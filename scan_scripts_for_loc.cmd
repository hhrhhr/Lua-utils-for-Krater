@echo off

set scripts=d:\tmp_Krater\scripts
if exist work\strings_in_scripts.txt del /q work\strings_in_scripts.txt

for /R %scripts% %%i in (*.lua) do (
    echo %%i
    lua parse_all_scripts_for_L.lua %%i >> work\strings_in_scripts.txt
)