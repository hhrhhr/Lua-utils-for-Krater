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

local mat = make_path(db[hash].internal_name)
mat = game_path .. "\\data\\data\\" .. mat

local hash_table = parse_material(mat)

--fonts = {}
require("inc_fonts")

local texture_name, desc_name = "", ""
local texture_hash, desc_hash = "", ""
for font, v in pairs(fonts) do
    for i, size in pairs(v.sizes) do
        texture_name = v.t_names[i]
        texture_hash = murmur.hash64A(texture_name):lower()
        texture_hash = hash_table[texture_hash]
        texture_name = texture_name .. ".dds"

        desc_name = v.d_names[i]
        desc_hash, dl = murmur.hash64A("materials/fonts/" .. desc_name)
        desc_hash = (desc_hash .. dl):lower()
        desc_name = desc_name .. ".fnt"

        local dds = db[texture_hash].internal_name
        local fnt = db[desc_hash].internal_name

        print(make_path(dds), make_path(fnt), texture_name, desc_name)
    end
end
