# John Bradley 2025

import sys
from os.path import exists as file_exists

comp_table = {
  0b0101010 : '0',
  0b0111111 : '1',
  0b0111010 : '-1',
  0b0001100 : 'D',
  0b0110000 : 'A',
  0b1110000 : 'M',
  0b0001101 : '!D',
  0b0110001 : '!A',
  0b1110001 : '!M',
  0b0001111 : '-D',
  0b0110011 : '-A',
  0b1110011 : '-M',
  0b0011111 : 'D+1',
  0b0110111 : 'A+1',
  0b1110111 : 'M+1',
  0b0001110 : 'D-1',
  0b0110010 : 'A-1',
  0b1110010 : 'M-1',
  0b0000010 : 'D+A',
  0b1000010 : 'D+M',
  0b0010011 : 'D-A',
  0b1010011 : 'D-M',
  0b0000111 : 'A-D',
  0b1000111 : 'M-D',
  0b0000000 : 'D&A',
  0b1000000 : 'D&M',
  0b0010101 : 'D|A',
  0b1010101 : 'D|M',
  # invalid comps
  0b1101010 : '',
  0b1111111 : '',
  0b1111010 : '',
  0b1001100 : '',
  0b1001101 : '',
  0b1001111 : '',
  0b1011111 : ''
}

jump_table = {
  0b000 : '',
  0b001 : 'JGT',
  0b010 : 'JEQ',
  0b011 : 'JGE',
  0b100 : 'JLT',
  0b101 : 'JNE',
  0b110 : 'JLE',
  0b111 : 'JMP'
}

def open_file(in_file):
  not file_exists(in_file) and sys.exit(f"{in_file} does not exist\n")
  
  lines = []
  with open(in_file) as fh:
    for line in fh:
      line = line.strip()   # truncate newline
      val = int(line,2)     # interpret strings as base-2 int
      lines.append(val)

  return lines

def write_file(out_file, lines):
  with open(out_file, 'w') as fh:
    fh.write("\n".join(lines))
    fh.write("\n")          # add in the last linebreak
  
def get_bit(value, bit_index):
  return 1 if (value & (1 << bit_index)) else 0

len(sys.argv) < 2 and sys.exit("At least one file expected\n")

for in_file in sys.argv[1:]:
  not in_file.endswith(".hack") and sys.exit("must be .hack file!\n")

  out_file = in_file.replace(".hack", ".asm")

  # open the file and populate lines
  binary = open_file(in_file)

  # decode the binary
  asm_array = []

  for op in binary:
    # determine if c or a op
    if get_bit(op,15):
      # c op
      # determine comp
      comp_val = (op >> 6) & 0b1111111
      comp = comp_table[comp_val]

      # error check
      comp == '' and sys.exit("invalid comp: {:07b}\n".format(comp_val))

      # determine dest
      dest = ''
      if get_bit(op,5): dest += "A"
      if get_bit(op,4): dest += "D"
      if get_bit(op,3): dest += "M"

      # determine jump
      jump = jump_table[op & 0b111] # isolate the lowest 3 bits

      # now build the operation
      asm = ''
      
      # dest
      if dest != '': asm += f"{dest}="

      # comp
      asm += comp

      # jump
      if jump != '': asm += f";{jump}"

      asm_array.append(asm)

    else:
      # a op
      asm_array.append(f"@{op}") # should be safe, as bit 15 isn't used

  write_file(out_file, asm_array)
