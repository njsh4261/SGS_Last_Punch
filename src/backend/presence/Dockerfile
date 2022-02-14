FROM openjdk:11
ARG JAR_FILE=build/libs/presence-server.jar
COPY ${JAR_FILE} presence-server.jar
ENTRYPOINT ["java","-jar","/presence-server.jar"]
EXPOSE 8084
