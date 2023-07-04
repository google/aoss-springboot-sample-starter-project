# AOSS-SpringBoot-Sample-Starter-Project

## Introduction
This is a simple “Hello-World” SpringBoot application written in Java, which downloads the required and available packages from Assured OSS and the rest non-available packages from Maven Central Repository (open-source). The aim of this document is to define how to start working on sample starter projects using Assured OSS packages, which can help a user to quickly start using Assured OSS with minimal friction.
Users can refer to [Assured Open Source Software](https://cloud.google.com/assured-open-source-software) for further reading and information about Assured OSS.

## Installation : 
Run the following command to clone the project in your local setup: 

```cmd
git clone https://github.com/google/aoss-springboot-sample-starter-project.git
```

## Prerequisite : 
1. Install the latest version of the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install).
2. If you have installed the Google Cloud CLI previously, make sure you have the latest version by running the command:

```cmd
gcloud components update
```
3. To enable access to Assured OSS, submit the [customer enablement form](https://developers.google.com/assured-oss#get-started).
4. [Validate connectivity](https://cloud.google.com/assured-open-source-software/docs/validate-connection) to Assured OSS for the requested service accounts.
5. [Enable the Artifact Registry API](https://cloud.google.com/artifact-registry/docs/enable-service) for the parent Google Cloud project of the service accounts used to access Assured OSS.
 
## Setting up the Authentication using Credential Helper : 

Prerequisites for setting up [Application Default Credentials](https://cloud.google.com/docs/authentication#adc), set up authentication first : 

1. Generate and download the [service account key](https://cloud.google.com/iam/docs/keys-create-delete#creating).
2. Revoke any existing auth by using the following command.

```cmd
gcloud auth revoke
```

3. Authenticate using the command:

```cmd
gcloud auth login --cred-file=FILEPATH.json
```
Where FILEPATH is the path to the service account key or the credential config file.

4. Update Application Default Credentials using the following command:

```cmd
export GOOGLE_APPLICATION_CREDENTIALS=FILEPATH.json
```
Where FILEPATH is the path to the service account key.

Refer to [set up authentication](https://cloud.google.com/assured-open-source-software/docs/validate-connection#set_up_authentication) for further information.

According to the build automation tool the user can choose between maven or gradle, and can refer to the respective README of the particular folder for futher modifaction and details to run the sample project
