FROM openjdk:11
ARG JAR_FILE=build/libs/workspace-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} workspaceServer.jar
ENTRYPOINT ["java","-jar","/workspaceServer.jar"]
EXPOSE 8082
