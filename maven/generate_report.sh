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

mvn dependency:list -DoutputFile=report.txt

sed -i 's/:jar:/:/g' report.txt
sed -i 's/:compile//g' report.txt

# Create a temporary file for editing
tmp_file=$(mktemp)

# Initialize arrays to store dependencies
aoss_dependencies=()
os_dependencies=()

# create the URL
while IFS= read -r dependency; do
    # Remove spaces from the dependency
    dependency=${dependency// /}
    # Check for valid URL
    if [[ ! $dependency =~ ^[^:]+:[^:]+:[^:]+$ ]]; then
        continue
    fi
    # Construct the URL for the dependency
    url="https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts/$dependency"

    # Execute the curl command and capture the output
    curl_output=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" "$url")

    # Check if the curl output contains the error message
    if [[ $curl_output == *"\"status\": \"NOT_FOUND\""* ]]; then
        os_dependencies+=("$dependency")
    else
        aoss_dependencies+=("$dependency")
    fi
done < report.txt
echo "Dependencies coming from Assured OSS : " >> "$tmp_file"
echo >> "$tmp_file"
# Append the AOSS dependencies to the temporary file
for dependency in "${aoss_dependencies[@]}"; do
    echo "$dependency" >> "$tmp_file"
done
echo >> "$tmp_file"
echo "Dependencies coming from Open Source: " >> "$tmp_file"
echo >> "$tmp_file"
# Append the OS dependencies to the temporary file
for dependency in "${os_dependencies[@]}"; do
    echo "$dependency" >> "$tmp_file"
done

# Overwrite the original report.txt file with the updated contents
mv "$tmp_file" report.txt


cat report.txt
