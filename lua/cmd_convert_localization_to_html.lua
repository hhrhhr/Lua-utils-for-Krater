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
    lang_file = make_path(lang_file)
    
    local lang = parse_bin_language(game_path .. "\\data\\data\\" .. lang_file)
    
    --------------------------------------------------------------------------------
    local sorted_lang = {}
    for k,v in pairs(lang) do
        table.insert(sorted_lang, k)
    end
    table.sort(sorted_lang)

    local f = assert(io.open(out_path .. "/game_strings_" .. code .. ".html", "w+"))
    local fmt = ""
    f:write("<!doctype html>\n<html>\n<head>\n")
    f:write("<meta http-equiv=\"Content-Language\" content=\"en\">\n")
    f:write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n")
    f:write("</head>\n<body>\n")
    for k,v in pairs(sorted_lang) do
        fmt = lang[v]
        fmt = string.gsub(fmt, "<(%w+)>", "<var>&lt;%1&gt;</var>")
        fmt = string.gsub(fmt, "(#[_%w]+)", "<var>%1</var>")
        fmt = string.gsub(fmt, "({%w+})", "<var>%1</var>")
        f:write("<p id=\"" .. v .. "\">" .. fmt .. "</p>\n")
    end
    f:write("</body>\n</html>\n")
    f:close()
end