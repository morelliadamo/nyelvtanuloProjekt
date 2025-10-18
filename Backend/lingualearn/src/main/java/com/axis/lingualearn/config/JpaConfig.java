package com.axis.lingualearn.config;

import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;

import jakarta.persistence.EntityManagerFactory;
import javax.sql.DataSource;
import model.UserModel;

@Configuration
@EntityScan(basePackageClasses = {UserModel.class})
public class JpaConfig {
    
    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(
            EntityManagerFactoryBuilder builder, DataSource dataSource) {
        LocalContainerEntityManagerFactoryBean factory = builder
                .dataSource(dataSource)
                .packages("model")
                .persistenceUnit("default")
                .build();
        
        // Explicitly set the EntityManagerFactory interface to avoid conflicts
        factory.setEntityManagerFactoryInterface(EntityManagerFactory.class);
        
        return factory;
    }
}