#!/bin/bash

# Check if gcloud command is installed
if ! command -v gcloud &> /dev/null; then
  echo "gcloud is not installed. Please install it."
  exit 1
fi

# Check if credentials file path is provided as an argument
if [ $# -eq 0 ]; then
  echo "Please provide the path to the JSON credentials file."
  exit 1
fi

# Retrieve the credentials file path from the command-line argument
credentials_file="$1"

# Run gcloud auth login with credentials file
gcloud auth login --cred-file="$credentials_file"

# Check the exit status of the gcloud auth login command
if [ $? -eq 0 ]; then
  echo "Authentication successful"
  # Export GOOGLE_APPLICATION_CREDENTIALS environment variable
  export GOOGLE_APPLICATION_CREDENTIALS="$credentials_file"
  # Run curl command to get the response
  access_token=$(gcloud auth application-default print-access-token)
  response=$(curl -sS -X GET -H "Authorization: Bearer $access_token" \
    "https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts?pageSize=2000")

  # Check the exit status of the curl command
  if [ $? -eq 0 ]; then
    echo "Response from API:"
    echo "$response"

  else
    echo "Failed to retrieve response from API"
  fi
else
  echo "Authentication failed"
fi
