FROM openjdk:11
ARG JAR_FILE=build/libs/workspace-server.jar
COPY ${JAR_FILE} workspace-server.jar
ENTRYPOINT ["java","-jar","/workspace-server.jar"]
EXPOSE 8082
