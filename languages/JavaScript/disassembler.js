// John Bradley 2025

const fs = require("fs");

const comp_table = {
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
  0b1010101 : 'D|M'
};

const jump_table = {
  0b000 : '',
  0b001 : 'JGT',
  0b010 : 'JEQ',
  0b011 : 'JGE',
  0b100 : 'JLT',
  0b101 : 'JNE',
  0b110 : 'JLE',
  0b111 : 'JMP'
};

function open_file(in_file) {
  let lines = fs.readFileSync(in_file, "utf8").split("\n");
  // interpret strings as base-2 int
  lines = lines.map(line => parseInt(line, 2));

  return lines;
}

function get_bit(value, bit_index) {
  return (value & (1 << bit_index)) != 0;
}

if (process.argv.length < 3) {
  throw new Error("At least one file expected");
}

for (let i = 2; i < process.argv.length; i++) {
  const in_file = process.argv[i];

  if (!in_file.includes(".hack")) {
    throw new Error("must be .hack file!");
  }

  const out_file = in_file.replace(".hack", ".asm");

  // open the file and populate lines
  const binary = open_file(in_file);

  // decode the binary
  let asm_array = [];

  for (const op of binary) {
    // determine if c or a op
    if (get_bit(op,15)) {
      // c op
      // determine comp
      const comp_val = (op >> 6) & 0b1111111;   // bit shift and isolate 7 bits
      const comp = comp_table[comp_val];

      // error check
      if (comp === undefined) {
        throw new Error(`invalid comp: ${comp_val}`);
      }

      // determne dest
      let dest = "";
      if (get_bit(op,5)) { dest += "A"; }
      if (get_bit(op,4)) { dest += "D"; }
      if (get_bit(op,3)) { dest += "M"; }

      // determine jump
      const jump = jump_table[op & 0b111]; // isolate the lowest 3 bits

      // now build the operation
      let asm = "";

      // dest
      if (dest !== "") { asm += `${dest}=`; }

      // comp
      asm += comp;

      // jump
      if (jump !== "") { asm += `;${jump}`; }

      asm_array.push(asm);
    }
    else {
      // a op
      asm_array.push(`@${op}`);
    }
  }

  // write to file
  fs.writeFileSync(out_file, asm_array.join("\n") + "\n");
}
