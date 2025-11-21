package com.axis.lingualearn.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.axis.lingualearn.DAO.UserDAO;
import com.axis.lingualearn.model.UserModel;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserDAO userDAO;

    @GetMapping("/{id}")
    public ResponseEntity<UserModel> getUserById(@PathVariable Integer id) {
        UserModel user = userDAO.getUserById(id);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        System.out.println("User ID requested: " + id);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/")
    public String getAllUsers() {
        return "all users";
    }
}