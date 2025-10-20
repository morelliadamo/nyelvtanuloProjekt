package model;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.annotation.Generated;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Table(name="courses")
public class CourseModel implements Serializable {
    
    @Serial
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="name")
    private String name;

    @Column(name="language_code")
    private String languageCode;

    @Column(name="created_at")
    private Timestamp createdAt;

    public CourseModel(int id, String name, String languageCode, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.languageCode = languageCode;
        this.createdAt = createdAt;
    }

    
}
