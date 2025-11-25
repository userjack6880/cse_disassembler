import 'dart:io';

//############################################################################//

void main(List<String> args) async
{
    // Check if at least one input file path has been passed
    if (args.length < 1)
    {
        print(("At least one file expected"));
        exit(0);
    }

    // Loop through each input file
    for (String inFile in args)
    {
        // Check if input file path has appropriate extension 
        if (!inFile.endsWith(".hack"))
        {
            print("Input must be a .hack file");
            exit(0);
        }
                
        // Check if input file exists
        if (!File(inFile).existsSync())
        {
            print("Input file does not exist");
            exit(0);
        }

        // Read binary lines from input file
        List<String> inLines = await File(inFile).readAsLines();

        // Create structure to contain HACK assembly lines
        List<String> outLines = [];

        // Computation Lookup Structure
        Map<String, String> compTable = 
        {
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
        };

        // Destination Lookup Structure
        Map<String, String> destTable = 
        {
            "000": "",
            "001": "M=",
            "010": "D=",
            "011": "DM=",
            "100": "A=",
            "101": "AM=",
            "110": "AD=",
            "111": "ADM="
        };

        // Jump Lookup Structure
        Map<String, String> jumpTable = 
        {
            "000": "",
            "001": ";JGT",
            "010": ";JEQ",
            "011": ";JGE",
            "100": ";JLT",
            "101": ";JNE",
            "110": ";JLE",
            "111": ";JMP"
        };

        //############################################################################//

        // Process the binary inputs and convert them to HACK assembly
        for (String line in inLines)
        {
            // A Instruction
            // if - Check instruction op-code (the first char in the string)
            
                // Get the remaining substring and convert to decimal 
                // Conversion (just uncomment)
                // String value = line.substring(1, 16);
                // int binVal = int.parse(value, radix: 2);

                // Construct the appropriate HACK instruction
                // https://api.flutter.dev/flutter/dart-core/String-class.html

                // Append to hackList
                // https://api.dart.dev/stable/3.5.4/dart-core/List/add.html

            // C Instruction
            // else if - Check instruction op-code (the first char in the string)
            
                // Create strings from the appropriate substrings
                // cBit, dBit, jBit
                // https://api.flutter.dev/flutter/dart-core/String-class.html

                // Return HACK destination string from destTable using dBit
                // https://dart.dev/language/collections#maps

                // Return HACK computation string from compTable using cBit

                // Return HACK jump string from jumpTable using jBit

                // Construct the appropriate HACK instruction

                // Append to hackList
        }

        //############################################################################//

        // Create output file name
        String outFile = inFile.replaceAll(".hack", ".asm");

        // Write data to output file
        File(outFile).writeAsStringSync(outLines.join("\n"));
    }
}
