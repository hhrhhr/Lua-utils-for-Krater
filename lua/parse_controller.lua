package.path = "lua/?.lua;_script/?.lua"
local murmur = require("murmur")
require("scripts/settings/controller_settings")

local Settings = {
    PlayerControllerSettings,
    OnScreenMouseControllerSettings,
    LoginControllerSettings,
    QuestTrackerControllerSettings,
    TopDownPlayerControllerSettings
}

local settings = {}

for k, v in pairs(Settings) do
    for k1, v1 in pairs(v) do
        for k2, v2 in pairs(v1) do
            table.insert(settings, k2)
        end
    end
end

Settings = nil

table.sort(settings)
local tmp = ""
for k, v in pairs(settings) do
    if tmp ~= v then
        print(v)
        tmp = v
    end
end
