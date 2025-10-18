package com.axis.lingualearn;

import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;

import DAO.UserDAO;
import model.UserModel;

@SpringBootApplication
@ComponentScan(basePackages = {"com.axis.lingualearn", "DAO", "controller", "service"})
public class LingualearnApplication {

	public static void main(String[] args) {
		SpringApplication.run(LingualearnApplication.class, args);
	}

	@Bean
	public CommandLineRunner commandLineRunner(UserDAO userDAO) {
		
		return runner -> {
			queryAllUsers(userDAO);
		};
	}

	private void queryAllUsers(UserDAO userDAO) {
		System.out.println("Querying all users from the database...");
		List<UserModel> users = userDAO.getAllUsers();
		users.forEach(user -> System.out.println(user.getUsername()));
	}
}
