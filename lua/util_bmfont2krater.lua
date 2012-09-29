require("util_binary_writer")

function bmfont2krater(input_file, bold)
    assert(input_file, "no input file")
    
    local size, height, base, scaleW, scaleH, count
    local chars, tt = {}, {}
    
    local f = assert(io.open(input_file))
    local line
    
    -- 1st line
    line = f:read("*l")
    for k, v in string.gmatch(line, "(%w+)=(%w+)") do
        tt[k] = tonumber(v)
    end
    size = tt["size"]
    tt = {}
    
    -- 2nd line
    line = f:read("*l")
    for k, v in string.gmatch(line, "(%w+)=(%w+)") do
        tt[k] = tonumber(v)
    end
    height = tt["lineHeight"]
    base = tt["base"]
    scaleW = tt["scaleW"]
    scaleH = tt["scaleH"]
    tt = {}
    
    -- 3rd line
    line = f:read("*l")
    
    -- 4rd line
    line = f:read("*l")
    for k, v in string.gmatch(line, "(%w+)=(%w+)") do
        tt[k] = tonumber(v)
    end
    count = tt["count"]
    tt = {}
    
    -- chars
    for i = 1, count do
        line = f:read("*l")
        for k, v in string.gmatch(line, "(%a+)=([-%d]+)") do
            tt[k] = tonumber(v)
        end
        table.insert(chars, {
            tt["id"], tt["x"], tt["y"], tt["width"], tt["height"],
            tt["xoffset"], tt["yoffset"], tt["xadvance"]
        })
    end
    f:close()

    if bold == 1 then
        local small_chars = {}
        -- latin
        for c = 97, 122 do
            for k, v in pairs(chars) do
                if (v[1] + 32) == c then
                    table.insert(small_chars, {
                        c, v[2], v[3], v[4], v[5], v[6], v[7], v[8]
                    })
                    break
                end
            end
        end
        -- latin supplemented
        for c = 224, 255 do
            for k, v in pairs(chars) do
                if (v[1] + 32) == c then
                    table.insert(small_chars, {
                        c, v[2], v[3], v[4], v[5], v[6], v[7], v[8]
                    })
                    break
                end
            end
        end
        -- cyrillic
        for c = 1072, 1103 do
            for k, v in pairs(chars) do
                if (v[1] + 32) == c then
                    table.insert(small_chars, {
                        c, v[2], v[3], v[4], v[5], v[6], v[7], v[8]
                    })
                    break
                end
            end
        end
        -- cyrillic ua, by
        for c = 1105, 1119 do
            for k, v in pairs(chars) do
                if (v[1] + 80) == c then
                    table.insert(small_chars, {
                        c, v[2], v[3], v[4], v[5], v[6], v[7], v[8]
                    })
                    break
                end
            end
        end
        -- ua Г с крючком
        for k, v in pairs(chars) do
            if (v[1]) == 1168 then
                table.insert(small_chars, {
                    1169, v[2], v[3], v[4], v[5], v[6], v[7], v[8]
                })
                break
            end
        end
        -- concat tables
        for k, v in pairs(small_chars) do
            table.insert(chars, v)
            count = count + 1
        end
        small_chars = nil
        table.sort(chars, function(a, b) return a[1] < b[1] end)
    end -- bold == 1

    local w = BinaryWriter
    local output_file = string.gsub(input_file, ".fnt$", ".bin")
    w:open(output_file)

    w:float32(size)
    w:float32(height)
    w:float32(base)
    w:float32(scaleW)
    w:float32(scaleH)
    w:int32(count)
    
    for k,v in pairs(chars) do
    --print(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
        w:int32(v[1])
        w:float32(v[2])
        w:float32(v[3])
        w:float32(v[4])
        w:float32(v[5])
        w:float32(v[6])
        w:float32(v[7])
        w:float32(v[8])
    end
    
    w:close()
end
