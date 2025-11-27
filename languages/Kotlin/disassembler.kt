// John Bradley 2025

import java.io.File;
import java.util.*;

val comp_table = mapOf(
  0b0101010 to "0",
  0b0111111 to "1",
  0b0111010 to "-1",
  0b0001100 to "D",
  0b0110000 to "A",
  0b1110000 to "M",
  0b0001101 to "!D",
  0b0110001 to "!A",
  0b1110001 to "!M",
  0b0001111 to "-D",
  0b0110011 to "-A",
  0b1110011 to "-M",
  0b0011111 to "D+1",
  0b0110111 to "A+1",
  0b1110111 to "M+1",
  0b0001110 to "D-1",
  0b0110010 to "A-1",
  0b1110010 to "M-1",
  0b0000010 to "D+A",
  0b1000010 to "D+M",
  0b0010011 to "D-A",
  0b1010011 to "D-M",
  0b0000111 to "A-D",
  0b1000111 to "M-D",
  0b0000000 to "D&A",
  0b1000000 to "D&M",
  0b0010101 to "D|A",
  0b1010101 to "D|M",
  // invalid comps
  0b1101010 to "",
  0b1111111 to "",
  0b1111010 to "",
  0b1001100 to "",
  0b1001101 to "",
  0b1001111 to "",
  0b1011111 to ""
)

val jump_table = mapOf(
  0b000 to "",
  0b001 to "JGT",
  0b010 to "JEQ",
  0b011 to "JGE",
  0b100 to "JLT",
  0b101 to "JNE",
  0b110 to "JLE",
  0b111 to "JMP"
)

fun open_file(in_file: String): List<Int> {
  val lines: List<String> = File(in_file).readLines()
  val op_codes = lines.map { it.toInt(2) }

  return op_codes
}

fun write_file(out_file: String, lines: List<String>) {
  File(out_file).writeText(lines.joinToString("\n") + "\n");
}

//############################################################################//

fun main(args: Array<String>) 
{
    // Check if at least one input file path has been passed
    if (args.size < 1)
    {
        println("At least one file expected")
        return
    }
    
    // Loop through each input file
    for (inFile in args)
    {
        // Check if input file path has appropriate extension 
        if (!inFile.endsWith(".hack"))
        {
            println("Input must be a .hack file")
            return
        }


        // Create structure to contain HACK assembly lines
        val outLines: ArrayList<String> = ArrayList<String>();

        //############################################################################//

        // Process the binary inputs and convert them to HACK assembly
        for (line in inLines)
        {


        }

        //############################################################################//

        // Create output file name
        val outFile = inFile.replace(".hack", ".asm");
        
        // Write data to output file
        File(outFile).writeText(outLines.joinToString(separator=""));
    }
}
