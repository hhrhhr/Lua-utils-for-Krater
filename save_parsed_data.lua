function SaveParsedData()
  print("[ log] saving "..fname)

  local fout = fname .. ".txt"
  local ft = assert(io.open(fout, "w+"))

  for k,v in ipairs(t.data) do
    local str = "<not defined>"
    if lang[v.hash] then
        if lang[v.hash].used then
            goto skip
        end
      str = lang[v.hash].eng
      lang[v.hash]["used"] = true
    end

    ft:write("[" .. v.hash .. "]\n")
    ft:write("id  = " .. v.id .. "\n")
    ft:write("eng = " .. str .. "\n")
    ft:write("rus = \n\n")
--[[
    ft:write("#[" .. v.hash .. "][" .. v.id .. "]\n")
    ft:write(str .. "\n")
]]
    ::skip::
  end
  ft:close()
end
