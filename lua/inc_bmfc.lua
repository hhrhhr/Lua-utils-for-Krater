local content = [[# AngelCode Bitmap Font Generator configuration file
fileVersion=1

# font settings
fontName=%s
charSet=0
fontSize=%d
aa=4
scaleH=100
useSmoothing=1
isBold=%d
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
alphaChnl=0
redChnl=4
greenChnl=4
blueChnl=4
invA=0
invR=0
invG=0
invB=0

# outline
outlineThickness=0]]

--[[
local font = "Ubuntu"
local size = 16
local bold = 1
local width = 256
local height = 256
--]]

function make_bmfc(font, size, bold, width, height)
    return string.format(content, font, size, bold, width, height)
end
