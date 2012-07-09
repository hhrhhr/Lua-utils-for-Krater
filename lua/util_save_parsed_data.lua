function SaveParsedData()
-- upvalues:
-- fname, t, lang

  print("[ log] saving " .. fname)

  local fout = out_path .. "\\" .. fname .. ".txt"
  local ft = assert(io.open(fout, "w+"))

  for k,v in ipairs(t.data) do
    local str = "<not defined>"
    if lang[v.hash] then
        if used[v.hash] then
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
--    ft:write("#[" .. v.hash .. "][" .. v.id .. "]\n")
--    ft:write(str .. "\n")
    ::skip::
  end
  ft:close()
end
