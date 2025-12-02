// John Bradley 2025

import 'dart:io';

const Map<int, String> comp_table = {
  // why did Dart remove binary representation...
  0x2A: '0',
  0x3F: '1',
  0x3A: '-1',
  0x0C: 'D',
  0x30: 'A',
  0x70: 'M',
  0x0D: '!D',
  0x31: '!A',
  0x71: '!M',
  0x0F: '-D',
  0x33: '-A',
  0x73: '-M',
  0x1F: 'D+1',
  0x37: 'A+1',
  0x77: 'M+1',
  0x0E: 'D-1',
  0x32: 'A-1',
  0x72: 'M-1',
  0x02: 'D+A',
  0x42: 'D+M',
  0x13: 'D-A',
  0x53: 'D-M',
  0x07: 'A-D',
  0x47: 'M-D',
  0x00: 'D&A',
  0x40: 'D&M',
  0x15: 'D|A',
  0x55: 'D|M'
};

const Map<int, String> jump_table = {
  0: '',
  1: 'JGT',
  2: 'JEQ',
  3: 'JGE',
  4: 'JLT',
  5: 'JNE',
  6: 'JLE',
  7: 'JMP'
};

Future<List<int>> open_file(String in_file) async {
  if (!File(in_file).existsSync())
    throw Exception("Can't open $in_file");

  List<String> lines = await File(in_file).readAsLines();
  List<int> op_array = [];

  for (String line in lines) {
    int val = int.parse(line, radix: 2); // interpret as base-2 int
    op_array.add(val);
  }

  return op_array;
}

bool get_bit(int value, int bit_index) {
  return (value & (1 << bit_index)) != 0;
}

void main(List<String> args) async {
  if (args.length < 1)
    throw Exception("At least one file expected");
  
  for (String in_file in args) {
    if (!in_file.endsWith(".hack"))
      throw Exception("must be a .hack file");
    
    String out_file = in_file.replaceAll(".hack",".asm");

    // open the file and populate lines
    List<int> binary = await open_file(in_file);

    // decode the binary
    List<String> asm_array = [];

    for (int op in binary) {
      // determine if c or a op
      if (get_bit(op,15)) {
        // c op
        // determine comp
        int comp_val = (op >> 6) & 0x7F; // bit shift and isolate
        String? comp = comp_table[comp_val];

        // error check
        if (comp == null)
          throw Exception("invalid comp: $comp_val");
        
        // determine dest
        String dest = "";
        if (get_bit(op,5)) dest += "A";
        if (get_bit(op,4)) dest += "D";
        if (get_bit(op,3)) dest += "M";

        // determine jump
        String? jump = jump_table[op & 0x7]; // isolate the lowest 3 bits

        // now build the operation
        String asm = "";

        // dest
        if (!dest.isEmpty) asm += "$dest=";

        // comp
        asm += comp;

        // jump
        if (jump != null && jump.isNotEmpty) asm += ";$jump";

        asm_array.add(asm);
      }
      else {
        // a op
        asm_array.add("@$op"); // should be safe, bit 15 isn't used
      }
    }

    // write to file
    File(out_file).writeAsStringSync(asm_array.join("\n") + "\n");
  }
}
