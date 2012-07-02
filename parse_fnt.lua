--[[
float size;         // vertical height, px
float lineHeight;   // distance in pixels between each line of text.
float base;         // number of pixels from the absolute top of the line to the base of the characters
float textureWidth;
float textureHeight;
long glyphCount;
for (i = 0; i < glyphCount; i++) {
  long glyphCode;   // UTF8
  float x;          // left position of the character image in the texture
  float y;          // top ...
  float width;      // width of the character image in the texture
  float height;     // height ...
  float xOffset;    // how much the current position should be offset when copying the image from the texture to the screen
  float yOffset;    // ...
  float xAdvance;   // How much the current position should be advanced after drawing the character
}
]]

require("util_binary_reader")

local input = arg[1]
local reader = BinaryReader
reader:open(input)
local fnt = {
    size = reader:float32(),
    height = reader:float32(),
    base = reader:float32(),
    tex_width = reader:float32(),
    tex_heigth = reader:float32(),
    glyph_count = reader:int32(),
    glyphs = {}
}

for i = 1, fnt.glyph_count do
    local tt = {
        code = reader:int32(),
        x = reader:float32(),
        y = reader:float32(),
        width = reader:float32(),
        height = reader:float32(),
        x_offset = reader:float32(),
        y_offset = reader:float32(),
        x_advance = reader:float32()
    }
    table.insert(fnt.glyphs, tt)
end
reader:close()

local str = ""
local old = -1
local new = -1
local p = 0
for k,v in pairs(fnt.glyphs) do
    new = v.code
    if p == 0 then
        str = new
        p = p + 1
    elseif new - old > 1 then
        if p == 1 then
            str = str .. "," .. new
            --p = 1
        else
            str = str .. "-" .. old .. "," .. new
            --p = 1
        end
        p = 1
    else
        p = p + 1
    end
    old = new
end

print("size="..fnt.size..", height="..fnt.height..", base="..fnt.base..
        ", width="..fnt.tex_width..", height="..fnt.tex_heigth)
print(str)

--[[
for k,v in pairs(fnt) do
    print(k,v)
    if type(v) == "table" then
        for i,j in pairs(v) do
            print(j.code.." "..j.x.." "..j.y.." "..j.width.." "..j.height.." "
                    ..j.x_offset.." "..j.y_offset.." "..j.x_advance)
        end
    end
end
]]
