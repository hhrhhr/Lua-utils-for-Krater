local fname = arg[1]
local command = arg[2]
local output = arg[3]

if command == "find" then
    local out = assert(io.open(output, "a+"))
    for line in io.lines(fname) do
        for str in string.gmatch(line, "L%(\"([^%).]+)\"%)") do
            --print(str..", L()")
            out:write(str .. "\n")
        end
        for str in string.gmatch(line, ":lookup%(\"([^%).]+)\"%)") do
            --print(str..", :lookup()")
            out:write(str .. "\n")
        end
        for str in string.gmatch(line, "\"(menu_[%l_]+)\"") do
            out:write(str .. "\n")
        end
        for str in string.gmatch(line, "\"(main_menu_[%l_]+)\"") do
            out:write(str .. "\n")
        end

    end
    out:close()
elseif command == "sort" then
    local strings = {}
    for line in io.lines(fname) do
        table.insert(strings, line)
    end
-- manual founded strings
    for i = 0, 15 do
        table.insert(strings, "rank_" .. i)
    end
    table.insert(strings, "weapons")
    table.insert(strings, "upgrades")
    table.insert(strings, "crafting")
    table.insert(strings, "valuables")
    table.insert(strings, "Blueprint_optional_text")
    table.insert(strings, "restart")
    table.insert(strings, "resume")

    table.insert(strings, "gameplay")
    table.insert(strings, "quickbar")
    table.insert(strings, "selection")
    table.insert(strings, "interface")
    table.insert(strings, "camera")

    table.insert(strings, "apply")
    table.insert(strings, "close")
    table.insert(strings, "default")
    table.insert(strings, "none")

    table.insert(strings, "main_story")
    table.insert(strings, "new_objective")
    table.insert(strings, "recruit")
    table.insert(strings, "sell")
    table.insert(strings, "buy_tab_text")
    table.insert(strings, "buy_back_tab_text_1")
    table.insert(strings, "buy_back_tab_text_2")
    table.insert(strings, "roster")
    table.insert(strings, "view")
    table.insert(strings, "boosters")
    table.insert(strings, "implants")
    table.insert(strings, "operate")
    table.insert(strings, "done")
    table.insert(strings, "sound_settings")
    table.insert(strings, "answer")
    table.insert(strings, "keybindings")

    table.insert(strings, "quest_added")
    table.insert(strings, "quest_complete")
    table.insert(strings, "new_blueprint")
    table.insert(strings, "new_unlock")
    table.insert(strings, "updated")
    table.insert(strings, "completed")
    table.insert(strings, "new_objective")
    table.insert(strings, "new_location")

    table.insert(strings, "attack_menu_button")
    table.insert(strings, "stop_menu_button")
    table.insert(strings, "defend_menu_button")
    table.insert(strings, "coop_menu_button")
    table.insert(strings, "quest_menu_button")
    table.insert(strings, "equipment_menu_button")
    table.insert(strings, "stats_menu_button")
    table.insert(strings, "main_menu_button")
    table.insert(strings, "extract_menu_button")

    table.insert(strings, "crafting_possible")
    table.insert(strings, "crafting_not_possible")
--
    table.sort(strings)
    local sorted = {}
    local old = ""
    for k, v in pairs(strings) do
        if v ~= old then
            table.insert(sorted, v)
            old = v
        end
    end
    local out = assert(io.open(fname, "w+"))
    for k, v in pairs(sorted) do
        out:write(v .. "\n")
    end
end
