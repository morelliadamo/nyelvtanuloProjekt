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
public class LeaderboardModel implements Serializable{
    
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private int userId;

    private int courseId;

    private int rank;

    private int xpTotal;

    private String period;

    private Timestamp updatedAt;


    public LeaderboardModel(int id, int userId, int courseId, int rank, int xpTotal, String period, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.courseId = courseId;
        this.rank = rank;
        this.xpTotal = xpTotal;
        this.period = period;
        this.updatedAt = updatedAt;
    }
}
