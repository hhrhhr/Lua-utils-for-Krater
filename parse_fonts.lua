package.path = "./?.lua;./work/?.lua"

-- hacks
local null = function() return false end
Application = { settings = null, build_identifier = null }
Gui = {}
-- hacks end
require("scripts/hud/font/script_gui")

local murmur = require("murmur")

--[[*************************************************************************]]
local unpacked_patch = "d:\\tmp_Krater\\_db_unp\\"
local descriptors = "(9efe0a916aae7880)font\\"
local textures = "(cd4238c6a0c69e32)texture\\"
local materials = "(eac0b497876adedf)material\\"
local krater_mat = "materials/fonts/krater"

--[[*************************************************************************]]
function is_file_exist(fullpath)
    local fd = io.open(fullpath)
    if not fd then return false end
    fd:close()
    return true
end

function is_desc_exist(filename)
    local fullpath = unpacked_patch..descriptors.."("..filename..").fnt"
    return is_file_exist(fullpath)
end

function is_tex_exist(filename)
    local fullpath = unpacked_patch..textures.."("..filename..").dds"
    return is_file_exist(fullpath)
end

function is_mat_exist()
    local m1,m2 = murmur.hash64A(krater_mat)
    local fullpath = unpacked_patch..materials.."("..m1..m2..").mat"
    if is_file_exist(fullpath) then
        return fullpath
    end
    return false
end

--[[*************************************************************************]]

dofile("util_parse_material.lua")

local fullpath = is_mat_exist()
local hash_table = parse_material(fullpath)

local font_names = {}
for font_name, _ in pairs(ScriptGui.fonts) do
    table.insert(font_names, font_name)
end
table.sort(font_names)

for _, font_name in pairs(font_names) do
    for _, v in pairs(ScriptGui.fonts[font_name]) do
        --print(k,v[1],v[2])
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

        local dds_exist = is_tex_exist(texture_hash)
        local fnt_exist = is_desc_exist(descriptor_hash)

        print(dds_exist, fnt_exist, texture_hash, texture_name, descriptor_hash, descriptor_name)
--[[        if fnt_exist and dds_exist then
            print(texture_hash, texture_name, descriptor_hash, descriptor_name)
        end ]]
    end
end
