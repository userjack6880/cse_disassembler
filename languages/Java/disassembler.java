import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

//############################################################################//

public class disassembler
{
    public static void main(String[] args) throws IOException 
    {
        // Check if at least one input file path has been passed
        if (args.length < 1)
        {
            System.out.println("At least one file expected");
            System.exit(0);
        }

        // Loop through each input file
        for (String inFile : args)
        {
            // Check if input file path has appropriate extension 
            if (!inFile.endsWith(".hack"))
            {
                System.out.println("Input must be a .hack file");
                System.exit(0);
            }

            // Check if input file exists
            if (!Files.exists(Paths.get(inFile)))
            {
                System.out.println("Input file does not exist");
                System.exit(0);
            }

            // Read binary lines from input file
            List<String> inLines = Files.readAllLines(Paths.get(inFile));

            // Create structure to contain HACK assembly lines
            ArrayList<String> outLines = new ArrayList<String>();

            // Computation Lookup Structure
            Hashtable<String,String> compTable = new Hashtable<String, String>();
                compTable.put("0101010", "0");
                compTable.put("0111111", "1");
                compTable.put("0111010", "-1");
                compTable.put("0001100", "D");
                compTable.put("0110000", "A");
                compTable.put("1110000", "M");
                compTable.put("0001101", "!D");
                compTable.put("0110001", "!A");
                compTable.put("1110001", "!M");
                compTable.put("0001111", "-D");
                compTable.put("0110011", "-A");
                compTable.put("1110011", "-M");
                compTable.put("0011111", "D+1");
                compTable.put("0110111", "A+1");
                compTable.put("1110111", "M+1");
                compTable.put("0001110", "D-1");
                compTable.put("0110010", "A-1");
                compTable.put("1110010", "M-1");
                compTable.put("0000010", "D+A");
                compTable.put("1000010", "D+M");
                compTable.put("0010011", "D-A");
                compTable.put("1010011", "D-M");
                compTable.put("0000111", "A-D");
                compTable.put("1000111", "M-D");
                compTable.put("0000000", "D&A");
                compTable.put("1000000", "D&M");
                compTable.put("0010101", "D|A");
                compTable.put("1010101", "D|M");

            // Destination Lookup Structure
            Hashtable<String,String> destTable = new Hashtable<String, String>();
                destTable.put("000", "");
                destTable.put("001", "M=");
                destTable.put("010", "D=");
                destTable.put("011", "DM=");
                destTable.put("100", "A=");
                destTable.put("101", "AM=");
                destTable.put("110", "AD=");
                destTable.put("111", "ADM=");

            // Jump Lookup Structure
            Hashtable<String,String> jumpTable = new Hashtable<String, String>();
                jumpTable.put("000", "");
                jumpTable.put("001", ";JGT");
                jumpTable.put("010", ";JEQ");
                jumpTable.put("011", ";JGE");
                jumpTable.put("100", ";JLT");
                jumpTable.put("101", ";JNE");
                jumpTable.put("110", ";JLE");
                jumpTable.put("111", ";JMP");

            //############################################################################//

            // Process the binary inputs and convert them to HACK assembly
            for (String lineStr : inLines)
            {
                char[] line = lineStr.toCharArray();

                // A Instruction
                // if - Check instruction op-code (the first char in the char[])
                
                    // Get the remaining substring and convert to decimal
                    // Conversion (just uncomment)
                    // String value = lineStr.substring(1, 16);
                    // int binVal = Integer.parseInt(value, 2);
                    // String val = Integer.toString(binVal);

                    // Construct the appropriate HACK instruction
                    // https://www.javatpoint.com/string-concatenation-in-java

                    // Append to hackList
                    // https://www.geeksforgeeks.org/list-add-method-in-java-with-examples/

                // C Instruction
                // else if - Check instruction op-code (the first char in the char[])

                    // Create strings from the appropriate substrings
                    // cBit, dBit, jBit
                    // https://www.javatpoint.com/substring

                    // Return HACK destination string from destTable using dBit
                    // https://www.javatpoint.com/java-hashtable

                    // Return HACK computation string from compTable using cBit

                    // Return HACK jump string from jumpTable using jBit

                    // Construct the appropriate HACK instruction

                    // Append to hackList
            }

            //############################################################################//

            // Create output file name
            String outFile = inFile.replaceAll(".hack", ".asm");
            
            // Write data to output file
            Files.write(Paths.get(outFile), outLines);
        }
    }
}
