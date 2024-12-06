#!/bin/bash

# Define repository URL using PAT from environment variable
REPO_URL="dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/Test"
AZ_USERNAME="<your-username>"
AZURE_PAT="<your-pat-here>"

# Check if /app/pim is empty and clone the repo if it is
if [ -z "$(ls -A /app/pim)" ]; then
  echo "Directory /app/pim is empty. Cloning the repository..."
#  git clone "$REPO_STRING" /app/pim
   git clone https://$AZ_USERNAME:$AZURE_PAT@dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/aws_ad_auth /app/pim
else
  echo "Directory /app/pim already contains files. Updating the repository..."
#  git -C /app/pim pull
   git -C /app/pim pull https://$AZ_USERNAME:$AZURE_PAT@dev.azure.com/Nexus-One/NX1%20Special%20Projects/_git/aws_ad_auth
fi

# Execute the main command
exec "$@"
