package.path = "lua/?.lua"
require("util_binary_reader")

-- arguments: fullpath to Krater directory
--          : output path
local game_path = arg[1]
local out_path = arg[2]

local f = assert(io.open(out_path .. "/db.txt", "w+"))

local reader = BinaryReader
reader:open(game_path .. "/data/" .. "exploded_database.db")
print("[LOG] open db")

local version = reader:int32()
assert(version == 4, "[ERROR] wrong version")
f:write("version = " .. version .. "\n")

local files_count = reader:int32()
print("[LOG] found "..files_count.." files")
f:write("files_count = " .. files_count .. "\n")
f:write("files = [[\n")

for i = 1, files_count do
    local unit_hash = reader:hex32()
    unit_hash = reader:hex32() .. unit_hash
    local file_hash = reader:hex32()
    file_hash = reader:hex32() .. file_hash
    local language = reader:int32()
--[[
    local fffs = reader:int32()
    fffs = fffs < files_count and fffs or -1
    f:write(string.format("\t%s %s %3d %5d %d\n",
        unit_hash, file_hash, language, internal_name, fffs))
]]
    local internal_name = reader:hex32()
    internal_name = reader:hex32() .. internal_name
    local lnk2, lnk1 = reader:hex32(), reader:hex32()
    f:write(string.format("\t%s %s %3d %s %s\n",
        unit_hash, file_hash, language, internal_name, lnk1 .. lnk2))
end
f:write("]]\n")

-- footer
local hash_table_footer = {}
local footer_lenght = reader:int32()
f:write("footer_lenght = " .. footer_lenght .. "\n")
f:write("footer = [[\n")
for i = 1, footer_lenght do
    local f_hash = reader:hex32()
    f_hash = reader:hex32() .. f_hash
    f:write("\t" .. f_hash .. "\n")
end
f:write("]]\n")

local bytes_left = reader:pos() - reader:size()
assert(bytes_left == 0, "[ERROR] file is not parsed until the end, remaining "..bytes_left.." bytes")

reader:close()
print("[LOG] db closed")

f:close()
