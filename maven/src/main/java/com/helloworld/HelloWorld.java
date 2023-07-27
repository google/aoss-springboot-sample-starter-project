// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


package com.helloworld;

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
        logger.info("Welcome to AOSS-SpringBoot-Sample-Starter-Project!");
    }
}
