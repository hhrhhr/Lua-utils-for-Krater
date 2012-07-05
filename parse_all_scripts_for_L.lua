local fname = arg[1]

for line in io.lines(fname) do
    for str in string.gmatch(line, "L%(\"([^%).]+)\"%)") do
        --print(str..", L()")
        print(str)
    end
    for str in string.gmatch(line, ":lookup%(\"([^%).]+)\"%)") do
        --print(str..", :lookup()")
        print(str)
    end
end
