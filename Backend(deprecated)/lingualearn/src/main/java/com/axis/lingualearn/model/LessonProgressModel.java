package com.axis.lingualearn.model;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;



// @Entity
@Getter
@Setter
@NoArgsConstructor
public class LessonProgressModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    
    private int userId;
    
    private int lessonId;
    
    private int courseId;
    
    private int progressPercent;
    
    private int xpTotal;
    
    private int attempts;
    
    private Timestamp lastUpdated;


    public LessonProgressModel(int id, int userId, int lessonId, int courseId, int progressPercent, int xpTotal, int attempts, Timestamp lastUpdated) {
        this.id = id;
        this.userId = userId;
        this.lessonId = lessonId;
        this.courseId = courseId;
        this.progressPercent = progressPercent;
        this.xpTotal = xpTotal;
        this.attempts = attempts;
        this.lastUpdated = lastUpdated;
    }

}
