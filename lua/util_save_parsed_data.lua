local function WriteString(f_handle, data)
    if not used[data.hash] and lang[data.hash] then
        local hash = data.hash
        local id = data.id
        local str = lang[hash]
        used[hash] = true
        local str_tr = ""
        if lang_tr[hash] then
            str_tr = lang_tr[hash]
        end
        f_handle:write("[" .. hash .. "]\n")
        f_handle:write("id  = " .. id .. "\n")
        f_handle:write(lang_name .. " = " .. str .. "\n")
        f_handle:write(tr_name .." = " .. str_tr .. "\n\n\n")
    end
end

function SaveParsedQuests()
    print("[ log] saving quests")
    local f40 = assert(io.open(out_path .. "\\" .. "_40+_quests.txt", "w+"))
    local f30 = assert(io.open(out_path .. "\\" .. "_30+_quests.txt", "w+"))
    local f20 = assert(io.open(out_path .. "\\" .. "_20+_quests.txt", "w+"))
    local f10 = assert(io.open(out_path .. "\\" .. "_10+_quests.txt", "w+"))
    local f01 = assert(io.open(out_path .. "\\" .. "_01+_quests.txt", "w+"))
    local ft
    for i, quest in pairs(quests) do
        local sz = #quest
        if sz > 0 then
            if sz > 39 then
                ft = f40
            elseif sz > 29 then
                ft = f30
            elseif sz > 19 then
                ft = f20
            elseif sz > 9 then
                ft = f10
            else
                ft = f01
            end
            ft:write(string.rep("#", 40) .. "\n# file: " .. questnames[i] .. "\n\n\n")
            for _, v in pairs(quest) do
                WriteString(ft, v)
            end
        end
    end
    f40:close()
    f30:close()
    f20:close()
    f10:close()
    f01:close()
end

function SaveParsedData()
    print("[ log] saving " .. fname)

    local fout = out_path .. "\\" .. fname .. ".txt"
    local ft = assert(io.open(fout, "w+"))

    local str = ""
    local str_tr = ""
    for _, v in ipairs(t.data) do
        WriteString(ft, v)
    end
    ft:close()
end

