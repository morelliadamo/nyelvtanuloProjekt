package model;

import java.io.Serial;
import java.io.Serializable;
import java.security.Timestamp;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// @Entity
@Getter
@Setter
@NoArgsConstructor
public class FriendsModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private int userId;

    private int friendId;

    private String status;

    private Timestamp createdAt;


    public FriendsModel(int id, int userId, int friendId, String status, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.friendId = friendId;
        this.status = status;
        this.createdAt = createdAt;
    }
}
