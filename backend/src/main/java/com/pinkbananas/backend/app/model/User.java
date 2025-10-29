package com.pinkbananas.backend.app.model;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "users")
public class User {
    @Id
    private String username;
    private String password;
    private String name;
    private String birthday;
    private String email;
    private int dailyStreak;
    private String goals;
    private String weeklyStreak;

    public User() {
        //no argument constructor :)
    }

    public User(String username, String password, String name, String goals, String weeklyStreak, String birthday, String email, int dailyStreak) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.birthday = birthday;
        this.email = email;
        this.dailyStreak = dailyStreak;
        this.goals = goals;
        this.weeklyStreak = weeklyStreak;

    }
    
    public User(String username, String password, String name, String goals, String weeklyStreak, String email, int dailyStreak) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.email = email;
        this.dailyStreak = dailyStreak;
        this.goals = goals;
        this.weeklyStreak = weeklyStreak;
    }

     public String getUsername() {return username;}
     public void setUsername(String username) {this.username = username;}

     public String getPassword() {return password;}
     public void setPassword(String password) {this.password = password;}

     public String getName() {return name;}
     public void setName(String name) {this.name = name;}

     public String getbirthday() {return birthday;}
     public void setbirthday(String birthday) {this.birthday = birthday;}

     public int getdailyStreak() {return dailyStreak;}
     public void setdailyStreak(int dailyStreak) {this.dailyStreak = dailyStreak;}

     public String getgoals() {return goals;}
     public void setgoals(String goals) {this.goals = goals;}

     public String getweeklyStreak() {return weeklyStreak;}
     public void setweeklyStreak(String weeklyStreak) {this.weeklyStreak = weeklyStreak;}

     public String getEmail() {return email;}
     public void setEmail(String email) {this.email = email;}

     @Override
     public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", password='[PROTECTED]'" + 
                '}';
     }    
}
