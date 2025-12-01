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

    
  }
}

//############################################################################//


    // Loop through each input file
    for (int curArg = 1; curArg < getline.length; curArg++)
    {
        string inFile = getline[curArg];
    
        // Check if input file path has appropriate extension 
        if (!endsWith(inFile, ".hack"))
        {
            writeln("Input must be a .hack file");
            return;
        }
  

        // Create structure to contain HACK assembly lines
        DList!string outLines;



        //############################################################################//

        // Process the binary inputs and convert them to HACK assembly
        foreach (string line; inLines)
        {
            // A Instruction
            // if - Check instruction op-code (the first char in the string)
            
                // Get the remaining substring and convert to decimal
                // Conversion (just uncomment)
                // string value = line[1..16];
                // int binVal =to!int(strtol(value.ptr, null, 2));

                // Construct the appropriate HACK instruction
                // https://dlang.org/spec/arrays.html#array-concatenation
                
                // Append to hackList
                // https://dlang.org/phobos/std_container_dlist.html#.DList.insertBack

            // C Instruction
            // else if - Check instruction op-code (the first char in the string)

                // Create strings from the appropriate substrings
                // cBit, dBit, jBit
                // https://dlang.org/spec/arrays.html#slicing

                // Return HACK destination string from destTable using dBit
                // https://dlang.org/spec/hash-map.html

                // Return HACK computation string from compTable using cBit 

                // Return HACK jump string from jumpTable using jBit

                // Construct the appropriate HACK instruction

                // Append to hackList
        }

        //############################################################################//

        // Create output file name
        string outFile = inFile.replace(".hack", ".asm");

        // Write data to output file
        toFile(outLines.array, outFile);
    }
}
