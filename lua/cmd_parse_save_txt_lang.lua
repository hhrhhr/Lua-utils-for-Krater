-- argument: fullpath to translated .txt file
--         : fullpath to output .txt file 
local src = arg[1]
local tgt = arg[2]

local t = assert(io.open(tgt, "w+"))

local str_num = 0   -- string count
local eng_num = 0
local rus_num = 0
local hash

for line in io.lines(src) do
    str_num = str_num + 1
    local str = string.match(line, "^%s*(.-)%s*$") -- clean space
    if str:len() > 0 and str[1] ~= "#" then
        local hs = string.match(str, "%[(%x+)%]")  -- find [section]
        if hs then
            hash = hs
            eng_num = eng_num + 1
        else
            local k, v = string.match(str, "([^=]*)%=(.*)") -- split
            if k then
                k = string.match(k, "^%s*(%S*)%s*$")
                if k == "rus" and v:len() > 0 then
                    v = string.match(v, "^%s*(.-)%s*$")
                    t:write(hash .. " = " .. v .. "\n")
                    rus_num = rus_num + 1
                end
            end
        end
    end
end

print("[log] parsed " .. str_num .. " lines")
print("[log] found " .. eng_num .. " original strings")
print("[log] and " .. rus_num .. " translated strings")

t:close()
