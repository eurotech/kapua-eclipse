#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi

# Set variables from arguments
root="$1"
currentYear=$(date +%Y)

# Initialize a counter for changed files
changedFiles=0

# Loop through all .java files in the specified directory recursively
for file in $(find "$root" -type f -name "*.java"); do
    fileChanged=false

    # Create a temporary file for modified content
    tempFile="${file}.tmp"

    # Capture the first line and the second line
    line1=$(head -n 1 "$file")  # First line
    line2=$(head -2 "$file" | tail -n 1)  # Second line

    {
        # Check for the second header pattern with two years (e.g., "2016, 2022")
        if [[ "$line2" =~ Copyright\ \(c\)\ ([0-9]{4}),\ ([0-9]{4})\ .+\ and\ others ]]; then
            # Replace the last year with the current year
            line2=$(echo "$line2" | sed -E 's/([0-9]{4}), ([0-9]{4})/\1, '"$currentYear"'/')
            fileChanged=true
        # Check for the first header pattern with a single year (e.g., "2016")
        elif [[ "$line2" =~ Copyright\ \(c\)\ ([0-9]{4})\ .+\ and\ others ]]; then
            # Append the current year to the existing year
            line2=$(echo "$line2" | sed -E "s/([0-9]{4})/\1, $currentYear/")
            fileChanged=true
        fi

        # Write the first line (unchanged) to the temporary file
        echo "$line1" > "$tempFile"
        # Write the modified second line
        echo "$line2" >> "$tempFile"

        # Write the rest of the file unchanged, starting from the third line
        tail -n +3 "$file" >> "$tempFile"
    }

    # If the file was changed, replace the original file
    if [ "$fileChanged" = true ]; then
        mv "$tempFile" "$file"
        echo "File changed: $file"
        ((changedFiles++))
    else
        rm "$tempFile"
    fi
done

# Print the total number of changed files
echo "Total files changed: $changedFiles"
