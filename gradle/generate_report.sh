#!/bin/bash
credentials_file="$1"
export GOOGLE_APPLICATION_CREDENTIALS="$credentials_file"

mvn dependency:list -DoutputFile=output.txt

sed -i 's/:jar:/:/g' output.txt
sed -i 's/:compile//g' output.txt

# Read each line from output.txt and create the URL
while IFS= read -r dependency; do
    # Remove spaces from the dependency
    if [[ $index -le 2 || $index -eq $(wc -l < output.txt) ]]; then
        continue
    fi
    dependency=${dependency// /}

    # Construct the URL for the dependency
    url="https://artifactregistry.googleapis.com/v1/projects/cloud-aoss/locations/us/repositories/cloud-aoss-java/mavenArtifacts/$dependency"

   
    # Execute the curl command and capture the output
    curl_output=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" "$url")

    # Check if the curl output contains the error message
    if [[ $curl_output == *"\"status\": \"NOT_FOUND\""* ]]; then
        echo "Dependency $dependency is coming from Open Source"
    else
        echo "Dependency $dependency is coming from Assured Open Source"
    fi

    echo "---------------------------------------"
done < output.txt
