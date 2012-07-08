package.path = "lua/?.lua"
require("util_parse_exploded_db")
require("util_parse_material")
local murmur = require("murmur")

-- arguments: fullpath to Krater directory
--          : output path
local game_path = arg[1]
local out_path = arg[2]

local db = parse_exploded_db(game_path .. "/data/" .. "exploded_database.db")

local str = "materials/fonts/krater"
local hash, hl = murmur.hash64A(str)
hash = string.lower(hash .. hl)

local mat = db[hash].internal_name
mat = game_path .. "\\data\\" ..make_path(mat)

local hash_table = parse_material(mat)

local fonts = {
    krater = {
        font = "comic_krater",
        sizes = {16, 20, 22, 25, 30, 32, 35, 40, 42, 45, 50}
    },
    krater_outline = {
        font = "comic_krater",
        suff = "_outline",
        sizes = {16}
    },
    fatfont = {
        font = "fatfont",
        sizes = {15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70}
    },
    fat_unicorn = {
        font = "fat_unicorn",
        sizes = {16, 20, 25, 30, 35}
    },
    fatshark_medium = {
        font = "fatshark_medium",
        sizes = {10, 15, 20, 25, 30, 35, 40, 45, 50}
    }
}

local conversion = {
    fatfont = "header_font_krater",
    fatshark_medium = "medium_font_krater"
}

local texture_name, desc_name = "", ""
local texture_hash, desc_hash = "", ""
for font, v in pairs(fonts) do
    if conversion[font] then
        v.desc = conversion[font]
    else
        v.desc = v.font
    end
    for i, size in pairs(v.sizes) do
        texture_name = v.font .. "_" .. size .. (v.suff or "")
        texture_hash = murmur.hash64A(texture_name):lower()
        texture_hash = hash_table[texture_hash]
        texture_name = texture_name .. ".dds"

        desc_name = v.desc .. "_" .. size .. (v.suff or "")
        desc_hash, dl = murmur.hash64A("materials/fonts/" .. desc_name)
        desc_hash = (desc_hash .. dl):lower()
        desc_name = desc_name .. ".fnt"

        local dds = db[texture_hash].internal_name
        local fnt = db[desc_hash].internal_name

        print(make_path(dds), make_path(fnt), texture_name, desc_name)
    end
end
