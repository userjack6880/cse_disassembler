// John Bradley

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class disassembler
{
  private static final HashMap<Integer, String> comp_table = new HashMap<>();
  static {
    comp_table.put(0b0101010, "0");
    comp_table.put(0b0111111, "1");
    comp_table.put(0b0111010, "-1");
    comp_table.put(0b0001100, "D");
    comp_table.put(0b0110000, "A");
    comp_table.put(0b1110000, "M");
    comp_table.put(0b0001101, "!D");
    comp_table.put(0b0110001, "!A");
    comp_table.put(0b1110001, "!M");
    comp_table.put(0b0001111, "-D");
    comp_table.put(0b0110011, "-A");
    comp_table.put(0b1110011, "-M");
    comp_table.put(0b0011111, "D+1");
    comp_table.put(0b0110111, "A+1");
    comp_table.put(0b1110111, "M+1");
    comp_table.put(0b0001110, "D-1");
    comp_table.put(0b0110010, "A-1");
    comp_table.put(0b1110010, "M-1");
    comp_table.put(0b0000010, "D+A");
    comp_table.put(0b1000010, "D+M");
    comp_table.put(0b0010011, "D-A");
    comp_table.put(0b1010011, "D-M");
    comp_table.put(0b0000111, "A-D");
    comp_table.put(0b1000111, "M-D");
    comp_table.put(0b0000000, "D&A");
    comp_table.put(0b1000000, "D&M");
    comp_table.put(0b0010101, "D|A");
    comp_table.put(0b1010101, "D|M");
  }

  private static final HashMap<Integer, String> jump_table = new HashMap<>();
  static {
    jump_table.put(0b000, "");
    jump_table.put(0b001, "JGT");
    jump_table.put(0b010, "JEQ");
    jump_table.put(0b011, "JGE");
    jump_table.put(0b100, "JLT");
    jump_table.put(0b101, "JNE");
    jump_table.put(0b110, "JLE");
    jump_table.put(0b111, "JMP");
  }

  public static List<Integer> open_file(String in_file) throws IOException {
    List<String> lines = Files.readAllLines(Paths.get(in_file));

    List<Integer> op_codes = new ArrayList<>();
    for (String line: lines) {
      if (!line.isEmpty()) {
        op_codes.add(Integer.parseInt(line,2)); // interpret strings as base-2 int
      }
    }

    return op_codes;
  }

  public static boolean get_bit(Integer value, Integer bit_index) throws IOException {
    return (value & (1 << bit_index)) != 0;
  }

  public static void main(String[] args) throws IOException 
  {
    if (args.length < 1) { 
      throw new IllegalArgumentException("At least one file expected");
    }

    for (String in_file : args) {
      if (!in_file.endsWith(".hack"))
      {
        throw new IllegalArgumentException("must be .hack file!");
      }

      String out_file = in_file.replaceAll(".hack",".asm");

      // open the file and populate lines
      List<Integer> binary = open_file(in_file);

      // decode the binary
      List<String> asm_list = new ArrayList<>();

      for (int op : binary) {
        // determine if c or a op
        if (get_bit(op,15)) {
          // c op
          // determine comp
          int comp_val = (op >> 6) & 0b1111111;   // bit shift and isolate 7 bits
          String comp = comp_table.get(comp_val);

          // error check
          if (comp == null) {
            throw new IllegalArgumentException(
              String.format("invalid comp: %07b", comp_val)
            );
          }

          // determine dest
          String dest = "";
          if (get_bit(op,5)) { dest += "A"; }
          if (get_bit(op,4)) { dest += "D"; }
          if (get_bit(op,3)) { dest += "M"; }

          // determine jump
          String jump = jump_table.get(op & 0b111);

          // now build the operation
          String asm = "";

          // dest
          if (!dest.isEmpty()) { asm += dest + "="; }

          // comp
          asm += comp;

          // jump
          if (!jump.isEmpty()) { asm += ";" + jump; }

          asm_list.add(asm);
        }
        else {
          // a op
          asm_list.add("@" + op);
        }
      }
      
      // write to file
      Files.write(Paths.get(out_file), asm_list);
    }
  }
}
