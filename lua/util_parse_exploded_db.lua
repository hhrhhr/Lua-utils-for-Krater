require("util_binary_reader")

function parse_exploded_db(fullpath)
    local reader = BinaryReader
    reader:open(fullpath)
    print("[LOG] open db")

    local header = reader:int32()
    assert(header == 3, "[ERROR] wrong header")

    local hash_table = {}

    local files_count = reader:int32()
    print("[LOG] found "..files_count.." files")

    for i = 1, files_count do
        local unit_hash = reader:hex32()
        unit_hash = reader:hex32() .. unit_hash
        local file_hash = reader:hex32()
        file_hash = reader:hex32() .. file_hash
        local language = reader:int32()
        local internal_name = reader:int32()
        local fffs = reader:int32()
--[[        if fffs ~= 0xffffffff then
            print(string.format("[INF] unknown field: %s %s %d %d -> %d <-",
                unit_hash, file_hash, language, internal_name, fffs))
        end
]]
        if language == 0 then
            hash_table[file_hash] = {
                unit_hash = unit_hash,
                internal_name = internal_name
            }
        else
            hash_table[file_hash][language] = {
                unit_hash = unit_hash,
                internal_name = internal_name
            }
        end
    end
    print("[LOG] hash table created")

    -- footer
    local hash_table_footer = {}
    local footer_lenght = reader:int32()
    for i = 1, footer_lenght do
        local f_hash = reader:hex32()
        f_hash = reader:hex32() .. f_hash
        table.insert(hash_table_footer, f_hash)
    end

    local bytes_left = reader:pos() - reader:size()
    assert(bytes_left == 0, "[ERROR] file is not parsed until the end, remaining "..bytes_left.." bytes")

    reader:close()
    print("[LOG] db closed")

    return hash_table
end
