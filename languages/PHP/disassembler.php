<?php
# John Bradley 2025

$comp_table = [
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
  0b1010101 => 'D|M',
  # invalid comps
  0b1101010 => '',
  0b1111111 => '',
  0b1111010 => '',
  0b1001100 => '',
  0b1001101 => '',
  0b1001111 => '',
  0b1011111 => ''
];

$jump_table = [
  0b000 => '',
  0b001 => 'JGT',
  0b010 => 'JEQ',
  0b011 => 'JGE',
  0b100 => 'JLT',
  0b101 => 'JNE',
  0b110 => 'JLE',
  0b111 => 'JMP'
];

function open_file($in_file) {
  $fh = fopen($in_file, "r") or die("Can't open $in_file\n");

  $lines = [];

  while (($line = fgets($fh)) !== false) {
    $line = rtrim($line, "\r\n");   # truncate newline
    $val  = bindec($line);          # interpret strings as base-2 int
    array_push($lines, $val);
  }

  fclose($fh);

  return $lines;
}

function write_file($out_file, $lines) {
  $fh = fopen($out_file, "w") or die ("Can't open $out_file\n");

  fwrite($fh, implode("\n", $lines));
  fwrite($fh, "\n"); # add in the last linebreak

  fclose($fh);
}

function get_bit($value, $bit_index) {
  return ($value & (1 << $bit_index)) ? 1 : 0;
}

if ($argc < 2) {
  die("At least one file expected\n");
}

for ($i = 1; $i < $argc; $i++) {
  $in_file = $argv[$i];

  if (!preg_match("/\.hack$/i", $in_file)) {
    die("must be .hack file!\n");
  }

  $out_file = str_replace(".hack", ".asm", $in_file);

  # open the file and populate lines
  $binary = open_file($in_file);

  # decode the binary
  $asm_array = [];

  foreach ($binary as $op) {
    # determine if c or a op
    if (get_bit($op,15)) {
      # c op
      # determine comp
      $comp_val = ($op >> 6) & 0b1111111;
      $comp = $comp_table[$comp_val];

      # error check
      if ($comp === "") {
        die(sprintf("invalid comp: %07b\n", $comp_val));
      }

      # determine dest
      $dest = "";
      if (get_bit($op,5)) { $dest .= "A"; }
      if (get_bit($op,4)) { $dest .= "D"; }
      if (get_bit($op,3)) { $dest .= "M"; }

      # determine jump
      $jump = $jump_table[$op & 0b111];

      # now build the operation
      $asm = "";

      # dest
      if ($dest !== "") {
        $asm .= "$dest=";
      }

      # comp
      $asm .= $comp;

      # jump
      if ($jump !== "") {
        $asm .= ";$jump";
      }

      array_push($asm_array, $asm);
    }
    else {
      # a op
      array_push($asm_array, "@$op"); # should be safe, as bit 15 isn't used
    }
  }

  # write to file
  write_file($out_file, $asm_array);
}
?>
