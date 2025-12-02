// John Bradley 2025

import std.file : readText, exists; 
import std.container : DList;
import std.conv : to, toChars;
import std.string : splitLines;
import core.stdc.stdlib : strtol;
import std.stdio : writeln, toFile;
import std.array : split, array, replace;
import std.algorithm.searching : startsWith, endsWith;

immutable string[int] comp_table = [
  0b0101010 : "0",
  0b0111111 : "1",
  0b0111010 : "-1",
  0b0001100 : "D",
  0b0110000 : "A",
  0b1110000 : "M",
  0b0001101 : "!D",
  0b0110001 : "!A",
  0b1110001 : "!M",
  0b0001111 : "-D",
  0b0110011 : "-A",
  0b1110011 : "-M",
  0b0011111 : "D+1",
  0b0110111 : "A+1",
  0b1110111 : "M+1",
  0b0001110 : "D-1",
  0b0110010 : "A-1",
  0b1110010 : "M-1",
  0b0000010 : "D+A",
  0b1000010 : "D+M",
  0b0010011 : "D-A",
  0b1010011 : "D-M",
  0b0000111 : "A-D",
  0b1000111 : "M-D",
  0b0000000 : "D&A",
  0b1000000 : "D&M",
  0b0010101 : "D|A",
  0b1010101 : "D|M"
];

immutable string[int] jump_table = [
  0b000 : "",
  0b001 : "JGT",
  0b010 : "JEQ",
  0b011 : "JGE",
  0b100 : "JLT",
  0b101 : "JNE",
  0b110 : "JLE",
  0b111 : "JMP"
];

int[] open_file(const string in_file) {
  if (!exists(in_file))
    throw new Exception("Can't open " ~ in_file);

  string[] lines = readText(in_file).splitLines();
  int[] op_array;

  foreach (line; lines) {
    // interpret strings as base-2 integer
    op_array ~= cast(int) strtol(line.ptr, null, 2);
  }

  return op_array;
}

bool get_bit(const int value, const int bit_index) {
  return (value & (1 << bit_index)) != 0;
}

void main(string[] args) {
  if (args.length < 2)
    throw new Exception("At least one file expected");
  
  for (int i = 1; i < args.length; i++) {
    string in_file = args[i];

    if (!endsWith(in_file, ".hack"))
      throw new Exception("must be a .hack file");
    
    string out_file = in_file.replace(".hack",".asm");

    // open the file and populate lines
    int[] binary = open_file(in_file);

    // decode the binary
    string[] asm_array;

    foreach (op; binary) {
      // determine if c or a op
      if (get_bit(op,15)) {
        // c op
        // determine comp
        int comp_val = (op >> 6) & 0b1111111; // bit shift and isolate 7 bits
        string comp = comp_table[comp_val];

        // error check
        if (comp is null)
          throw new Exception("invalid comp: " ~ to!string(comp_val));

        // determine dest
        string dest = "";
        if (get_bit(op,5)) dest ~= "A";
        if (get_bit(op,4)) dest ~= "D";
        if (get_bit(op,3)) dest ~= "M";

        // determine jump
        string jump = jump_table[op & 0b111]; // isolate the lowest 3 bits

        // now build the operations
        string asm_op = "";

        // dest
        if (dest.length != 0) asm_op ~= dest ~ "=";

        // comp
        asm_op ~= comp;

        // jump
        if (jump.length != 0) asm_op ~= ";" ~ jump;

        asm_array ~= asm_op ~ "\n"; // newline here because D is silly
      }
      else {
        // a op
        asm_array ~= "@" ~ to!string(op) ~ "\n";
      }
    }

    // write to file
    asm_array.toFile(out_file);
  }
}
