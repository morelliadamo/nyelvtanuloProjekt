package com.axis.lingualearn.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.axis.lingualearn.model.UserModel;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

@Repository
@Primary
@Transactional
public class UserDAOImpl implements UserDAO {

    private EntityManager entityManager;


    @Autowired
    public UserDAOImpl(EntityManager entityManager) {
        this.entityManager = entityManager;
    }



    @Override
    public void createUser(UserModel user) {
        entityManager.persist(user);
    }


    @Override
    public UserModel getUserById(Integer id) {
        return entityManager.find(UserModel.class, id);
    }


    @Override
    public List<UserModel> getAllUsers() {
        TypedQuery<UserModel> query = entityManager.createQuery("SELECT u FROM UserModel u", UserModel.class);
        return query.getResultList();
    }

    @Override
    public void deleteUser(Integer id) {
        UserModel user = getUserById(id);
        if (user != null) {
            entityManager.remove(user);
        } else {
            throw new IllegalArgumentException("User not found");
        }
    }


    // @Override
    // public void updateUser(UserModel user) {
    // }




}
