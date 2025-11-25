import java.io.File;
import java.util.*;

//############################################################################//

fun main(args: Array<String>) 
{
    // Check if at least one input file path has been passed
    if (args.size < 1)
    {
        println("At least one file expected")
        return
    }
    
    // Loop through each input file
    for (inFile in args)
    {
        // Check if input file path has appropriate extension 
        if (!inFile.endsWith(".hack"))
        {
            println("Input must be a .hack file")
            return
        }

        // Check if input file exists
        if (!File(inFile).exists())
        {
            println("Input file does not exist")
            return
        }

        // Read binary lines from input file
        val inLines: List<String> = File(inFile).readLines();

        // Create structure to contain HACK assembly lines
        val outLines: ArrayList<String> = ArrayList<String>();

        // Computation Lookup Structure
        val compTable = mapOf(
            "0101010" to "0",
            "0111111" to "1",
            "0111010" to "-1",
            "0001100" to "D",
            "0110000" to "A",
            "1110000" to "M",
            "0001101" to "!D",
            "0110001" to "!A",
            "1110001" to "!M",
            "0001111" to "-D",
            "0110011" to "-A",
            "1110011" to "-M",
            "0011111" to "D+1",
            "0110111" to "A+1",
            "1110111" to "M+1",
            "0001110" to "D-1",
            "0110010" to "A-1",
            "1110010" to "M-1",
            "0000010" to "D+A",
            "1000010" to "D+M",
            "0010011" to "D-A",
            "1010011" to "D-M",
            "0000111" to "A-D",
            "1000111" to "M-D",
            "0000000" to "D&A",
            "1000000" to "D&M",
            "0010101" to "D|A",
            "1010101" to "D|M",
        )

        // Destination Lookup Structure
        val destTable = mapOf(
            "000" to "",
            "001" to "M=",
            "010" to "D=",
            "011" to "DM=",
            "100" to "A=",
            "101" to "AM=",
            "110" to "AD=",
            "111" to "ADM="
        )

        // Jump Lookup Structure
        val jumpTable = mapOf(
            "000" to "",
            "001" to ";JGT",
            "010" to ";JEQ",
            "011" to ";JGE",
            "100" to ";JLT",
            "101" to ";JNE",
            "110" to ";JLE",
            "111" to ";JMP"
        )

        //############################################################################//

        // Process the binary inputs and convert them to HACK assembly
        for (line in inLines)
        {
            // A Instruction
            // if - Check instruction op-code (the first char in the char[])

                // Get the remaining substring and convert to decimal
                // Conversion (just uncomment)
                // val binVal: String = line.substring(1, 16);

                // Construct the appropriate HACK instruction

                // Append to hackList

            // C Instruction
            // else if - Check instruction op-code (the first char in the char[])

                // Create strings from the appropriate substrings
                // cBit, dBit, jBit

                // Return HACK destination string from destTable using dBit

                // Return HACK computation string from compTable using cBit 

                // Return HACK jump string from jumpTable using jBit

                // Construct the appropriate HACK instruction

                // Append to hackList
        }

        //############################################################################//

        // Create output file name
        val outFile = inFile.replace(".hack", ".asm");
        
        // Write data to output file
        File(outFile).writeText(outLines.joinToString(separator=""));
    }
}
