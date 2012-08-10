package.path = "lua/?.lua;_script/?.lua"
require("util_save_parsed_data")
local murmur = require("murmur")

-- // hacks for game scripts
function Color(r, g, b) return true end
function fassert(v1, v2, v3) return true end
Application = {}
-- \\ hacks
require("scripts/settings/tutorials")
require("scripts/settings/shop_settings")
require("scripts/settings/monster_toppings")
require("scripts/settings/item_archetypes/item_archetypes")
require("scripts/settings/item_archetypes/item_properties")
require("scripts/settings/area_settings")
require("scripts/settings/abilities/abilities")

-- arguments: path to lang file
--          : lang name ("eng" for example)
--          : output directory path
--          : path to translated lang file, not required
--          : lang name ("rus" for example)
local lang_file = arg[1]
      lang_name = arg[2]
      out_path  = arg[3]
local tr_file   = arg[4]
      tr_name   = arg[5] or "new"

-- counters
local all_str = 0
local tr_str = 0
local used_str = 0
local unused_str = 0

--[[
-- fing english localization
require("util_parse_exploded_db")
require("util_parse_bin_lang")
local db = parse_exploded_db(game_path .. "/data/" .. "exploded_database.db")
local strings = "localization/game_strings"
local a, b = murmur.hash64A(strings)
strings = (a..b):lower()
local lang_file = db[strings].internal_name
lang, all_str = parse_bin_language(game_path .. "\\data\\" .. make_path(lang_file))
used = {}
]]

-- language tables
lang = {}
lang_tr = {}
used = {}

local hash, str = "", ""
for line in io.lines(lang_file) do
    hash = string.sub(line, 1, 8)
    str = string.sub(line, 12)
    lang[hash] = str
    all_str = all_str + 1
end

if tr_file then
    for line in io.lines(tr_file) do
        hash = string.sub(line, 1, 8)
        str = string.sub(line, 12)
        lang_tr[hash] = str
        tr_str = tr_str + 1
    end
end

-- main

t = { data = {} }
function t:add(param)
    if not param or string.len(param) == 0 then return end
    local _hash = murmur.hash64A(param):lower()
    for k,v in pairs(self.data) do
        if v.hash == _hash then
            --print("[info] duplicate skipped: ".._hash.." "..param)
            return
        end
    end
    local tt = {hash = _hash, id = param}
    table.insert(self.data, tt)
end
function t:clear()
    self.data = {}
end
function t:sort()
    table.sort(self.data, function(a,b) return a.id < b.id end)
end


--[[ output: gui.txt ********************************************************]]
fname = "gui"

for line in io.lines("_work\\strings_in_scripts.txt") do
    t:add(line)
end
--t:sort()  -- already sorted in cmd_find_strings_in_scripts.lua
SaveParsedData()
t:clear()

--[[ output: tutorials.txt  *************************************************]]
fname = "tutorials"
local parse = Tutorials

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(v.caption)
    t:add(v.text)
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: shop.txt *******************************************************]]
fname = "shops"
local parse = ShopArchetypes

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(v.name)
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: monsters.txt  *************************************************]]
fname = "monsters"
local parse = ArchetypeGroups

print("[ log] parsing "..fname)
for i, j in pairs(parse) do
    for k = 1, #j, 2 do
        t:add(j[k])
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ prepare to item_archetypes *********************************************]]
local function parse_weapon(class)
    print("[ log] parsing "..fname)
    for k, v in pairs(ItemArchetypes.weapons) do
        if v.class == class then
            t:add(k)
            local opt = v.optional_text
            if opt then
                t:add(opt)
            end
        end
    end
    t:sort()
    SaveParsedData()
    t:clear()
end

--[[ output: weapons_(tank|cc|healer|dps).txt *******************************]]
fname = "weapons_tank"
parse_weapon("tank")

fname = "weapon_cc"
parse_weapon("cc")

fname = "weapon_healer"
parse_weapon("healer")

fname = "weapon_dps"
parse_weapon("dps")

--[[ output: weapon_epic.txt ************************************************]]
fname = "weapon_epic"
local parse = ItemArchetypesDesigned

print("[ log] parsing "..fname)
for _, j in pairs(parse) do
    for k, v in pairs(j) do
        t:add(k)
        t:add(v.name)
        local opt = v.optional_text
        if opt then
            t:add(opt)
        end
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: blueprints.txt *************************************************]]
--[[
fname = "blueprints"
local parse = ItemArchetypes.blueprints

print("[ log] parsing "..fname)
for k,v in pairs(parse) do
    print(k,v)
end
]]

--[[ output: gadgets.txt ****************************************************]]
fname = "gadgets"
local parse = ItemArchetypes.gadgets

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(k)
    t:add(v.description)
    local opt = v.optional_text
    if opt then
        t:add(opt)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: injuries.txt ***************************************************]]
fname = "injuries"
local parse = ItemArchetypes.injuries

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(v.name)
    local desc = v.description
    if desc then
        t:add(desc)
    end
    local opt = v.optional_text
    if opt then
        t:add(opt)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: trash.txt ******************************************************]]
fname = "trash"
local parse = ItemArchetypes.trash

print("[ log] parsing "..fname)
for i, j in pairs(parse) do
    for k, v in pairs(j.levels) do
        t:add(v.loc)
        local opt = v.optional_text
        if opt then
            t:add(opt)
        end
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: enhancement.txt ************************************************]]
fname = "enhancement"
local parse = ItemArchetypes.enhancements

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(k)
    local desc = v.description
    if desc then
        t:add(desc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: craft.txt ******************************************************]]
fname = "craft"
local parse = ItemArchetypes.craft

print("[ log] parsing "..fname)
for i, j in pairs(parse) do
    for k, v in pairs(j.levels) do
        t:add(v.loc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: components.txt *************************************************]]
fname = "components"
local parse = ItemArchetypes.components

print("[ log] parsing "..fname)
for i, j in pairs(parse) do
    for k, v in pairs(j.levels) do
        local id = v.id
        if id then
            t:add(id)
        end
    end
    t:add(j.name)
    local desc = j.description
    if desc then
        t:add(desc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: properties.txt *************************************************]]
fname = "properties"
local parse = ItemPropertiesPowerNames

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(v)
end

local parse = ItemProperties
for k, v in pairs(parse) do
    if v.type == "prefix" or v.type == "suffix" then
        for i, j in pairs(v) do
            if type(j) == "table" then
                t:add(j.name)
            end
        end
    elseif v.type == "components" then
        if v.stat == "buff" then
            for i, j in pairs(v.buffs) do
                t:add(j)
            end
        else
            t:add(v.name)
        end
    elseif v.type == "injuries" then
        t:add(v.stat)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: areas.txt ******************************************************]]
fname = "areas"
local parse = RANDOM_LOADING_SCREEN_TEXTS

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    t:add(v)
end

local parse = AreaSettings
for k, v in pairs(parse) do
    t:add(v.name)
    for i, j in pairs(v.layout) do
        t:add(j.name)
        local tid = j.loading_screen.text_id
        if type(tid) ~= "table" then
            t:add(tid)
        end
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: abilities.txt  *************************************************]]
fname = "abilities"
local parse = Abilities

print("[ log] parsing "..fname)
local abils = {}
for k, v in pairs(parse) do
    if v.icon then
        table.insert(abils, tostring(k))
    end
end
table.sort(abils)

for i, j in pairs(abils) do
    local ab = parse[j]
    t:add(ab.name)
    local desc = ab.description
    if desc then
        t:add(desc)
    end
    local opt = ab.optional_text
    if opt then
        t:add(opt)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: quest.txt ******************************************************]]
fname = "scripts/managers/interaction/interaction_requires"
questnames = {}

print("[ log] parsing quests")
for line in io.lines("_script/" .. fname..".lua") do
    line = string.match(line, "%(\"(.*)\"%)$")      -- skip (" ")
    line = string.match(line, "/([^/.]*)$")         -- take script name
    table.insert(questnames, line)
end

require(fname)
require("parse_quest")
quests = {}
for k, v in pairs(questnames) do
    local s = ""
    s = "table.insert(quests, parse_quest(" .. v .. "))"
    local chunk = load(s)
    local activate = chunk()
end
SaveParsedQuests()
t:clear()



--[[ calculate used strings *************************************************]]
for k, v in pairs(used) do
    used_str = used_str + 1
end
print("[info] used only " .. used_str .. " localized strings\n")

--[[ save unused strins *****************************************************]]
print("[ log] parsing unknown strings")
local sorted_lang = {}
for k, v in pairs(lang) do
    if not used[k] then
        table.insert(sorted_lang, k)
    end
end
table.sort(sorted_lang)

print("[ log] saving unknown strings")
local ft = assert(io.open(out_path .. "\\" .. "__unused.txt", "w+"))
for k, v in pairs(sorted_lang) do
    if not used[k] then
        unused_str = unused_str + 1

        ft:write("[" .. v .. "]\n")
        ft:write("id  = \n")
        ft:write(lang_name .. " = " .. lang[v] .. "\n")
        ft:write(tr_name .. " = \n\n")
    end
end
ft:close()
print("[info] saved "..unused_str.." unknown strings\n")

if used_str + unused_str == all_str then
    print("[info] "..used_str.."+"..unused_str.."="..all_str..", all OK")
else
    print("[warn] "..used_str.."+"..unused_str.."!="..all_str..", something wrong")
end