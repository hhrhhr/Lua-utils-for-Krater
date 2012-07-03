BinaryWriter = {
    f_handle = nil
}

function BinaryWriter:open(fullpath)
    self.f_handle = assert(io.open(fullpath, "w+b"))
end

function BinaryWriter:close()
    if self.f_handle then
        self.f_handle:close()
    end
end

function BinaryWriter:pos()
    if self.f_handle then
       return self.f_handle:seek()
    end
end

function BinaryWriter:int8(byte)
    local i8 = string.char(byte)
    self.f_handle:write(i8)
end

function BinaryWriter:int16(word)
    local i82 = string.char(bit32.rshift(word, 8))
    local i81 = string.char(bit32.band(word, 0xff))
    local out = i81 .. i82
    self.f_handle:write(out)
end

function BinaryWriter:int32(int)
    local i84 = string.char(           bit32.rshift(int, 24)       )
    local i83 = string.char(bit32.band(bit32.rshift(int, 16), 0xff))
    local i82 = string.char(bit32.band(bit32.rshift(int, 8),  0xff))
    local i81 = string.char(bit32.band(int,                   0xff))
    local out = i81 .. i82 .. i83 .. i84
    self.f_handle:write(out)
end

function BinaryWriter:float32(float)
    if float == 0 then
        BinaryWriter:int32(0)
        return
    end
    local f = 0
    local sign = 0
    if float < 0 then
        sign = 1
        float = -float
    end
    f = bit32.replace(f, sign, 31, 1)

    local exp = math.floor(math.log(float, 2))
    local mantissa = (float / math.pow(2, exp))
    exp = exp + 127
    f = bit32.replace(f, exp, 23, 8)

    local m = mantissa - 1
    for i = 22, 0, -1 do
        m = m * 2
        if m >= 1 then
            m = m - 1
            f = bit32.replace(f, 1, i, 1)
        end
        if m == 0 then
            break
        end
    end

    BinaryWriter:int32(f)
end
