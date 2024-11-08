FROM maven:3.6.3-jdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -Pproduction

FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/my-app-1.0-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "my-app-1.0-SNAPSHOT.jar"]
