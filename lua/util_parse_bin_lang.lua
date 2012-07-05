require("util_binary_reader")

function parse_bin_language(fullpath)
    local r = BinaryReader
    r:open(fullpath)
    print("[LOG] open lang file")

    local check = r:hex32()
    assert(check == "3e85f3ae", "header not math, "..check.."~=3e85f3ae")

    local lang = {}
    local string_num = r:int32()
    print("[LOG] found "..string_num.." strings")

    local str, hash = "", ""
    local offset, pos = 0, 0
    local hashes, offsets, strings = {}, {}, {}

    for i = 1, string_num do
        hash = r:hex32()
        offset = r:int32()
        table.insert(hashes, hash)
        table.insert(offsets, offset)
    end
    print("[LOG] offsets readed")

--    local len = 0
    for i = 1, string_num do
--        len = (offsets[i+1] or r:size()) - offsets[i]
--        str = r:str(len)
        str = r:str()
        table.insert(strings, str)
    end
    print("[LOG] strings readed")

    for i = 1, string_num do
        lang[hashes[i]] = strings[i]
    end
    print("[LOG] lang table created")

    r:close()
    print("[LOG] lang file closed")

    return lang
end
