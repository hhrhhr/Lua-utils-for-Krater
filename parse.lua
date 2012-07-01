murmur = require("murmur")
require("save_parsed_data")

lang = {}
all_str = 0
used_str = 0
unused_str = 0
dofile("load_lang.lua")

t = { data = {} }
function t:add(v1, v2)
    for k,v in pairs(self.data) do
        if v.hash == v1 then
            --print("[info] duplicate skipped: "..v1.." "..v2)
            return
        end
    end
    local tt = {hash = v1, id = v2}
    table.insert(self.data, tt)
end
function t:clear()
    self.data = {}
end
function t:sort()
    table.sort(self.data, function(a,b) return a.id < b.id end)
end


--[[*************************************************************************]]

--[[ output: tutorials.txt  *************************************************]]
require("scripts/settings/tutorials")
fname = "tutorials"
local parse = Tutorials

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    local hash_cap = murmur.hash64A(v.caption, #v.caption):lower()
    t:add(hash_cap, v.caption)

    local hash_txt = murmur.hash64A(v.text, #v.text):lower()
    t:add(hash_txt,v.text)
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: shop.txt *******************************************************]]
require("scripts/settings/shop_settings")
fname = "shops"
local parse = ShopArchetypes

print("[ log] parsing "..fname)
for k, v in pairs(parse) do
    local hash_name = murmur.hash64A(v.name, #v.name):lower()
    t:add(hash_name, v.name)
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: monsters.txt  *************************************************]]
require("scripts/settings/monster_toppings")
fname = "monsters"
local parse = ArchetypeGroups

print("[ log] parsing "..fname)
for i, j in pairs(parse) do
    for k = 1, #j, 2 do
        local hash_name = murmur.hash64A(j[k], #j[k]):lower()
        t:add(hash_name, j[k])
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[*************************************************************************]]

--[[ prepare to item_archetypes *********************************************]]
require("scripts/settings/item_archetypes/item_archetypes")

local function parse_weapon(class)
    print("[ log] parsing "..fname)
    for k, v in pairs(ItemArchetypes.weapons) do
        if v.class == class then
            local hash_name = murmur.hash64A(k, #k):lower()
            t:add(hash_name, k)

            local opt = v.optional_text
            if opt then
                local hash_txt = murmur.hash64A(opt, #opt):lower()
                t:add(hash_txt, opt)
            end
        end
    end
    t:sort()
    SaveParsedData()
    t:clear()
end

--[[ output: weapons_tank.txt ***********************************************]]
fname = "weapons_tank"
parse_weapon("tank")

--[[ output: weapon_cc.txt **************************************************]]
fname = "weapon_cc"
parse_weapon("cc")

--[[ output: weapon_healer.txt **********************************************]]
fname = "weapon_healer"
parse_weapon("healer")

--[[ output: weapon_dps.txt *************************************************]]
fname = "weapon_dps"
parse_weapon("dps")

--[[ output: weapon_epic.txt ************************************************]]
fname = "weapon_epic"
local parse = ItemArchetypesDesigned

print("[ log] parsing "..fname)
for _,j in pairs(parse) do
    for k, v in pairs(j) do
        local hash = murmur.hash64A(k, #k):lower()
        t:add(hash, k)

        local hash_name = murmur.hash64A(v.name, #v.name):lower()
        t:add(hash_name, v.name)

        local opt = v.optional_text
        if opt then
            local hash_opt = murmur.hash64A(opt, #opt):lower()
            t:add(hash_opt, opt)
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
    local hash = murmur.hash64A(k, #k):lower()
    t:add(hash, k)

    local hash_desc = murmur.hash64A(v.description, #v.description):lower()
    t:add(hash_desc, v.description)

    local opt = v.optional_text
    if opt then
        local hash_opt = murmur.hash64A(opt, #opt):lower()
        t:add(hash_opt, opt)
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
    local hash_name = murmur.hash64A(v.name, #v.name):lower()
    t:add(hash_name, v.name)

    local desc = v.description
    if desc then
        local hash_desc = murmur.hash64A(desc, #desc):lower()
        t:add(hash_desc, desc)
    end

    local opt = v.optional_text
    if opt then
        local hash_opt = murmur.hash64A(opt, #opt):lower()
        t:add(hash_opt, opt)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: trash.txt ******************************************************]]
fname = "trash"
local parse = ItemArchetypes.trash

print("[ log] parsing "..fname)
for i,j in pairs(parse) do
    for k,v in pairs(j.levels) do
        local hash_loc = murmur.hash64A(v.loc, #v.loc):lower()
        t:add(hash_loc, v.loc)

        local opt = v.optional_text
        if opt then
            local hash_opt = murmur.hash64A(opt, #opt):lower()
            t:add(hash_opt, opt)
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
    local hash_name = murmur.hash64A(v.name, #v.name):lower()
    t:add(hash_name, k)

    local desc = v.description
    if desc then
        local hash_desc = murmur.hash64A(desc, #desc):lower()
        t:add(hash_desc, desc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: craft.txt ******************************************************]]
fname = "craft"
local parse = ItemArchetypes.craft

print("[ log] parsing "..fname)
for i,j in pairs(parse) do
    for k,v in pairs(j.levels) do
        local hash_loc = murmur.hash64A(v.loc, #v.loc):lower()
        t:add(hash_loc, v.loc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: components.txt *************************************************]]
fname = "components"
local parse = ItemArchetypes.components

print("[ log] parsing "..fname)
for i,j in pairs(parse) do
    for k,v in pairs(j.levels) do
        local id = v.id
        if id then
            local hash_id = murmur.hash64A(id, #id):lower()
            t:add(hash_id, id)
        end
    end

    local hash_name = murmur.hash64A(j.name, #j.name):lower()
    t:add(hash_name, j.name)

    local desc = j.description
    if desc then
        local hash_desc = murmur.hash64A(desc, #desc):lower()
        t:add(hash_desc, desc)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: properties.txt *************************************************]]
-- // hacks
function Color(r,g,b) return true end
function fassert(v1,v2,v3) return true end --print(string.format("!!!fassert!!! %s: %s %s",v1,v2,v3)) end
-- \\ hacks

require("scripts/settings/item_archetypes/item_properties")
fname = "properties"
print("[ log] parsing "..fname)

local parse = ItemPropertiesPowerNames
for k,v in pairs(parse) do
    local hash_name = murmur.hash64A(v, #v):lower()
    t:add(hash_name, v)
end

local parse = ItemProperties
for k,v in pairs(parse) do
    if v.type == "prefix" or v.type == "suffix" then
        for i,j in pairs(v) do
            if type(j) == "table" then
                --print("",i,j.name)
                local hash_name = murmur.hash64A(j.name, #j.name):lower()
                t:add(hash_name, j.name)
            end
        end
    elseif v.type == "components" then
        if v.stat == "buff" then
            for i,j in pairs(v.buffs) do
                local hash_buff = murmur.hash64A(j, #j):lower()
                t:add(hash_buff, j)
            end
        else
            local hash_comp = murmur.hash64A(v.name, #v.name):lower()
            t:add(hash_comp, v.name)
        end
    elseif v.type == "injuries" then
        local hash_stat = murmur.hash64A(v.stat, #v.stat):lower()
        t:add(hash_stat, v.stat)
    end
end
t:sort()
SaveParsedData()
t:clear()

--[[ output: areas.txt ******************************************************]]
-- // hacks
Application = {}
-- \\ hacks
require("scripts/settings/area_settings")
fname = "areas"
print("[ log] parsing "..fname)

local parse = RANDOM_LOADING_SCREEN_TEXTS
for k,v in pairs(parse) do
    local hash_tip = murmur.hash64A(v, #v):lower()
    t:add(hash_tip, v)
end
--local tips = t.data
--t:clear()

local parse = AreaSettings
for k,v in pairs(parse) do
    local hash_name = murmur.hash64A(v.name, #v.name):lower()
    t:add(hash_name, v.name)
    for i,j in pairs(v.layout) do
        local hash_name = murmur.hash64A(j.name, #j.name):lower()
        t:add(hash_name, j.name)

        local tid = j.loading_screen.text_id
        if type(tid) ~= "table" then
            local hash_tid = murmur.hash64A(tid, #tid):lower()
            t:add(hash_tid, tid)
        end
    end
end

t:sort()
SaveParsedData()
t:clear()

--[[ output: abilities.txt  *************************************************]]
require("scripts/settings/abilities/abilities")
fname = "abilities"
local parse = Abilities

print("[ log] parsing "..fname)

local abils = {}
for k,v in pairs(parse) do
    if v.icon then
        table.insert(abils,tostring(k))
    end
end
table.sort(abils)

for i,j in pairs(abils) do
    local ab = parse[j]

    local hash_name = murmur.hash64A(ab.name, #ab.name):lower()
    t:add(hash_name, ab.name)

    local desc = ab.description
    if desc then
        local hash_desc = murmur.hash64A(desc, #desc):lower()
        t:add(hash_desc, desc)
    end

    local opt = ab.optional_text
    if opt then
        local hash_txt = murmur.hash64A(opt, #opt):lower()
        t:add(hash_txt, opt)
    end
end
--t:sort()
SaveParsedData()
t:clear()



--[[ output: quest.txt ******************************************************]]
fname = "scripts/managers/interaction/interaction_requires"
questnames = {}

print("[ log] parsing quests")
for line in io.lines(fname..".lua") do
    line = string.match(line, "%(\"(.*)\"%)$")
    line = string.match(line, "/([^/.]*)$")
    table.insert(questnames, line)
end
require(fname)
require("parse_quest")
quests = {}
for k,v in pairs(questnames) do
    local s
    s = "table.insert(quests, parse_quest(" .. v .. "))"
    local chunk = load(s)
    local activate = chunk()
end
require("save_parsed_quest")
SaveParsedQuests()




--[[ calculate used strings *************************************************]]
for k,v in pairs(lang) do
    if v.used then used_str = used_str + 1 end
end
print("[info] used only "..used_str.." localized strings\n")

--[[ save unused strins *****************************************************]]
print("[ log] parsing unused strings")
local newlang = {}
for k,v in pairs(lang) do
    if not v.used then
        table.insert(newlang, k)
    end
end
table.sort(newlang)

print("[ log] saving unused strings")
local ft = assert(io.open("__unused.txt", "w+"))
for k,v in pairs(newlang) do
    if not lang[v].used then
        unused_str = unused_str + 1

        ft:write("[" .. v .. "]\n")
        ft:write("id  = \n")
        ft:write("eng = " .. lang[v].eng .. "\n")
        ft:write("rus = \n\n")
--[[
        ft:write("#[" .. v .. "]\n")
        ft:write(lang[v].eng .. "\n")
]]
    end
end
ft:close()

print("[info] saved "..unused_str.." unknown strings\n")
if used_str+unused_str == all_str then
    print("[info] "..used_str.."+"..unused_str.."="..all_str..", all OK")
else
    print("[warn] "..used_str.."+"..unused_str.."!="..all_str..", something wrong")
end
