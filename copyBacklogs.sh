#!/bin/bash

count=0

# Check if directory path is provided
if [ -z "$1" ]; then
  echo "Directory path not provided."
  exit 1
fi

# Recursive function to find README.md and SUMMARY.md files
find_files() {
  local dir=$1

  # Loop through all files and directories in the current dir
  for file in "$dir"/*; do
    # If the current item is a directory call this function recursively
    if [ -d "$file" ]; then
      find_files "$file"
    # If the current item is a README.md and SUMMARY.md file create a BACKLOG.md copy
    elif [ "$file" == "$dir/README.md" ] && [ -f "$dir/SUMMARY.md" ]; then
      cp "$file" "$dir/BACKLOG.md"
      echo "BACKLOG.md created in directory: $dir"
      count=`expr $count + 1`
    fi
  done
}

# Start find_files function
find_files "$1"
echo "$count file had changed."
echo "Done!"