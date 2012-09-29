local content = [[
# AngelCode Bitmap Font Generator configuration file
fileVersion=1

# font settings
fontName=%s
charSet=0
fontSize=%d
aa=16
scaleH=100
useSmoothing=1
isBold=0
isItalic=0
useUnicode=1
disableBoxChars=1
outputInvalidCharGlyph=0
useHinting=1
renderFromOutline=0
useClearType=1

# character alignment
paddingDown=0
paddingUp=0
paddingRight=0
paddingLeft=0
spacingHoriz=%d
spacingVert=%d
useFixedHeight=0
forceZero=0

# output file
outWidth=%d
outHeight=%d
outBitDepth=32
fontDescFormat=0
fourChnlPacked=0
textureFormat=tga
textureCompression=0
alphaChnl=%d
redChnl=%d
greenChnl=%d
blueChnl=%d
invA=0
invR=0
invG=0
invB=0

# outline
outlineThickness=%d
]]

local all_chars = [[
# selected chars
chars=32-126,169,174,192-194,196-203,205-207,209,211-212,214,217-220,223-226,228-235,237-239,241,243-244
chars=246,249-252,255,1025,1028,1030-1031,1038,1040-1103,1105,1108,1110-1111,1118,1168-1169,8211-8212
chars=8216-8218,8220-8222,8230,8470,8482
]]

local big_chars = [[
# selected chars
chars=32-96,123-126,169,174,192-194,196-203,205-207,209,211-212,214,217-220,223,1025,1028,1030-1031,1038
chars=1040-1071,1168,8211-8212,8216-8218,8220-8222,8230,8470,8482
]]

--[[
local font = "Ubuntu"
local size = 16
local bold = 1
local width = 256
local height = 256
--]]

function make_bmfc(fontname, size, bold, width, height, outline)
    local a, b, c = 0, 4, 0
    if outline == "_outline" then
        a = 2
        b = 0
        c = size * 0.125
    end

    local p = size * 0.1

    local txt = string.format(content, fontname, size, p,p, width, height, a, b, b, b, c)
    if bold == 1 then
        txt = txt .. big_chars
    else
        txt = txt .. all_chars
    end
    return txt
end
