# Step 1: Use Maven to build the application
FROM maven:3.6.3-jdk-8 as builder

# Copy the project files to the container
COPY ./ /usr/src/app

# Set the working directory
WORKDIR /usr/src/app

# Build the application
RUN mvn clean package

# Step 2: Create the final image with the Java runtime
FROM openjdk:8-jdk-alpine

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app/target/sample-0.0.1-SNAPSHOT.jar /usr/app/sample-0.0.1-SNAPSHOT.jar

# Set the working directory
WORKDIR /usr/app

# Command to run the application
CMD ["java", "-jar", "sample-0.0.1-SNAPSHOT.jar"]

