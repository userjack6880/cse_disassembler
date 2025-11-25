using System;
using System.IO;

//############################################################################//

namespace Disassembler
{
    class Program
    {
        static void Main(string[] args)
        {
            // Check if input file path has been passed
            if (args.Length < 1)
            {
                Console.WriteLine("At least one file expected");
                System.Environment.Exit(0);
            }

            foreach (string inFile in args)
            {
                // Check if input file path has appropriate extension 
                if (!inFile.Contains(".hack"))
                {
                    Console.WriteLine("Input must be a .hack file");
                    System.Environment.Exit(0);
                }
                
                // Check if input file exists
                if (!File.Exists(inFile))
                {
                    Console.WriteLine("Input file does not exist");
                    System.Environment.Exit(0);
                }

                // Read binary lines from input file
                string[] inLines = File.ReadLines(inFile).ToArray();

                // Create structure to contain HACK assembly lines
                List<string> outLines = new List<string>();

                // Computation Lookup Structure
                Dictionary<string, string> compTable =
                new Dictionary<string, string>()
                {
                    {"0101010", "0"},
                    {"0111111", "1"},
                    {"0111010", "-1"},
                    {"0001100", "D"},
                    {"0110000", "A"},
                    {"1110000", "M"},
                    {"0001101", "!D"},
                    {"0110001", "!A"},
                    {"1110001", "!M"},
                    {"0001111", "-D"},
                    {"0110011", "-A"},
                    {"1110011", "-M"},
                    {"0011111", "D+1"},
                    {"0110111", "A+1"},
                    {"1110111", "M+1"},
                    {"0001110", "D-1"},
                    {"0110010", "A-1"},
                    {"1110010", "M-1"},
                    {"0000010", "D+A"},
                    {"1000010", "D+M"},
                    {"0010011", "D-A"},
                    {"1010011", "D-M"},
                    {"0000111", "A-D"},
                    {"1000111", "M-D"},
                    {"0000000", "D&A"},
                    {"1000000", "D&M"},
                    {"0010101", "D|A"},
                    {"1010101", "D|M"}
                };

                // Destination Lookup Structure
                Dictionary<string, string> destTable =
                new Dictionary<string, string>()
                {
                    {"000", ""},
                    {"001", "M="},
                    {"010", "D="},
                    {"011", "DM="},
                    {"100", "A="},
                    {"101", "AM="},
                    {"110", "AD="},
                    {"111", "ADM="}
                };

                // Jump Lookup Structure
                Dictionary<string, string> jumpTable =
                new Dictionary<string, string>()
                {
                    {"000", ""},
                    {"001", ";JGT"},
                    {"010", ";JEQ"},
                    {"011", ";JGE"},
                    {"100", ";JLT"},
                    {"101", ";JNE"},
                    {"110", ";JLE"},
                    {"111", ";JMP"}
                };

                //############################################################################//

                // Process the binary inputs and convert them to HACK assembly
                foreach (string line in inLines)
                {
                    // A Instruction
                    // if - Check instruction op-code (the first char in the char[])
                            
                        // Get the remaining substring and convert to decimal
                        // Conversion (just uncomment)
                        // string value = line.Substring(1, 15);
                        // int binVal = Convert.ToInt32(value, 2);
                        // string val = binVal.ToString();

                        // Construct the appropriate HACK instruction
                        // https://docs.microsoft.com/en-us/dotnet/csharp/how-to/concatenate-multiple-strings

                        // Append to hackList
                        // https://thedeveloperblog.com/c-sharp/list-add

                    // C Instruction
                    // else if - Check instruction op-code (the first char in the char[])

                        // Create strings from the appropriate substrings
                        // cBit, dBit, jBit
                        // https://www.geeksforgeeks.org/c-sharp-substring-method/

                        // Return HACK destination string from destTable using dBit
                        // https://www.geeksforgeeks.org/c-sharp-dictionary-with-examples/

                        // Return HACK computation string from compTable using cBit

                        // Return HACK jump string from jumpTable using jBit

                        // Construct the appropriate HACK instruction

                        // Append to hackList
                }

                //############################################################################//

                // Create output file name
                string outFile = inFile.Replace(".hack", ".asm");

                // Write data to output file
                File.WriteAllLines(outFile, outLines);
            }
        }
    }
}
