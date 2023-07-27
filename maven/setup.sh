# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

check_credentials_file() {
  local credentials_file="$1"

  if [ ! -f "$credentials_file" ]; then
    echo "Credentials file not found: $credentials_file"
    exit 1
  fi
}

# Run gcloud auth login with credentials file
run_gcloud_auth_login() {
  local credentials_file="$1"

  gcloud auth login --cred-file="$credentials_file"
}

# Check the exit status of the gcloud auth login command
check_gcloud_auth_status() {
  if [ $? -eq 0 ]; then
    echo "Authentication successful"
    export GOOGLE_APPLICATION_CREDENTIALS="$credentials_file"
    access_token=$(gcloud auth application-default print-access-token)
    response=$(curl -sS -X GET -H "Authorization: Bearer $access_token" \
      "https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts?pageSize=2000")

    if [ $? -eq 0 ]; then
      echo "Authentication Successful, proceed with mvn clean install"
    else
      echo "Authentication failed"
    fi
  else
    echo "Authentication failed"
  fi
}

main() {
  
  # Check if the credentials file path is provided
  if [ $# -eq 0 ]; then
    echo "Please provide the path to the JSON credentials file."
    exit 1
  fi

  # Retrieve the credentials file path from the command-line argument
  local credentials_file="$1"

  check_credentials_file "$credentials_file"

  run_gcloud_auth_login "$credentials_file"

  check_gcloud_auth_status
}

main "$@"