#!/bin/bash

# Azure Metadata Service URL
metadata_url="http://169.254.169.254/metadata/instance?api-version=2021-02-01"

# Send a GET request to the Azure Metadata Service
response=$(curl -sS -H "Metadata: true" $metadata_url)

# Check if the request was successful (status code 200)
if [ $? -eq 0 ]; then
    # Print the retrieved metadata
    echo "Azure Instance Metadata:"
    echo "$response"
else
    # If the request was not successful, print an error message
    echo "Failed to retrieve metadata."
fi
