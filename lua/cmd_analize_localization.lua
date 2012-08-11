package.path = "lua/?.lua"
require("util_parse_exploded_db")
require("util_parse_bin_lang")
local murmur = require("murmur")

-- arguments: fullpath to Krater directory
local game_path = arg[1]
local out_path = arg[2] or false
local ready_tr = arg[3] or false

local lang
if ready_tr then
    lang = parse_bin_language(ready_tr)
else
    local db = parse_exploded_db(game_path .. "/data/" .. "exploded_database.db")
    local strings = "localization/game_strings"
    local a, b = murmur.hash64A(strings)
    strings = (a..b):lower()
    a, b = nil, nil
    
    -- find english localization
    local lang_file = db[strings].internal_name
    -- can be used db[strings][n].internal_name, where n = 1,2,4,8...
    
    -- make path from file XXXYY to XXX/XXXYY
    lang_file = make_path(lang_file)
    
    lang = parse_bin_language(game_path .. "\\data\\data\\" .. lang_file)
end

-- count all chars and glyph (UTF8)
print("[LOG] scan for unique chars")
local chars = {}
local char = ""
local glyphs = {}
local glyph = ""
local res = ""
local c = 0
local err = ""

for hash, str in pairs(lang) do
    for i = 1, string.len(str) do
        char = string.byte(string.sub(str, i))
        if char < 32 then
            err = "[WARN] found wrong char code: 0x" .. string.format("%02X", char)
            err = err .. ", source: " .. hash
            --err = err .. "\n" .. string.rep("-", 80) .. "\n"
            --err = err .. str .. "\n" .. string.rep("-", 80)
            print(err)
        elseif char < 128 then
            res = char
            glyph = string.char(char)
            c = 0
        elseif char < 192 then          -- bytes
            res = bit32.lshift(res, 6)
            res = res + bit32.band(char, 0x3f)
            glyph = glyph .. string.char(char)
            c = c - 1
        elseif char < 224 then          -- 2 bytes
            res = bit32.band(char, 0x1f)
            glyph = string.char(char)
            c = 1
        elseif char < 240 then          -- 3 bytes
            res = bit32.band(char, 0x0f)
            glyph = string.char(char)
            c = 2
        elseif char < 240 then          -- 4 bytes
            res = bit32.band(char, 0x07)
            glyph = string.char(char)
            c = 3
        else
            err = "[WARN] found wrong UTF8 byte: 0x" .. string.format("%02X", char)
            err = err .. ", changed to 0xFFFD"
            print(err)
            res = 65533
            glyph = string.char(0xFF) .. string.char(0xFD)
        end
    
        if c == 0 then
            if chars[res] then
                chars[res] = chars[res] + 1
            else
                chars[res] = 1
                table.insert(glyphs, glyph)
            end
        end
    end
end
table.sort(glyphs)

print("[LOG] sort char codes")
local sorted_chars = {}
for k, v in pairs(chars) do
    table.insert(sorted_chars, k)
end
table.sort(sorted_chars)

-- make string like 32-160,165,200-300....
print("[LOG] make config for BMFont")
local str = ""
local old = -1
local new = -1
local p = 0
for k, v in pairs(sorted_chars) do
    new = v
    if p == 0 then
        str = new
        p = p + 1
    elseif new - old > 1 then
        if p == 1 then
            str = str .. "," .. new
        else
            str = str .. "-" .. old .. "," .. new
        end
        p = 1
    else
        p = p + 1
    end
    old = new
end

local BOM = string.char(0xef)..string.char(0xbb)..string.char(0xbf)
if out_path then
    local f = assert(io.open(out_path .. "\\utf8_char_list.txt", "w+"))
    local str = BOM .. table.concat(glyphs)
    f:write(str)
    f:close()
    print("\nutf8_char_list.txt for BMFont generated")
else
    print("\n--- list all UTF8 char codes ---")
    print(table.concat(sorted_chars,", "))
    print(string.rep("-", 80))
    
    print("\n--- list all char codes in BMFont format ---")
    print(str)
    print(string.rep("-", 80))
    
    print("\n--- list all UTF8 chars ---")
    print(BOM .. table.concat(glyphs))
    print(string.rep("-", 80))
end
