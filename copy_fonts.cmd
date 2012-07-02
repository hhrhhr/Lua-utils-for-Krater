@echo off

set input=d:\tmp_Krater\_db_unp
set fnt=(9efe0a916aae7880)font
set dds=(cd4238c6a0c69e32)texture
set mat=(eac0b497876adedf)material
set output=d:\tmp_Krater\fonts


if exist parsed_fonts.csv del /q parsed_fonts.csv
lua parse_fonts.lua "%input%" "%fnt%" "%dds%" "%mat%" > parsed_fonts.csv


if not exist %output% mkdir %output%
for /f "tokens=1,2,3,4,5,6" %%a in (parsed_fonts.csv) do (
    if %%a==true if %%b==true (
        echo "%%c -> %%d"
        copy /y "%input%\%dds%\(%%c).dds" "%output%\%%d.dds" >nul
        echo "%%e -> %%f"
        copy /y "%input%\%fnt%\(%%e).fnt" "%output%\%%f.fnt" >nul
    )
)


del /q parsed_fonts.csv


:eof
