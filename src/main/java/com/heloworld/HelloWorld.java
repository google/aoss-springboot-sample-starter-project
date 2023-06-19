package com.heloworld;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@RestController
@SpringBootApplication
public class HelloWorld {
    // Create a logger instance for logging messages
    static final Logger logger = LogManager.getLogger(HelloWorld.class);

    // Handler for GET request to the root URL ("/")
    @GetMapping("/hello")
    public String home() {
        // Log a message indicating the request
        logger.info("Request received for /");
        // Return a "Hello, World!" message
        return "Hello, World!";
    }

    // Application entry point
    public static void main(String[] args) {
        // Start the Spring Boot application
        SpringApplication.run(HelloWorld.class, args);
        // Log a message indicating the application has started
        logger.info("Application started");
    }
}
