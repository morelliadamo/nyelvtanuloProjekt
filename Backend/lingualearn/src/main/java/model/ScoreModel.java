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
public class ScoreModel implements Serializable{
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    
    private int userId;
    
    private int lessonId;
    
    private int courseId;
    
    private int score;
    
    private int xpEarned;
    
    private int attempts;
    
    private Timestamp completedAt;

    public ScoreModel(int id, int userId, int lessonId, int courseId, int score, int xpEarned, int attempts, Timestamp completedAt) {
        this.id = id;
        this.userId = userId;
        this.lessonId = lessonId;
        this.courseId = courseId;
        this.score = score;
        this.xpEarned = xpEarned;
        this.attempts = attempts;
        this.completedAt = completedAt;
    }

    // Getters and Setters
}
