local fname = arg[1]
local command = arg[2]
local output = arg[3]

if command == "find" then
    local out = assert(io.open(output, "a+"))
    for line in io.lines(fname) do
        for str in string.gmatch(line, "L%(\"([^%).]+)\"%)") do
            --print(str..", L()")
            out:write(str .. "\n")
        end
        for str in string.gmatch(line, ":lookup%(\"([^%).]+)\"%)") do
            --print(str..", :lookup()")
            out:write(str .. "\n")
        end
    end
    out:close()
elseif command == "sort" then
    local strings = {}
    for line in io.lines(fname) do
        table.insert(strings, line)
    end
    table.sort(strings)
    local sorted = {}
    local old = ""
    for k, v in pairs(strings) do
        if v ~= old then
            table.insert(sorted, v)
            old = v
        end
    end
    local out = assert(io.open(fname, "w+"))
    for k, v in pairs(sorted) do
        out:write(v .. "\n")
    end
end
