// John Bradley 2025

using System;
using System.IO;

namespace Disassembler {
  class Program {
    private static readonly 
    Dictionary<int,string> comp_table = new Dictionary<int,string> {
      {0b0101010, "0"   },
      {0b0111111, "1"   },
      {0b0111010, "-1"  },
      {0b0001100, "D"   },
      {0b0110000, "A"   },
      {0b1110000, "M"   },
      {0b0001101, "!D"  },
      {0b0110001, "!A"  },
      {0b1110001, "!M"  },
      {0b0001111, "-D"  },
      {0b0110011, "-A"  },
      {0b1110011, "-M"  },
      {0b0011111, "D+1" },
      {0b0110111, "A+1" },
      {0b1110111, "M+1" },
      {0b0001110, "D-1" },
      {0b0110010, "A-1" },
      {0b1110010, "M-1" },
      {0b0000010, "D+A" },
      {0b1000010, "D+M" },
      {0b0010011, "D-A" },
      {0b1010011, "D-M" },
      {0b0000111, "A-D" },
      {0b1000111, "M-D" },
      {0b0000000, "D&A" },
      {0b1000000, "D&M" },
      {0b0010101, "D|A" },
      {0b1010101, "D|M" }
    };

    private static readonly
    Dictionary<int,string> jump_table = new Dictionary<int,string> {
      {0b000, ""    },
      {0b001, "JGT" },
      {0b010, "JEQ" },
      {0b011, "JGE" },
      {0b100, "JLT" },
      {0b101, "JNE" },
      {0b110, "JLE" },
      {0b111, "JMP" }
    };

    private static int[] open_file(string in_file) {
      if (!File.Exists(in_file))
        throw new Exception($"Can't open {in_file}");

      List<int> lines = new List<int>();

      foreach (string raw in File.ReadLines(in_file)) {
        string line = raw.Trim(); // remove newlines
        int val = Convert.ToInt32(line, 2); // interpret strings as base-2 integer
        lines.Add(val);
      }

      return lines.ToArray();
    }

    private static bool get_bit(int value, int bit_index) {
      return (value & (1 << bit_index)) != 0;
    }

    static void Main(string[] args) {
      if (args.Length < 1)
        throw new Exception("At least one file expected");

      foreach (string in_file in args) {
        if (!in_file.Contains(".hack"))
          throw new Exception("must be a .hack file");

        string out_file = in_file.Replace(".hack", ".asm");

        // open the file and populate lines
        int[] binary = open_file(in_file);

        // decode the binary
        List<string> asm_array = new List<string>();

        foreach (int op in binary) {
          // determine if c or a op
          if (get_bit(op,15)) {
            // c op
            // determine comp
            int comp_val = (op >> 6) & 0b1111111; // bit shift and isolate 7 bits
            string comp = comp_table[comp_val];

            // error check
            if (string.IsNullOrEmpty(comp))
              throw new Exception($"invalid comp: {comp_val}");

            // determine dest
            string dest = "";
            if (get_bit(op,5)) dest += "A";
            if (get_bit(op,4)) dest += "D";
            if (get_bit(op,3)) dest += "M";

            // determine jump
            string jump = jump_table[op & 0b111]; // isolate the lowest 3 bits

            // now build the operation
            string asm = "";

            // dest 
            if (!string.IsNullOrEmpty(dest)) asm += $"{dest}=";

            // comp
            asm += comp;

            // jump
            if (!string.IsNullOrEmpty(jump)) asm += $";{jump}";

            asm_array.Add(asm);
          }
          else {
            // a op
            asm_array.Add($"@{op}"); // should be safe, as bit 15 isn't used
          }
        }

        // write to file
        File.WriteAllLines(out_file, asm_array);
      }
    }
  }
}
