dofile("util_parse_bin_lang.lua")

local fname = "f:\\steam\\steamapps\\common\\krater\\data\\64\\6477"

local lang = {}
lang = parse_bin_language(fname)

for k,v in pairs(lang) do
    print(k,v)
end
