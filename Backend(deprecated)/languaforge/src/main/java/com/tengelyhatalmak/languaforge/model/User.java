package com.tengelyhatalmak.languaforge.model;

import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "user")
@Getter
@Setter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username", unique = true, nullable = false)
    private String username;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "role")
    private String role;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "last_login")
    private Date lastLogin;

    @Column(name = "is_anonymized")
    private boolean isAnonymized;

    @Column(name = "anonymized_at")
    private Date anonymizedAt;

    @Column(name = "is_deleted")
    private boolean isDeleted;

    @Column(name = "deleted_at")
    private Date deletedAt;


    public User(String username, String email, String passwordHash, String role, Date createdAt, Date lastLogin, Boolean isAnonymized, Date anonymizedAt, Boolean isDeleted, Date deletedAt) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = (createdAt != null) ? createdAt : new Date(System.currentTimeMillis());
        this.lastLogin = lastLogin;
        this.isAnonymized = (isAnonymized != null) ? isAnonymized : Boolean.FALSE;
        this.anonymizedAt = anonymizedAt;
        this.isDeleted = (isDeleted != null) ? isDeleted : Boolean.FALSE;
        this.deletedAt = deletedAt;
    }

}
