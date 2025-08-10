// <r:package>
package com.example.demo;

// <r:imports>
import java.util.*;
import com.fasterxml.jackson.annotation.JsonProperty;

// <r:class>
public class UserManager {
    // <r:fields>
    private Map<Integer, User> users;
    private static final String DEFAULT_EMAIL = "noemail@example.com";
    
    // <r:constructor>
    public UserManager() {
        this.users = new HashMap<>();
    }
    
    // <r:methods>
    public void addUser(User user) {
        users.put(user.getId(), user);
    }
    
    public Optional<User> getUser(int id) {
        return Optional.ofNullable(users.get(id));
    }
    
    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }
    
    // <r:inner-class>
    public static class User {
        @JsonProperty("id")
        private int id;
        
        @JsonProperty("name")
        private String name;
        
        @JsonProperty("email")
        private String email;
        
        public User(int id, String name, String email) {
            this.id = id;
            this.name = name;
            this.email = email != null ? email : DEFAULT_EMAIL;
        }
        
        // Getters
        public int getId() { return id; }
        public String getName() { return name; }
        public String getEmail() { return email; }
    }
}