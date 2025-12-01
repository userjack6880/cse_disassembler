# John Bradley 2025

comp_table = Dict{UInt16,String}(
  0b0101010 => "0",
  0b0111111 => "1",
  0b0111010 => "-1",
  0b0001100 => "D",
  0b0110000 => "A",
  0b1110000 => "M",
  0b0001101 => "!D",
  0b0110001 => "!A",
  0b1110001 => "!M",
  0b0001111 => "-D",
  0b0110011 => "-A",
  0b1110011 => "-M",
  0b0011111 => "D+1",
  0b0110111 => "A+1",
  0b1110111 => "M+1",
  0b0001110 => "D-1",
  0b0110010 => "A-1",
  0b1110010 => "M-1",
  0b0000010 => "D+A",
  0b1000010 => "D+M",
  0b0010011 => "D-A",
  0b1010011 => "D-M",
  0b0000111 => "A-D",
  0b1000111 => "M-D",
  0b0000000 => "D&A",
  0b1000000 => "D&M",
  0b0010101 => "D|A",
  0b1010101 => "D|M"
)

jump_table = Dict{UInt8,String}(
  0b000 => "",
  0b001 => "JGT",
  0b010 => "JEQ",
  0b011 => "JGE",
  0b100 => "JLT",
  0b101 => "JNE",
  0b110 => "JLE",
  0b111 => "JMP"
);

function open_file(in_file::String)
  lines = readlines(in_file)
  # interpret strings as base-2 int
  op_codes = [parse(UInt16, line; base=2) for line in lines] 
  return op_codes
end

function get_bit(value::UInt16, bit_index::Integer)
  return (value & (1 << bit_index)) != 0
end

if length(ARGS) < 1
  error("At least one file expected")
end

for in_file in ARGS
  if !endswith(in_file, ".hack")
    error("must be .hack file!")
  end

  out_file = replace(in_file, ".hack" => ".asm")

  # open the file and populate lines
  binary = open_file(in_file)

  # decide the binary
  asm_array = String[]

  for op in binary
    # determine if c or a op
    if get_bit(op,15)
      # c op
      # determine comp
      comp_val = (op >> 6) & 0b1111111; # bit shift and isolate 7 bits
      # error check and set value
      if haskey(comp_table, comp_val)
        comp = comp_table[comp_val]
      else
        error("invalid comp: $(lpad(bin(comp_val), 7, '0'))")
      end

      # determine dest
      dest = ""
      if get_bit(op,5) dest *= "A" end
      if get_bit(op,4) dest *= "D" end
      if get_bit(op,3) dest *= "M" end

      # determine jump
      jump = jump_table[op & 0b111]   # isolate the lowest 3 bits

      # now build the operation
      asm = ""

      # dest
      if !isempty(dest) asm *= "$dest=" end

      # comp
      asm *= comp

      # jump
      if !isempty(jump) asm *= ";$jump" end

      push!(asm_array, asm)
    else
      # a op
      push!(asm_array, "@$op")
    end
  end

  # write to file
  write(out_file, join(asm_array, "\n") * "\n")
end
