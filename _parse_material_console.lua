if not arg[1] then os.exit() end

local fi = assert(io.open(arg[1],"rb"))

function i32()  --integer
    local i32 = 0
    i32 = i32 + string.byte(fi:read(1)) * 2^0
    i32 = i32 + string.byte(fi:read(1)) * 2^8
    i32 = i32 + string.byte(fi:read(1)) * 2^16
    i32 = i32 + string.byte(fi:read(1)) * 2^24
    return i32
end

function h32()
    local h32 = string.format("%08x", i32())
    return h32
end

function f32()  --float
    local x = i32()
--    x = 1056964608
--    print(x)
--[[    --mirror bits
    local a,b = 0,0
    a = bit32.lshift(bit32.band(x,1431655765),1)
    b = bit32.rshift(bit32.band(x,-1431655766),1)
    x = bit32.bor(a,b)
    a = bit32.lshift(bit32.band(x,858993459),2)
    b = bit32.rshift(bit32.band(x,-858993460),2)
    x = bit32.bor(a,b)
    a = bit32.lshift(bit32.band(x,252645135),4)
    b = bit32.rshift(bit32.band(x,-252645136),4)
    x = bit32.bor(a,b)
    a = bit32.lshift(bit32.band(x,16711935),8)
    b = bit32.rshift(bit32.band(x,-16711936),8)
    x = bit32.bor(a,b)
    a = bit32.lshift(bit32.band(x,65535),16)
    b = bit32.rshift(bit32.band(x,-65536),16)
    x = bit32.bor(a,b)
]]
    local mantissa = bit32.extract(x,0,23)
    local exp = bit32.extract(x,23,8)
    local sig = bit32.extract(x,31,1)

    if sig == 0 then sig = 1 else sig = -1 end
    exp = exp - 127

    local mul = 1
    local res = 1
    for i=22, 0, -1 do
        mul = mul * 0.5
        res = bit32.extract(mantissa,i) * mul + res
    end
--    print(sig,exp,mantissa,res)
    local f = sig * res * math.pow(2,exp)
    f = math.floor(f*1000000)/1000000
    return f
end

--[[ read ]]

local entry_size = i32()    --
local entry_count = i32()
print("entry count:", entry_count)

for i=0, entry_count-1 do
    local fhash = h32()     -- hash of filename
    local dhash = h32()     -- hash of directory???
    local str = string.format("% 4d %s %s",i,fhash,dhash)

    local count = i32()
    local Xhash, Lhash, Hhash = {},{},{}
    for j=1, count do
        Xhash[j] = h32()
        Lhash[j] = h32()
        Hhash[j] = h32()
        local st2 = ""
        if j > 1 then
            st2 = "\n                      "
        end
        str = string.format("%s%s % 2d %s %s",str,st2,j,Xhash[j],Hhash[j]..Lhash[j])
    end
    print(str)

    local num1 = i32()
--    print("    num1:("..num1..")")

    local num2 = i32()
    local t2 = {}
    for j=1, num2 do
        t2[j] = {}
        table.insert(t2[j], i32())
        table.insert(t2[j], i32())
        table.insert(t2[j], h32())
        table.insert(t2[j], i32())
    end
--    print("    num2:("..num2..")")
    for j=1, num2 do
--        print("",t2[j][1],t2[j][2],t2[j][3],t2[j][4])
    end

    local num3 = i32() / 4
    local t3 = {}
    for j=1, num3 do
        table.insert(t3, f32())
    end
--    print("    num3(float):("..num3..") ",table.concat(t3, " "))
--    print("\n")
end

print("pos: " .. fi:seek() - fi:seek("end"))

fi:close()