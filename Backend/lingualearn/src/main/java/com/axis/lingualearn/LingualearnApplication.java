package com.axis.lingualearn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication // scans com.axis.lingualearn and all subpackages automatically
@EntityScan("com.axis.lingualearn.model")
public class LingualearnApplication {
    public static void main(String[] args) {
		System.out.println("Application is starting...");
        SpringApplication.run(LingualearnApplication.class, args);
    }
}