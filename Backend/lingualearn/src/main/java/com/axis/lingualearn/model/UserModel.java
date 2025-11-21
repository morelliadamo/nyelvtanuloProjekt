package com.axis.lingualearn.model;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="users")
public class UserModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name="username")
    private String username;

    @Column(name="email")
    private String email;

    @Column(name="password_hash")
    private String password_hash;

    @Column(name="role")
    private String role;

    @Column(name="created_at")
    private Timestamp created_at;

    private Timestamp deleted_at;

    @Column(name="last_login")
    private Timestamp last_login;

    private Boolean is_deleted;

    public UserModel() {}

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

    // Getters and setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword_hash() { return password_hash; }
    public void setPassword_hash(String password_hash) { this.password_hash = password_hash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }

    public Timestamp getDeleted_at() { return deleted_at; }
    public void setDeleted_at(Timestamp deleted_at) { this.deleted_at = deleted_at; }

    public Timestamp getLast_login() { return last_login; }
    public void setLast_login(Timestamp last_login) { this.last_login = last_login; }

    public Boolean getIs_deleted() { return is_deleted; }
    public void setIs_deleted(Boolean is_deleted) { this.is_deleted = is_deleted; }
}