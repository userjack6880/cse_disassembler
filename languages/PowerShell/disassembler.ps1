# Check if at least one input file path has been passed
if ($args.Length -lt 1)
{
        echo "At least one file expected"
    exit
}

# Loop through each input file
foreach ($inFile in $args)
{
    # Check if input file path has appropriate extension 
    if (!$inFile.EndsWith(".hack"))
    {
        echo "Input must be a .hack file"
        exit
    }

    # Check if input file exists
    if (![System.IO.File]::Exists($inFile))
    {
        echo "Input file does not exist"
        exit
    }

    # Read binary lines from input file
    $inLines = [System.IO.File]::ReadLines($inFile)

    # Create structure to contain HACK assembly lines
    $outLines = @()

    # Computation Lookup Structure
    $compTable = 
    @{
        '0101010' = '0';
        '0111111' = '1';
        '0111010' = '-1';
        '0001100' = 'D';
        '0110000' = 'A';
        '1110000' = 'M';
        '0001101' = '!D';
        '0110001' = '!A';
        '1110001' = '!M';
        '0001111' = '-D';
        '0110011' = '-A';
        '1110011' = '-M';
        '0011111' = 'D+1';
        '0110111' = 'A+1';
        '1110111' = 'M+1';
        '0001110' = 'D-1';
        '0110010' = 'A-1';
        '1110010' = 'M-1';
        '0000010' = 'D+A';
        '1000010' = 'D+M';
        '0010011' = 'D-A';
        '1010011' = 'D-M';
        '0000111' = 'A-D';
        '1000111' = 'M-D';
        '0000000' = 'D&A';
        '1000000' = 'D&M';
        '0010101' = 'D|A';
        '1010101' = 'D|M'
    };

    # Destination Lookup Structure
    $destTable = 
    @{
        '000' = '';
        '001' = 'M=';
        '010' = 'D=';
        '011' = 'DM=';
        '100' = 'A=';
        '101' = 'AM=';
        '110' = 'AD=';
        '111' = 'ADM='
    };

    # Jump Lookup Structure
    $jumpTable = 
    @{
        '000' = '';
        '001' = ';JGT';
        '010' = ';JEQ';
        '011' = ';JGE';
        '100' = ';JLT';
        '101' = ';JNE';
        '110' = ';JLE';
        '111' = ';JMP'
    };

    ################################################################################

    # Process the binary inputs and convert them to HACK assembly
    foreach ($line in $inLines)
    {
        # A Instruction
        # if - Check instruction op-code (the first char in the string)

            # Get the remaining substring and convert to decimal 
            # Conversion (just uncomment)
            # $binString = $line.Substring(1, 15)
            # $value = [convert]::ToInt32($binString, 2)

            # Construct the appropriate HACK instruction
            # https://localhorse.net/article/powershell-how-to-concatenate-strings

            # Append to hackList
            # https://www.delftstack.com/howto/powershell/add-items-to-array-in-powershell/

        # C Instruction

            # Create strings from the appropriate substrings
            # cBit, dBit, jBit
            # https://lazyadmin.nl/powershell/substring/

            # Return HACK destination string from destTable using dBit
            # https://lazyadmin.nl/powershell/powershell-hashtable/
            
            # Return HACK computation string from compTable using cBit

            # Return HACK jump string from jumpTable using jBit

            # Construct the appropriate HACK instruction

            # Append to hackList
    }

    ################################################################################

    # Create output file name
    $outFile = $inFile.replace('.hack', '.asm')

    # Write data to output file
    [System.IO.File]::WriteAllLines($outFile, $outLines)
}
