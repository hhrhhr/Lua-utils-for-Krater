package.path = "lua/?.lua"
require("util_binary_writer")

-- arguments: path to source lang
--          : path to translated
--          : output
local src = arg[1]
local tr = arg[2]
local out = arg[3]

local lang = {}
local hash, str = "", ""
local count = 0

print("[log] open sorce lang")
for line in io.lines(src) do
    hash = string.sub(line, 1, 8)
    str = string.sub(line, 12)
    lang[hash] = str
    count = count + 1
end
print("[log] found " .. count .. " strings")

print("[log] merge with translated strings")
local c = 0
for line in io.lines(tr) do
    hash = string.sub(line, 1, 8)
    str = string.sub(line, 12)
    lang[hash] = str
    c = c + 1
end
print("[log] merged " .. c .. " strings")

print("[log] sort hashes")
local sorted_lang = {}
for k, v in pairs(lang) do
    table.insert(sorted_lang, k)
end
table.sort(sorted_lang)

print("[log] calculate strings lenght")
local string_size = {}
local sz = 0
local offset = count * 8 + 8
for k, hash in ipairs(sorted_lang) do
    table.insert(string_size, offset)
    sz = string.len(lang[hash]) + 1
    offset = offset + sz 
end

print("[log] write binary")
local writer = BinaryWriter
writer:open(out)

writer:int32(1048966062)
writer:int32(count)
for i = 1, count do
    writer:int32(tonumber(string.format("%u", "0x"..sorted_lang[i])))
    writer:int32(string_size[i])
end
for k, hash in ipairs(sorted_lang) do
    writer:str(lang[hash])
end

writer:close()
print("[log] all done")
