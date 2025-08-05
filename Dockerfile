# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the Maven/Gradle wrapper files and pom.xml first (for caching)
COPY pom.xml ./
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw

# Copy the source code
COPY src ./src

# Package the application (skip tests to speed up)
RUN ./mvnw clean package -DskipTests

# Expose port 8080
EXPOSE 8080

# Run the Spring Boot app
CMD ["java", "-jar", "target/CalculatorSpringApplication-0.0.1-SNAPSHOT.jar"]
