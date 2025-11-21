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
public class LessonModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private int unitId;

    private String title;

    private String description;

    private String difficulty;

    private Timestamp createdAt;


    public LessonModel(int id, int unitId, String title, String description, String difficulty, Timestamp createdAt) {
        this.id = id;
        this.unitId = unitId;
        this.title = title;
        this.description = description;
        this.difficulty = difficulty;
        this.createdAt = createdAt;
    }
}
