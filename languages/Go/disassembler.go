// John Bradley 2025

package main

import (
    "fmt"
    "os"
    "strings"
    "strconv"
)

var comp_table = map[int]string {
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
  0b1010101 : "D|M",
  // invalid comps
  0b1101010 : "",
  0b1111111 : "",
  0b1111010 : "",
  0b1001100 : "",
  0b1001101 : "",
  0b1001111 : "",
  0b1011111 : "",
}

var jump_table = map[int]string {
  0b000 : "",
  0b001 : "JGT",
  0b010 : "JEQ",
  0b011 : "JGE",
  0b100 : "JLT",
  0b101 : "JNE",
  0b110 : "JLE",
  0b111 : "JMP",
}

func open_file(in_file string) []uint16 {
	_, err := os.Stat(in_file)
	if os.IsNotExist(err) { panic(fmt.Sprintf("Input file does not exist: %v", err)) }

	fh, err := os.ReadFile(in_file)
	if err != nil {	panic(fmt.Sprintf("Can't open %s: %v", in_file, err)) }

	lines := strings.Split(string(fh), "\n")	// truncates newlines
	var op_codes []uint16

	for _, line := range lines {
		if line == "" { continue }
		val, err := strconv.ParseUint(line, 2, 16)	// interpret strings as base-2 int
		if err != nil {	panic(err) }
		op_codes = append(op_codes, uint16(val))
	}

	return op_codes
}

func write_file(out_file string, lines []string) {
	// add linebreak at end of output
	err := os.WriteFile(out_file, []byte(strings.Join(lines, "\n") + "\n"), 0644)
	if err != nil { panic(fmt.Sprintf("Can't write to %s, %v", out_file, err)) }
}

func get_bit(value uint16, bit_index uint8) bool {
	return (value & (1 << bit_index)) != 0
}

func main() {
	if len(os.Args) < 2 { panic("At least one file expected!") }

	for i := 1; i < len(os.Args); i++ {
		in_file := os.Args[i]
		if !strings.HasSuffix(in_file, ".hack") { panic ("must be .hack file!") }

		out_file := strings.ReplaceAll(in_file, ".hack", ".asm")

		// open the file and populate lines
		binary := open_file(in_file)

		// decode the binary
		var asm_array []string

		for _, op := range binary {
			// determine if c or a op
			if get_bit(op,15) {
				// c op
				// determine comp
				comp_val := (op >> 6) & 0b1111111		// bit shift and isolate 7 bits
				comp := comp_table[int(comp_val)]

				// error check
				if comp == "" { panic(fmt.Sprintf("invalid comp: %07b", comp_val)) }

				// determine dest
				dest := ""
				if get_bit(op,5) { dest += "A" }
				if get_bit(op,4) { dest += "D" }
				if get_bit(op,3) { dest += "M" }

				// determine jump
				jump := jump_table[int(op & 0b111)]

				// now build the operation
				asm := ""

				// dest
				if dest != "" { asm += fmt.Sprintf("%s=", dest) }

				// comp
				asm += comp

				// jump
				if jump != "" { asm += fmt.Sprintf(";%s", jump) }

				asm_array = append(asm_array, asm)
			} else {
				// a op
				asm_array = append(asm_array, fmt.Sprintf("@%d", op))
			}
		}

		// write to file
		write_file(out_file, asm_array)
	}
}
