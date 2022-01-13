FROM openjdk:11
ARG JAR_FILE=build/libs/authServer-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} authServer.jar
ENTRYPOINT ["java","-jar","/authServer.jar"]
EXPOSE 8081
