function SaveParsedQuests()
    print("[ log] saving quests")
    local f40 = assert(io.open(out_path .. "\\" .. "_40+_quests.txt", "w+"))
    local f30 = assert(io.open(out_path .. "\\" .. "_30+_quests.txt", "w+"))
    local f20 = assert(io.open(out_path .. "\\" .. "_20+_quests.txt", "w+"))
    local f10 = assert(io.open(out_path .. "\\" .. "_10+_quests.txt", "w+"))
    local f01 = assert(io.open(out_path .. "\\" .. "_01+_quests.txt", "w+"))
    local ft
    for i,j in pairs(quests) do
        local sz = #j
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
            ft:write("############################\n# file: " .. questnames[i] .. "\n\n")
            for k,v in pairs(j) do
                local str = "<not defined>"
                if lang[v.hash] then
                    if used[v.hash] then
                        --print("!!!" .. v.id)
                        goto skip
                    end
                    str = lang[v.hash]
                    used[v.hash] = true
-- skip <not defenied>
                else
                    goto skip
                end

                ft:write("[" .. v.hash .. "]\n")
                ft:write("id  = " .. v.id .. "\n")
                ft:write("eng = " .. str .. "\n")
                ft:write("rus = \n\n")
--                ft:write("#[" .. v.hash .. "][" .. v.id .. "]\n")
--                ft:write(str .. "\n")
                ::skip::
            end
        end
    end
    f40:close()
    f30:close()
    f20:close()
    f10:close()
    f01:close()
end
