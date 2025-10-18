package com.axis.lingualearn;

import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;

import DAO.UserDAO;
import model.UserModel;
import service.UserService;

@SpringBootApplication
@ComponentScan(basePackages = {"com.axis.lingualearn", "DAO", "controller", "service"})
public class LingualearnApplication {

	public static void main(String[] args) {
		SpringApplication.run(LingualearnApplication.class, args);
	}

	@Bean
	public CommandLineRunner commandLineRunner(UserService userService) {

		return runner -> {
			System.out.println("Application started successfully.");
			
			
			// UserModel user = userService.getUserById(3);
			// if (user != null) {
			// 	System.out.println("User found: " + user.getUsername());
			// } else {
			// 	System.out.println("No user found with ID: 3");
			// }
		};
	}



	// private void createUser(UserDAO userDAO) {
	// 	UserModel newUser = new UserModel();
	// 	newUser.setUsername("testuser");
	// 	newUser.setEmail("testuser@example.com");
	// 	newUser.setPassword_hash("hashedpassword");
	// 	newUser.setRole("USER");
	// 	newUser.setCreated_at(null);
	// 	newUser.setLast_login(null);
	// 	newUser.setDeleted_at(null);
	// 	newUser.setIs_deleted(false);
	// 	userDAO.createUser(newUser);
	// }

	// private void queryAllUsers(UserService userService) {
	// 	List<UserModel> users = userService.getAllUsers();
	// 	users.forEach(user -> System.out.println(user.getUsername()));
	// }

	// private UserModel queryUserById(UserService userService, Integer id) {
	// 	return userService.getUserById(id);
	// }
}
