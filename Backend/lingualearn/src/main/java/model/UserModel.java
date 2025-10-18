package model;
import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 *
 * @author 1more
 */

@Entity
@Getter
@Setter
@NoArgsConstructor
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

    // @Column(name="deleted_at")
    private Timestamp deleted_at;

    @Column(name="last_login")
    private Timestamp last_login;

    // @Column(name="is_deleted")
    private Boolean is_deleted;



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
