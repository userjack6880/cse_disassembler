package main

import (
    "fmt"
    "os"
    "strings"
    "strconv"
)

//############################################################################//

func main() {

    // Check if at least one input file path has been passed
    if len(os.Args) < 2 {
        fmt.Println("At least one file expected")
        return
    }

    // Loop through each input file
    for curArg := 1; curArg < len(os.Args); curArg++ {

        var inFile = os.Args[curArg]

        // Check if input file path has appropriate extension 
        if (!strings.HasSuffix(inFile, ".hack")) {
            fmt.Println("Input must be a .hack file")
            return
        }

        // Check if input file exists
        _, err := os.Stat(inFile)
        if (os.IsNotExist(err)) {
            fmt.Println("Input file does not exist")
            return
        }

        // Read binary lines from input file
        fileContents, err := os.ReadFile(inFile)
        if err != nil {
            fmt.Println(err)
            return
        }
        inLines := strings.Split(string(fileContents), "\n")

        // Create structure to contain HACK assembly lines
        var outLines []string

        // Computation Lookup Structure
        var compTable = map[string]string {
            "0101010": "0",
            "0111111": "1",
            "0111010": "-1",
            "0001100": "D",
            "0110000": "A",
            "1110000": "M",
            "0001101": "!D",
            "0110001": "!A",
            "1110001": "!M",
            "0001111": "-D",
            "0110011": "-A",
            "1110011": "-M",
            "0011111": "D+1",
            "0110111": "A+1",
            "1110111": "M+1",
            "0001110": "D-1",
            "0110010": "A-1",
            "1110010": "M-1",
            "0000010": "D+A",
            "1000010": "D+M",
            "0010011": "D-A",
            "1010011": "D-M",
            "0000111": "A-D",
            "1000111": "M-D",
            "0000000": "D&A",
            "1000000": "D&M",
            "0010101": "D|A",
            "1010101": "D|M",
        }

        // Destination Lookup Structure
        var destTable = map[string]string {
            "000": "",
            "001": "M=",
            "010": "D=",
            "011": "DM=",
            "100": "A=",
            "101": "AM=",
            "110": "AD=",
            "111": "ADM=",
        }

        // Jump Lookup Structure
        var jumpTable = map[string]string {
            "000": "",
            "001": ";JGT",
            "010": ";JEQ",
            "011": ";JGE",
            "100": ";JLT",
            "101": ";JNE",
            "110": ";JLE",
            "111": ";JMP",
        }

        //############################################################################//

        // Process the binary inputs and convert them to HACK assembly
        for _, line := range inLines {
            
            // A Instruction
            // if - Check instruction op-code (the first char in the string)
            
                // Get the remaining substring and convert to decimal 
                // Conversion (just uncomment)
                // value, err := strconv.ParseInt(line[1:16], 2, 64)
                // if err != nil {
                //     fmt.Println(err)
                //     return
                // }

                // Construct the appropriate HACK instruction
                // https://golangdocs.com/concatenate-strings-in-golang

                // Append to hackList
                // https://dev.to/andyhaskell/a-closer-look-at-go-s-slice-append-function-3bhb

            // C Instruction
            // else if - Check instruction op-code (the first char in the string)

                // Create strings from the appropriate substrings
                // cBit, dBit, jBit
                // https://golangdocs.com/substring-in-golang

                // Return HACK destination string from destTable using dBit
                // https://golangdocs.com/maps-in-golang

                // Return HACK computation string from compTable using cBit

                // Return HACK jump string from jumpTable using jBit

                // Construct the appropriate HACK instruction

                // Append to hackList
        }

        //############################################################################//

        // Create output file name
        contentOut := []byte(strings.Join(outLines, "\n"))
        newFile := strings.ReplaceAll(inFile,".hack",".asm")

        // Write data to output file
        err = os.WriteFile(newFile, contentOut, 0644)
        if err != nil {
            fmt.Println(err)
            return
        }
    }
}
