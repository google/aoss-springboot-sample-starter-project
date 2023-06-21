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
    static final Logger logger = LogManager.getLogger(HelloWorld.class);

    @GetMapping("/hello") 
    public String home() {
        return "Hello, World!";
    }

    public static void main(String[] args) {
        SpringApplication.run(HelloWorld.class, args);
        logger.info("Application started");
    }
}
