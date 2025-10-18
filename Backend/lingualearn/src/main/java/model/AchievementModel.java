package model;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

// @Entity
@Getter
@Setter
@NoArgsConstructor
@Table(name="achievements")
public class AchievementModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="name")
    private String name;

    @Column(name="description")
    private String description;

    @Column(name="icon_url")
    private String iconUrl;

    @Column(name="created_at")
    private Timestamp createdAt;
    
    public AchievementModel(int id, String name, String description, String iconUrl, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.iconUrl = iconUrl;
        this.createdAt = createdAt;
    }
}
