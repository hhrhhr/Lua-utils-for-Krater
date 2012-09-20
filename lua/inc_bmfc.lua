local content = [[# AngelCode Bitmap Font Generator configuration file
fileVersion=1

# font settings
fontName=%s
charSet=0
fontSize=%d
aa=%d
scaleH=100
useSmoothing=%d
isBold=%d
isItalic=0
useUnicode=1
disableBoxChars=1
outputInvalidCharGlyph=0
useHinting=1
renderFromOutline=1
useClearType=1

# character alignment
paddingDown=0
paddingUp=0
paddingRight=0
paddingLeft=0
spacingHoriz=4
spacingVert=4
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
outlineThickness=%d]]

--[[
local font = "Ubuntu"
local size = 16
local bold = 1
local width = 256
local height = 256
--]]

function make_bmfc(fontname, size, bold, width, height, outline)
    local aa, smooth = 16, 1
    if size < 20 then
        --aa = 0
        --smooth = 0
    end
    local a, b, c = 0, 4, 0
    if outline == "_outline" then
        a = 1
        b = 0
        c = 2
    end
    return string.format(content, fontname, size, aa, smooth, bold, width, height, a, b, b, b, c)
end
