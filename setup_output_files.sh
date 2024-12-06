#!/bin/bash

# Check if a namespace is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE_CONFIG="$1"
TEMPLATE_DIR="./templates/"
OUTPUT_DIR="./output/"

# Create the output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Creating output directory: $OUTPUT_DIR"
  mkdir -p "$OUTPUT_DIR"
fi

# Find all template files in the specified directory
TEMPLATE_FILES=("$TEMPLATE_DIR"template.*)

# Ensure at least one template file is found
if [ ${#TEMPLATE_FILES[@]} -eq 0 ]; then
  echo "No template files found in $TEMPLATE_DIR."
  exit 1
fi

# Process each template file
for TEMPLATE_FILE in "${TEMPLATE_FILES[@]}"; do
  # Extract the file name from the path and define the output file name
  TEMPLATE_BASENAME=$(basename "$TEMPLATE_FILE")
  OUTPUT_FILE="${OUTPUT_DIR}${TEMPLATE_BASENAME#template.}"

  echo "Generating $OUTPUT_FILE from $TEMPLATE_FILE..."

  # Replace the placeholder in the template file
  sed "s|<YOUR NAMESPACE HERE>|$NAMESPACE_CONFIG|g" "$TEMPLATE_FILE" > "$OUTPUT_FILE"

  if [ $? -eq 0 ]; then
    echo "Successfully created $OUTPUT_FILE"
  else
    echo "Failed to create $OUTPUT_FILE. Exiting."
    exit 1
  fi
done

