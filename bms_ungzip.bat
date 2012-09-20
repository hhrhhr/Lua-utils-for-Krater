@echo off

set krater=f:\steam\steamapps\common\krater
set packs=230b8ac979d9d395 30d3ac7d103556ae 33c9b8d393acaf70 3ff9e9c5f68b4235 46f4455f4676790b 90b5903d8794e388 9e13b2414b41b842 c28c0b590a8de3f5 eba393dbe3d1182f ec181385e7000cf1 ff3483721c6c164c

if exist _big rmdir /s /q _big >nul
mkdir _big

for %%i in (%packs%) do (
    echo %%i
    tools\quickbms bms\ungzip.bms %krater%\data\%%i _big
)

:eof
pause
