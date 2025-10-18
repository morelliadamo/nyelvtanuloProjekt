package model;

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
public class StreakModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private int id;

    private String name;
    
    private String description;
    
    private String iconUrl;
    
    private Timestamp createdAt;



    public StreakModel(int id, String name, String description, String iconUrl, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.iconUrl = iconUrl;
        this.createdAt = createdAt;
    }
}
