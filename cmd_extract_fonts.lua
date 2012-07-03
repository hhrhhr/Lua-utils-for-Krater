local db_path = arg[1]
local db_name = "exploded_database.db"

local str = "materials/fonts/krater"

--[[ *********************************************************************** ]]
local function make_path(name)
    return string.sub(name, 0, string.len(name)-2) .. "\\" .. name
end

--[[ *********************************************************************** ]]
local murmur = require("murmur")
local hh, hl = murmur.hash64A(str)
str = string.lower(hh .. hl)

dofile("util_parse_exploded_db.lua")
local db = parse_exploded_db(db_path .. "\\" .. db_name)

local mat = db[str].internal_name
mat = db_path .. "\\" ..make_path(mat)

dofile("util_parse_material.lua")
local hash_table = parse_material(mat)

--[[ *********************************************************************** ]]
package.path = "./?.lua;./work/?.lua"
-- hacks
local null = function() return false end
Application = { settings = null, build_identifier = null }
Gui = {}
-- hacks end
require("scripts/hud/font/script_gui")

--[[ *********************************************************************** ]]
local font_names = {}
for font_name, _ in pairs(ScriptGui.fonts) do
    table.insert(font_names, font_name)
end
table.sort(font_names)

for _, font_name in pairs(font_names) do
    for _, v in pairs(ScriptGui.fonts[font_name]) do
        --print(_,v[1],v[2])
        local font_size = v[1]
        local texture_name = v[2]
        local texture_hash = murmur.hash64A(texture_name):lower()
        texture_name = texture_name..".dds"
        texture_hash = hash_table[texture_hash]

        local descriptor_name = ScriptGui.get_font(font_name, font_size)
        local descriptor_hash, dl = murmur.hash64A(descriptor_name)
        descriptor_hash = (descriptor_hash..dl):lower()
        descriptor_name = string.gsub(descriptor_name, "materials/fonts/", "")
        descriptor_name = descriptor_name..".fnt"

        local dds_name = db[texture_hash] and db[texture_hash].internal_name or false
        local fnt_name = db[descriptor_hash] and db[descriptor_hash].internal_name or false

        --print(dds_exist, fnt_exist, texture_hash, texture_name, descriptor_hash, descriptor_name)
        if fnt_name and dds_name then
            print(make_path(dds_name), make_path(fnt_name), texture_name, descriptor_name)
        end
    end
end
