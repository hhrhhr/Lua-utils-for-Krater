function parse_language(fullpath)

    print("[ log] parsing localization...")
    --local fname = "localization/game_strings.txt"

    local lang = {}
    local c = 0
    local all_str = 0
    local section

    for line in io.lines(fullpath) do
        c = c + 1
        if c == 1 then goto skip end
        local str = string.match(line, "^%s*(.-)%s*$")     -- clean space
        if #str > 0 and str[1] ~= "#" then
            local sec = string.match(str, "^%[([%w%s]*)%]$") -- find [section]
            if sec and sec ~= "EOF" then
                section = sec
                lang[sec] = {}
                all_str = all_str + 1
            else
                local k, v = string.match(str, "([^=]*)%=(.*)")
                if k then
                    k = string.match(k, "^%s*(%S*)%s*$")
                    v = string.match(v, "^%s*(.-)%s*$")
                    lang[section][k] = v
                    lang[section]["used"] = false
                end
            end
        end
        if (c % 5000) == 0 then print("[ log] process line "..c) end
        ::skip::
    end

    print("[ log] loaded "..c.." lines")
    print("[info] found "..all_str.." localized strings\n")

    --[[
    for k, v in pairs(lang) do
      for k1, v1 in pairs(v) do
        print(string.format("-%s-,-%s-,-%s-",k, k1, v1))
      end
    end
    ]]

    return lang, all_str
end