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

fun get_bit(value: Int, bit_index: Int): Boolean {
  return (value and (1 shl bit_index)) != 0
}

fun main(args: Array<String>) 
{
  if (args.size < 1) { 
    throw IllegalArgumentException("At least one file expected")
  }

  for (in_file in args)
  {
    if (!in_file.endsWith(".hack"))
    {
      throw IllegalArgumentException("must be .hack file!")
    }

    val out_file = in_file.replace(".hack",".asm")

    // open the file and populate lines
    val binary = open_file(in_file)

    // decode the binary
    val asm_list = mutableListOf<String>()

    for (op in binary) {
      // determine if c or a op
      if (get_bit(op,15)) {
        // c op
        // determine comp
        val comp_val = (op shr 6) and 0b1111111   // bit shift and isolate 7 bits
        val comp = comp_table[comp_val]

        // error check
        if (comp.isNullOrEmpty()) {
          throw IllegalArgumentException("invalid comp")
        }

        // determine dest
        var dest = ""
        if (get_bit(op,5)) { dest += "A" }
        if (get_bit(op,4)) { dest += "D" }
        if (get_bit(op,3)) { dest += "M" }

        // determine jump
        val jump = jump_table[op and 0b111]

        // now build the operation
        var asm = ""

        // dest
        if (dest.isNotEmpty()) { asm += "${dest}=" }

        // comp
        asm += comp

        // jump
        if (!jump.isNullOrEmpty()) { asm += ";${jump}" }

        asm_list.add(asm)
      }
      else {
        // a op
        asm_list.add("@${op}")
      }

      File(out_file).writeText(asm_list.joinToString("\n") + "\n")
    }
  }
}
