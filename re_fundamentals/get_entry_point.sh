#!/bin/bash
#
# elf_header_extractor.sh
#
# Extracts and displays key ELF header fields (Magic Number, Class,
# Byte Order, Entry Point Address) from a given ELF file.
#
# Usage: ./elf_header_extractor.sh <file_name>

# Source the reusable display function
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/messages.sh"

# 1. Accept the ELF file name as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

file_name="$1"

# 2. Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# 3. Check if the file is a valid ELF file
if ! readelf -h "$file_name" &>/dev/null; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

file_type=$(file -b "$file_name")
if [[ "$file_type" != *"ELF"* ]]; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# 4. Extract the required data using readelf
header=$(readelf -h "$file_name")

# Magic Number (pulled directly from readelf's "Magic:" line)
magic_number=$(echo "$header" | grep "Magic:" | sed -E 's/.*Magic:[[:space:]]+//')

# Class (32-bit / 64-bit)
class=$(echo "$header" | grep "Class:" | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//')

# Byte Order (endianness)
byte_order=$(echo "$header" | grep "Data:" | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//')

# Entry Point Address
entry_point_address=$(echo "$header" | grep "Entry point address:" | awk -F': ' '{print $2}' | sed 's/^[[:space:]]*//')

# 5. Display the output using messages.sh
display_elf_header_info
