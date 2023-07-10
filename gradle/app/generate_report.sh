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
credentials_file="$1"
export GOOGLE_APPLICATION_CREDENTIALS="$credentials_file"

gradle dependencies --configuration compileClasspath > dependencies.txt


# Variables to store dependencies from Assured OSS and Open Source
aoss_dependencies=""
os_dependencies=""

# Read each dependency from the file and generate the URL
while IFS= read -r dependency; do
  # Check if the dependency starts with "+" or "|"
  if [[ $dependency == [+\|]* ]]; then
    # Remove any spaces in the dependency
    dependency=${dependency// /}

    # Remove any special characters from the start of the dependency name
    dependency=$(echo "$dependency" | sed 's/^[^[:alnum:]]*//')

    # Construct the URL for the dependency
    url="https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts/$dependency"

    # Execute the cURL command and capture the output
    curl_output=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" "$url")

    # Check if the cURL output contains the error message
    if [[ $curl_output == *"\"status\": \"NOT_FOUND\""* ]]; then
      os_dependencies+="$dependency"$'\n'
    else
      aoss_dependencies+="$dependency"$'\n'
    fi
  fi
done <dependencies.txt

# Create the report.txt file
echo "Assured OSS Dependencies" > report.txt
echo >> report.txt
echo "$aoss_dependencies" >> report.txt
echo "" >> report.txt
echo "Open Source Dependencies" >> report.txt
echo >> report.txt
echo "$os_dependencies" >> report.txt

# Print the report
cat report.txt

# Clean up by removing the temporary file
rm dependencies.txt
