package com.pinkbananas.backend.app.model;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "users")
public class User {
    @Id
    private String username;
    private String password;
    private String name;
    private int age;
    private int streak;

    public User() {
        //no argument constructor :)
    }

    public User(String username, String password, String name, int age, int streak) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.age = age;
        this.streak = streak;
    }
    
    public User(String username, String password, String name, int streak) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.streak = streak;
    }

     public String getUsername() {return username;}
     public void setUsername(String username) {this.username = username;}

     public String getPassword() {return password;}
     public void setPassword(String password) {this.password = password;}

     public String getName() {return name;}
     public void setName(String name) {this.name = name;}

     public int getAge() {return age;}
     public void setAge(int age) {this.age = age;}

     public int getStreak() {return streak;}
     public void setStreak(int streak) {this.streak = streak;}

     @Override
     public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", password='[PROTECTED]'" + 
                '}';
     }    
}
