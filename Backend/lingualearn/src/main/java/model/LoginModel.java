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
public class LoginModel implements Serializable {
    
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    
    private int userId;
    
    private Timestamp loginTime;
    
    private String deviceInfo;
    
    private String ipAddress;
    
    private String sessionToken;
    
    private Timestamp expiresAt;

    public LoginModel(int id, int userId, Timestamp loginTime, String deviceInfo, String ipAddress, String sessionToken, Timestamp expiresAt) {
        this.id = id;
        this.userId = userId;
        this.loginTime = loginTime;
        this.deviceInfo = deviceInfo;
        this.ipAddress = ipAddress;
        this.sessionToken = sessionToken;
        this.expiresAt = expiresAt;
    }
}
