require("util_binary_reader")

function parse_material(fullpath)
    local reader = BinaryReader
    reader:open(fullpath)
    print("[LOG] open material file")

    local hash_table = {}

    local entry_size = reader:int32()
    local entry_count = reader:int32()
    print("[LOG] found "..entry_count.." entries")

    for i=0, entry_count - 1 do
        local fhash = reader:hex32()    -- 32 bit, hash of filename
        local dhash = reader:hex32()    -- 32 bit, hash of directory???
        local count = reader:int32()
        local xhash = {}                -- 32 bit, unknown
        local tex_hash = {}             -- 64 bit, DDS texture hash
        for j = 1, count do
            xhash[j] = reader:hex32()
            local hl,hh = reader:hex32(), reader:hex32()
            tex_hash[j] = hh .. hl
            hash_table[fhash] = tex_hash[j]
        end

        local num1 = reader:int32()
        local num2 = reader:int32()
        local t2 = {}
        for j=1, num2 do
            t2[j] = {}
            table.insert(t2[j], reader:int32())
            table.insert(t2[j], reader:int32())
            table.insert(t2[j], reader:hex32())
            table.insert(t2[j], reader:int32())
        end
        local num3 = reader:int32() / 4
        local t3 = {}
        for j=1, num3 do
            table.insert(t3, reader:float32())
        end
        -- t2 and t3 not used now
    end
    print("[LOG] hash table created")

    local bytes_left = reader:pos() - reader:size()
    assert(bytes_left == 0, "[ERROR] file is not parsed to end, left "..bytes_left.." bytes")

    reader:close()
    print("[LOG] material file closed")

    return hash_table
end
