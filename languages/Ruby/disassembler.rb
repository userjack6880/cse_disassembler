# John Bradley 2025

comp_table = {
  0b0101010 => '0',
  0b0111111 => '1',
  0b0111010 => '-1',
  0b0001100 => 'D',
  0b0110000 => 'A',
  0b1110000 => 'M',
  0b0001101 => '!D',
  0b0110001 => '!A',
  0b1110001 => '!M',
  0b0001111 => '-D',
  0b0110011 => '-A',
  0b1110011 => '-M',
  0b0011111 => 'D+1',
  0b0110111 => 'A+1',
  0b1110111 => 'M+1',
  0b0001110 => 'D-1',
  0b0110010 => 'A-1',
  0b1110010 => 'M-1',
  0b0000010 => 'D+A',
  0b1000010 => 'D+M',
  0b0010011 => 'D-A',
  0b1010011 => 'D-M',
  0b0000111 => 'A-D',
  0b1000111 => 'M-D',
  0b0000000 => 'D&A',
  0b1000000 => 'D&M',
  0b0010101 => 'D|A',
  0b1010101 => 'D|M'
}

jump_table = {
  0b000 => '',
  0b001 => 'JGT',
  0b010 => 'JEQ',
  0b011 => 'JGE',
  0b100 => 'JLT',
  0b101 => 'JNE',
  0b110 => 'JLE',
  0b111 => 'JMP'
}

def open_file(in_file)
  lines = File.readlines(in_file, chomp: true)  # truncate newline while reading
  op_codes = lines.map { |line| line.to_i(2) }  # interpret string as base-2 int
end

def get_bit(value, bit_index)
  (value & (1 << bit_index)) != 0
end


abort("At least one file expected") if ARGV.length < 1

for in_file in ARGV do
  abort("must be .hack file!") if not in_file.end_with? ".hack"

  out_file = in_file.dup.sub! ".hack", ".asm"

  # open the file and populate lines
  binary = open_file(in_file)

  # decode the binary
  asm_array = []

  for op in binary do
    # determine if c or a op
    if get_bit(op,15)
      # c op
      # determine comp
      comp_val = (op >> 6) & 0b1111111          # bit shift and isolate 7 bits
      comp = comp_table[comp_val]

      # error check
      abort("invalid comp #{comp_val.to_s(2).rjust(7, "0")}") if comp.nil?

      # determine dest
      dest = ''
      dest << "A" if get_bit(op,5)
      dest << "D" if get_bit(op,4)
      dest << "M" if get_bit(op,3)

      # determine jump
      jump = jump_table[op & 0b111]

      # now build the operation
      asm = ''

      # dest
      asm << "#{dest}=" if not dest.empty?

      # comp
      asm << comp

      # jump
      asm << ";#{jump}" if not jump.empty?

      asm_array << asm
    else
      # a op
      asm_array << "@#{op}"
    end
  end

  # write to file
  File.write(out_file, asm_array.join("\n") + "\n")
end
