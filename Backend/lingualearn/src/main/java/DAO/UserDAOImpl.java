package DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.UserModel;

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
    public List<UserModel> getAllUsers() {

        TypedQuery<UserModel> query = entityManager.createQuery("SELECT u FROM UserModel u", UserModel.class);
        return query.getResultList();
    }

}
