package.path = "lua/?.lua"
require("util_parse_exploded_db")
require("util_parse_bin_lang")
local murmur = require("murmur")

-- arguments: fullpath to Krater directory
--          : output path
local game_path = arg[1]
local out_path = arg[2]
local db = parse_exploded_db(game_path .. "/data/" .. "exploded_database.db")

local strings = "localization/game_strings"
local a, b = murmur.hash64A(strings)
strings = (a..b):lower()
a, b = nil, nil

-- find localization
local lang_codes = {0, 1, 2, 4, 8, 16, 32, 64, 128}

for i, code in pairs(lang_codes) do
    print("[LOG] --- lang " .. code .. " ---")
    local lang_file = 0
    if code == 0 then
        lang_file = db[strings].internal_name
    else
        lang_file = db[strings][code].internal_name
    end

    -- make path from file XXXYY to XXX/XXXYY
    lang_file = string.sub(lang_file, 0, string.len(lang_file)-2) .. "/" .. lang_file
    
    local lang = parse_bin_language(game_path .. "/data/" .. lang_file)
    
    --------------------------------------------------------------------------------
    local sorted_lang = {}
    for k,v in pairs(lang) do
        table.insert(sorted_lang, k)
    end
    table.sort(sorted_lang)
    
    local f = assert(io.open(out_path .. "/game_strings_" .. code .. ".txt", "w+"))
    for k,v in pairs(sorted_lang) do
        f:write(v .. " = " .. lang[v] .. "\n")
    end
    f:close()
end