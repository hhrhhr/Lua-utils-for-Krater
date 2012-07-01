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
    local m1,m2 = murmur.hash64A(krater_mat, #krater_mat)
    local fullpath = unpacked_patch..materials.."("..m1..m2..").mat"
    if is_file_exist(fullpath) then
        return fullpath
    end
    return false
end

--[[*************************************************************************]]

dofile("_parse_material.lua")

local fullpath = is_mat_exist()
local hash_table = parse_material(fullpath)

local font_names = {}
for font_name, _ in pairs(ScriptGui.fonts) do
    table.insert(font_names, font_name)
end
table.sort(font_names)

for _, font_name in pairs(font_names) do
--   print(font_name)
--    local _m = string.find(font_name, "_masked")
--    local _o = string.find(font_name, "_offscreen")
--    if not (_m or _o) then
        for k,v in pairs(ScriptGui.fonts[font_name]) do
            --print(k,v[1],v[2])
            local size = v[1]
            local tex_name = v[2]
            local tex_hash = murmur.hash64A(tex_name, #tex_name):lower()
            tex_name = tex_name..".dds"
            tex_hash = hash_table[tex_hash]

            local font_desc = ScriptGui.get_font(font_name, size)
            local desc_hash,dl = murmur.hash64A(font_desc, #font_desc)
            desc_hash = (desc_hash..dl):lower()
            font_desc = string.gsub(font_desc, "materials/fonts/", "")
            font_desc = font_desc..".fnt"

            local tex_exist = is_tex_exist(tex_hash)
            local desc_exist = is_desc_exist(desc_hash)

            if desc_exist and tex_exist then
                print(tex_hash, tex_name, desc_hash, font_desc)
            end
        end
--    end
end
