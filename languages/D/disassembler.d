import std.file : readText, exists; 
import std.container : DList;
import std.conv : to, toChars;
import std.string : splitLines;
import core.stdc.stdlib : strtol;
import std.stdio : writeln, toFile;
import std.array : split, array, replace;
import std.algorithm.searching : startsWith, endsWith;

//############################################################################//

void main(string[] getline) 
{
    // Check if at least one input file path has been passed
    if (getline.length < 2)
    {
        writeln("At least one file expected");
        return;
    }

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
        
        // Check if input file exists
        if (!inFile.exists)
        {
            writeln("Input file does not exist");
            return;
        }

        // Read binary lines from input file
        string[] inLines = readText(inFile).splitLines(); 

        // Create structure to contain HACK assembly lines
        DList!string outLines;

        // Computation Lookup Structure
        string[string] compTable = [
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
            "1010101": "D|M"
        ];

        // Destination Lookup Structure
        string[string] destTable = [
            "000": "",
            "001": "M=",
            "010": "D=",
            "011": "DM=",
            "100": "A=",
            "101": "AM=",
            "110": "AD=",
            "111": "ADM="
        ];

        // Jump Lookup Structure
        string[string] jumpTable = [
            "000": "",
            "001": ";JGT",
            "010": ";JEQ",
            "011": ";JGE",
            "100": ";JLT",
            "101": ";JNE",
            "110": ";JLE",
            "111": ";JMP"
        ];

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
