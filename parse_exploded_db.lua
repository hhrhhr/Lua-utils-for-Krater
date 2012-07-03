require("util_binary_reader")

local input = arg[1]

local reader = BinaryReader
reader:open(input)

local header = reader:int32()
assert(header == 3, "[ERROR] wrong header")

local hash_table = {}
local files_count = reader:int32()
for i = 1, files_count do
    local unit_hash = reader:hex32()
    unit_hash = reader:hex32() .. unit_hash
    local file_hash = reader:hex32()
    file_hash = reader:hex32() .. file_hash
    local language = reader:int32()
    local internal_name = reader:int32()
    local fffs = reader:int32()
    if fffs ~= 0xffffffff then
        print(string.format("%s %s %d %d -> %d <- [INFO] unknown field",
            unit_hash, file_hash, language, internal_name, fffs))
    end

    hash_table[file_hash] = {
        unit_hash = unit_hash,
        language = language,
        internal_name = internal_name
    }
end

-- footer
local hash_table_footer = {}
local footer_lenght = reader:int32()
for i = 1, footer_lenght do
    local f_hash = reader:hex32()
    f_hash = reader:hex32() .. f_hash
    table.insert(hash_table_footer, f_hash)
end

local bytes_left = reader:pos() - reader:size()
assert(bytes_left == 0, "[ERROR] file is not parsed to end, left "..bytes_left.." bytes")
reader:close()
