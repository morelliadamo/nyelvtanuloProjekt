package DAO;

import java.util.List;

import model.UserModel;

public interface UserDAO {

    void createUser(UserModel user);

    UserModel getUserById(Integer id);

    List<UserModel> getAllUsers();

    // void updateUser(UserModel user);

    void deleteUser(Integer id);


}
