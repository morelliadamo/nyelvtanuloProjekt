package model;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;



@Entity
@Getter
@Setter
@NoArgsConstructor
public class UserXAchievmentModel implements Serializable {
    
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private int userId;

    private int achievementId;

    private Timestamp earnedAt;

    public UserXAchievmentModel(int id, int userId, int achievementId, Timestamp earnedAt) {
        this.id = id;
        this.userId = userId;
        this.achievementId = achievementId;
        this.earnedAt = earnedAt;
    }

}