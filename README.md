# Heading 1 AOSS-SpringBoot-Sample-Starter-Project

## Introduction
This is a simple “Hello-World” SpringBoot application written in Java, which downloads the required and available packages from Assured OSS and the rest non-available packages from Maven Central Repository (open-source). The aim of this document is to define how to start working on sample starter projects using Assured OSS packages, which can help a user to quickly start using Assured OSS with minimal friction.
Users can refer to [Assured Open Source Software](https://cloud.google.com/assured-open-source-software) for further reading and information about Assured OSS.

## Installation : 
Run the following command to clone the project in your local setup: 

```cmd
git clone {Project link}
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
 
## Steps to run the project :
After cloning the project, User need to follow certain steps to get started with the project:

1. Setting up the Authentication via Service Key : 

Users have to replace the KEY present in settings.xml file, with the base64-encoding of the entire service account JSON key file. To do this, execute following command:

```cmd
cat KEY_FILE_LOCATION | base64
```

Where KEY_FILE_LOCATION is the location of the service account JSON key file.

Replace the KEY value in the settings.xml file : 

```cmd
<username>_json_key_base64</username>
<password>{KEY}</password>
```

2. The current pom.xml files contain packages required for the application to run, Users can add more packages by adding <dependency> tag to the file. Available packages will get downloaded from Asurred OSS and rest from open-source.

```cmd
<dependencies>

    <dependency>
      
    </dependency>
	
  </dependencies>
```

3. Upgrade the Java SDK version according to system requirements by changing the properties section of pom.xml file

```cmd
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

4. Run the following install command where <project_path>/ .m2/settings.xml_path is the path of settings.xml file in the  .m2 directory of your project directory.

```cmd
mvn -s .m2/settings.xml_path clean install
```

All the required packages will get downloaded, and users can import it to start working with it. 
You have the basic framework to start working with SpringBoot Application along with the Logging library, to see output which is “Hello,World”, open localhost:8080/hello.
In case you get stuck in any process refer to [Download Java packages using direct repository access](https://cloud.google.com/assured-open-source-software/docs/download-java-packages#access_packages_not_available_in_assured_oss).