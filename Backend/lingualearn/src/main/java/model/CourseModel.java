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
public class CourseModel implements Serializable {
    
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String languageCode;
    private Timestamp createdAt;

    public CourseModel(int id, String name, String languageCode, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.languageCode = languageCode;
        this.createdAt = createdAt;
    }

    
}
