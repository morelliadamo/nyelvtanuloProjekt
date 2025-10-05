package model;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Timestamp;


@Entity
public class RoleModel implements Serializable {


    //instance variables
    @Serial
    private static final long serialVersionUID = 1L;

    @Getter
    @Setter
    private Integer id;

    @Getter
    @Setter
    private String name;

    @Getter
    @Setter
    private Timestamp created_at;

    @Getter
    @Setter
    private Timestamp deleted_at;

    @Getter
    @Setter
    private Boolean is_deleted;
    /*  waiting for DB for other annotations... */


    //constructors
    public RoleModel(Integer id, String name, Timestamp created_at, Timestamp deleted_at, boolean is_deleted){
        this.id = id;
        this.name = name;
        this.created_at = created_at;
        this.deleted_at = deleted_at;
        this.is_deleted = is_deleted;


    }





    //stored procedures

}
