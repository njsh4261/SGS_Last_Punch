FROM openjdk:11
ARG JAR_FILE=build/libs/websocket-server-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} websocket-server.jar
ENTRYPOINT ["java","-jar","/websocket-server.jar"]
EXPOSE 9001
