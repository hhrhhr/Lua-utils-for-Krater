package.path = "lua/?.lua"
require("inc_fonts")
require("inc_bmfc")

-- arguments: fullpath to Krater directory
--          : output path
local game_path = arg[1]
local out_path = arg[2]

function exist(filename)
    local f = io.open(filename)
    if f then
        f:close()
        return true
    end
    return false
end

local f
local fn, fi, fo, txt
local width, height
local bmfc_exe = "tools\\bmfont.exe -c %s -o %s -t %s > nul"
local chars = out_path .. "\\..\\utf8_char_list.txt"
local nvcompress = "tools\\nvcompress.exe -alpha -nomips -bc3 %s %s >nul"

for fnt, v in pairs(fonts) do
    width = 64
    height = 64
    for i, size in pairs(v.sizes) do
        f = new_fonts[fnt]
        fn = out_path .. "\\" .. fnt .. "_" .. size
        fi = fn .. ".bmfc"
        fo = fn .. ".fnt"

        print(fnt .. "_" .. size)
        while true do
            txt = make_bmfc(f.font, size, f.bold, width, height)
            local bmfc = assert(io.open(fi, "w+"))
            bmfc:write(txt)
            bmfc:close()

            print("\ntry to fit in " .. width .. "*" .. height)
            os.execute(string.format(bmfc_exe, fi, fo, chars))

            if exist(fn .. "_1.tga") then
                print("not fitted :(")
                os.execute("del " .. fn .. "_*")
                if width <= height then
                    width = width * 2
                else
                    height = height * 2
                end
            else
                print("OK\n\n")
                break
            end
        end

        os.execute(string.format(nvcompress, fn.."_0.tga", fn..".dds"))

        --os.exit()
    end
end


