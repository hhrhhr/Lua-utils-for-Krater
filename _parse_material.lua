function parse_material(fullpath)
    local fi = assert(io.open(fullpath,"rb"))

--[[ functions ]]
    function i32()  -- integer
        local i32 = 0
        i32 = i32 + string.byte(fi:read(1)) * 2^0
        i32 = i32 + string.byte(fi:read(1)) * 2^8
        i32 = i32 + string.byte(fi:read(1)) * 2^16
        i32 = i32 + string.byte(fi:read(1)) * 2^24
        return i32
    end

    function h32()  -- hex
        local h32 = string.format("%08x", i32())
        return h32
    end

    function f32()  -- float
        local x = i32()
        local mantissa = bit32.extract(x, 0, 23)
        local exp = bit32.extract(x, 23, 8) - 127
        local sign = bit32.extract(x, 31, 1)
        if sign == 0 then sign = 1 else sign = -1 end
        local mul, res = 1, 1
        for i=22, 0, -1 do
            mul = mul * 0.5
            res = bit32.extract(mantissa, i) * mul + res
        end
        local f = sign * res * math.pow(2, exp)
        return f
    end

--[[ parse start ]]
    local hash_table = {}

    local entry_size = i32()
    local entry_count = i32()
    for i=0, entry_count - 1 do
        local fhash = h32()     -- 32 bit, hash of filename
        local dhash = h32()     -- 32 bit, hash of directory???
        local count = i32()
        local xhash = {}        -- 32 bit, unknown
        local tex_hash = {}     -- 64 bit, DDS texture hash
        for j = 1, count do
            xhash[j] = h32()
            local hl,hh = h32(), h32()
            tex_hash[j] = hh .. hl
            hash_table[fhash] = tex_hash[j]
        end

        local num1 = i32()
        local num2 = i32()
        local t2 = {}
        for j=1, num2 do
            t2[j] = {}
            table.insert(t2[j], i32())
            table.insert(t2[j], i32())
            table.insert(t2[j], h32())
            table.insert(t2[j], i32())
        end
        local num3 = i32() / 4
        local t3 = {}
        for j=1, num3 do
            table.insert(t3, f32())
        end
    end
    assert((fi:seek() - fi:seek("end")) == 0)
    fi:close()

    return hash_table
end