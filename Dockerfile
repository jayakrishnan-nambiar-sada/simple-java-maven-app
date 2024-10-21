
FROM openjdk:17-jdk-alpine


WORKDIR /app


COPY target/my-app-1.0-SNAPSHOT.jar /app/my-app.jar

EXPOSE 8080

#ENTRYPOINT ["java", "-jar", "/app/my-app.jar"]

ENTRYPOINT ["sh", "-c", "java -jar /app/my-app.jar; tail -f /dev/null"]

