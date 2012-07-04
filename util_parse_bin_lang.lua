function parse_bin_language(fullpath)

    dofile("util_binary_reader.lua")
    local r = BinaryReader
    r:open(fullpath)

    local check = r:hex32()
    assert(check == "3e85f3ae", "header not math, "..check.."~=3e85f3ae")

    local lang = {}
    local string_num = r:int32()
    local str, hash = "", ""
    local offset, pos = 0, 0
    local hashes, offsets, strings = {}, {}, {}

    for i = 1, string_num do
        hash = r:hex32()
        offset = r:int32()
        table.insert(hashes, hash)
        table.insert(offsets, offset)
    end

--    local len = 0
    for i = 1, string_num do
--        len = (offsets[i+1] or r:size()) - offsets[i]
--        str = r:str(len)
        str = r:str()
        table.insert(strings, str)
    end

    for i = 1, string_num do
        lang[hashes[i]] = strings[i]
    end

    return lang
end
