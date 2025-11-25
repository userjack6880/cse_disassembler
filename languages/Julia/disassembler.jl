# Check if at least one input file path has been passed
if length(ARGS) < 1
    println("At least one file expected")
    exit()
end

# Loop through each input file
for inFile in ARGS

    # Check if input file path has appropriate extension 
    if !endswith(inFile, ".hack")
        println("Input must be a .hack file")
        exit()
    end

    # Check if input file exists
    if !isfile(inFile)
        println("Input file does not exist")
        exit()
    end

    # Read binary lines from input file
    inLines = readlines(inFile)

    # Create structure to contain HACK assembly lines
    outLines = []

    # Computation Lookup Structure
    compTable = Dict{String, String}(
        "0101010" => "0",
        "0111111" => "1",
        "0111010" => "-1",
        "0001100" => "D",
        "0110000" => "A",
        "1110000" => "M",
        "0001101" => "!D",
        "0110001" => "!A",
        "1110001" => "!M",
        "0001111" => "-D",
        "0110011" => "-A",
        "1110011" => "-M",
        "0011111" => "D+1",
        "0110111" => "A+1",
        "1110111" => "M+1",
        "0001110" => "D-1",
        "0110010" => "A-1",
        "1110010" => "M-1",
        "0000010" => "D+A",
        "1000010" => "D+M",
        "0010011" => "D-A",
        "1010011" => "D-M",
        "0000111" => "A-D",
        "1000111" => "M-D",
        "0000000" => "D&A",
        "1000000" => "D&M",
        "0010101" => "D|A",
        "1010101" => "D|M"
    )

    # Destination Lookup Structure
    destTable = Dict{String, String}(
        "000" => "",
        "001" => "M=",
        "010" => "D=",
        "011" => "DM=",
        "100" => "A=",
        "101" => "AM=",
        "110" => "AD=",
        "111" => "ADM="
    )

    # Jump Lookup Structure
    jumpTable = Dict{String, String}(
        "000" => "",
        "001" => ";JGT",
        "010" => ";JEQ",
        "011" => ";JGE",
        "100" => ";JLT",
        "101" => ";JNE",
        "110" => ";JLE",
        "111" => ";JMP"
    )

    ################################################################################

    # Process the binary inputs and convert them to HACK assembly
    for line in inLines

        # A Instruction
        # if - Check instruction op-code (the first char in the string)

            # Get the remaining substring and convert to decimal 
            # Conversion (just uncomment)
            # value = parse(Int, line[2:16]; base=2)

            # Construct the appropriate HACK instruction
            # https://docs.julialang.org/en/v1/manual/strings/#man-concatenation

            # Append to hackList
            # https://docs.julialang.org/en/v1/base/collections/#Dequeues

        # C Instruction
        # elseif - Check instruction op-code (the first char in the string)
        
            # Create strings from the appropriate substrings
            # cBit, dBit, jBit
            # https://docs.julialang.org/en/v1/manual/strings/#String-Basics

            # Return HACK destination string from destTable using dBit
            # https://docs.julialang.org/en/v1/base/collections/#Dictionaries

            # Return HACK computation string from compTable using cBit

            # Return HACK jump string from jumpTable using jBit

            # Construct the appropriate HACK instruction

            # Append to hackList
        # end
    end

    ################################################################################

    # Create output file name
    outFile = replace(inFile, ".hack" => ".asm")

    # Write data to output file
    write(outFile, join(outLines, "\n"))
end