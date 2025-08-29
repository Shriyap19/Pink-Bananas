package com.pinkbananas.backend.app;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
		System.out.println("test");
	}

	@Component
    class Runner implements CommandLineRunner {
        private final MongoTemplate mongo;

        Runner(MongoTemplate mongo) {
            this.mongo = mongo;
        }

        public void run(String... args) {
            try {
                mongo.executeCommand("{ ping: 1 }");
                System.out.println("✅ Connected to MongoDB Atlas!");
            } catch (Exception e) {
                System.err.println("❌ Connection failed: " + e.getMessage());
            }
        }
    }
}
