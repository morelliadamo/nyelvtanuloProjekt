/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.catalina.User;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 *
 * @author 1more
 */

@Entity
@Getter
@Setter
@NoArgsConstructor
public class UserModel implements Serializable {

    //instance variables
    @Serial
    private static final long serialVersionUID = 1L;


    private Integer id;

    private String username;

    private String email;

    private String password_hash;

    private String role;

    private Timestamp created_at;

    private Timestamp deleted_at;

    private Timestamp last_login;

    private Boolean is_deleted;
    /* waiting for DB for other annotations... */


    //constructors
    public UserModel(Integer id, String username, String email, String password_hash, String role, Timestamp created_at, Timestamp deleted_at, Timestamp last_login, boolean is_deleted) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password_hash = password_hash;
        this.role = role;
        this.created_at = created_at;
        this.deleted_at = deleted_at;
        this.last_login = last_login;
        this.is_deleted = is_deleted;

    }






    //stored procedures



}
