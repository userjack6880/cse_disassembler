// John Bradley 2025

#![allow(non_snake_case)]
use std::collections::HashMap;
use std::env;
// use std::path::Path;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::io::Write;

fn comp_table() -> HashMap<u16, &'static str> {
  HashMap::from([
    (0b0101010, "0"),
    (0b0111111, "1"),
    (0b0111010, "-1"),
    (0b0001100, "D"),
    (0b0110000, "A"),
    (0b1110000, "M"),
    (0b0001101, "!D"),
    (0b0110001, "!A"),
    (0b1110001, "!M"),
    (0b0001111, "-D"),
    (0b0110011, "-A"),
    (0b1110011, "-M"),
    (0b0011111, "D+1"),
    (0b0110111, "A+1"),
    (0b1110111, "M+1"),
    (0b0001110, "D-1"),
    (0b0110010, "A-1"),
    (0b1110010, "M-1"),
    (0b0000010, "D+A"),
    (0b1000010, "D+M"),
    (0b0010011, "D-A"),
    (0b1010011, "D-M"),
    (0b0000111, "A-D"),
    (0b1000111, "M-D"),
    (0b0000000, "D&A"),
    (0b1000000, "D&M"),
    (0b0010101, "D|A"),
    (0b1010101, "D|M"),
    // invalid comps
    (0b1101010, ""),
    (0b1111111, ""),
    (0b1111010, ""),
    (0b1001100, ""),
    (0b1001101, ""),
    (0b1001111, ""),
    (0b1011111, "")
  ])
}

fn jump_table() -> HashMap<u16, &'static str> {
  HashMap::from([
    (0b000, ""),
    (0b001, "JGT"),
    (0b010, "JEQ"),
    (0b011, "JGE"),
    (0b100, "JLT"),
    (0b101, "JNE"),
    (0b110, "JLE"),
    (0b111, "JMP")
  ])
}

fn open_file(in_file: &str) -> Vec<u16> {
  let fh = File::open(&in_file).expect("Can't open file to read!");
  let lines = BufReader::new(fh);

  let mut op_codes: Vec<u16> = Vec::new();

  for line in lines.lines() {
    let raw_line = line           // newline is automatically truncated
      .expect("Error reading line");
    if !raw_line.is_empty() {     // interpret strings as base-2 int
      let val = u16::from_str_radix(&raw_line, 2)
        .expect("Invalid binary string");
      op_codes.push(val);
    }
  }

  op_codes
}

fn write_file(out_file: &str, lines: &Vec<String>) {
  let mut fh = File::create(out_file).expect("Can't open file to write!");

  if let Err(e) = writeln!(fh, "{}", lines.join("\n")) {
      panic!("Writing error: {}", e.to_string());
  }
}

fn get_bit(value: u16, bit_index: u8) -> bool {
  (value & (1 << bit_index)) != 0
}

fn main() 
{
  let args: Vec<String> = env::args().collect();
  let comp_table = comp_table();
  let jump_table = jump_table();

  if args.len() < 2 { panic!("At least one file expected"); }

  // Loop through each input file
  for i in 1..args.len()
  {
    let in_file = &args[i];

    if !in_file.ends_with(".hack") { panic!("must be a .hack file!"); }

    let out_file = in_file.replace(".hack", ".asm");

    // open the file and populate lines
    let binary = open_file(in_file);

    // decode the binary
    let mut asm_array: Vec<String> = Vec::new();

    for op in &binary {
      // determine if c or a op
      if get_bit(*op,15) {
        // c op
        // determine comp
        let comp_val = (op >> 6) & 0b1111111;   // bit shift and isolate 7 bits
        let comp = comp_table.get(&comp_val).expect("invalid comp_table lookup");

        // error check
        if comp.is_empty() { panic!("invalid comp: {:07b}", comp_val); }

        // determine dest
        let mut dest = String::new();
        if get_bit(*op,5) { dest.push_str("A"); }
        if get_bit(*op,4) { dest.push_str("D"); }
        if get_bit(*op,3) { dest.push_str("M"); }

        // determine jump
        let jump = jump_table.get(&(op & 0b111)).expect("invalid jump_table lookup");

        // now build the operation
        let mut asm = String::new();

        // dest
        if !dest.is_empty() { asm.push_str(&format!("{}=", dest)); }

        // comp
        asm.push_str(&comp);

        // jump
        if !jump.is_empty() { asm.push_str(&format!(";{}", jump)); }

        asm_array.push(asm);
      }
      else {
        asm_array.push(format!("@{}", op)); // should be safe, as bit 15 isn't used
      }
    }

    // write to file
    write_file(&out_file, &asm_array);
  }
}
