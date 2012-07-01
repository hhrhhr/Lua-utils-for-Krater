Lua-utils-for-Krater
====================

unpack, parse, check and examine Lua scripts for Krater game

parse_fonts
-----------

* needed scripts:

        scripts/hud/font/script_gui
        scripts/helpers/revision_info
    
* usage:

        lua parse_fonts.lua

* sample output:

        true true 8bc3dfd4efc764df fat_unicorn_16.dds dc7cb497ae753bea fat_unicorn_16.fnt
        true true 3b4b4915d09c7286 fat_unicorn_20.dds 7cfad845a76ac836 fat_unicorn_20.fnt
        true true 0549bf8a18d17d6b fat_unicorn_25.dds 9ca906d9e61f1f97 fat_unicorn_25.fnt

  .dds found?, .fnt found? .dds hash, .dds name, .fnt hash, .fnt name without "materials/fonts/"
  