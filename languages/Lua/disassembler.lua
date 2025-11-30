-- John Bradley 2025

comp_table = {
  -- Lua doesn't support binary representation... but it does hex
  [0x2A] = "0",
  [0x3F] = "1",
  [0x3A] = "-1",
  [0x0C] = "D",
  [0x30] = "A",
  [0x70] = "M",
  [0x0D] = "!D",
  [0x31] = "!A",
  [0x71] = "!M",
  [0x0F] = "-D",
  [0x33] = "-A",
  [0x73] = "-M",
  [0x1F] = "D+1",
  [0x37] = "A+1",
  [0x77] = "M+1",
  [0x0E] = "D-1",
  [0x32] = "A-1",
  [0x72] = "M-1",
  [0x02] = "D+A",
  [0x42] = "D+M",
  [0x13] = "D-A",
  [0x53] = "D-M",
  [0x07] = "A-D",
  [0x47] = "M-D",
  [0x00] = "D&A",
  [0x40] = "D&M",
  [0x15] = "D|A",
  [0x55] = "D|M"
}

jump_table = {
  [0] = "",
  [1] = "JGT",
  [2] = "JEQ",
  [3] = "JGE",
  [4] = "JLT",
  [5] = "JNE",
  [6] = "JLE",
  [7] = "JMP"
}

function open_file(in_file)
  local fh = io.open(in_file, "r")
  if not fh then
    error("Can't open " .. in_file)
  end

  local lines = {}
  for line in fh:lines() do
    -- new lines are already truncated
    local val = tonumber(line,2)  -- interpret strings as base-2 int
    table.insert(lines, val)
  end

  fh:close()

  return lines
end

function write_file(out_file, lines)
  local fh = io.open(out_file, "w")
  if not fh then
    error("Can't open " .. out_file)
  end

  fh:write(table.concat(lines, "\n"))

  fh:close()
end

function get_bit(value, bit_index)
  return (value & (1 << bit_index)) ~= 0
end

-- Check if at least one input file path has been passed
if #arg < 1 then
  error("At least one file expected")
end

-- Loop through each input file
for i = 1, #arg do
  local in_file = arg[i]

  if not in_file:find(".hack") then
      error("must be .hack file!")
  end

  local out_file = string.gsub(in_file, ".hack", ".asm")

  -- open the file and populate lines
  local binary = open_file(in_file)

  -- decode the binary
  local asm_table = {}

  for _, op in ipairs(binary) do
    -- determine if c or a op
    if get_bit(op,15) then
      -- c op
      -- determine cmp
      local comp_val = (op >> 6) & 0x7F -- bit shift and isolate 7 bits
      local comp = comp_table[comp_val]

      -- error check
      if comp == nil then
        error(string.format("Invalid comp: %d", comp_val))
      end

      -- determine dest
      local dest = ""
      if get_bit(op,5) then dest = dest .. "A" end
      if get_bit(op,4) then dest = dest .. "D" end
      if get_bit(op,3) then dest = dest .. "M" end

      -- determine jump
      local jump = jump_table[op & 0x7] -- isolate the lowest 3 bits

      -- now build the operation
      local asm = ""

      -- dest
      if dest ~= "" then asm = asm .. dest .. "=" end

      -- comp
      asm = asm .. comp

      -- jump
      if jump ~= "" then asm = asm .. ";" .. jump end

      table.insert(asm_table, asm)
    else
      -- a op
      table.insert(asm_table, "@" .. op)
    end
  end

  -- write to file
  write_file(out_file, asm_table)
end
