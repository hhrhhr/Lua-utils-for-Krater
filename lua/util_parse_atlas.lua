-- dx,dy = 848,904

package.path = "lua/?.lua;_script/?.lua"

require("scripts/settings/item_archetypes/item_archetypes")
require("scripts/hud/hud_elements")

local img = "\"inventory.jpg\""
local str = ".%s {background:url(%s) -%dpx -%dpx;}"

local weapons = {}

local class = "tank"
for k, v in pairs(ItemArchetypes.weapons) do
    if v.class == class then
        table.insert(weapons, k)

        local icon = v.icon
        local x = HudElements[icon].uv00[1] * 2048 - 848
        local y = HudElements[icon].uv00[2] * 2048 - 904

        local s = string.format(str, icon, img, x, y)
        print(s)
    end
end
print(".i40 {width: 40px; height: 40px;}\n\n")
--table.sort(weapons)

str = [[<tr>
<td><div class="i40 %s"><br /></div></td>
<td><div class="name">%s</div></td>
<td><div class="damage">%d-%d</div></td>
<td><div class="cooldown">%d</div></td>
<td><div class="dps">%d</div></td>
<td><div class="range">%d</div></td>
<td><div class="value">%d</div></td>
</tr>]]

print("<!DOCTYPE HTML>\n<html>\n<head>\n<link rel='stylesheet' href='weapons.css' />\n</head>\n<body>")
print("<table>")
for k, v in pairs(weapons) do
    
    local w = ItemArchetypes.weapons[v]
    local s = string.format(str, w.icon, v, w.min_damage, w.max_damage, w.cooldown, w.dps, w.range, w.value)
    print(s)
end
print("</table>\n</body>\n</html>")