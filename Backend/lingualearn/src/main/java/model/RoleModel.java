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
public class RoleModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Integer id;

    private String name;

    private Timestamp created_at;

    private Timestamp deleted_at;

    private Boolean is_deleted;



    public RoleModel(Integer id, String name, Timestamp created_at, Timestamp deleted_at, boolean is_deleted){
        this.id = id;
        this.name = name;
        this.created_at = created_at;
        this.deleted_at = deleted_at;
        this.is_deleted = is_deleted;
    }








    //stored procedures

}
