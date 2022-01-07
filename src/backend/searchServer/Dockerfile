FROM openjdk:11
ARG JAR_FILE=build/libs/searchServer-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} searchServer.jar
ENTRYPOINT ["java","-jar","/searchServer.jar"]
EXPOSE 8080