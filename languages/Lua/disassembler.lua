-- Check if at least one input file path has been passed
if #arg < 1 then
    print("At least one file expected")
    os.exit(1)
end

-- Loop through each input file
for curArg = 1, #arg do

    inFile = arg[curArg]

    -- Check if input file path has appropriate extension 
    if not inFile:find(".hack") then
        print("Input must be a .hack file")
        os.exit(1)
    end

    -- Check if input file exists
    if not io.open(inFile, "r") then
        print("Input file does not exist")
        os.exit(1)
    end

    -- Read binary lines from input file
    local fh = io.open(inFile, "r")
    local inLines = {}
    for line in fh:lines() do
        table.insert (inLines, line);
    end
    fh:close()

    -- Create structure to contain HACK assembly lines
    outLines = {}

    -- Computation Lookup Structure
    compTable = {
        ["0101010"] = "0",
        ["0111111"] = "1",
        ["0111010"] = "-1",
        ["0001100"] = "D",
        ["0110000"] = "A",
        ["1110000"] = "M",
        ["0001101"] = "!D",
        ["0110001"] = "!A",
        ["1110001"] = "!M",
        ["0001111"] = "-D",
        ["0110011"] = "-A",
        ["1110011"] = "-M",
        ["0011111"] = "D+1",
        ["0110111"] = "A+1",
        ["1110111"] = "M+1",
        ["0001110"] = "D-1",
        ["0110010"] = "A-1",
        ["1110010"] = "M-1",
        ["0000010"] = "D+A",
        ["1000010"] = "D+M",
        ["0010011"] = "D-A",
        ["1010011"] = "D-M",
        ["0000111"] = "A-D",
        ["1000111"] = "M-D",
        ["0000000"] = "D&A",
        ["1000000"] = "D&M",
        ["0010101"] = "D|A",
        ["1010101"] = "D|M"
    }

    -- Destination Lookup Structure
    destTable = {
        ["000"] = "",
        ["001"] = "M=",
        ["010"] = "D=",
        ["011"] = "DM=",
        ["100"] = "A=",
        ["101"] = "AM=",
        ["110"] = "AD=",
        ["111"] = "ADM="
    }

    -- Jump Lookup Structure
    jumpTable = {
        ["000"] = "",
        ["001"] = ";JGT",
        ["010"] = ";JEQ",
        ["011"] = ";JGE",
        ["100"] = ";JLT",
        ["101"] = ";JNE",
        ["110"] = ";JLE",
        ["111"] = ";JMP"
    }

    --############################################################################--

    -- Process the binary inputs and convert them to HACK assembly
    for idx, line in pairs(inLines) do

    -- A Instruction
    -- if - Check instruction op-code (the first char in the string)

        -- Get the remaining substring and convert to decimal
        -- Conversion (just uncomment)
        -- value = tonumber(value:sub(2, 16), 2)

        -- Construct the appropriate HACK instruction
        -- https://www.lua.org/pil/3.4.html

        -- Append to hackList
        -- https://www.lua.org/pil/19.2.html

    -- C Instruction
    -- elseif - Check instruction op-code (the first char in the string)
        
        -- Create strings from the appropriate substrings
        -- cBit, dBit, jBit
        -- https://www.tutorialspoint.com/string-sub-function-in-lua

        -- Return HACK destination string from destTable using dBit
        -- https://www.tutorialspoint.com/lua/lua_tables.htm

        -- Return HACK computation string from compTable using cBit

        -- Return HACK jump string from jumpTable using jBit

        -- Construct the appropriate HACK instruction

        -- Append to hackList
    end

    --############################################################################--

    -- Create output file nameite to file
    local outFile = string.sub(inFile, 1, -5) .. 'asm'
    
    -- Write data to output file
    fh = io.open(outFile, "w")
    fh:write(table.concat(outLines))
    fh:close()
end
