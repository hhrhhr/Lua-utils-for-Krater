-- input values

new_fonts = {
    krater = {
        font = "Neucha"
    },
    krater_outline = {
        font = "Neucha"
    },
    fatfont = {
        font = "Cuprum",
        bold = 1
    },
    fat_unicorn = {
        font = "Ubuntu"
    },
    fatshark_medium = {
        font = "Marmelad"
    }
}

fonts = {
    krater = {
        font = "comic_krater",
        sizes = {16, 20, 22, 25, 30, 32, 35, 40, 42, 45, 50}
    },
    krater_outline = {
        font = "comic_krater",
        suff = "_outline",
        sizes = {16}
    },
    fatfont = {
        font = "fatfont",
        sizes = {15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70}
    },
    fat_unicorn = {
        font = "fat_unicorn",
        sizes = {16, 20, 25, 30, 35}
    },
    fatshark_medium = {
        font = "fatshark_medium",
        sizes = {10, 15, 20, 25, 30, 35, 40, 45, 50}
    }
}

-----------------------------------------------------------------------

for font, v in pairs(new_fonts) do
    if not v.bold then
        v.bold = 0
    end
end

local conversion = {
    fatfont = "header_font_krater",
    fatshark_medium = "medium_font_krater"
}

for font, v in pairs(fonts) do
    local desc
    if conversion[font] then
        desc = conversion[font]
    else
        desc = v.font
    end
    local t_names = {}
    local d_names = {}
    for i, size in pairs(v.sizes) do
        local suff = "_" .. size .. (v.suff or "")
        table.insert(t_names, v.font .. suff)
        table.insert(d_names, desc .. suff)
    end
    v.t_names = t_names
    v.d_names = d_names
end
