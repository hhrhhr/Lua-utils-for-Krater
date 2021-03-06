local str_num = 0
local T = {}

function add(param)
    if #param == 0 then return end
    str_num = str_num + 1
    local _hash = murmur.hash64A(param):lower()
    for k,v in pairs(T) do
        if v.hash == _hash then
            --print("!!! duplicate ".._hash.." "..param)
            return
        end
    end
    local tt = {hash = _hash, id = param}
    table.insert(T, tt)
end
function clearT()
    str_num = 0
    T = {}
end
function getT()
    return T
end

function fill(num, suf)
    return "#" .. string.rep("-",num) ..
        num .. (suf or "") ..
        string.rep(" ", (suf and 13 or 14) - num)
end



function parse_progress(prerequisites)
    for k,v in pairs(prerequisites) do
        --print("# 2",k,v)
        if v.type == "stat" then
            --print("# 2",v.stat_id)
            add(v.stat_id or k)
        else if v.type = "quest" then
            add(v.quest_id)
        else
            --print("# 2!",v.type)
        end
    end
end

function parse_branch(branch, level)
    local l = level or 1
    for k,v in pairs(branch) do
        if v.type == "text_choice" then
            --print(fill(l,"+"),v.text)
            add(v.text)
            for k1,v1 in pairs(v.options) do
                --print(fill(l,"+"),v1)
                add(v1)
            end
            l = l + 1
            for k1,v1 in pairs(v.branches) do
                parse_branch(v1, l)
            end
        elseif v.type == "add_quest" then
            --print(fill(l,"q"),v.description)
            add(v.quest_id)
            add(v.description)
            l = l + 1
            for k1,v1 in pairs(v.missions) do
                if v1.stat_name then
                    --print(fill(l,"m"),v1.stat_name)
                    add(v1.stat_name)
                end
            end
            l = l - 1
        elseif v.type == "tutorial_start" then
            --print(fill(l),v.text)
            add(v.text)
        elseif v.type == "self_text" then
            --print(fill(l),v.text)
            add(v.text)
        elseif v.type == "text" then
            --print(fill(l),v.text)
            add(v.text)
        else
            --print(fill(l, "!"),v.type)  --skipped
        end
    end
end

function parse_quest(quest)
    clearT()

--[[    parse handle_progress   ]]
    if quest.handle_progress and quest.handle_progress.type == "progress" then
        --print("#",quest.name)
        for k,v in pairs(quest.handle_progress.prerequisites) do
            parse_progress(v)
        end
    end

--[[    parse branches          ]]
    local n = 0
    local b = "branch_"
    while true do
        n = n + 1
        local br = quest[b .. n]
        if br and br.type == "branch" then
            --print("\n#",b .. n)
            parse_branch(br[1])
        else
            break
        end
    end

--[[    parse meta_nodes        ]]
    if quest.meta_nodes and quest.meta_nodes.type == "nodes" then
        --print("\n#",quest.meta_nodes.type)
        parse_branch(quest.meta_nodes[1])
    end

--    print("\n===========================")
--    for k,v in pairs(getT()) do
--        print(k,v)
--    end
    --if (str_num > 0) then
        --print(quest.name.." ("..#getT().."/"..str_num..")")
    --end
--    local qn = {qn = quest.name}
--    table.insert(T, qn)
    return T
end
