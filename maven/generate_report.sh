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

# Set the credentials file and export environment variable
set_credentials() {
  local credentials_file="$1"
  export GOOGLE_APPLICATION_CREDENTIALS="$credentials_file"
}

# Generate the maven dependencies list and store it in tempfile_output_mvn
generate_maven_dependencies() {
  mvn dependency:list -DoutputFile=tempfile_output_mvn.txt

}

# Convert maven dependencies into URL format and update tempfile_output_mvn
convert_maven_dependencies() {
  sed -i 's/:jar:/:/g' tempfile_output_mvn.txt
  sed -i 's/:compile//g' tempfile_output_mvn.txt
}

# Process maven dependencies and update it according to curl output
process_maven_dependencies() {
  while IFS= read -r dependency; do
    # Remove spaces from the dependency
    dependency=$(echo "$dependency" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    # Check for valid URL
    if [[ ! $dependency =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
      continue
    fi

    # Convert the dependency to URL format and store in tempfile_output_mvn.txt
    url_dependency=$(echo "$dependency" | sed 's/\(.*\)/"name": "projects\/cloud-aoss\/locations\/us\/repositories\/cloud-aoss-java\/mavenArtifacts\/\1",/')
    echo "$url_dependency" >> tempfile_output_mvn.txt

  done < tempfile_output_mvn.txt
}

# Fetch cURL output and store it in tempfile_output_curl
fetch_curl_output() {
  local access_token=$(gcloud auth application-default print-access-token)
  local url="https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts"
  local next_page_token

  curl_output_first=$(curl -X GET -H "Authorization: Bearer $access_token" "$url?pageSize=2000" | grep name | sort -f)
  echo "$curl_output_first" >> tempfile_output_curl

  curl_output=$(curl -X GET -H "Authorization: Bearer $access_token" "$url")
  next_page_token=$(echo "$curl_output" | grep nextPageToken | awk '{print $2}' | sed 's/"//g')

  while [[ -n "$next_page_token" ]]; do
    curl_output_token=$(curl -sS -X GET -H "Authorization: Bearer $access_token" "$url?pageSize=2000&pageToken=$next_page_token")
    echo "$curl_output_token" | grep name | sort -f >> tempfile_output_curl
    next_page_token=$(echo "$curl_output_token" | grep nextPageToken | awk '{print $2}' | sed 's/"//g')
  done
}

# Process packages and check which packages are present in tempfile_output_curl
process_packages() {

  while IFS= read -r file; do
    if grep -q "$file" tempfile_output_curl; then
      ((aoss_count++))
      aoss_packages+="$(echo "$file" | awk -F'/' '{print substr($NF, 1, length($NF)-2)}')"$'\n'
    else
      ((public_repo_count++))
    fi
  done < tempfile_output_mvn.txt
}

# Save the final result in report.txt
save_report() {
    cat <<EOF > report.txt
Number of packages coming from AOSS: $aoss_count
Number of packages coming from the public repository: $public_repo_count
List of packages coming from AOSS:
 
$aoss_packages

EOF

}

# Perform cleanup by removing the temporary files
cleanup() {
  rm tempfile_output_curl tempfile_output_mvn.txt
}

# Main script execution
main() {
  local credentials_file="$1"

  set_credentials "$credentials_file"
  generate_maven_dependencies
  convert_maven_dependencies
  process_maven_dependencies
  fetch_curl_output

  local aoss_count=0
  local public_repo_count=0
  local aoss_packages=""

  process_packages
  save_report
  cat report.txt
  cleanup
}

main "$@"