package.path = "lua/?.lua"
require("inc_fonts")
require("inc_bmfc")
require("util_binary_writer")
require("util_bmfont2krater")

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
local ft, fd, fbmfc, ffnt, ftga, fdds, txt
local width, height
local bmfont = "tools\\bmfont.com -c %s -o %s -t %s >nul"
local chars = out_path .. "\\..\\utf8_char_list.txt"
local nvcompress = "tools\\nvcompress.exe -alpha -nomips -bc3 %s %s >nul"

for fnt, v in pairs(fonts) do
    width = 128
    height = 128
    for i, size in pairs(v.sizes) do
        f = fonts[fnt]
        ft = out_path .. "\\" .. f.t_names[i]
        fd = out_path .. "\\" .. f.d_names[i]
        fbmf = fd .. ".bmfc"
        ffnt = fd .. ".fnt"
        ftga = fd .. "_0.tga"
        fdds = ft .. ".dds"

        print(fnt .. "_" .. size)
        while true do
            txt = make_bmfc(f.new_font, size, f.bold, width, height, f.suff)
            local bmfc = assert(io.open(fbmf, "w+"))
            bmfc:write(txt)
            bmfc:close()

            print("\ntry to fit in " .. width .. "*" .. height)
            os.execute(string.format(bmfont, fbmf, ffnt, chars))

            if exist(fd .. "_1.tga") or exist(fd .. "_01.tga") then
                print("not fitted :(")
                os.execute("del " .. fd .. "_*")
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

        os.execute(string.format(nvcompress, ftga, fdds))
        local w = BinaryWriter
        w:update(fdds)
        w:int32(0)
        w:close()

        bmfont2krater(ffnt)

        os.execute("del " .. fd.."_0.tga " .. ffnt .. " " .. fbmf)
    end
end
