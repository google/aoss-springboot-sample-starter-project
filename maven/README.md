# AOSS-SpringBoot-Sample-Starter-Project using Maven

Follow the following steps if you are using Maven as build automation tool for your Java project.

Remember to Set up the Authentication using Credential Helper mentioned in README.

After cloning the project follow the following steps to work on sample project:

1. The current pom.xml files contain packages required for the application to run, Users can add more packages by adding <dependency> tag to the file. Available packages will get downloaded from Asurred OSS and rest from open-source.

```cmd
<dependencies>

    <dependency>
      
    </dependency>
	
  </dependencies>
```

2. Upgrade the Java SDK version according to system requirements by changing the properties section of pom.xml file

```cmd
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

3. Run the following command to install the packages and run the application:

```cmd
mvn clean install
```

```cmd
javac HelloWorld.java
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

### Updating settings.xml file:

If the settings file already exists in ~/. m2/  location for linux and ${user. home}/. m2 location for mac, user can directly update the settings.xml file, if not user has to create the settings.xml file

Replace the {KEY} value in the settings.xml file :


```cmd
<settings>
  <servers>
    <server>
      <id>artifact-registry</id>
      <configuration>
        <httpConfiguration>
          <get>
            <usePreemptive>true</usePreemptive>
          </get>
          <head>
            <usePreemptive>true</usePreemptive>
          </head>
          <put>
            <params>
              <property>
                <name>http.protocol.expect-continue</name>
                <value>false</value>
              </property>
            </params>
          </put>
        </httpConfiguration>
      </configuration>
      <username>_json_key_base64</username>
      <password>{KEY}</password>
    </server>
  </servers>
</settings>
```

Run the following command :

```cmd
mvn -s settings.xml clean install
```
Refer to [Authenticate using password](https://cloud.google.com/assured-open-source-software/docs/download-java-packages#authenticate_using_password) for further information.


