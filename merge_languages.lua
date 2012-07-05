dofile("util_parse_lang.lua")

local eng_file = "work/localization/game_strings.txt"
local rus_files = {
    --"work/newlang/tutorials.txt",
    --"work/newlang/enhancement.txt",
    --"work/newlang/_01+_quests.txt"
}

local count = 0
local lang = {}
lang, count = parse_language(eng_file)

local rus = {}
for _, file in pairs(rus_files) do
    rus = parse_language(file)
    for k,v in pairs(rus) do
        if v.rus and #v.rus > 0 then
                lang[k].eng = v.rus
        end
    end
    rus = {}
end

local sorted_lang = {}
for k,v in pairs(lang) do
    table.insert(sorted_lang, k)
end
table.sort(sorted_lang)

local string_size = {}
local sz = 0
local offset = count * 8 + 8
for k,v in ipairs(sorted_lang) do
    table.insert(string_size, offset)
--    print(k,v)
    sz = string.len(lang[v].eng)+1
    offset = offset + sz 
end

dofile("util_binary_writer.lua")
local w = BinaryWriter
w:open("ready/game_strings")

w:int32(1048966062)
w:int32(count)
for i = 1, count do
    w:int32(tonumber(string.format("%u", "0x"..sorted_lang[i])))
    w:int32(string_size[i])
end
for k,v in ipairs(sorted_lang) do
    w:str(lang[v].eng)
end

w:close()
