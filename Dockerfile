# Stage 1: Build the WAR file using Maven and Java 8
FROM maven:3.8.1-openjdk-8 AS build
WORKDIR /app

# Copy all source code and configuration files into the container
COPY . .

# Run Maven to build the WAR file
RUN mvn clean package

# Stage 2: Run the app on Apache Tomcat 9
FROM tomcat:9.0

# Remove the default ROOT app to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the generated WAR file to the Tomcat webapps directory
# Change WebAppCal-1.3.5.war if your WAR file has a different name
COPY --from=build /app/target/WebAppCal-1.3.5.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 so Jenkins or EC2 security group can allow traffic
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
