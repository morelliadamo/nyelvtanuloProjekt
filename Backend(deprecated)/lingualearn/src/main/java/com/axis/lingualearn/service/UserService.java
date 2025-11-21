package com.axis.lingualearn.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axis.lingualearn.DAO.UserDAO;
import com.axis.lingualearn.model.UserModel;

@Service
public class UserService {

	private final UserDAO userDAO;

	@Autowired
	public UserService(UserDAO userDAO) {
		this.userDAO = userDAO;
	}

	public UserModel getUserById(Integer id) {
		return userDAO.getUserById(id);
	}

	public List<UserModel> getAllUsers() {
		return userDAO.getAllUsers();
	}

    public void createUser(UserModel user) {
        userDAO.createUser(user);
    }

    public void deleteUser(Integer id) {
        userDAO.deleteUser(id);
    }
}
