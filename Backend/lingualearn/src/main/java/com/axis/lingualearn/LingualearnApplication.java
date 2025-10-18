package com.axis.lingualearn;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class LingualearnApplication {

	public static void main(String[] args) {
		SpringApplication.run(LingualearnApplication.class, args);
	}




	
	@Bean
	public CommandLineRunner commandLineRunner() {
		
		return runner -> {
			System.out.println("Lingualearn Application started...");
		};

	}

}
