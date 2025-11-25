const fs = require("fs");

//############################################################################//

// Check if at least one input file path has been passed
if (process.argv.length < 3)
{
    console.log("At least one file expected");
    return;
}

// Loop through each input file
for (var curArg = 2; curArg < process.argv.length; curArg++)
{
    var inFile = process.argv[curArg];

    // Check if input file path has appropriate extension 
    if (!inFile.includes(".hack"))
    {
        console.log("Input must be a .hack file");
        return;
    }

    // Check if input file exists
    if (!fs.existsSync(inFile))
    {
        console.log("Input file does not exist");
        return;
    }

    // Read binary lines from input file
    const inLines = fs.readFileSync(inFile, "utf8").split("\n");

    // Create structure to contain HACK assembly lines
    const outLines = []

    // Computation Lookup Structure
    let compTable = {
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
    let destTable = {
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
    let jumpTable = {
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
    for (const line of inLines)
    {
        // A Instruction
        // if - Check instruction op-code (the first char in the string)
        
            // Get the remaining substring and convert to decimal 
            // Conversion  (just uncomment)
            // var value = parseInt(line.substring(1, 16), 2);

            // Construct the appropriate HACK instruction
            // https://masteringjs.io/tutorials/fundamentals/string-concat

            // Append to hackList
            // https://daily.dev/blog/add-to-list-javascript-array-manipulation-basics

        // C Instruction
        // elif - Check instruction op-code (the first char in the string)
        
            // Create strings from the appropriate substrings
            // cBit, dBit, jBit
            // https://www.w3schools.com/jsref/jsref_substring.asp

            // Return HACK destination string from destTable using dBit
            // https://www.makeuseof.com/javascript-dictionaries-create-use/

            // Return HACK computation string from compTable using cBit

            // Return HACK jump string from jumpTable using jBit

            // Construct the appropriate HACK instruction

            // Append to hackList
    }

    //############################################################################//

    // Create output file name
    var outFile = inFile.replace(".hack", ".asm");

    // Write data to output file
    fs.writeFileSync(outFile, outLines.join("\n"));
}