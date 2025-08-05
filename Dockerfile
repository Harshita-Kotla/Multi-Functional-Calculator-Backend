# Use Java 21 for Spring Boot
FROM openjdk:21-jdk-slim as build

# Set work directory
WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (helps with caching)
RUN ./mvnw dependency:go-offline

# Copy all source code
COPY src src

# Package the application
RUN ./mvnw clean package -DskipTests

# -----------------------
# Run stage
# -----------------------
FROM openjdk:21-jdk-slim

WORKDIR /app

# Copy jar from builder
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java","-jar","app.jar"]
