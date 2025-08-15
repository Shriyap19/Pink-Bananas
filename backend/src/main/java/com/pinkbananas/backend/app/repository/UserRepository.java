package com.pinkbananas.backend.app.repository;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.pinkbananas.backend.app.model.User;

public interface UserRepository extends MongoRepository<User, String>{
    //public void save(String username, String password);
    
}