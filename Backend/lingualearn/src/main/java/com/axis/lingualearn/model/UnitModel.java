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
public class UnitModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private int courseId;

    private String title;

    private int orderIndex;

    private Timestamp createdAt;



    public UnitModel(int id, int courseId, String title, int orderIndex, Timestamp createdAt) {
        this.id = id;
        this.courseId = courseId;
        this.title = title;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
    }





}
