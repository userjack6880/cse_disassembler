# John Bradley 2025

$comp_table =
@{
  0b0101010 = "0"
  0b0111111 = "1"
  0b0111010 = "-1"
  0b0001100 = "D"
  0b0110000 = "A"
  0b1110000 = "M"
  0b0001101 = "!D"
  0b0110001 = "!A"
  0b1110001 = "!M"
  0b0001111 = "-D"
  0b0110011 = "-A"
  0b1110011 = "-M"
  0b0011111 = "D+1"
  0b0110111 = "A+1"
  0b1110111 = "M+1"
  0b0001110 = "D-1"
  0b0110010 = "A-1"
  0b1110010 = "M-1"
  0b0000010 = "D+A"
  0b1000010 = "D+M"
  0b0010011 = "D-A"
  0b1010011 = "D-M"
  0b0000111 = "A-D"
  0b1000111 = "M-D"
  0b0000000 = "D&A"
  0b1000000 = "D&M"
  0b0010101 = "D|A"
  0b1010101 = "D|M"
  # invalid comps
  0b1101010 = ""
  0b1111111 = ""
  0b1111010 = ""
  0b1001100 = ""
  0b1001101 = ""
  0b1001111 = ""
  0b1011111 = ""
}

$jump_table =
@{
  0b000 = ""
  0b001 = "JGT"
  0b010 = "JEQ"
  0b011 = "JGE"
  0b100 = "JLT"
  0b101 = "JNE"
  0b110 = "JLE"
  0b111 = "JMP"
}

function open_file {
  param([string]$in_file)

  return @([System.IO.File]::ReadLines($in_file) |
    ForEach-Object { [Convert]::ToInt32($_, 2) })  # interpret strings as base-2 int
}

function get_bit {
  param([int]$value, [int]$bit_index)
  return ($value -band (1 -shl $bit_index)) -ne 0
}

if ($args.Length -lt 1) { throw "At least one file expected!" }

foreach ($in_file in $args) {
  if (!$in_file.EndsWith(".hack")) { throw "must be .hack file!" }

  $out_file = $in_file.replace('.hack', '.asm')

  # open the file and populate lines
  $binary = open_file($in_file)

  # decode the binary
  $asm_array = @()

  foreach ($op in $binary) {
    # determine if c or a op
    if (get_bit $op 15) {
      # c op
      # determine comp
      $comp_val = ($op -shr 6) -band 0b1111111    # bit shift and isolate 7 bits
      $comp = $comp_table[$comp_val]

      # error check
      if ($comp -eq "") { throw ("invalid comp: {0:D7}" -f $comp_val) }

      # determine dest
      $dest = "";
      if (get_bit $op 5) { $dest += "A" }
      if (get_bit $op 4) { $dest += "D" }
      if (get_bit $op 3) { $dest += "M" }

      # determine jump
      $jump = $jump_table[$op -band 0b111]

      # now build the operation
      $asm = "";

      # dest
      if ($dest -ne "") { $asm += "$dest=" }

      # comp
      $asm += $comp

      # jump
      if ($jump -ne "") { $asm += ";$jump" }

      $asm_array += $asm
    }
    else {
      $asm_array += "@$op"
    }
  }

  [System.IO.File]::WriteAllLines($out_file, $asm_array)
}
