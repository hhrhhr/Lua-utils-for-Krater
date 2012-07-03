input_file = arg[1]
assert(input_file, "no input file")

require("util_binary_writer")
local w = BinaryWriter
w:update(input_file)
w:int32(0)
w:close()
