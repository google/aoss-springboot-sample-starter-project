# AOSS-SpringBoot-Sample-Starter-Project using Gradle

Follow the following steps if you are using Gradle as build automation tool for your Java project.

Remember to Set up the Authentication using Credential Helper mentioned in README.

After cloning the project follow the following steps to work on sample project:

1. The current build.gradle files contain packages required for the application to run, Users can add more packages by adding libraries under dependencies{} tag to the file. Available packages will get downloaded from Asurred OSS and rest from open-source.

```cmd
dependencies {

    implementation group: '', name: '', version: ''

}
```
2. Run the following command to install the packages and run the application:

```cmd
gradle clean build
```

```cmd
./gradlew run
```

All the required packages will get downloaded, and users can import it to start working with it. 
You have the basic framework to start working with SpringBoot Application along with the Logging library, to see output which is “Hello,World”, open localhost:8080/hello.

In case you get stuck in any process refer to [Download Java packages using direct repository access](https://cloud.google.com/assured-open-source-software/docs/download-java-packages#access_packages_not_available_in_assured_oss).

## Additional Information

Ideally it is preferred to use authentication using credential helper but user can also authenticate using service key : 

### Setting up authentication via service Key:

Users have to replace the KEY present in settings.xml file, with the base64-encoding of the entire service account JSON key file. To do this, execute following command:

```cmd
cat KEY_FILE_LOCATION | base64
```
Where KEY_FILE_LOCATION is the location of the service account JSON key file.

### Updating build.gradle file :

```cmd
repositories {
    maven {
        url "artifactregistry://us-maven.pkg.dev/cloud-aoss/cloud-aoss-java"
        #Use this if you are authenticating using password
	    credentials {
            username = "_json_key_base64"
            password = "$artifactRegistryMavenSecret"
        }
        authentication {
            basic(BasicAuthentication)
        }
    }
    mavenCentral()
}
```
Refer to [Authenticate using password](https://cloud.google.com/assured-open-source-software/docs/download-java-packages#authenticate_using_password) for further information.