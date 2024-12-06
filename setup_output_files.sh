#!/bin/bash

# Check if a namespace is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE_CONFIG="$1"

# Find all files in the current directory with the prefix "template"
TEMPLATE_FILES=(template.*)

# Ensure at least one template file is found
if [ ${#TEMPLATE_FILES[@]} -eq 0 ]; then
  echo "No template files found in the current directory."
  exit 1
fi

# Process each template file
for TEMPLATE_FILE in "${TEMPLATE_FILES[@]}"; do
  # Define the output file name by removing the "template." prefix
  OUTPUT_FILE="${TEMPLATE_FILE#template.}"

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
